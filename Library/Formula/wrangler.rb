require 'formula'

class Wrangler <Formula
  @url='http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.8/wrangler-0.8.7.tar.gz'
  @homepage='http://www.cs.kent.ac.uk/projects/forse/'
  @md5='4f68ce562e94d719a75548ce9bb08033'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
