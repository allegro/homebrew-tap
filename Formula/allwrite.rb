# Generated with JReleaser 1.23.0 at 2026-04-07T21:02:24.122604185Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.2.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.0/pl.allegro.tech.allwrite.allwrite-cli-0.2.0-linux-x86_64.zip"
    sha256 "b51e41ee3f011ab6d09a3d03e1393171b14b449acfc918bd566dd6f87b7b0bc3"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.0/pl.allegro.tech.allwrite.allwrite-cli-0.2.0-osx-aarch_64.zip"
    sha256 "e6b1b614e80c28edfd1398b3ceabd7f684ecc7a9189930bc4b2fc75f2eff69f9"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.0/pl.allegro.tech.allwrite.allwrite-cli-0.2.0-osx-x86_64.zip"
    sha256 "8a946a4168ad7b92a9b239829aa5ff1975cb86b526e3ca744e13e2fe6828e29f"
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
    assert_match "0.2.0", output
  end
end
