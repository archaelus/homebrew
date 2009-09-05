require 'brewkit'

class Erlanghtmldocs <Formula
  @ertsvsn='5.7.3'
  @version=@ertsvsn+'-snapshot'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/snapshots/otp_html_R13B02_2009-09-04_18.tar.gz'
  @md5='1ed195c400b12b5f01c90386914019d1'

  def doc
    prefix+'share'+'doc'+'erlang'
  end

  def install
    doc.mkpath
    ["lib", "erts-5.7.3", "doc"].each do |dir|
      FileUtils.mv dir, prefix+"share"+"doc"+"erlang"+dir
    end
  end
  
end
