{
  lib, 
  stdenv,
  fetchFromGitLab,
  gtk3,
  libGLU,
  intltool,
  pkg-config,
  libyaml,
  gfortran,
  wrapGAppsHook,
  openbabel2, 
  netcdf,
  libtool,
  automake,
  autoconf,
  gtk-doc,
  libxslt,
  cairo,
  libepoxy,
  cmake,
  libarchive,
  withCube ? true,
  withOpenBabel ? true,
  withXsf ? true,
  withMsym ? true,
  withEtsfFileFormat ? true,
  withArchives ? true,

}: stdenv.mkDerivation {
  pname = "v_sim";
  version = "staging";

  src = fetchFromGitLab {
    owner = "l_sim";
    repo = "v_sim";
    # Use this if you want to use the latest commit from the statig branch.
    # Don't forget to reset the hash, otherwise nix will stick with the version that has the specified hash.
    rev = "028868150220063856aae36bbbf2c5947c46f745"; 
    hash = "sha256-4BdmkguvqZ9uGNiOoS71zjXuH5IP/usPrZAxX6hhEDw=";
    # 3.8.0
    # rev = "${version}";
    # hash = "sha256-2igDBoEKQkhc2S6ErObYci6Ae3cYtpee5y+ElO3zCqs=";
  };
  # It is also possible to use the tarball from the v_sim website and avoid the autogen
  # src = fetchTarball {
  #   # https://l_sim.gitlab.io/v_sim/download-confirm.en.html?v_sim.tar.bz2
  #   url = "https://l_sim.gitlab.io/v_sim/download/v_sim.tar.bz2";
  #   sha256 = "0dw5zm919s97c33c77zqfqfhm8012g1n27hvijiq3l860si1dqnh";
  # };  

  enableParallelBuilding = true;

  # nativeBuildInputs are dependencies that are only needed at build time
  nativeBuildInputs = [
    wrapGAppsHook 

    # needed for the preConfigure phase when building from gitlab 
    libtool
    automake
    autoconf
    gtk-doc
    libxslt
    
    # for the staging version
    #cmake
    ]
    ++ lib.optional withMsym cmake;
  
  # buildInputs are the ones that might be linked to the final executable
  buildInputs = [ 
    gtk3
    libGLU
    intltool
    pkg-config
    libyaml
    gfortran
    cairo
    libepoxy
    ] 
    ++ lib.optional withOpenBabel openbabel2
    ++ lib.optional withEtsfFileFormat netcdf
    ++ lib.optional withArchives libarchive;

  preConfigure = ''
    ./autogen.sh
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  # prevents mkDerivation from messing with cmake flags. Otherwise the Msym plugin will not compile
  dontUseCmakeConfigure = true;

  configureFlags = []
    ++ lib.optional withXsf "--with-xsf"
    ++ lib.optional withCube "--with-cube"
    ++ lib.optional withMsym "--with-msym" # what does it do?
    ++ lib.optional withOpenBabel "--with-openbabel"
    ++ lib.optional withEtsfFileFormat "--with-etsf-file-format";
    # These ones are left out 
    # "--with-strict-cflags"   # this does not compile
    # "--enable-gtk-doc"       # don't need docs (it's meant for developers)
    # "--enable-introspection" # still experimental, don't include it for now (might depend on: libgirepository1.0-dev python-gi-dev python3-dev python3-gi)
    # "--with-archives"        # not sure what it does

  # will run make check
  doCheck = true;

  meta = with lib; {
    # the original software is published under cecill 1.1, but it seems that it might be okey to redistribute it under follow up licenses?
    license = licenses.cecill21;
    description = "v_sim - Visualize atomic structures";
    maintainer = "";
    #platforms = platforms.all; # has not been tested for anything else than x86_64-linux
    mainProgram = "v_sim";
    longDescription = ''
      V_Sim visualizes atomic structures such as crystals, grain boundaries, molecules and so on (either in binary format, or in plain text format).

       The rendering is done in pseudo-3D with spheres (atoms) or arrows (spins). The user can interact through many functions to choose the view, set the pairs, draw cutting planes, compute surfaces from scalar fields, duplicate nodes, measure geometry... Moreover V_Sim allows to export the view as images in PNG, JPG or scheme in PDF, SVG and other formats. Some tools are also available to colorize atoms from data values or to animate on screen many position files. The tool is fully scriptable with Python.

       A comprehensive manual is available on the web site, see https://l_sim.gitlab.io/v_sim/user_guide.html.

       Compiling and installing V_Sim is detailled at https://l_sim.gitlab.io/v_sim/install.html and in the INSTALL file of the package (providing dependencies information as well).

      © 1998 - 2023, CEA (France)
    '';
    homepage = "https://l_sim.gitlab.io/v_sim/index.en.html";
  };
}
