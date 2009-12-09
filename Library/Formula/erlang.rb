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
  url 'http://erlang.org/download/otp_src_R13B03.tar.gz'
  md5 '411fcb29f0819973f71e28f6b56d9948'
  version 'R13B03'
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
    { #:p1 => DATA,
      :p0 => ["patch-toolbar.erl",
              "patch-erts_emulator_Makefile.in",
              "patch-erts_emulator_hipe_hipe_amd64_asm.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_bifs.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_glue.S.diff",
              "patch-erts_emulator_hipe_hipe_amd64.c.diff",
              "patch-erts_emulator_sys_unix_sys_float.c.diff",
              "patch-erts_configure.diff",
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
end


__END__
--- otp_src_R13B02-1/configure	2009-09-21 11:29:51.000000000 +0200
+++ otp_src_R13B02-1-hvt/configure	2009-11-11 19:02:24.000000000 +0200
@@ -2702,7 +2702,7 @@
 	export LDFLAGS
 fi
 if test X${enable_darwin_64bit} = Xyes; then
-	if test X"$TMPSYS" '!=' X"Darwin-i386"; then
+	if test X"$TMPSYS" '!=' X"Darwin-i386" '-a' X"$TMPSYS" '!=' X"Darwin-x86_64"; then
 		{ { echo "$as_me:$LINENO: error: --enable-darwin-64bit only supported on x86 host" >&5
 echo "$as_me: error: --enable-darwin-64bit only supported on x86 host" >&2;}
    { (exit 1); exit 1; }; }
@@ -2712,7 +2712,7 @@
 	export CFLAGS
 	LDFLAGS="-m64 $LDFLAGS"
 	export LDFLAGS
-elif test X"$TMPSYS" '=' X"Darwin-i386"; then
+elif test X"$TMPSYS" '=' X"Darwin-i386" '-o' X"$TMPSYS" '!=' X"Darwin-x86_64"; then
 	CFLAGS="-m32 $CFLAGS"
 	export CFLAGS
 	LDFLAGS="-m32 $LDFLAGS"
diff -r -u otp_src_R13B02-1/erts/configure otp_src_R13B02-1-hvt/erts/configure
--- otp_src_R13B02-1/erts/configure	2009-09-21 11:29:49.000000000 +0200
+++ otp_src_R13B02-1-hvt/erts/configure	2009-11-11 19:05:49.000000000 +0200
@@ -2803,7 +2803,7 @@
 	esac
 fi
 if test X${enable_darwin_64bit} = Xyes; then
-	if test X"$TMPSYS" '!=' X"Darwin-i386"; then
+	if test X"$TMPSYS" '!=' X"Darwin-i386" '-a' X"$TMPSYS" '!=' X"Darwin-x86_64"; then
 		{ { echo "$as_me:$LINENO: error: --enable-darwin-64bit only supported on x86 host" >&5
 echo "$as_me: error: --enable-darwin-64bit only supported on x86 host" >&2;}
    { (exit 1); exit 1; }; }
