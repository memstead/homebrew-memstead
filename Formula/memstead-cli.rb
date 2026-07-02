class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8c4a0597a02881bc74bb65d330ff8a3dca9e5fb1a1da9b6c830457daf99213dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a02bbabb78f2aa50aca5a4a395c257fc3b7381e14ab001d2548c2456cd11906d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e53b0d1a0fae4da6086a36b00b550d57879f74974e4a2f85d9f545c8e19ee9fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c67cafd6a10121b2effa2d62fb518d5e18a9310925059bf61dd303711f0d3fe9"
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
