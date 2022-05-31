{
  enable = true;
  fonts = [
    "xft:JetBrainsMono Nerd Font:size=11"
    "xft:Vazir Font:size=11"
  ];
  iso14755 = true;
  scroll = {
    bar = {
      enable = false;
    };
  };
  extraConfig = {
    cursor          = "#a89984";
    background      = "#282828";
    foreground      = "#d4be98";

    # Black
    color0          = "#665c54";
    color8          = "#928374";
    
    # Red
    color1          = "#ea6962";
    color9          = "#ea6962";
    
    # Green
    color2          = "#a9b665";
    color10         = "#a9b665";
    
    # Yellow
    color3          = "#e78a4e";
    color11         = "#d8a657";
    
    # Blue
    color4          = "#7daea3";
    color12         = "#7daea3";
    
    # Magenta
    color5          = "#d3869b";
    color13         = "#d3869b";
    
    # Cyan
    color6          = "#89b482";
    color14         = "#89b482";
    
    # White
    color7          = "#d4be98";
    color15         = "#d4be98";

    # Extensions
    perl-ext-common = "bidi";
    perl-lib        = "/home/dripware/.dotfiles/config/urxvt/ext";
  };
}