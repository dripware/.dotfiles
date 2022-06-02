#!/usr/bin/env bash
# automated install script for nixos for quickly setting up an install from live iso
set -e
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null & pwd 2> /dev/null; )"
echo $HERE
check_root(){
	if [[ "$USER" != "root" ]]; then
		echo "RUN ONLY AS ROOT"
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
ask_for_device(){
	lsblk >&2
	__prompt "which device do you want to install nixos on? (e.g. /dev/sda): "
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
			echo "what?" >&2
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
			echo -e "Password did not match.\n" >&2
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
	DEVICE="$(ask_for_device)"
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

__parted(){
	parted "$DEVICE" -s -- $@
}
partition_device(){
	__parted mklabel msdos
	__parted mkpart primary 1MiB "-$SWAP_SIZE"GB
	if (( $SWAP_SIZE != 0 )); then
		__parted mkpart primary linux-swap "-$SWAP_SIZE"GB 100%FREE
	fi
}
format_partitions(){
	mkfs.ext4 -q -L nixos "$DEVICE"1
	if (( $SWAP_SIZE != 0 )); then
		mkswap -L swap "$DEVICE"2
	fi
}
mount_partitions(){
	mount "$DEVICE"1 /mnt
	if (( $SWAP_SIZE != 0 )); then
		swapon "$DEVICE"2
	fi
}
generate_hardware_config(){
	nixos-generate-config --root /mnt
	mv /mnt/etc/nixos/hardware-configuration.nix "$HERE"
}
generate_device_dot_nix(){
	echo "\"$DEVICE\"" > "$HERE"/device.nix
}
build_system(){
	nix-shell -p nixUnstable git --run "nix build $HERE#nixosConfigurations.$MACHINE_NAME.config.system.build.toplevel --extra-experimental-features 'nix-command flakes'"
}
unmount_partitions_if_mounted(){
	swapoff -a
	umount "$DEVICE"?
}

ask_for_inputs
unmount_partitions_if_mounted
partition_device
format_partitions
mount_partitions
generate_hardware_config
generate_device_dot_nix
build_system
