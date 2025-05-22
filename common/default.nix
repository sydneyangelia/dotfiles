{
  inputs,
  pkgs,
  config,
  ...
}:
{
  # Configuring Nix
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    channel.enable = false;
    nixPath = [ "nixpkgs=${config.nix.registry.nixpkgs.to.path}" ];
    registry = {
      n.flake = inputs.nixpkgs;
    };
    settings.auto-optimise-store = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  # Base Packages
  environment.systemPackages = with pkgs; [
    fastfetch
    neovim
    man-pages
    man-pages-posix
    gptfdisk
  ];

  # Localization
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  # Other Settings
  documentation.dev.enable = true;
  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;
  programs.git.enable = true;
  console.keyMap = "dvorak";
}
