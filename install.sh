#!/usr/bin/env bash
# automated install script for nixos for quickly setting up an install from live iso
set -e
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null & pwd 2> /dev/null; )"
__print(){
	echo -e "\e[1m\e[35m$@\e[0m" >&2
}
check_root(){
	if [[ "$USER" != "root" ]]; then
		__print "RUN ONLY AS ROOT"
		exit
	fi
}
__prompt(){
	local INPUT
	while : ; do
		read -p "$@" INPUT
		echo "" >&2
		if [[ "$INPUT" != "" ]]; then
			echo "$INPUT"
			return
		fi
	done
}
ask_for_disk(){
	lsblk >&2
	__prompt "which disk device do you want to install nixos on? (e.g. /dev/sda): "
}

ask_for_swap_size(){
	__prompt "how big should the swap partion be? (in GB):"
}
__prompt_password(){
	local PASS
	while : ; do
		read -s -p "$@: " PASS
		echo "" >&2
		if [[ "$PASS" != "" ]]; then
			echo "$PASS"
			return
		fi
	done
}
prompt_boolean(){
	local PROMPT
	[[ "$1" != "" ]] && PROMPT="$1" || PROMPT="Do you want to proceed" 
	while : ;do
		local ANS="$(__prompt "$PROMPT (y/n)?")"
		if [[ "$ANS" == "y" ]]; then
			return 0
		elif [[ "$ANS" == "n" ]]; then
			return 1
		else
			__print "what?"
		fi
	done
}
ask_for_password(){
	local PASS PASS_AGAIN PROMPT
	[[ "$#" != 0 ]] && PROMPT="$@" || PROMPT="Enter password"
	while : ; do
		PASS="$(__prompt_password "$PROMPT")"
		PASS_AGAIN="$(__prompt_password "$PROMPT again")"
		if [[ "$PASS" == "$PASS_AGAIN" ]]; then
			echo "$PASS"
			return 0
		else
			__print "Password did not match.\n"
		fi
	done
}
ask_for_username(){
	__prompt "Enter username (must match username in home-manager config): "
}
ask_for_machine_name(){
	__prompt "Enter name for computer (must match name in nixos config): "
}
ask_for_inputs(){
	DISK="$(ask_for_disk)"
	SWAP_SIZE="$(ask_for_swap_size)"
	MACHINE_NAME="$(ask_for_machine_name)"
	USERNAME="$(ask_for_username)"
	ROOT_PASSWORD="$(ask_for_password "Enter root password")"

	if prompt_boolean "same password for $USERNAME"; then
		USER_PASSWORD="$ROOT_PASSWORD"
	else
		USER_PASSWORD="$(ask_for_password "Enter $USERNAME password")"
	fi
}
clean_before_install(){
	__print "unmounting $DISK..."
	swapoff -a
	MOUNTED="$(mount | grep $DISK | awk '{print $1}')"
	for i in $MOUNTED; do umount $i; done
	rm -rf $HERE/system_local
}
__parted(){
	parted "$DISK" -s -- $@
}
partition_disk(){
	__print "partitioning $DISK..."
	__parted mklabel msdos
	__parted mkpart primary 1MiB "-$SWAP_SIZE"GB
	if (( $SWAP_SIZE != 0 )); then
		__parted mkpart primary linux-swap "-$SWAP_SIZE"GB 100%FREE
	fi
}
format_partitions(){
	__print "formating partitions in $DISK..."
	mkfs.ext4 -q -L nixos "$DISK"1
	if (( $SWAP_SIZE != 0 )); then
		mkswap -L swap "$DISK"2
	fi
}
mount_partitions(){
	__print "mounting partitions..."
	mount "$DISK"1 /mnt
	if (( $SWAP_SIZE != 0 )); then
		swapon "$DISK"2
	fi
}
__generate_hardware_config(){
	__print "generating hardware-configuration..."
	nixos-generate-config --root /mnt
	cp /mnt/etc/nixos/hardware-configuration.nix "$HERE"/system_local
	rm /mnt/etc/nixos/*
}
generate_system_system_local(){
	__print "generating system_local flake..."
	mkdir $HERE/system_local
	__generate_hardware_config
	cat > $HERE/system_local/flake.nix <<- EOF
	{
	  description = "local flake only used to keep some extra variable for this nixos install";
	  outputs = { self, nixpkgs }: {
	    disk = "$DISK";
	    hardware-configuration = import ./hardware-configuration.nix;
          };
        }
	EOF
}
update_flake(){
	nix flake update $HERE#
}
install_nixos(){
	__print "installing nixos..."
	nix-shell -p nixUnstable git --run "nix build --extra-experimental-features 'nix-command flakes' .#nixosConfigurations.machine.config.system.build.toplevel --show-trace"
	# nixos-install --root /mnt --system "$(nix path-info --extra-experimental-features 'nix-command flakes' "$HERE#nixosConfigurations.$MACHINE_NAME.config.system.build.toplevel")"
}
install_homemanager(){
	__print "installing home-manager..."
	nix-shell -p nixUnstable git --run "nix build --no-link $HERE#homeConfigurations.$USERNAME.activationPackage --extra-experimental-features 'nix-command flakes'"
	"$(nix path-info --extra-experimental-features 'nix-command flakes')"/activate
}

check_root
ask_for_inputs
clean_before_install
partition_disk
format_partitions
mount_partitions
generate_system_system_local
update_flake
install_nixos
# install_homemanager
