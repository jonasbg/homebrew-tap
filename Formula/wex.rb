# Formula/wex.rb
class Wex < Formula
    desc "Clean web content extractor that converts to markdown"
    homepage "https://github.com/jonasbg/wex"
    version "1.0.0"
    license "MIT"
  
    on_macos do
      if Hardware::CPU.arm?
        url "https://github.com/jonasbg/wex/releases/download/v1.0.0/wex_Darwin_arm64.tar.gz"
        sha256 "WILL_BE_UPDATED_BY_GORELEASER"
      else
        url "https://github.com/jonasbg/wex/releases/download/v1.0.0/wex_Darwin_x86_64.tar.gz"
        sha256 "WILL_BE_UPDATED_BY_GORELEASER"
      end
    end
  
    on_linux do
      if Hardware::CPU.arm?
        url "https://github.com/jonasbg/wex/releases/download/v1.0.0/wex_Linux_arm64.tar.gz"
        sha256 "WILL_BE_UPDATED_BY_GORELEASER"
      else
        url "https://github.com/jonasbg/wex/releases/download/v1.0.0/wex_Linux_x86_64.tar.gz"
        sha256 "WILL_BE_UPDATED_BY_GORELEASER"
      end
    end
  
    def install
      bin.install "wex"
    end
  
    test do
      system "#{bin}/wex", "--version"
    end
  end
