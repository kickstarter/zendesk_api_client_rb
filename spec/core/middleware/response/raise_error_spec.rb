require 'core/spec_helper'

describe ZendeskAPI::Middleware::Response::RaiseError do
  context "with a failed connection" do
    context "connection failed" do
      before(:each) do
        stub_request(:any, /.*/).to_raise(Faraday::Error::ConnectionFailed)
      end

      it "should raise NetworkError" do
        expect { client.connection.get "/non_existent" }.to raise_error(ZendeskAPI::Error::NetworkError)
      end
    end

    context "connection timeout" do
      before(:each) do
        stub_request(:any, /.*/).to_timeout
      end

      it "should raise NetworkError" do
        expect { client.connection.get "/non_existent" }.to raise_error(ZendeskAPI::Error::NetworkError)
      end
    end
  end

  context "status errors" do
    let(:body) { "" }

    before(:each) do
      stub_request(:any, /.*/).to_return(:status => status, :body => body,
        :headers => { :content_type => "application/json" })
    end

    context "with status = 404" do
      let(:status) { 404 }

      it "should raise RecordNotFound when status is 404" do
        expect { client.connection.get "/non_existent" }.to raise_error(ZendeskAPI::Error::RecordNotFound)
      end
    end

    context "with status in 400...600" do
      let(:status) { 500 }

      it "should raise NetworkError" do
        expect { client.connection.get "/non_existent" }.to raise_error(ZendeskAPI::Error::NetworkError)
      end
    end

    context "with status = 422" do
      let(:status) { 422 }

      it "should raise RecordInvalid" do
        expect { client.connection.get "/non_existent" }.to raise_error(ZendeskAPI::Error::RecordInvalid)
      end

      context "with a body" do
        let(:body) { MultiJson.dump(:details => "hello") }

        it "should return RecordInvalid with proper message" do
          begin
            client.connection.get "/non_existent"
          rescue ZendeskAPI::Error::RecordInvalid => e
            e.errors.should == "hello"
            e.to_s.should == "ZendeskAPI::Error::RecordInvalid: hello"
          else
            fail # didn't raise an error
          end
        end
      end
    end

    context "with status = 200" do
      let(:status) { 200 }

      it "should not raise" do
        client.connection.get "/abcdef"
      end
    end
  end
end
