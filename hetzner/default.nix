{ pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  # Running Services
  services = {
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = false;
  };

  # Base Packages
  environment.systemPackages = with pkgs; [
    ghostty.terminfo
    tmux
    arch-install-scripts
    tcpdump
    dig
  ];

  # Network Setup
  networking = {
    hostName = "hetzner";
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    useDHCP = true; # Switch this to a static setup later
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = builtins.readFile ./nftables.conf;
    };
  };

  # User Account
  users.users.sydney = {
    description = "Sydney Angelia";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRJWbyvyeo8ykLovPOR+EuwqmjOsSrBBckpicVWhULl mac"
    ];
  };

  # Boot/Firmware stuff
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };

  # Miscellaneous settings
  system.stateVersion = "24.05";
  nix.settings.trusted-users = [
    "@wheel"
  ];

}
