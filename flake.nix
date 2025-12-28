{
  description = "Home Manager configuration";

  inputs = {
    # Use nixpkgs-unstable for the latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # This ensures home-manager uses the same nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
     };
    
    elephant.url = "github:abenz1267/elephant";
    walker = {
    url = "github:abenz1267/walker";
    inputs.elephant.follows = "elephant";
   };
  };

  nix.settings = {
  extra-substituters = ["https://walker.cachix.org" "https://walker-git.cachix.org"];
  extra-trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="];
};

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Define user configurations for different devices
      userConfigs = {
        # Primary user configuration
        tp = {
          username = "aki";  # Replace with your username
          homeDirectory = "/home/aki";  # Replace with your home path
        };

        # Add more configurations as needed
        # work = {
        #   username = "<work-username>";
        #   homeDirectory = "/home/<work-username>";
        # };
      };

      mkHomeConfig = name: config:
      home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
            {
              home = {
                inherit (config) username homeDirectory;
                stateVersion = "25.11";
             };

              # Protect Omarchy-managed directories
              home.file.".config/omarchy".enable = false;
              home.file.".config/hypr".enable = false;
              home.file.".config/alacritty".enable = false;
              home.file.".config/btop/themes".enable = false;
            }
          ];
        };
    in {
      homeConfigurations = builtins.mapAttrs mkHomeConfig userConfigs;
    };
}
