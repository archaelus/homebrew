require "formula"

class Terraform < Formula
  homepage "http://www.terraform.io/"
  url "https://dl.bintray.com/mitchellh/terraform/terraform_0.1.1_darwin_amd64.zip"
  sha1 "fec131ab6b38237e77847291376a9ff860b36f3e"
  version "0.1.1"

  def install
    bin.install Dir["terraform*"]
  end
end
