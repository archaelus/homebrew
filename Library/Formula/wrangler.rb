require 'formula'

class Wrangler < Formula
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.9/wrangler-0.9.2.4.tar.gz'
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  md5 '0fa78c8ffb5d0169a41661adb70a5f50'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
