{
	description = "Flake for YANET";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-parts.url = "github:hercules-ci/flake-parts";
		flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
		flake-compat.url = "github:nix-community/flake-compat";
	};

	outputs = inputs @ { flake-parts, ... }: 
		flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				flake-parts.flakeModules.easyOverlay
			];
		
			systems = [ "x86_64-linux" ];

			perSystem = { config, pkgs, ... }: {
				overlayAttrs = {
					inherit (config.packages) yanet;
				};

				packages = rec {
					dpdk = pkgs.callPackage ./pkgs/dpdk { kernel = null; };
					yanet = pkgs.callPackage ./pkgs/yanet { inherit dpdk; };

					default = yanet;
				};
			};
		};
}
