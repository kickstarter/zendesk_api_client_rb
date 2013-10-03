require 'core/spec_helper'

describe ZendeskAPI::Tag, :vcr, :not_findable do
  it_should_be_readable :tags

  [organization, topic, ticket].each do |object|
    under object do
      before(:each) do
        parent.tags = %w{tag2 tag3}
        parent.tags.save!
      end

      it "can be set" do
        tags.should == %w{tag2 tag3}
      end

      it "should be removable" do
        parent.tags.destroy!(:id => "tag2")

        tags.should == %w{tag3}
      end

      it "should be updatable" do
        parent.tags.update!(:id => "tag4")

        tags.should == %w{tag2 tag3 tag4}
      end

      it "should be savable" do
        parent.tags << "tag4"
        parent.tags.save!

        tags.should == %w{tag2 tag3 tag4}
      end

      it "should be modifiable" do
        parent.tags.delete(ZendeskAPI::Tag.new(nil, :id => "tag2"))
        parent.tags.save!

        tags.should == %w{tag3}

        parent.tags.delete_if {|tag| tag.id == "tag3"}
        parent.tags.save!

        tags.should be_empty
      end
    end
  end

  def tags
    parent.tags.fetch!(:reload).map(&:id).sort
  end
end
