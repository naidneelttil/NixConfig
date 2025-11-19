# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Athena"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
hardware.graphics.extraPackages = with pkgs; [
  rocmPackages.clr.icd
];
 #hardware.amdgpu.opencl = true;
 #hashcat support????
 #nixpkgs.config.rocmSupport = true; 
 # audomatically upgrade the system
 system.autoUpgrade.enable = true;
 system.autoUpgrade.allowReboot = true;
# Enable networking
  networking.networkmanager.enable = true;

#let me use ftp for fuckssake 
networking.firewall.allowedTCPPorts =[ 21 ];
networking.firewall.allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];
#let me print goddamit
  services.printing = {
  
  drivers = with pkgs ; [
     cups-filters
     cups-browsed
  ];

  };	
  #auto-detect printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

  };


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  
  # virtualization with podman 
  virtualisation.podman.enable = true;
  virtualisation.containers.enable = true;
  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;


  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
   # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.naidneelttil = {
    isNormalUser = true;
    description = "naidneelttil";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # allow flatpak
  services.flatpak.enable = true; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # add experimental features
     nix.extraOptions = ''
    experimental-features = nix-command flakes 
    '';
  #install all nerdfonts  
  fonts.packages = with pkgs; [ nerd-fonts.daddy-time-mono ];

  #install ollama as a systemd service
services.ollama = {
  enable = true;
  # Optional: preload models, see https://ollama.com/library
  loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
};

  environment.systemPackages = with pkgs; [
   awscli2
   neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   vlc
   nethack
   ghidra
   fastfetch
   fish
   git
   file
   tmux
   burpsuite
   wireshark
   wget  
   distrobox
   kanata
   nodejs_24
   gcc15
   dos2unix
   zip
   unzip
   vscode
   chromium
   qemu
   nerd-fonts.symbols-only
   nerd-fonts.fira-code
   nerd-fonts.ubuntu
   nerd-fonts.daddy-time-mono
   docker-compose
   rubyPackages_3_4.railties
   dirbuster
   kitty
   nmap
   hashcat
   ocl-icd
   pocl
   anki-bin
   signal-desktop
   yt-dlp
   checksec
   gdb
   zellij
   ngrok
   openvpn
   tldr
    (python312.withPackages (ps: with ps; [
      pip
      numpy
      requests
      beautifulsoup4
      lxml
      pwntools
       #tensorflow
       pandas
      # py-cord
      # discordpy
       python-dotenv
      ]))  

  ];
# Make normal binaries work
programs.nix-ld = {
  enable = true;
  libraries = pkgs.steam-run.args.multiPkgs pkgs; 
}; 

  services.kanata.enable = true;
  services.kanata.keyboards.box = {
    config = ''
(defsrc
  esc
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)


(deflayer default
  caps
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    @e    r    t    @y   @u   @i   @o    p    [    ]    \
  esc  @a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lalt lmet lctl           spc            rctl rmet alt
)

(defalias
  a (tap-dance 200 (a (unicode ā))) 
  o (tap-dance 200 (o (unicode ō))) 
  i (tap-dance 200 (i (unicode ī)))
  e (tap-dance 200 (e (unicode ē)))
  y (tap-dance 200 (y (unicode ȳ)))
  u (tap-dance 200 (u (unicode ū)))


)

    '';
    devices = [];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

