class MemsteadMcp < Formula
  desc "Install expertise into your agent. MCP server for Memstead: the `memstead-mcp` binary exposes typed knowledge graphs kept as markdown in git to any MCP-capable agent over JSON-RPC stdio (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "af9c0ed87db1276bd6dcd532e5335bfd3a332fc4064e536cc467d2dc5b64889e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "4b06d881060fd8408fa3ac1802f6c7c577c2a01148797ae53d558858ce91dfe4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f73eb3d50c92750e96a08fdacfa904ea6761caa22abbfc273fd5c3db5afdad5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.20.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "670ca4fe8ce894af81f4c33bc3a0f7dcb849dfda66434c897c8919e489b75832"
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
