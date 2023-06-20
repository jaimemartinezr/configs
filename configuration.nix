# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
  #  useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    windowManager.bspwm.enable = true;
    displayManager.defaultSession = "none+bspwm";
  };
 
  programs.gamemode.enable = true;

  # Enable the X11 windowing system.
  
  fileSystems."/mnt" = { 
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Configure keymap in X11
   services.xserver.layout = "es";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.userjaime = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;
  
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ 
    virt-manager
    qemu
    htop
    ranger
    killall
    gnumake];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.steam = {
  enable = true;
  dedicatedServer.openFirewall = true;
  };

  home-manager.useGlobalPkgs = true;

  home-manager.users.userjaime = { pkgs, ... }: {
    
    home.packages = [
      pkgs.firefox
      pkgs.tree
      pkgs.neofetch
      pkgs.picom
      pkgs.feh
      pkgs.eww
      pkgs.tor-browser-bundle-bin
      pkgs.vlc
      pkgs.rofi
      pkgs.nerdfonts
      pkgs.ripgrep
      pkgs.fd
      pkgs.lua-language-server
      pkgs.llvmPackages_16.clang-unwrapped
      pkgs.cmake
      pkgs.qbittorrent];
    
    xsession.windowManager.bspwm = {
      enable = true;
      monitors = {
        HDMI-0 = ["I" "II" "III" "IV" "V"];
      };
      settings = {
        border_width = 2;
        window_gap = 12;
        split_ratio = 0.52;
        borderless_monocle = true;
        gapless_monocle = true;
	pointer_modifier = "mod4";
	pointer_action1 = "move";
	pointer_action2 = [ "resize_side" "resize_corner"];
      };
      rules = {
        "steam" = {
	  state = "floating";
	  border = false;
        };
	"firefox" = {
	  state = "floating";
	  border = false;
	};
      };
      extraConfigEarly = "pgrep -x sxhkd > /dev/null || sxhkd &";
      extraConfig = "~/.fehbg &";
      startupPrograms = ["polybar" "feh"];
    };

    services.picom = {
      enable = true;
      vSync = true;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      settings = {
        blur = {
          method = "dual_kawase";
          strength = 1;
        };
      };
    };

    programs.rofi = {
      enable = true;
    };
    
    programs.kitty = {
      enable = true;
      font = {
        name = "NoToSerifNerdFont";
        size = 16;
      };
      settings = {
        background_opacity = "0.8";
      };
      theme = "Sakura Night";
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        telescope-nvim  
        nvim-treesitter.withAllGrammars
	lsp-zero-nvim
	nvim-lspconfig
	nvim-cmp
	cmp-nvim-lsp
	luasnip];
    };

    services.polybar = {
      enable = true;
      package = pkgs.polybarFull;
      config = {
        "colors" = {
          background = "#142445";
          foreground = "#e3c7fc";
          primary = "#e3c7fc";
          secondary = "#e3c7fc";
          alert = "#A54242";
          disabled = "#707880";
        };
        "bar/mybar" = {
          width = "100%";
          height = "24pt";
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          line-size = "3pt";
          border-color = "#00000000";
          padding-left = 0;
          padding-right = 1;
          module-margin = 1;
          font-0 = "NoToSerifNerdFont:size=16";
          modules-left = "xworkspaces";
          modules-center= "xwindow";
          modules-right = "filesystem pulseaudio xkeyboard memory cpu eth date";
          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
          enable-ipc = "true";
          wm-restack = "bspwm";
        };
        "module/xworkspaces" = {
          type = "internal/xworkspaces";
          label-active = "%name%";
          label-active-background = "\${colors.background-alt}";
          label-active-underline= "\${colors.primary}";
          label-active-padding = 1;
          label-occupied = "%name%";
          label-occupied-padding = 1;
          label-urgent = "%name%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 1;
          label-empty = "%name%";
          label-empty-foreground = "\${colors.disabled}";
          label-empty-padding = 1;
        };
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:60:...%";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = 5;
          mount-0 = "/";
          label-mounted = "%{F#e3c7fc}󰋊%{F-} %percentage_used%%";
          label-unmounted = "󱁌";
          label-unmounted-foreground = "\${colors.disabled}";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          format-volume-prefix = " ";
          format-volume-prefix-foreground = "\${colors.primary}";
          format-volume = "<label-volume>";
          label-volume = "%percentage%%";
          label-muted = "󰝟";
          label-muted-foreground = "\${colors.disabled}";
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";
          label-layout = "󰌌 %layout%";
          label-layout-foreground = "\${colors.primary}";
          label-indicator-padding = 2;
          label-indicator-margin = 1;
          label-indicator-foreground = "\${colors.background}";
          label-indicator-background = "\${colors.secondary}";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "󰍛 ";
          format-prefix-foreground = "\${colors.primary}";
          label = "%percentage_used:2%%";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "󰻠 ";
          format-prefix-foreground = "\${colors.primary}";
          label = "%percentage:2%%";
        };
        "module/eth" = {
          type = "internal/network";
          interval = 5;
          format-connected = "<label-connected>";
          format-disconnected = "<label-disconnected>";
          label-disconnected = "%{F#e3c7fc}%{F#707880} disconnected";
          interface-type = "wired";
          label-connected = "%{F#e3c7fc}%{F-} %local_ip%";
        };
        "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%H:%M";
          date-alt = "%Y-%m-%d %H:%M:%S";
          label = "%date%";
          label-foreground = "\${colors.primary}";
        };
        "settings" = {
          screenchange-reload = true;
          pseudo-transparency = true;
        };
      };
      script = "killall -q polybar/npolybar mybar 2>&1 | tee -a /tmp/polybar.log & disown";
    };

    home.stateVersion = "23.05";
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
