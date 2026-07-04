class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "dbb96f996359ee638499895664b16ac7f9419140a26986314457538675e05d2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "59167c70f4eb3643148253c221d88cdb1a56d8da35112af1d66515f871b2859e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed7a32728ddc800341369ba74e59cc3496f3498adb1075c616b81e067bf911aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bb46ffe5898dbb1cc32c5b2de42996f94610bf5341ed60e9d453a5ae3b4c72b"
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
