require_relative '../spec_helper'

module Barometer::Utils
  describe PayloadRequest do
    describe "#get" do
      let(:api) { double(:api, url: nil, params: nil, unwrap_nodes: [], current_query: nil) }
      let(:payload_request) { PayloadRequest.new(api) }

      before { Get.stub(call: "<foo></foo>") }
      it "makes a GET request" do
        url = double(:url)
        params = double(:params)
        api.stub(url: url, params: params)

        payload_request.get

        expect( Get ).to have_received(:call).with(url, params)
      end

      it "XML parses the GET response" do
        response = double(:response)
        Get.stub(call: response)
        unwrap_nodes = double(:unwrap_nodes)
        api.stub(unwrap_nodes: unwrap_nodes)
        XmlReader.stub(:parse)

        payload_request.get

        expect( XmlReader ).to have_received(:parse).with(response, unwrap_nodes)
      end

      it "wraps the result as a payload" do
        expect( payload_request.get ).to be_a Payload
      end

      it "stores the query used to make the request" do
        current_query = double(:query)
        api.stub(current_query: current_query)

        payload = payload_request.get

        expect( payload.query ).to eq current_query
      end
    end
  end
end
