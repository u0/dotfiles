#!/usr/local/bin/bash
SCRIPT_DIR=$(pwd)

# Setting up doas.conf
doas sh -c "(touch /etc/test.conf; echo '# Allow wheel by default\npermit nopass keepenv :wheel' > /etc/test.conf) &"

# Adding <user> to wheel group
printf "Enter your username: "; read -s username
printf "Adding '$username' to group wheel\n"
doas sh -c "usermod -G wheel $username"

# Install dependencies
packages=("vim" "git" "wget" "dina-fonts" "dunst" "ungoogled-chromium" "gnupg" "go")
doas pkg_add $(packages)

# Rename the `ungoogled-chromium` binary to `chrome` for simplicity
file_name="chrome"
file_path="$(which $file_name)"
parent_dir="$(dirname -- "$(readlink -f -- "$file_path")")"
printf "Renaming $file_path to $parent_dir/$file_name\n"
doas sh -c "mv $file_path $parent_dir/$file_name"

# Copy Xsetup_0 and Xresources file to `/etc/X11/xenodm/`
printf "Xsetup_0 and Xresources file being copied to /etc/X11/xenodm/\n"
doas sh -c "cp {$SCRIT_DIR/Xsetup_0,$SCRIPT_DIR/Xresources} /etc/X11/xenodm/"

# Installing oh-my-zsh on the machine
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Reconfiguring ~/.zshrc
cp $SCRIPT_DIR/.zshrc $HOME

# Put the tmux config, `.xsession` file, cwm config file and Xresources in $HOME
cp {$SCRIPT_DIR/.tmux.conf,$SCRIPT_DIR/Xresources,$SCRIPT_DIR/.xsession,$SCRIPT_DIR/.cwmrc} $HOME
mv $HOME/Xresources $HOME/.Xresources # Rename to a hidden file

# Set up the `.config/` and `.local/` directory file
mkdir $HOME/.config/
dunst_path=$(mkdir $HOME/.config/dunst)
cp $SCRIPT_DIR/dunstrc $dunst_path

mkdir $HOME/.local/
usr_bin_path=$(mkdir $HOME/.local/bin)
cp $SCRIPT_DIR/bin/* $usr_bin_path


