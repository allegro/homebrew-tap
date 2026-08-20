# Generated with JReleaser 1.25.0 at 2026-08-20T06:48:01.61261796Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.5.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.5.0/pl.allegro.tech.allwrite.allwrite-cli-0.5.0-linux-x86_64.zip"
    sha256 "87fd31dbf5dbf6af4bfa7e7343654356b163a63ca5ecb0ad8603459e020df9e5"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.5.0/pl.allegro.tech.allwrite.allwrite-cli-0.5.0-osx-aarch_64.zip"
    sha256 "694ffe190b70dc57f562375ddbf68f3d2966ab87437c0fad9d2debb4dbfa6b64"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.5.0/pl.allegro.tech.allwrite.allwrite-cli-0.5.0-osx-x86_64.zip"
    sha256 "3ac48b25e0dfd5779a2cda3f9feb13a33cc6ad867fbfff66e957c2a81a84046f"
  end


  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/allwrite" => "allwrite"


    # auto completions
    system "_ALLWRITE_COMPLETE=bash #{libexec}/bin/allwrite > bash_completion.sh"
    system "_ALLWRITE_COMPLETE=zsh #{libexec}/bin/allwrite > zsh_completion.sh"
    system "_ALLWRITE_COMPLETE=fish #{libexec}/bin/allwrite > fish_completion.sh"
    bash_completion.install "bash_completion.sh" => "allwrite"
    zsh_completion.install "zsh_completion.sh" => "_allwrite"
    fish_completion.install "fish_completion.sh" => "allwrite.fish"
  end

  def post_install
    if OS.mac?
      Dir["#{libexec}/lib/**/*.dylib"].each do |dylib|
        chmod 0664, dylib
        MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
        MachO.codesign!(dylib)
        chmod 0444, dylib
      end
    end
  end

  test do
    output = shell_output("#{bin}/allwrite --version")
    assert_match "0.5.0", output
  end
end
