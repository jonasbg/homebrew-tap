class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.3.3"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.3/ted-Darwin-arm64.tar.gz"
      sha256 "983f9e7f5e2e5e2b1dd0a9aa444f6ba465a9df8fdbb612a560fd86e7500b9b13"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.3/ted-Darwin-x86_64.tar.gz"
      sha256 "202f13f5347bd50e4018ff3a57b089a1efa13c41bfe5c9e9974115c522343c92"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.3/ted-Linux-x86_64.tar.gz"
      sha256 "eedfa23cb29db38e195e8a3330d365925a79f992edf234da7cf53f51ec4368b0"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "glib"
    depends_on "patchelf" => :build
    depends_on "wayland"
  end

  def install
    if OS.mac?
      # Homebrew may strip the single top-level archive directory.
      bundle = prefix/"ted.app"
      if File.directory?("ted.app")
        prefix.install "ted.app"
      else
        bundle.install "Contents"
      end
      bin.mkpath
      cp bundle/"Contents/MacOS/ted", bin/"ted"
    else
      bin.install "ted"
      system "patchelf", "--set-rpath", HOMEBREW_PREFIX/"lib", bin/"ted"
      (share/"icons/hicolor/256x256/apps").install "ted.png"
      inreplace "ted.desktop", "@BIN@", (opt_bin/"ted").to_s
      (share/"applications").install "ted.desktop"
    end
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      To open Ted from Spotlight, Launchpad or the Dock, add it to
      ~/Applications once. It follows every brew upgrade:
        mkdir -p ~/Applications/ted.app
        ln -sfn #{opt_prefix}/ted.app/Contents ~/Applications/ted.app/Contents
    EOS
  end

  test do
    assert_equal "ted #{version}", shell_output("#{bin}/ted --version").strip
  end
end
