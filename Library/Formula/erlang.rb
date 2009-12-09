require 'formula'

class ErlangManuals <Formula
  url 'http://www.erlang.org/download/otp_doc_man_R13B03.tar.gz'
  md5 '1fe80b110061ef73614824fb06d4d6eb'
end

class ErlangHtmlDocs <Formula
  url 'http://erlang.org/download/otp_doc_html_R13B03.tar.gz'
  md5 'ade1a4d5dcfe3732dc953f7cf9664b37'
end

class Erlang <Formula
  version 'R13B03'
  url "http://erlang.org/download/otp_src_#{version}.tar.gz"
  md5 '411fcb29f0819973f71e28f6b56d9948'
  homepage 'http://www.erlang.org'

  depends_on 'icu4c'
  
  def skip_clean? path
    ["*/bin/*",
     "*/doc/*",
     "*/lib/*",
     "*/share/*",
     "*.o",
     "*.so"].any? { |pat| path.fnmatch? pat }
  end

  def patches
    { :p0 => ["patch-erts_emulator_Makefile.in",
              "patch-erts_emulator_hipe_hipe_amd64_asm.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_bifs.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_glue.S.diff",
              "patch-erts_emulator_hipe_hipe_amd64.c.diff",
              "patch-erts_emulator_sys_unix_sys_float.c.diff",
              "patch-lib_ssl_c_src_esock_openssl.c",
              "patch-lib_wx_configure.in",
              "patch-lib_wx_configure"
            ].map { |file_name| "http://svn.macports.org/repository/macports/!svn/bc/60054/trunk/dports/lang/erlang/files/#{file_name}" }
    }
  end

  def install
    ENV.deparallelize
    ENV.gcc_4_2 # see http://github.com/mxcl/homebrew/issues/#issue/120

    config_flags = ["--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--enable-smp-support"]

    unless ARGV.include? '--disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      config_flags << '--enable-hipe'
    end

    if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
      config_flags << "--enable-darwin-64bit" 
      config_flags << "--enable-m64-build"
    end

    system "./configure", *config_flags
    system "touch lib/wx/SKIP" if MACOS_VERSION >= 10.6
    system "make"
    system "make install"

    ErlangManuals.new.brew { man.install Dir['man/*'] }
    if ARGV.include? '--with-html-docs'
      ErlangHtmlDocs.new.brew {
        doc.install Dir['doc/*']
        doc.install Dir['erts-*/*']
        doc.install Dir['lib/*']
      }
    end
  end

  def test
    "erl -noshell -eval 'crypto:start().' -s init stop"
  end
end
