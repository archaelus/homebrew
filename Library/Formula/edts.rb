require HOMEBREW_PREFIX+'lib/elpa'
require 'formula'

class Edts < Formula
  homepage 'https://github.com/tjarvstrand/edts'
  url 'https://github.com/tjarvstrand/edts/archive/0.1.0.tar.gz'
  head 'https://github.com/tjarvstrand/edts.git'

  depends_on 'auto-complete'

  def install
    system "make" # if this fails, try separate make/make install steps
    packager = ELPA::Packager.new name, version
    # # Emacs 23
    # packager.add Dir['color-theme-solarized.el', 'solarized-definitions.el']
    # Emacs 24
    packager.add Dir['solarized-*.el']
    packager.pkg_el 'Solarized themes for Emacs'
    packager.install_tarball prefix
    


    bin.install 'start.sh'
  end

end
