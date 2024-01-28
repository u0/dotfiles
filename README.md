# dotfiles

## Installation

### Doas configuration
Setup `doas.conf` file configuration:

```bash
permit keepenv :wheel
```

Make sure to add your user to the `wheel` group after doing so:

```bash
usermod -G wheel <user>
```

### Package installation

```bash
doas pkg_add ungoogled-chromium dunst zsh vim git go dmenu wget gnupg
```

### Final step

```bash
sh install.sh
```
