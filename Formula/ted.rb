class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.3.2"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.2/ted-Darwin-arm64.tar.gz"
      sha256 "54222bfbabc4d4099ddbd3cfaef92c6da9c2caaa7602ec6a1dd2eecaadf9d693"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.2/ted-Darwin-x86_64.tar.gz"
      sha256 "037d7383f25d19aab7007b0547c90aa2b46f119d70b5c3ef845fcae61102f396"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.2/ted-Linux-x86_64.tar.gz"
      sha256 "33bcf690cc594909b5beefc35077f05755bda57fceeaa592ee9acb584afdbfc4"
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
