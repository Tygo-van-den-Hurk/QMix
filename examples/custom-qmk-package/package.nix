{
  buildQmkFirmware,
  qmk,
  ...
}:

# A different version of the qmk package:

buildQmkFirmware {
  keyboard = "2key2crawl";
  inherit qmk;
}
