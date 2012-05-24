require 'formula'

class Aspell6En < Formula
  url 'ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-7.1-0.tar.bz2'
  homepage ''
  md5 'beba5e8f3afd3ed1644653bb685b2dfb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
