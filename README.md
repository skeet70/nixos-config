# nixos-config

`sudo ln -s ~/nixos-config /etc/nixos`
once applied run `sway --unsupported-gpu` to start the gui. If on the laptop keyboard, add `XKB_DEFAULT_LAYOUT=dvorak`.

USB drives should mount automatically, but if they don't use `udiskctl (un)mount -b /dev/sdX`.
Toggle between `dvorak` and `us` keyboard layouts with caps lock.

- Use `nmtui` to manager network stuff.
- Use `spotify_player` for Spotify.
- If you need full battery charge before taking the laptop to-go, run `sudo tlp fullcharge`.
- For now `systemctl --user start docker` to enable docker on a per-run basis. I had it `enable`d in systemctl, but an upgrade broke that when the symlink changed.
- `nix-shell -p kooha` for screen recording.
- start `vscode` with `--ozone-platform=wayland` for now. [vscode is broken right now](https://github.com/NixOS/nixpkgs/issues/246509) for me on wayland.
- use `hx` (helix) as a vscode alternative for now.
  - (with something selected) `*vn` to select more instances of it, then `c` to change them all. Useful when it's not a symbol recognized by the LSP.
    - (with something selected) `*%s` then enter to select all in doc of something hovered
  - `,` to collapse multiple cursors
  - `%s` to search+select all occurrences of something typed in the doc
- start `brave` with `NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:nix-community/nixGL -- brave` for now so hardware acceleration works
  - prefer firefox but was having memory-leaky problems and meet issues as of 04/03/24

## TODO

- hardware acceleration stopped working in brave even in `nixGL`
