pkgs:

pkgs.buildEnv {
  name = "mac-home";
  paths = with pkgs; [
    zig
    flashrom
    tree
    bun
    neovim
    nil
    lua-language-server
    typst
    tinymist

    # fonts
    nerd-fonts.fira-code

    # tools
    tt
    fastfetch
    cmatrix
    ripgrep
    graphviz
    (python3.withPackages (
      ppkgs: with ppkgs; [
        numpy
        pandas
        pwntools
        pydot
        ipython
        torch-bin
        torchvision-bin
        matplotlib
        flask
        flask-cors
        bcrypt
      ]
    ))
    p7zip
    age
    verilog
    mtr
    b3sum
    android-tools
    exiftool
    minisign
    idevicerestore
    libimobiledevice
    qemu
  ];
}
