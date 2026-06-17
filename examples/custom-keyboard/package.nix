{
  buildQmkFirmware,
  ...
}:

# Building your own keyboard not in the main QMK repository.

buildQmkFirmware {
  keyboard = "myboard";
  src = ./src;
}
