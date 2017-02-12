require 'spec_helper'

describe Hydra::Groupy do
  it "has a version number" do
    expect(Hydra::Groupy::VERSION).not_to be nil
  end

  describe '.group_adapter' do
    it 'delegates method to .configuration' do
      configuration = instance_double(described_class::Configuration, group_adapter: true)
      allow(described_class).to receive(:configuration).and_return(configuration)
      expect(configuration).to receive(:group_adapter)
      described_class.group_adapter
    end
  end

  describe '.role_adapter' do
    it 'delegates method to .configuration' do
      configuration = instance_double(described_class::Configuration, role_adapter: true)
      allow(described_class).to receive(:configuration).and_return(configuration)
      expect(configuration).to receive(:role_adapter)
      described_class.role_adapter
    end
  end

  describe '.configure' do
    before do
      Object.send(:remove_const, :Rails) if defined?(Rails)
    end
    describe 'without Rails defined' do
      it 'will call the configuration block' do
        expect { |b| described_class.configure(&b) }.to yield_control
      end
    end

    describe 'with Rails defined' do
      before do
        module Rails
        end
      end
      after do
        Object.send(:remove_const, :Rails)
      end
      it 'will not call the configuration block immediately but instead rely on the Hydra::Groupy::Railtie' do
        expect { |b| described_class.configure(&b) }.not_to yield_control
      end
    end
  end
end
