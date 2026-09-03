class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.18.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "bd9ca15d56abcabd73c10194f13645fc74bc2371e5cf035269e25e3c50330912"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.18.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "5febd4b9dc8c93b9f81d8b224ef007acf94be2f75eae330fe17793f9a205f439"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.18.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67c79649a4450d0c87945903d03c41379e25e8f9945863499eed32bf5edb4108"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.18.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea9975def3fafe396fcbadc39a82ae7da45b46f7a7e37a249251d264d4455cb6"
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
      bin.install "memstead-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "memstead-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "memstead-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "memstead-mcp"
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
