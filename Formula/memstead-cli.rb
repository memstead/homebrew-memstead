class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.12.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3e45451f03c6367dc5ddd1feb42ec630cd09ac62aaae62c2fb33b4b574d35956"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.12.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f9d0fe1e1a092136b84c161e70dcae17b1a712f5ca8190de8c1117607a834940"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.12.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e9a8a9e6bfc40a40a3825818b9a2138428d219e4d5e3257819ebc3cad82e5842"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.12.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db17c5ec817b24fb0b9ac5bd33af8e50f9b006046660955f54776c48a0095318"
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
      bin.install "memstead"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "memstead"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "memstead"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "memstead"
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
