# Generated with JReleaser 1.24.0 at 2026-06-30T13:50:13.7771556Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.2.4"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.4/pl.allegro.tech.allwrite.allwrite-cli-0.2.4-linux-x86_64.zip"
    sha256 "de4dd15349b02c27c579f0f69770d75c7bef75de8c105e66637873e9043b8129"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.4/pl.allegro.tech.allwrite.allwrite-cli-0.2.4-osx-aarch_64.zip"
    sha256 "13a7c4fa417230f58e24e1319dafac36ce58be8e8eaae13f98c6f6034c7fcd3b"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.4/pl.allegro.tech.allwrite.allwrite-cli-0.2.4-osx-x86_64.zip"
    sha256 "3e984ec2a5d88fd05f4e601bcaa5af5d40388e56ed3e1d94b79a8f31d6dd20d9"
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
    assert_match "0.2.4", output
  end
end
