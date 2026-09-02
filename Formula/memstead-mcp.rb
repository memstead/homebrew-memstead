class MemsteadMcp < Formula
  desc "MCP server for Memstead — exposes the typed entity-graph engine over JSON-RPC stdio. Default build produces the full `memstead-mcp` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder + archive surface."
  homepage "https://memstead.io"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.16.0/memstead-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "8735cb2a384691737b670af35d24568de4fd8fc0537135110cc369e8369782cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.16.0/memstead-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "03001aee6f2bdd7102a7f543c189d8f5bed2efdbd5199f78507db7bb15c75da9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.16.0/memstead-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "077ffbb43d2244000e605cb5366e331c594621a7b4b51130f981f218350b2ecc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.16.0/memstead-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb5001994f5da3fa2a53ee437613cfbeb697a5e555b12a4058d848e7c69bbf05"
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
