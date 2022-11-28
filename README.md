# nixos-config

`sudo ln -s ~/nixos-config /etc/nixos`
once applied run `sway --unsupported-gpu` to start the gui. If in VM with no hardware, add `WLR_NO_HARDWARE_CURSOR=1`. If on the laptop keyboard, add `XKB_DEFAULT_LAYOUT=dvorak`.

USB drives should mount automatically, but if they don't use `udiskctl (un)mount -b /dev/sdX`.
Toggle between `dvorak` and `us` keyboard layouts with caps lock.

Use `nmtui` to manager network stuff.
Use `ncspot` for Spotify.
If you need full battery charge before taking the laptop to-go, run `sudo tlp fullcharge`.

## TODO

- move Insomnia collections over
- move over rust build settings
- try https://github.com/uowuo/abaddon
