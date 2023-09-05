{ config, lib, pkgs, modulesPath, ... }:

{
  # adds the OpenTabletDriver service and otd/otd-gui programs for managing tablets
  # use otd-gui to set the area to a specific window
  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = true;
}
