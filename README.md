# nixos-config

`sudo ln -sf configuration.nix /etc/nixos/configuration.nix`
once applied run `sway` to start the gui. If in VM with no hardware, add `WLR_NO_HARDWARE_CURSOR=1`. If on the laptop keyboard, add `XKB_DEFAULT_LAYOUT=dvorak`.

USB drives should mount automatically, but if they don't use `udiskctl (un)mount -b /dev/sdX`.
Toggle between `dvorak` and `us` keyboard layouts with caps lock.

Use `nmtui` to manager network stuff.

## TODO

- blueberry bluetooth?
