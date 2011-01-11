require 'formula'

class CouchdbLucene <Formula
  url 'https://github.com/rnewson/couchdb-lucene/tarball/v0.6.0'
  homepage 'https://github.com/rnewson/couchdb-lucene'
  md5 'b55610d4c054987a5c69183585a31d8b'

  depends_on 'couchdb'
  depends_on 'maven'

  def install
    # Skipping tests because the integration test assumes that couchdb-lucene
    # has been integrated with a local couchdb instance. Not sure if there's a
    # way to only disable the integration test.
    system "mvn", "-DskipTests=true"

    system "tar -xzf target/couchdb-lucene-#{version}-dist.tar.gz"
    system "mv couchdb-lucene-#{version}/* #{prefix}"

    (etc + "couchdb/local.d/couchdb-lucene.ini").write ini_file
    (prefix + "couchdb-lucene.plist").write plist_file
  end

  def caveats; <<-EOS
You can enable couchdb-lucene to automatically load on login with:

  cp "#{prefix}/couchdb-lucene.plist" ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/couchdb-lucene.plist

Or start it manually with:
  #{bin}/run
EOS
  end

  def ini_file
    return <<-EOS
[couchdb]
os_process_timeout=60000 ; increase the timeout from 5 seconds.

[external]
fti=#{`which python`.chomp} #{prefix}/tools/couchdb-external-hook.py

[httpd_db_handlers]
_fti = {couch_httpd_external, handle_external_req, <<"fti">>}
EOS
  end

  def plist_file
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>couchdb-lucene</string>
    <key>EnvironmentVariables</key>
    <dict>
      <key>HOME</key>
      <string>~</string>
      <key>DYLD_LIBRARY_PATH</key>
      <string>/opt/local/lib:$DYLD_LIBRARY_PATH</string>
    </dict>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/run</string>
    </array>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>StandardOutPath</key>
    <string>/dev/null</string>
    <key>StandardErrorPath</key>
    <string>/dev/null</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>
EOS
  end
end
