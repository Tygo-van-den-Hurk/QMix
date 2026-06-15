{
  runCommand,
  fetchgit,
  git,
}:
{
  url ? "https://github.com/qmk/qmk_firmware.git",
  origin ? "https://github.com/qmk/qmk_firmware.git",
  leaveDotGit ? false,
  clearKeyboards ? false,
  fetchSubmodules ? true,
  tag ? null,
  rev ? null,
  hash ? null,
  meta ? { },
}:

let
  error = "either the argument `tag' or the argument `rev' is required, but neither was provided";
  revspec =
    if rev != null then
      rev
    else if tag != null then
      tag
    else
      throw error;
in

runCommand "qmk-firmware-${revspec}"
  {
    nativeBuildInputs = [ git ];
    inherit revspec;
    inherit origin;
    inherit leaveDotGit;
    inherit clearKeyboards;
    src = fetchgit {
      inherit url;
      inherit tag;
      inherit rev;
      inherit hash;
      inherit fetchSubmodules;
      inherit leaveDotGit;
    };

    meta = {
      description = "QMK firmware for building a keyboard.";
    }
    // meta;
  }
  /* SHELL */ ''
    cp "$src" -r "$out"
    chmod -R +w "$out"
    cd "$out"

    # Removing all keyboards in the keyboard directory
    if [ "$clearKeyboards" = "${toString true}" ]; then
      echo clearing all keyboards...
      rm -rf keyboards/*
    fi

    # recreating the git repository if .git wasn't left in.
    if [ "$leaveDotGit" = "${toString false}" ]; then
      echo recreating git repository...
      git init
      git config user.email "dev@qmk.fm"
      git config user.name "QMK Developers"
      git remote add origin "$origin"
      git add .
      git commit --message "State at $revspec" \
        --message "This is to keep QMK happy" \
        --date="@0" --quiet
    fi
  ''
