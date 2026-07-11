class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "346930f5b47b7fcc8956cd524296075755f803225e1a72b877e51be522ab9fd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b344f28ccbb4ecf1a737eee5f2e9633516217e6a65f7410ba47ea0d8d88e889b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c86a98594e8a4a2ebe461705b59f986a52369e7edb751b867a1a4deee9aa7f90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9833463f0fc302c9068b1869f3d0b5e0ea8b87cbfea5b3bf32a1278dd149d42"
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
