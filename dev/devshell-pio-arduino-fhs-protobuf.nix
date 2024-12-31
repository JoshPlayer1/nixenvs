{pkgs ? import <nixpkgs> {}, ...}: let
  envname = "pio-arduino-fhs";
  # as a function to make sure the same pkgs is used as in targetPkgs
  mypython = pks: pks.python3.withPackages (ps: with ps; [platformio pylibftdi pyusb protobuf setuptools]);
  # "proxy" env, is this useful/necessary???
  # myEnv = pkgs.buildEnv {
  #   name = envname;
  #   paths = [ pkgs.zsh ];
  # };
in
  (pkgs.buildFHSUserEnv {
    name = envname;
    targetPkgs = pkgs: (with pkgs; [
      arduino-cli
      avrdude
      libftdi
      # libusb
      libftdi1
      libusb1
      platformio-core
      python312Packages.setuptools
      (mypython pkgs)
      zsh
    ]);
    # NOTE:just use nix develop or do this in your .envrc to avoid a load loop:
    # https://github.com/direnv/direnv/issues/992#issuecomment-1744989487
    runScript = ''
      ${pkgs.zsh}/bin/zsh
    '';
  })
  .env
