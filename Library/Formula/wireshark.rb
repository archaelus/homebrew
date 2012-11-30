require 'formula'

class Wireshark < Formula
  homepage 'http://www.wireshark.org'
  url 'http://wiresharkdownloads.riverbed.com/wireshark/src/all-versions/wireshark-1.8.3.tar.bz2'
  sha1 '3e1322eea5794c71de752b7923af9379bcc95299'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :optional
  depends_on 'libgcrypt' => :optional
  depends_on 'c-ares' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'

  if build.include? 'with-x'
    depends_on :x11
    depends_on 'gtk+'
  end

  option 'with-x', 'Include X11 support'
  option 'with-python', 'Enable experimental Python bindings'
  option 'install-headers', 'Install c header files'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Optionally enable experimental python bindings; is known to cause
    # some runtime issues, e.g.
    # "dlsym(0x8fe467fc, py_create_dissector_handle): symbol not found"
    args << '--without-python' unless build.include? 'with-python'

    # actually just disables the GTK GUI
    args << '--disable-wireshark' unless build.include? 'with-x'

    ENV.append_to_cflags '-O0'
    system "./configure", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
    if ARGV.include? '--install-headers' then
      # headers
      inc = include + 'wireshark'
      inc.install Dir['*.h']
      epan = inc + 'epan'
      epan.install Dir['epan/*.h']

      ['crypt','dfilter','dissectors','ftypes'].each { |d|
        (epan + d).install Dir['epan/' + d + '/*.h']
      }

      (inc + 'wiretap').install Dir['wiretap/*.h']
    end
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end
end

