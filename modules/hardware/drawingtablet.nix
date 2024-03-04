{ config, lib, pkgs, modulesPath, ... }:

{
  # adds the OpenTabletDriver service and otd/otd-gui programs for managing tablets
  # use otd-gui to set the area to a specific window
  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = true;
  # not supported by home manager directly, and the config file changes enough for it not to make a ton of sense
  # to static it here. Main thing on a new install would be to change the mode (bottom left) to artist mode to support
  # pressure tip.
}
