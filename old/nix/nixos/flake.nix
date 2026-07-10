{
  description = "My first flakes NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    emacs-overlay.url = github:nix-community/emacs-overlay;
  };
 
  outputs = { self, nixpkgs, home-manager, emacs-overlay }@attrs: {
    
    nixosConfigurations.victor-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    }; 
  };
}
