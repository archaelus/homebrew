require 'brewkit'

class ErlangManuals <Formula
  @version='R13B02'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/snapshots/otp_man_R13B02_2009-09-04_18.tar.gz'
  @md5='853d01156d49f16b30ead8e0145f45ca'
end

class Erlang <Formula
  @version='R13B02'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/snapshots/otp_src_R13B02.tar.gz'
  @md5='203c71edf5383fec3a64a5b9af7670c0'
    
  def options
    [
      ['--64bit', "Build a 64bit version of Erlang."],
    ]
  end
  
  def install
    ENV.deparallelize
    config_flags = ["--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--enable-smp-support",
                          "--enable-hipe"]
    if ARGV.include? '--64bit'
      config_flags << "--enable-darwin-64bit" << "--enable-m64-build"
    end
    system "./configure", *config_flags
    system "make"
    system "make install"
    
    ErlangManuals.new.brew { man.install Dir['man/*'] }
  end
end
