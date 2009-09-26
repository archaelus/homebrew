require 'brewkit'

class Faac <Formula
  url 'http://downloads.sourceforge.net/faac/faac-1.28.tar.gz'
  homepage 'http://www.audiocoding.com'
  md5 ''

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
