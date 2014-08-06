require "formula"

class Packer < Formula
  homepage "http://www.packer.io/"
  url "https://dl.bintray.com/mitchellh/packer/0.6.1_darwin_amd64.zip"
  sha1 "fa940f3bb0d9cb2eabefc62ea0a80dce34263ef9"
  version "0.6.1"

  def install
    bin.install Dir["packer*"]
  end
end
