{ pkgs, ... }:

let
  alacritty-theme = pkgs.fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "94e1dc0b9511969a426208fbba24bd7448493785";
    sha256 = "sha256-bPup3AKFGVuUC8CzVhWJPKphHdx0GAc62GxWsUWQ7Xk=";
  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${alacritty-theme}/themes/alabaster.toml" ];
      font = {
        size = 22.0;
        normal = {
          family = "Monospace";
         
        };

      };
    };
  };
}
