require 'brewkit'

class Vilistextum <Formula
  @url='http://bhaak.dyndns.org/vilistextum/vilistextum-2.6.9.tar.gz'
  @homepage='http://bhaak.dyndns.org/vilistextum/'
  @md5='5ba56ffdc56758da716bb46c3e0f517e'

# def deps
#   BinaryDep.new 'cmake'
# end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
#   system "cmake . #{cmake_std_parameters}"
    system "make install"
  end
end
