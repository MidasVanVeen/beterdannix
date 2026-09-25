{ pkgs, ... }:

{
  networking.hostName = "beterdannix";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Matches the partitioning from the Hetzner traditional ISO guide.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Hetzner x86_64 traditional installation uses legacy boot.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    "ext4"
  ];

  users.users.root.hashedPassword = "!";

  users.users.midas = {
    isNormalUser = true;
    description = "Midas van Veen";

    extraGroups = [
      "wheel"
    ];

    initialHashedPassword =
      "$y$j9$T.adctGxV6tDLmHUUq1bNK/$2PRVCwbT0D7fAM1bDw8s/e51UfOd7QJmZgFJwvWLK0C";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpefuRpvepWVnJYlVOelftRZD5rzRQS/vyoUKpnp3WM midasvanveen.email@gmail.com"
    ];
  };

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "25.11";
}
