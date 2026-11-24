class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.3.4"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.4/ted-Darwin-arm64.tar.gz"
      sha256 "0ce88d10c218ae59c74cbfd2af7b1d91b8f0bf9dd2be8ba73ac7fd8f1b87dc13"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.4/ted-Darwin-x86_64.tar.gz"
      sha256 "a5baf93d2274d5ae1445873c93c817e631d50250aba63d8d1468585a7ea29d3d"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.4/ted-Linux-x86_64.tar.gz"
      sha256 "6e2df34018ca44e7dfa840c29d98f4af3150e95be54f06f2f47aa31e5738d2c0"
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
