# Generated with JReleaser 1.24.0 at 2026-05-11T05:50:51.691010563Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.2.1"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.1/pl.allegro.tech.allwrite.allwrite-cli-0.2.1-linux-x86_64.zip"
    sha256 "383fc2b6bc8f86001e329a6a0be94d5837d500616b70009754cd5f0517299ae8"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.1/pl.allegro.tech.allwrite.allwrite-cli-0.2.1-osx-aarch_64.zip"
    sha256 "297ab53fe6bed682b9db605e4bee116c2ce55af94b16d6e1f2c3d235d13da9c0"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.1/pl.allegro.tech.allwrite.allwrite-cli-0.2.1-osx-x86_64.zip"
    sha256 "37d2d4f1bbd745bc0e277c1ac3d9b8a1cb4e71dc98ed084e167d46db8e72a40d"
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
    assert_match "0.2.1", output
  end
end
