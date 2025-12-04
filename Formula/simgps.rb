class Simgps < Formula
  desc "iOS Simulator GPS CLI tool"
  homepage "https://github.com/aovoq/simgps"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aovoq/simgps/releases/download/v0.1.1/simgps-aarch64-apple-darwin.tar.xz"
      sha256 "a05edb071f368a8e957f686fd020fd351a8b24ca99e1c087087e4e7bfc872dca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aovoq/simgps/releases/download/v0.1.1/simgps-x86_64-apple-darwin.tar.xz"
      sha256 "6b2ba75f2e1fd4072220085ed573fc022be64a3403d369e27338489af538597c"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "simgps" if OS.mac? && Hardware::CPU.arm?
    bin.install "simgps" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
