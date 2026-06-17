{
  buildQmkFirmware,
  fetchFromGitHub,
  ...
}:

let
  # just a random example I found on GitHub, can also be a path instead of a
  # derivation to for example your current git repository.
  qmkUserspace = fetchFromGitHub {
    owner = "filterPaper";
    repo = "qmk_userspace";
    rev = "9075e194d51677ce75bc8516e21eb02acdf11034";
    hash = "sha256-k1Jr30L+qbtQPpJrAMEb95SMppWHxIyrxq+xLs0KPPk=";
  };
in

# Using the new userspace feature:

buildQmkFirmware {
  keyboard = "cradio";
  split = true;
  inherit qmkUserspace;
}
