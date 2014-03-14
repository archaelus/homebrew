require "formula"

class Stlink < Formula
  homepage "https://github.com/texane/stlink"
  head "https://github.com/texane/stlink.git"
  url "https://github.com/texane/stlink/archive/1.0.0.tar.gz"
  sha1 ""

  # depends_on "cmake" => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "libusb"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "CONFIG_USE_LIBSG=0"
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
