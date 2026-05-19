# Generated with JReleaser 1.24.0 at 2026-05-19T07:47:09.885480932Z

class Allwrite < Formula
  desc "Automated code migrations runner"
  homepage "https://github.com/allegro/allwrite"
  version "0.2.2"
  license "Apache-2.0"

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.2/pl.allegro.tech.allwrite.allwrite-cli-0.2.2-linux-x86_64.zip"
    sha256 "1ab59502b616a1eb94176ef08895509dbf931f8d223d51c1a321ce2a42b90eae"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.2/pl.allegro.tech.allwrite.allwrite-cli-0.2.2-osx-aarch_64.zip"
    sha256 "f68d1b1a989590383575adc2dc74e6f96c96437482ddbf0f870bac096b3cae2a"
  end
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/allegro/allwrite/releases/download/v0.2.2/pl.allegro.tech.allwrite.allwrite-cli-0.2.2-osx-x86_64.zip"
    sha256 "c35caad62de36d8e92c95b99428e6fbc79a2184543aa0911599a398da21fbe95"
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
    assert_match "0.2.2", output
  end
end
