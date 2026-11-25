class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.3.7"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.7/ted-Darwin-arm64.tar.gz"
      sha256 "9f45a3c7c2d3c9bf3ffa4d8c490a56e9857bb5673393f5c0e07ec8ee42b405cc"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.7/ted-Darwin-x86_64.tar.gz"
      sha256 "0bdb2f5e25a057e0f87db89da4cfd80dee6f18c06853dd035ca0e9dbcde16829"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.3.7/ted-Linux-x86_64.tar.gz"
      sha256 "0ef5c5433fdb3ec95010ac3388ae8a9b6ce6d113f8b266a070f09418e9d97bfd"
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
