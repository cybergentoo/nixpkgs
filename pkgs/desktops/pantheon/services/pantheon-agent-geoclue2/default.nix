{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
, meson
, ninja
, vala
, glib
, gtk3
, libgee
, desktop-file-utils
, geoclue2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-geoclue2";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-LrDu9NczSKN9YLo922MqYbcHG1QAwzXUb7W0Q/g9ftI=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
   ];

  buildInputs = [
    geoclue2
    gtk3
    libgee
   ];

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/pantheon-agent-geoclue2/pull/21
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Pantheon Geoclue2 Agent";
    homepage = "https://github.com/elementary/pantheon-agent-geoclue2";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
