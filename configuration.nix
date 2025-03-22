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
  boot.extraModulePackages = [
    config.boot.kernelPackages.nvidia_x11
  ];
  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Casablanca";

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


  #services.displayManager.ly.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  


  # Enable the X11 windowing system.
  # Configure keymap in X11
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
    #dsipaly manager / login manager
  };

  # Enable hyperland
  programs.hyprland = {
    enable = true; # enable Hyprland
    withUWSM  = true;
    xwayland.enable = true;
  };
  security.pam.services.swaylock = {}; #sway lock active
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh = {
	enable = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rambeau = {
    isNormalUser = true;
    description = "Rambeau";
    extraGroups = [ "networkmanager" "wheel" ];
  
    shell = pkgs.zsh;
    packages = with pkgs; [
      # kdePackages.kate
      # flatpak
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gh
    fzf
    zellij
    lazygit 
    fastfetch

    btop
    fd
    lsd
    zoxide
    bat
    du-dust
    duf
    neovim 

    git
    wget
    curl
    pciutils
    glxinfo  

    wofi
    kitty
    ghostty
    vscode-fhs
    #lf

    waybar
  ];

  services.flatpak.enable = true;

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
  networking.firewall.enable = true;


######################################################################################## nvidia
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  # services.xserver.videoDrivers = ["modesetting" "nvidia"];


  # Enable OpenGL
  hardware.graphics = {
    enable = true;

    enable32Bit = true;
    extraPackages = with pkgs; [  
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      libvdpau-va-gl # Bridge between VDPAU (NVIDIA's video API) and VA-API (Intel's video API)
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ 
      intel-media-driver
      intel-vaapi-driver 
    ];
  };
  # environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false; # requre OFFLOAD

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    prime = {
      sync.enable = true;

      #  offload = {
      #     enable = true;
      #     enableOffloadCmd = true;
      #   };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest; # might break i see deprication warnings
        # substituteStream() in derivation nvidia-x11-565.77-6.6.82: WARNING: '--replace' is deprecated, use --replace-{fail,warn,quiet}. (file 'nvidia-bug-report.sh')
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

############################################################################################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
