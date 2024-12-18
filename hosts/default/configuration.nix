# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
#      inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Athena"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.windowManager.hypr.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
 # services.xremap = {
 #   userName = "naidneelttil";
 #   watch = true;
 #   yamlConfig = ''
 #     modmap:
 #       - name: Global
 #         remap:
 #           Esc: CapsLock
 #           CapsLock: Esc
 #           ALT_L: CONTROL_L
#            CONTROL_L: ALT_L
#            ALT_R: CONTROL_R
#            CONTROL_R: ALT_R
#    '';
#  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable Experimental Features
  nix.settings.experimental-features =[ "nix-command" "flakes"];	
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.naidneelttil = {
    isNormalUser = true;
    description = "naidneelttil";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
       "naidneelttil" = import ./home.nix; 

    };
  };

# Make normal binaries work
programs.nix-ld = {
  enable = true;
  libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; 
}; 
programs.nix-ld.package = pkgs.nix-ld-rs;

  # Install firefox.
  #programs.firefox.enable = true;

  #install nixvim 
#  inputs.nixvim.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  virtualisation.podman.enable = true;
  virtualisation.containers.enable = true;

  environment.systemPackages = with pkgs; [ 
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ghidra
  distrobox
  steam-run
  (lib.hiPrio (writeShellScriptBin "python3" ''LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH exec -a $0 ${python3}/bin/python3 "$@"''))
  rust-analyzer
   openvpn
   kanata
   binutils
   gnumake

    (python311.withPackages (ps: with ps; [
      #stem # tor
      angr
      pillow
      pip
      numpy
      scipy
      flake8
      pytest
      coverage
      cython
      wheel
      jupyterlab
      #tensorflow
       pandas
      statsmodels
      matplotlib
      pytorch
      fastai
      #openai
      ipython
      scikitlearn
      sympy 
    ]))  
  ];


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
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  esc  a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lalt lmet lctl           spc            rctl rmet alt
)


    '';
    devices = [];
  };

  #use xremap
 # hardware.uinput.enable = true;
 # users.groups.uinput.members = [ "naidneelttil" ];
 # users.groups.input.members = [ "naidneelttil" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.graphics.extraPackages = with pkgs; [

    rocmPackages.clr.icd
  ];
}
