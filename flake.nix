{
  description = "iuricarras' Nix-Config";
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    #
    # ========= Architectures =========
    #
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];

    #
    # ========= Host Config Functions =========
    #
    # Handle a given host config
    mkHost = host: {
      ${host} = let
        systemFunc = lib.nixosSystem;
      in
        systemFunc {
          specialArgs = {
            inherit
              inputs
              outputs
              ;

            # ========== Extend lib with lib.custom ==========
            # NOTE: This approach allows lib.custom to propagate into hm
            # see: https://github.com/nix-community/home-manager/pull/3454
            lib = nixpkgs.lib.extend (self: super: {custom = import ./lib {inherit (nixpkgs) lib;};});
          };
          modules = [
            ./hosts/nixos/${host}
          ];
        };
    };
    # Invoke mkHost for each host config
    mkHostConfigs = hosts: lib.foldl (acc: set: acc // set) {} (lib.map (host: mkHost host) hosts);
    # Return the hosts declared in the given directory
    readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
  in {
    #
    # ========= Overlays =========
    #
    # Custom modifications/overrides to upstream packages.
    overlays = import ./overlays {inherit inputs;};

    #
    # ========= Host Configurations =========
    #
    # Building configurations is available through `just rebuild` or `nixos-rebuild --flake .#hostname` or `nh os`
    nixosConfigurations = mkHostConfigs (readHosts "nixos");

    #
    # ========= Packages =========
    #
    # Add custom packages to be shared or upstreamed.
    # packages = forAllSystems (
    #   system: let
    #     pkgs = import nixpkgs {
    #       inherit system;
    #       overlays = [self.overlays.default];
    #     };
    #   in
    #     lib.packagesFromDirectoryRecursive {
    #       callPackage = lib.callPackageWith pkgs;
    #       directory = ./pkgs/common;
    #     }
    # );

    #
    # ========= Formatting =========
    #
    # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };

  inputs = {
    #
    # ========= Official NixOS, NUR and HM Package Sources =========
    #
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The next two are for pinning to stable vs unstable regardless of what the above is set to
    # This is particularly useful when an upcoming stable release is in beta because you can effectively
    # keep 'nixpkgs-stable' set to stable for critical packages while setting 'nixpkgs' to the beta branch to
    # get a jump start on deprecation changes.
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #
    # ========= Utilities =========
    #
    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative vms using libvirt
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix.url = "github:danth/stylix/release-24.11";

    #
    # ========= Personal Repositories =========
    #
    # Discord Bot
    #
    discord_bot = {
      url = "github:iuricarras/discord_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #
    # SDDM Themes
    #
    sddm-themes = {
      url = "github:iuricarras/sddm-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private secrets repo.
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/iuricarras/nix_private.git?ref=main&shallow=1";
      inputs = {};
    };

    #nixos-proxmox
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };
}
