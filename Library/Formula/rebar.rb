require 'formula'

class Rebar <Formula
  url 'http://hg.basho.com/rebar/get/705c944d242e.bz2'
  homepage 'http://hg.basho.com/rebar'
  md5 ''
  version '2010030801'

  depends_on 'erlang'

  def install
#   system "cmake . #{std_cmake_parameters}"
    system "./bootstrap"
  end
end
