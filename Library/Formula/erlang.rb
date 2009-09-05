require 'brewkit'

class ErlangManuals <Formula
  @version='5.7.3-snapshot'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/snapshots/otp_man_R13B02_2009-09-04_18.tar.gz'
  @md5='853d01156d49f16b30ead8e0145f45ca'
end

class Erlang <Formula
  @version='5.7.3-snapshot'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/snapshots/otp_src_R13B02.tar.gz'
  @md5='80048e589272db810f5d536f47050ab8'
    
  def options
    [
      ['--64bit', "Build a 64bit version of Erlang."],
    ]
  end
  
  def install
    ENV.deparallelize

    configure_args = ["--disable-debug",
                      "--prefix='#{prefix}'",
                      "--enable-kernel-poll",
                      "--enable-threads",
                      "--enable-dynamic-ssl-lib",
                      "--enable-smp-support",
                      "--enable-hipe",
                     ]
    
    if ARGV.include? '--64bit'
      configure_args.push("--enable-m64-build")
      configure_args.push("--enable-darwin-64bit")
    end
    
    system "./configure", *configure_args
    system "make"
    system "make install"
    
    ErlangManuals.new.brew { man.install Dir['man/*'] }
    ErlangHtmlDocs.new.brew { doc.install }
  end
end
