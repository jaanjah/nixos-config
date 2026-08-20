{
  config,
  ...
}:
{
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Saves full VRAM to /tmp on suspend; fixes corruption after resume.
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    open = false;

    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
