class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a9a6eac16c5cb21ecbb28cb1d44f8311c1e1920e8ede80e2bd22c2e86e5c85c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e3546397b199f6e271ea35c8e5d6d60278e54aa2620af0606cd2865606eae7e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18580f67b4c4dceb728839a63296ae4eff0a6d81d36630b9f1e88470db5ae3c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "416436c2a08b47af1f22d93f787716732da1a376c293cac0a930e36eff99966b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "memstead" if OS.mac? && Hardware::CPU.arm?
    bin.install "memstead" if OS.mac? && Hardware::CPU.intel?
    bin.install "memstead" if OS.linux? && Hardware::CPU.arm?
    bin.install "memstead" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
