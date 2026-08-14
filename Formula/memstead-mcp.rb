class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.7.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "bbcb03113bd346ee6e58314f7ef8a3e38564fe52053dee5b6bda5e07d022310b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.7.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "480f4b68e667c39500563ea34d17c3de11a409dd6f7e19a5b63e216dc30dc467"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.7.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5e20f975fc2fe76d5f8168142279547cc8a16acfca171e7702df5b8c2e99885"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.7.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90f8f7ced17236e7e55ee467842d5fda6b4b09814a38b5b184e33e4ee3836a88"
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
