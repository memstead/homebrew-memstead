class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "e5cd89c372ae75f23a9a790469d03191452aa4097244d763d29bf745daa16b7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "6fa51483d048d949f8ad63c94e2fb3ea9424969391a4ba0f7d1d0c91521515f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "63563e4ed2b8171a1ca55f4df13c96e18aabaa5a3df889a75eec8e025ee018bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "159f3e3d96a400e1b213e1d0c6e84a0aff2f0d8af654a8fdf820bac83a9e8b83"
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
    bin.install "memstead-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "memstead-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "memstead-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "memstead-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
