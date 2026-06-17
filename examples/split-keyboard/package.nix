{
  buildQmkFirmware,
  ...
}:

# A split keyboard:

buildQmkFirmware {
  keyboard = "sofle";
  split = true;
}
