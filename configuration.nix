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

  # open a port in the firewall for the DNS server
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  
  # setup the dns server to serve the zone file we want
  services.bind = {
    enable = true;
    ipv4Only = false;
    zones = [
      { name = "satsaholic.duckdns.org"; 
        master = true; 
        file = "/etc/nixos/satsaholic.duckdns.org.zone"; 
        masters = []; slaves = [];
        extraConfig = "";
      } 
      { name = "19.217.95.in-addr.arpa"; 
        master = true; 
        file = "/etc/nixos/19.217.95.in-addr.arpa.zone"; 
        masters = []; slaves = [];
        extraConfig = "";
      }
    ];
  };

  # enable nginx for a rented subdomain
  services.nginx.enable = true;
  services.nginx.virtualHosts."simplythebest.lnpay.xyz" = {
      root = "/var/www/simplythebest.lnpay.xyz";
  };
}
