class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.2.4"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.4/ted-Darwin-arm64.tar.gz"
      sha256 "68958abbaae311a4703e96e3b5a723e816c3a1ae0bdb69d80f368c5819d3461d"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.4/ted-Darwin-x86_64.tar.gz"
      sha256 "a8e8af541b402747e5257ff68723e0b741785059ae8f46f9696a7f33dbaf3104"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.4/ted-Linux-x86_64.tar.gz"
      sha256 "ed6d19dd0109bdad91bed77b73476781d6ff14268fd5a4806a050f5af73dca6b"
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
