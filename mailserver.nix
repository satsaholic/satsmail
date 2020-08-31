{ config, pkgs, ... }:
{
  imports = [
    (builtins.fetchTarball {
      # Pick a commit from the branch you are interested in
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-20.03/nixos-mailserver-nixos-20.03.tar.gz";
      # And set its hash
      sha256 = "02k25bh4pg31cx40ri4ynjw65ahy0mmj794hi5i1yn48j56vdbkj";
    })
  ];

  # Some Lets Encrypt related settings. Using the very email address that this server will host.
  security.acme.email = "satsaholic@satsaholic.duckdns.org";
  security.acme.acceptTerms = true;

  mailserver = {
    enable = true;
    localDnsResolver = false; # default is true, but we are overriding since this server also runs our dns server on port 53
    fqdn = "mx1.satsaholic.duckdns.org";
    domains = [ "satsaholic.duckdns.org" ];

    # A list of all login accounts. To create the password hashes, use
    # mkpasswd -m sha-512 "super secret password"
    loginAccounts = {
        "satsaholic@satsaholic.duckdns.org" = {
            hashedPassword = "$6$AI5W0k30tinN.J$/X8euz4Ht8gYC0k7rJcl3yPGPhqikdnC78B4pgdtc/DQWQ5SvV9lZBBh/AXsJ.WBg8Lgg5tHCrlXn9qYCztEJ.";

            aliases = [
                "postmaster@satsaholic.duckdns.org"
            ];

            # Make this user the catchAll address for domains example.com and
            # example2.com
            catchAll = [
                "satsaholic.duckdns.org"
            ];
        };

       # "user2@example.com" = { ... };
    };

    # Extra virtual aliases. These are email addresses that are forwarded to
    # loginAccounts addresses.
    extraVirtualAliases = {
        # address = forward address;
        # "abuse@example.com" = "user1@example.com";
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}

