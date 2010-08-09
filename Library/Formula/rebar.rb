require 'formula'

class Rebar <Formula
  head 'http://hg.basho.com/rebar/get/tip.tar.gz'
  homepage 'http://hg.basho.com/rebar/'
  url 'http://hg.basho.com/rebar/get/705c944d242e.bz2'e
  version '2010030801'

  depends_on 'erlang'

  def install
    system "./bootstrap"
    bin.install "rebar"
  end
end
