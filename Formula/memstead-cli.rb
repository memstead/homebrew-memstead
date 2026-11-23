class MemsteadCli < Formula
  desc "Typed project knowledge for AI agents. Command-line interface for Memstead: the `memstead` binary queries and mutates typed knowledge graphs kept as markdown in git (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.28.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f30ecb492ad8ccabfe5e76ccf6610a0aa0fc4e8ae9d19e0b618c42899ce53b10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.28.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f546180dcd0e32d7102064f0fb5e402a428bdddb4de18b5499c3945d97d386ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.28.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa7e84a842661da6d17b65788a12b5cedfa7d2aa1db3cebbd7dc496fc2673e70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.28.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84a9992d0026c89c559190a4faf95828e00ceded242cae80e62911c38fac1d64"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
