require 'formula'

class FastExport <Formula
  url 'git://repo.or.cz/fast-export.git'
  version '20090525'
  homepage 'http://repo.or.cz/w/fast-export.git'
  md5 ''

  depends_on 'git'

  def install
#    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
#   system "cmake . #{std_cmake_parameters}"
    system "cc -I #{HOMEBREW_PREFIX}/include/subversion-1 -I #{HOMEBREW_PREFIX}/include/apr-1  -L#{HOMEBREW_PREFIX}/lib -lsvn_fs-1 -lsvn_repos-1 -lsvn_subr-1 -lapr-1  svn-fast-export.c -o svn-fast-export"
    bin.install "hg-fast-export.py"
    bin.install "hg-fast-export.sh"
    bin.install "hg-reset.py"
    bin.install "hg-reset.sh"
    bin.install "hg2git.py"
    bin.install "svn-fast-export"
    bin.install "svn-fast-export.py"

  end
end
