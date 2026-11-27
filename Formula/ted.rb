class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.3.9"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.9/ted-Darwin-arm64.tar.gz"
      sha256 "686702cf4548ee341dba7ae584cc5d7763ead0a5c29b594715e72ff5df8ace00"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.9/ted-Darwin-x86_64.tar.gz"
      sha256 "19e4ca9d534315f05693653c6f20b641627cc26b54ec555cc0ced55cc9118353"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.9/ted-Linux-x86_64.tar.gz"
      sha256 "ece91e56c907bf7d7a73b7b5bf4028dc5a67139df146683485e636ec6733acd5"
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
