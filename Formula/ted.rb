class Ted < Formula
  desc "Native code editor"
  homepage "https://github.com/jonasbg/ted"
  version "0.2.8"

  on_macos do
    on_arm do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.8/ted-Darwin-arm64.tar.gz"
      sha256 "57628eb001e59ac991dfdba58f1a17922bc2fa0dee4e8a00616c11d5b7c5f6e9"
    end
  end

  on_macos do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.8/ted-Darwin-x86_64.tar.gz"
      sha256 "fa7e6d7fa886fdce8448f3daf833ee41afd256f4d66f0a5a42ae8307e110375f"
    end
  end

  on_linux do
    on_intel do
      url "https://raw.githubusercontent.com/jonasbg/omarchy/main/clients/0.2.8/ted-Linux-x86_64.tar.gz"
      sha256 "24223705588568735934efff37fc760b160318fa98655aa3f19b7fcf069cf7e4"
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
