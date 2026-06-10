{
  imports = [
    ./build-qmk-firmware
    ./fetch-qmk-firmware
  ];

  # So that the entire flake can `callPackage` the helper function.
  flake.lib = {
    fetchQmkFirmwareHelperPath = ./fetch-qmk-firmware/package.nix;
    buildQmkFirmwareHelperPath = ./build-qmk-firmware/package.nix;
  };
}
