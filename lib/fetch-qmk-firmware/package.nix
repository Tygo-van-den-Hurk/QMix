{
  fetchgit,
}:

{
  url ? "https://github.com/qmk/qmk_firmware.git",
  leaveDotGit ? false,
  fetchSubmodules ? true,
  tag ? null,
  rev ? null,
  hash ? null,
  meta ? { },
}:

fetchgit {
  inherit url;
  inherit tag;
  inherit rev;
  inherit hash;
  inherit fetchSubmodules;
  inherit leaveDotGit;
  inherit meta;
}
