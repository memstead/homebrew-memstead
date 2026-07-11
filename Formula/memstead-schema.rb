class MemsteadSchema < Formula
  desc "Schema types for Memstead — entity definitions, vocabulary, and validation rules. Internal library surface consumed by the memstead binaries — pre-1.0, experimental, no API stability promise."
  homepage "https://memstead.io"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-schema-aarch64-apple-darwin.tar.xz"
      sha256 "d224b1f8eef7bf015ece01e708032fd7267e520b48cf26fbf7c4ea7a815cb24a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-schema-x86_64-apple-darwin.tar.xz"
      sha256 "418ceadee235d1ef331e1c2afbf58b76d40ed298196a1f8b7e10c16d33dad349"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-schema-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96f364ed673870a1bb7605926b979dc7b085b33f1c731eb3dc1394c8eb5b547b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.3.0/memstead-schema-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0dbe75b58735ae6925f5d57cb62ec128d138de2290007872a67945458924faca"
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
    bin.install "emit_json_schemas" if OS.mac? && Hardware::CPU.arm?
    bin.install "emit_json_schemas" if OS.mac? && Hardware::CPU.intel?
    bin.install "emit_json_schemas" if OS.linux? && Hardware::CPU.arm?
    bin.install "emit_json_schemas" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
