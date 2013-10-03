require 'core/spec_helper'

describe ZendeskAPI::Macro, :delete_after do
  def valid_attributes
    { :title => "my test macro", :actions => [{ :field => "status", :value => "solved" }] }
  end

  it_should_be_readable :macros
  it_should_be_readable :macros, :active

  it_should_be_creatable
  it_should_be_updatable :actions, [{ "field" => "priority", "value" => "low" }]
  it_should_be_deletable

  describe "application", :vcr do
    subject do
      VCR.use_cassette("#{described_class.to_s}_application_create") do
        described_class.create(client, valid_attributes.merge(default_options))
      end
    end

    after :all do
      VCR.use_cassette("#{described_class.to_s}_application_delete") do
        subject.destroy
      end
    end

    describe "to a ticket" do
      it "should return a hash" do
        result = subject.apply(ticket)
        result.should be_instance_of(Hashie::Mash)
        result.ticket.should_not be_nil
      end
    end

    it "should be appliable" do
      result = subject.apply
      result.should be_instance_of(Hashie::Mash)
      result.ticket.should_not be_nil
    end
  end
end
