class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.2.9"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.9/ted-Darwin-arm64.tar.gz"
      sha256 "9384028430b0538a1094841a700e78e074acaa51d203b69b6490a6330559be38"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.9/ted-Darwin-x86_64.tar.gz"
      sha256 "36091ceb211652cb7ef212a8a8b6dc10849602dbdde86715eda32f7870ab6840"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.9/ted-Linux-x86_64.tar.gz"
      sha256 "b77df67b16d3d284d060b91e64849b34e189ca5d719d59dfe2ee109d33bb9303"
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

  test do
    assert_equal "ted #{version}", shell_output("#{bin}/ted --version").strip
  end
end
