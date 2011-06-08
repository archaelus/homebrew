require 'formula'

class YubikeyPersonalization < Formula
  head 'git://github.com/Yubico/yubikey-personalization.git'
  homepage 'https://github.com/Yubico/yubikey-personalization'

  def install
    system "autoreconf -f -i -Wall,no-obsolete"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
