# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "za";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    ncdu
    nfs-utils
    htop
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  fileSystems."/mnt/movies" = {
    device = "192.168.1.182:/mnt/drive-8tb-01/movies";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" ];
  };

  fileSystems."/mnt/series" = {
    device = "192.168.1.182:/mnt/drive-8tb-02/series";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" ];
  };

  fileSystems."/mnt/docker-volumes" = {
    device = "192.168.1.182:/mnt/drive-4tb-01/docker-volumes";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" "rw" "exec" ];
  };

  fileSystems."/mnt/audiobooks" = {
    device = "192.168.1.182:/mnt/drive-4tb-01/audiobooks";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" ];
  };

  fileSystems."/mnt/photos" = {
    device = "192.168.1.182:/mnt/drive-4tb-01/photos";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" ];
  };

  fileSystems."/mnt/homevideos" = {
    device = "192.168.1.182:/mnt/drive-4tb-02/homevideos";
    fsType = "nfs";
    options = [ "soft" "intr" "bg" "rw" "exec" ];
  };
  environment.etc."mnt/movies".source = pkgs.writeText "empty" "";
  environment.etc."mnt/series".source = pkgs.writeText "empty" "";
  environment.etc."mnt/docker-volumes".source = pkgs.writeText "empty" "";
  environment.etc."mnt/audiobooks".source = pkgs.writeText "empty" "";
  environment.etc."mnt/photos".source = pkgs.writeText "empty" "";
  environment.etc."mnt/homevideos".source = pkgs.writeText "empty" "";

  environment.shellAliases = {
    ncdu = "${pkgs.writeScriptBin "ncdu" ''
      #!${pkgs.bash}/bin/bash
      exec \${pkgs.ncdu}/bin/ncdu --exclude /mnt/movies --exclude /mnt/series --exclude /mnt/docker-volumes --exclude /mnt/audiobooks --exclude /mnt/photos --exclude /mnt/homevideos "$@"
    ''}";
  };

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];

}

