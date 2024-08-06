{ config, pkgs, ... }:

{
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = pkgs.lib.mkForce [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];
}
