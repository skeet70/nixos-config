{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "battery" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  boot.extraModulePackages = [ ];

  networking.hostName = "murph-icl-gen2";

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b7dcb30c-e8a8-4450-8297-c5b81975fa6f";
      fsType = "btrfs";
      options = [ "subvol=root" "compress-force=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/20ac52dd-b7ad-46a1-964f-2cd025dfb0e1";

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/b7dcb30c-e8a8-4450-8297-c5b81975fa6f";
      fsType = "btrfs";
      options = [ "subvol=home" "compress-force=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/b7dcb30c-e8a8-4450-8297-c5b81975fa6f";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress-force=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/b7dcb30c-e8a8-4450-8297-c5b81975fa6f";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress-force=zstd" "noatime" ];
    };

  fileSystems."/var/log" =
    {
      device = "/dev/disk/by-uuid/b7dcb30c-e8a8-4450-8297-c5b81975fa6f";
      fsType = "btrfs";
      options = [ "subvol=log" "compress-force=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/17AE-3D77";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7aaeef47-7f4d-4095-bae3-f63aa98a7075"; }];

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp82s0.useDHCP = lib.mkDefault true;
  # see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];
  # compensate for thinkpad trackpoint name
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";
  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
  # get discrete HDMI port to work, attempt nvidia drivers
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
      offload.enable = true;
    };
    powerManagement.enable = true;
  };
  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true;

  # may not do anything on wayland but good reference if needed
  services.xserver = lib.mkMerge [
    {
      # set the right DPI. xdpyinfo says the screen is 508x285 but it's actually 344x193
      monitorSection = ''
        DisplaySize 344 193
      '';

      # try nvidia drivers
      videoDrivers = [ "modesetting" "nvidia" ];
    }
  ];

  services.throttled.enable = lib.mkDefault true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_BAT = 60;
    };
  };
  services.fstrim.enable = lib.mkDefault true;
}
