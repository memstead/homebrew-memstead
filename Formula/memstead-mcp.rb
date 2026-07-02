class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d016f773daf60c12b0f981928175cefa3973836b1621af12474882987d07c145"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "4b44ddf8b7f1ce8f75fd6b8e5ffb3266f2a1140005259314eee494545f70e64e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4638218a2545d6b7eec54d6c54dda236d192c116a0bd0543aaa98985b18fc18d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.1.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28333135f78146328bbb6396bba82704e25bc97ecc4263d5468e9d3f5813ec47"
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
