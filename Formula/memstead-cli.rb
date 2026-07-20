class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9906cbc7a72a21d5332309f3937260e1faa99ed7313e0c85ba86f16e0e1d7bca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c5c5e3b8d94e10df1f3eeafeec261ca9e459ba50d9c049f6909e2582524178b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9336de77cd5a3f6de508bf51d795bfe9c3b2e111962d05bec1abdafa4adba97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.4.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "187a80e386331c171bb6be4b00500f5086f5b83011a13028d8782177dc83daa5"
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
    bin.install "memstead" if OS.mac? && Hardware::CPU.arm?
    bin.install "memstead" if OS.mac? && Hardware::CPU.intel?
    bin.install "memstead" if OS.linux? && Hardware::CPU.arm?
    bin.install "memstead" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
