{
  buildQmkFirmware,
  ...
}:

# An older version of the QMK firmware repository:

buildQmkFirmware {
  keyboard = "2key2crawl";
  qmkFirmware = "v0.32.16";
}
