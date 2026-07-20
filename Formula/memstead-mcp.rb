class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "98a8940279d379b21016603303b9298d45faf56b3c7990bc46814a54690a338a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "ec13c139272ec9289889788d6f24adcf431399eaa6d019c98869394b0ba5e8ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41dcd3a8814989ec5a765a88f198330e739fa713f6d4b49f0b45cd0f3586f4b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "33990dcff8fb1cda4cb0fa59aa7169731cef5a43acd33323e47ae0a5abe92224"
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
