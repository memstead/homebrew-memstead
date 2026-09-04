class MemsteadCli < Formula
  desc "Command-line interface for Memstead — query and mutate typed entity graphs from the shell. Default build produces the full `memstead` binary (multi-mem, git-backed); `--no-default-features` builds the lean folder-only surface."
  homepage "https://memstead.io"
  version "0.18.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.18.1/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d3e25f405cb4d21d8d6d96430a41cda3eb71db1f722c0de96366f2bbd427fb41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.18.1/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0932d370264ba9db061628329b2380c06dbb8e852ef4196353118e8949768647"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.18.1/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4432fa6514cfb6a199524faeb15cec810bc05e502aa8d76def7724f7b091e63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.18.1/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09c73a103725ca0e67aabd25c513c66ed1be4c6802e947d14bfb2a0f6c9f7689"
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
