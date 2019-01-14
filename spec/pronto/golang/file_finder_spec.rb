require 'spec_helper'

require_relative '../../../lib/pronto/golang/file_finder'

describe Pronto::GolangSupport::FileFinder do
  let(:file_finder) do
    Object.new.tap { |ff| ff.extend(described_class) }
  end

  let(:test_base_directory) { 'spec/fixtures/config_file_location' }

  let(:filename) { '.golangtools.yml' }

  describe '.root_level=' do
    it 'sets the root_level' do
      described_class.root_level = '/tmp'
      expect(described_class.instance_variable_get('@root_level')).to eq('/tmp')
    end
  end

  describe '.root_level?' do
    it 'checks if the root level matches the given path' do
      described_class.root_level = '/tmp'
      expect(described_class.root_level?('/tmp')).to eq(true)
      expect(described_class.root_level?('/not_tmp')).to eq(false)
    end
  end

  describe '#find_file_upwards' do
    it 'finds one file matching the given name' do
      test_directory  = File.expand_path(test_base_directory)
      start_directory = File.join(test_directory, 'config_propagation', 'subdirectory')

      described_class.root_level = test_directory

      expect(file_finder.find_file_upwards(filename, start_directory))
        .to eq(File.join(start_directory, filename))
    end

    it 'uses the home directory' do
      home_directory = File.expand_path(File.join(test_base_directory, 'home'))
      allow(ENV).to receive(:key?).with('HOME').and_return(true)
      allow(Dir).to receive(:home).and_return(home_directory)

      test_directory  = File.expand_path(test_base_directory)
      start_directory = File.join(test_directory, 'empty_config_location')

      described_class.root_level = test_directory

      expect(file_finder.find_file_upwards(filename, start_directory, use_home: true))
        .to eq(File.join(home_directory, filename))
    end
  end

  describe '#find_files_upwards' do
    it 'finds multiple files matching the given name propagating upwards' do
      test_directory  = File.expand_path(test_base_directory)
      prop_directory  = File.join(test_directory, 'config_propagation')
      start_directory = File.join(prop_directory, 'subdirectory')

      described_class.root_level = test_directory

      expect(file_finder.find_files_upwards(filename, start_directory))
        .to match_array([
          File.join(start_directory, filename),
          File.join(prop_directory, filename)
        ])
    end
  end
end
