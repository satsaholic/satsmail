{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
  ];  

  imports = [
    ./hardware-configuration.nix
    ./mailserver.nix    
    
  ];

  boot.cleanTmpDir = true;
  networking.hostName = "larawag-419";
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIT7z0zlSGVnGsHKLEcGfgRz0VyPRX4X9UOuorPVdgfR"
  ];

  services.bind = {
    enable = true;
    zones = [
      { name = "satsaholic.duckdns.org"; 
        master = true; 
        file = "satsaholic.duckdns.org.zone"; 
        masters = []; slaves = [];
        extraConfig = "";
      }
    ];
  };
}
