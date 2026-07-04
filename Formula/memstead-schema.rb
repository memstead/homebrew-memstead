class MemsteadSchema < Formula
  desc "Schema types for Memstead — entity definitions, vocabulary, and validation rules."
  homepage "https://memstead.io"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-schema-aarch64-apple-darwin.tar.xz"
      sha256 "01c29c25185dd4345f89ff6b33c9f71c60c76ad373bdbde00d87a8efea284945"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-schema-x86_64-apple-darwin.tar.xz"
      sha256 "136872fd56f95d98d7fdbd8bff6ee54d2cba10aae7157a7703f066d9db4b1898"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-schema-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d1fc51d44fce5eeee5f681c988e66c9a7ba1dd6f7087f205db353aa60856138"
    end
    if Hardware::CPU.intel?
      url "https://github.com/memstead/memstead/releases/download/v0.2.0/memstead-schema-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89b805ca2ffdd994cb5b4d3adb43635f37658ea75096385d421298ed1ba421cd"
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
