class MemsteadMcp < Formula
  desc "Typed project knowledge for AI agents. MCP server for Memstead: the `memstead-mcp` binary exposes typed knowledge graphs kept as markdown in git to any MCP-capable agent over JSON-RPC stdio (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d0e1d483c9c7661e70ce08e55f6d4548aaff2061ac33ced69a726e1aeef8b600"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "424cdb1eb2e34494f0ce49540cb1a0f7e512e9b1252d64106c00575827a596ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db1185519c028ed0521314b35187bc873ca2095c63338a06aa3595bdc4a5153e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.27.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d5fca34f8585cf3440b7d1082646a0d404d1902d3bf93054ca06ffa0707fa39"
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
