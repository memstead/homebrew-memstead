class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "1a0e4a97ee85694bbe4a222cc56e34c107dd56bf59e7bfd6946d495e0c1e8aea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b359e5aa10becbc2694bbd66ccb884b59a7da0bf53dc4084975a5a17720326da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c4332100acaba285017105d96ed9883b1002839589ee28fdecf534ded95cdb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.6.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce50b56adb5b4b5405e8a54d4d504f7b2ab0f5d49e701cb5a6adcc8925ca3dda"
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
