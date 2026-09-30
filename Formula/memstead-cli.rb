class MemsteadCli < Formula
  desc "Typed project knowledge for AI agents. Command-line interface for Memstead: the `memstead` binary queries and mutates typed knowledge graphs kept as markdown in git (multi-mem, git-backed; folder workspaces served by the same engine)."
  homepage "https://memstead.com"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.22.0/memstead-cli-aarch64-apple-darwin.tar.xz"
      sha256 "05becb80e194c2454bf152908dfe85bfdf93c8234d48247273ffa888f5ec3d49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.22.0/memstead-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0fdbfaf553d9ef6bb3c20c94f473c1a4c6984ba29f0ec341de1a38637514e194"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.22.0/memstead-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "58885cc22ffe6942b61bab9333d6e40dc7942c7adae0e0530d120bc37bd95f60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.22.0/memstead-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f76f65ef36349a6fe6ab0c8b2392d2a8f1d1ff5bf96097fb73487615da559beb"
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
