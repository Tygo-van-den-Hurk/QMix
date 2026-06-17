{
  buildQmkFirmware,
  ...
}:

# A split keyboard nested deep inside the keyboards subdirectory:

buildQmkFirmware {
  keyboard = "splitkb/aurora/lily58";
  split = true;
}
