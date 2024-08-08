{
  config,
  pkgs,
  ...
}: {
  home = {
    homeDirectory = "/home/jason";

    packages = with pkgs; [
      lolcat
    ];

    stateVersion = "22.11";
    username = "jason";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
