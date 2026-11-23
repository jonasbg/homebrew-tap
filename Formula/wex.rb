class Wex < Formula
  desc "Clean web content extractor that converts to markdown"
  homepage "https://github.com/jonasbg/wex"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jonasbg/wex/releases/download/v0.0.1/wex_Darwin_arm64.tar.gz"
      sha256 "343aff15b13b8c3d60aa1ef2f87efd1272907e831f68b40758a4e70cb1996fb7"
    end
    on_intel do
      url "https://github.com/jonasbg/wex/releases/download/v0.0.1/wex_Darwin_x86_64.tar.gz"
      sha256 "55be848809aba86adad921e96d44da14997b6e5661b4f41b06448b5af56a98b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jonasbg/wex/releases/download/v0.0.1/wex_Linux_arm64.tar.gz"
      sha256 "af349161bb51de0eece2ac7be5289bbd825a02508ca413de66960146de831c40"
    end
    on_intel do
      url "https://github.com/jonasbg/wex/releases/download/v0.0.1/wex_Linux_x86_64.tar.gz"
      sha256 "fe44cb1c5efccf4151313a178d640aeaecfea22a2cb36f97a7006021d5be859e"
    end
  end

  def install
    bin.install "wex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wex --version")
  end
end
