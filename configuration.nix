{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages;
  };

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  services.resolved.enable = true;
  networking = {
    hostName = "nixos";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = true;
            AutoConnect = true;
          };
          Network = {
            EnableIPv6 = true;
          };
        };
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  users.users.kyd0 = {
    isNormalUser = true;
    description = "reKyd0";
    extraGroups = [ "wheel" "video" "audio" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      ranger
      hyprpaper
      kotatogram-desktop
      libreoffice
      discord
      grim
      shotcut
      wf-recorder
      slurp
      vscodium
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vulkan-tools
      libvdpau-va-gl
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "kyd0";
      };
      default_session = initial_session;
    };
  };

  security.sudo.wheelNeedsPassword = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.xserver.enable = false;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  }; 

  programs.nix-ld.enable = true;
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      hy = "sudo nvim /home/kydo/.config/hypr/hyprland.conf";
      cfg = "codium /home/kyd0/.config";
      nx = "sudo nvim /etc/nixos/configuration.nix";
      rb = "sudo nixos-rebuild switch";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    htop
    btop
    fastfetch
    cava
    wget
    curl
    wofi
    waybar
    kitty
    mpv
    firefox
    unzip
    python3
    bibata-cursors
    jdk21
    openssh
    gcc
    wl-clipboard
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
  ];

  services.tlp.enable = true;
  services.fstrim.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}

