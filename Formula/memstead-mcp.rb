class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.17.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "4f01376daed8abb9749f603ee2c20b970f77f286d71fbbaa1e119673b10b67f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.17.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "4afefb0a8c5fec758a161cc03bd8e17b102b54055c4dd7b62eb177214c5071c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.17.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f63ef7e80ee2ff1767d34707ac4362521e6480451b6cbbff16e7dab9043dbc20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.17.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f04ec6f900c9a6008a46cb6449155df3da5ca6c8ef617e0728a3920fb70da5be"
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
