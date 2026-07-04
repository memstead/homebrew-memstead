class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "69adeffe386c2ea2839a043042d6a38e51c7a616ae91805c0bf9c1ec1388c992"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a93a119ec644b3d678f648db9bcec86441121e5d734b15fda740693e8801a2fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c4f843f087cccbab064c40fb5a8012bbddba02e7da3b2d03ddc645347e18a81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "557a278f953008cc27b153965284907126cdf54d9c659b71e9918b7c08dddfdb"
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
