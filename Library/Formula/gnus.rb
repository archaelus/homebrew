require 'formula'

class Gnus <Formula
  head 'http://git.gnus.org/gnus.git', :using => :git
  homepage ''
  md5 ''

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
