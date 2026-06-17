{
  buildQmkFirmware,
  ...
}:

# Using your own keymap:

buildQmkFirmware rec {
  keyboard = "2key2crawl";
  keymap = "custom";
  src = ./src;
  srcMount = "keyboards/${keyboard}/keymaps/${keymap}";
}
