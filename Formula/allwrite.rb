# Generated with JReleaser 1.25.0 at 2026-08-05T13:44:49.492965015Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.4.2"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.2/pl.allegro.tech.allwrite.allwrite-cli-0.4.2-linux-x86_64.zip"
    sha256 "72bcfaedcb3da432dd70e1b2cf21efad756d9b1f3c14666c7308c58dca8570a9"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.2/pl.allegro.tech.allwrite.allwrite-cli-0.4.2-osx-aarch_64.zip"
    sha256 "adb2bdbd58a022ed0588d3f1f245a58f4e894ac6f7660276e459ac46741636f7"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.4.2/pl.allegro.tech.allwrite.allwrite-cli-0.4.2-osx-x86_64.zip"
    sha256 "898eb8520d9509eb0338a98b858507da43da8b71f2e788aec80e3a520c430d9f"
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
    assert_match "0.4.2", output
  end
end
