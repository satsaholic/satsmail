## Satsmail
The goal here is to document the evolution of and, where necessary, the creation of the various
[NixOS](https://nixos.org) configuration files that may be needed to accomplish:
1. DNS Server - (status: nearly complete) - a fully configured DNS server which is serving the authoratative DNS record for some domain (or subdomain -- `satsaholic.duckdns.org` in this case)
2. EMAIL Server - (status: working but needs more dns records for mail deliverability, etc) -- a fully configured mail server with one or more users that can send/receive mail via accounts at that domain
3. PRIVACY - (status: not started) - get all this working behind tor for privacy reasons, rent ports/ip addresses where necessary and reverse route them to tor hidden services
4. CONVENIENCE - (status: not started) - integrate bitcoin's lightning network payments as a way to align the economics of the above and have everything up and running smoothly and quickly

### Base Setup & Workflow
1. After installing NixOS (the operating system, not just the package manager) the system configuration file in `/etc/nixos/configuration.nix` is pretty minimal.
2. We make changes to the `configuration.nix` file and/or break it into sub-files.
3. Setting up `/etc/nixos` as a git repository seems to make sense for now. There are probably better ways.
4. After making changes to the nix configuration files (preferably comimitting the changes to a git branch), run `nixos-rebuild switch` to deterministically rebuild the system configuration and switch to the new config
5. If all is well, merge the branch into master.

#### System Notes

##### DNS Server Setup
1. Enabling Bind9 in NixOS is easy. The available options are under `services.bind` and are described [here](https://github.com/NixOS/nixpkgs-channels/blob/nixos-20.03/nixos/modules/services/networking/bind.nix)
2. Sometimes it is easier to browse the options [here](https://search.nixos.org/options?show=services.bind.zones&query=services.bind&from=0&size=30&sort=relevance&channel=20.03)
3. Make sure that the zone file you are feeding in is properly written.
4. Then run `nixos-rebuild switch` and hopefully, if all went well, you now have a dns server running.

##### Mail Server Setup
1. On a server running NixOS where the server has been already configured with a nameserver (e.g. bind9)
2. Followed [these instructions](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/wikis/A-Complete-Setup-Guide)
3. Then run `nixos-rebuild switch --upgrade`
