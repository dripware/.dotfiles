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
		local ANS="$(__prompt "$PROMPT (y/n)? ")"
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
	__prompt "Enter username: "
}
ask_for_machine_name(){
	__prompt "Enter name for computer: "
}
ask_for_system_config(){
	__print "Avaliable system configs:"
	for config in $(ls $HERE/system_config -I base.nix); do
		__print "\t- ${config%.*}"
	done
	__prompt "Enter configuration profile you want to use: "
}
ask_for_inputs(){
	DISK="$(ask_for_disk)"
	SWAP_SIZE="$(ask_for_swap_size)"
	MACHINE_NAME="$(ask_for_machine_name)"
	USERNAME="$(ask_for_username)"
	SYSTEM_CONFIG="$(ask_for_system_config)"
	USER_CONFIG="$SYSTEM_CONFIG"
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
	rm -rf $HERE/local_config
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
	cp /mnt/etc/nixos/hardware-configuration.nix "$HERE"/local_config
	rm /mnt/etc/nixos/*
}
generate_system_local_config(){
	__print "generating local_config flake..."
	mkdir $HERE/local_config
	__generate_hardware_config
	cat > $HERE/local_config/flake.nix <<- EOF
	{
	  description = "local flake only used to keep some extra variable for this specific nixos install. it's generated automatically by the install script";
	  outputs = { self, nixpkgs }: {
	    disk = "$DISK";
	    hardware-configuration = import ./hardware-configuration.nix;
	    machine_name = "$MACHINE_NAME";
            user_config = "$USER_CONFIG";
	    system_config = "$SYSTEM_CONFIG";
	    username = "$USERNAME";
          };
        }
	EOF
	chmod +rw $HERE/local_config $HERE/local_config/*
}
update_flake(){
	__print "updating nix flake..."
	nix flake lock --update-input local_config "$HERE#" --extra-experimental-features 'nix-command flakes'
}
git_add_local_config(){
	git --git-dir $HERE/.git add $HERE/local_config -f
}
install_nixos(){
	__print "installing nixos..."
	nixos-install --flake "$HERE#main" --no-root-password
	nixos-enter --root /mnt -c "echo root:$ROOT_PASSWORD | chpasswd"
	nixos-enter --root /mnt -c "echo $USERNAME:$USER_PASSWORD | chpasswd"
}

copy_dotfiles(){
	__print "copying dotfiles to newly installed nixos..."
	cp $HERE /mnt/home/$USERNAME/tmp_repo -r
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME git clone /home/$USERNAME/tmp_repo /home/$USERNAME/.dotfiles"
	rm -rf /mnt/home/$USERNAME/.dotfiles/.git/hooks
	nixos-enter --root /mnt -c "chown $USERNAME /home/$USERNAME/tmp_repo/local_config -R"
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME cp /home/$USERNAME/tmp_repo/local_config /home/$USERNAME/.dotfiles/local_config -r"
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME ln /home/$USERNAME/.dotfiles/.githooks /home/$USERNAME/.dotfiles/.git/hooks -s"
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME git --git-dir=/home/$USERNAME/.dotfiles/.git remote set-url origin git@github.com:dripware/.dotfiles"
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME git --git-dir=/home/$USERNAME/.dotfiles/.git --work-tree=/home/$USERNAME/.dotfiles add /home/$USERNAME/.dotfiles/local_config -f"
	nixos-enter --root /mnt -c "nix-daemon" &
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME nix flake lock --update-input local_config /home/$USERNAME/.dotfiles"
	rm -rf /mnt/home/$USERNAME/tmp_repo
}
install_homemanager(){
	__print "installing home-manager..."
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME nix build /home/$USERNAME/.dotfiles#homeConfigurations.main.activationPackage -o /home/$USERNAME/result"
	nixos-enter --root /mnt -c "sudo -Hu $USERNAME /home/$USERNAME/result/activate"
	rm /mnt/home/$USERNAME/result
}
generate_wallpaper(){
	__print "generate dynamite wallpapers..."
	nixos-enter --root /mnt -c "~/.local/bin/dynamite-generate"
}

check_root
ask_for_inputs
clean_before_install
partition_disk
format_partitions
mount_partitions
generate_system_local_config
git_add_local_config
update_flake
install_nixos
copy_dotfiles
install_homemanager
generate_wallpaper
