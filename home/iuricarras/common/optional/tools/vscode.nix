{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
      ms-vscode.cpptools-extension-pack
      ms-python.python
    ];
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  home.file.".config/Code/User/settings.json".text = ''
    {
      "github.copilot.nextEditSuggestions.enabled": true,
      "files.autoSave": "afterDelay",
      "nix.serverPath": "nixd",
      "nix.enableLanguageServer": true,
      "nix.serverSettings": {
        "nixd": {
          "formatting": {
            "command": [ "alejandra" ],
          },
        }
      },
      "workbench.colorTheme": "Default Light Modern"
    }
  '';
}
