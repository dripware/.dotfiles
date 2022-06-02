#!/usr/bin/env bash
set -e
is_root(){
	if [[ "$USER" == "root" ]]; then
		return 0
	else
		return 1
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
ask_for_inputs(){
	DEVICE="$(ask_for_device)"
	SWAP_SIZE="$(ask_for_swap_size)"
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
	mkfs.ext4 -L nixos "$DEVICE"1
	if (( $SWAP_SIZE != 0 )); then
		mkswap -L swap "$DEVICE"2
	fi
}
mount_partitions(){
	mount "$DEVICE"1 /mnt
	swapon "$DEVICE"2
}

ask_for_inputs
partition_device
format_partitions
mount_partitions




