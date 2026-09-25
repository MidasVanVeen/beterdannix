{
  description = "placeholder server config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ({ pkgs, ... }: {
            networking.hostName = "beterdanniet";

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            # The firewall rejects incoming connections by default. SSH is the
            # only explicitly allowed TCP service.
            networking.firewall = {
              enable = true;
              allowedTCPPorts = [ 22 ];
            };

            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
              };
            };

            users.users.midas = {
              isNormalUser = true;
              description = "Midas van Veen";
              extraGroups = [ "wheel" ];
              initialHashedPassword = "$y$j9$T.adctGxV6tDLmHUUq1bNK/$2PRVCwbT0D7fAM1bDw8s/e51UfOd7QJmZgFJwvWLK0C";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpefuRpvepWVnJYlVOelftRZD5rzRQS/vyoUKpnp3WM midasvanveen.email@gmail.com"
              ];
            };

            environment.systemPackages = [ pkgs.vim ];

            system.stateVersion = "25.11";
          })
        ];
      };
    };
}
