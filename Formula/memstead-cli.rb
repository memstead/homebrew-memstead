class MemsteadCli < Formula
  desc "Install expertise into your agent. Command-line interface for Memstead: the `memstead` binary queries and mutates typed knowledge graphs kept as markdown in git (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6fc28d4efdd90f12e0919487722ce8d243167e41b93e8d3be5c883975835432a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ae5197932c1dd0a07e5e7308094375418bb2dd24a42c4ba423f8169e476fc655"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bfe57ea0ad7cec63a87da6e23484dce0042a20aada4299d889283e9f5e0b8a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a90f91e6a91bdfa4dfbfd794c6c67befbdf891e8b6577440bb0e4b29317ad387"
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
