class StrimziKafkaCli < Formula
  include Language::Python::Virtualenv

  desc "Command Line Interface for Strimzi Kafka Operator"
  homepage "https://github.com/systemcraftsman/strimzi-kafka-cli"
  version "0.1.0a79"
  url "https://files.pythonhosted.org/packages/source/s/strimzi-kafka-cli/strimzi_kafka_cli-"+version+".tar.gz"
  license "Apache-2.0"

  depends_on ["python@3.11", "python@3.10", "python@3.9"]

  def install
    venv = virtualenv_create(libexec, python="python3.11", without_pip: false)

    @venv_root = venv.instance_variable_get(:@venv_root)
    @formula = venv.instance_variable_get(:@formula)

    bin_before = Dir[@venv_root/"bin/*"].to_set

    system @venv_root/"bin/pip", "install", "strimzi-kafka-cli==" + version

    bin_after = Dir[@venv_root/"bin/*"].to_set
    bin_to_link = (bin_after - bin_before).to_a

    @formula.bin.install_symlink(bin_to_link)
  end

  test do
    assert_match "Strimzi Kafka CLI", shell_output("#{bin}/kfk")
    assert_match "CLI Version: " + version, shell_output("#{bin}/kfk --version")
  end
end
