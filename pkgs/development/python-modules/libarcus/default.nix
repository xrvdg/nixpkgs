{ stdenv, lib, fetchFromGitHub, python, cmake, sip, protobuf }:

if lib.versionOlder python.version "3.4.0"
then throw "libArcus not supported for interpreter ${python.executable}"
else

stdenv.mkDerivation rec {
  pname = "libarcus";
  name = "${pname}-${version}";
  version = "3.0.3";
  
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "05dpd6nx32nws0ghsm365wlsb8hg2s3v9fqcmdk11biwfhnr6rjw";
  };
  
  propagatedBuildInputs = [ sip protobuf ];
  nativeBuildInputs = [ cmake ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
