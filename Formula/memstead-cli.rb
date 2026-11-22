class MemsteadCli < Formula
  desc "Typed project knowledge for AI agents. Command-line interface for Memstead: the `memstead` binary queries and mutates typed knowledge graphs kept as markdown in git (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "05fb1b58bdc695671405b968bb4836b2eefd6196f7bb11b957401c9900f18ccc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1ed1cdc6615b66f284719d06f74abbe9a731bd5d8c2f66f82a7348f5bb554e4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b833ce7f5e387ed7c4547ec9e17c66d52f9bd7f33fd3b86fda216e7657e0abfd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4dfbe08dd9a11f701d449ee707e02fa01c50f40ed887da15417fd12298d5be40"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "memstead"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "memstead"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "memstead"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "memstead"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
