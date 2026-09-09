class MemsteadMcp < Formula
  desc "Install expertise into your agent. MCP server for Memstead: the `memstead-mcp` binary exposes typed knowledge graphs kept as markdown in git to any MCP-capable agent over JSON-RPC stdio (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.19.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "895b99e8b53a55f3b4c98817f1c4213ad1a011403e8772e06d37f6d9418774a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.19.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "f0e9ce08810be8405c0ba36ca7038e35961ef284735451edda4b2d88018af381"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.19.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "201a294009b4e43433b65ba481a7c3df8ddc679576603ca76bff9fb1154cda77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.19.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d7a961cc782a608eb104e29855f5ba549ef33b7279405928cf2b7cd62b24e16"
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
