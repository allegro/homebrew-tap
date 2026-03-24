# Generated with JReleaser 1.23.0 at 2026-03-24T18:02:42.219208954Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.1.0"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.1.0/pl.allegro.tech.allwrite.allwrite-cli-0.1.0-linux-x86_64.zip"
    sha256 "9347aa58be7fc1fbc75a1c035e3114d0a5ee3e5a71322f17185b062174fe32a4"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.1.0/pl.allegro.tech.allwrite.allwrite-cli-0.1.0-osx-aarch_64.zip"
    sha256 "596249acdbe6df3f9aa065b4a94d01599583c2e7b9acc59c9853c07a8932257b"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.1.0/pl.allegro.tech.allwrite.allwrite-cli-0.1.0-osx-x86_64.zip"
    sha256 "0ffecef736c2bf7c855f08168b8288b007ecdb7b26cf664db303089ee5322926"
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
    assert_match "0.1.0", output
  end
end
