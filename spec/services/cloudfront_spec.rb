require "spec_helper"

describe Awslogs::Base do
  let(:fake_s3) {
    list_objects_v2: {
      contents: [
        { key: "log-1.gz" },
        { key: "log-2.gz" },
        { key: "log-3.gz" }
      ]
    },
    get_object: {
      "log-1.gz": "test log 1\n",
      "log-2.gz": "test log 2\n",
      "log-3.gz": "test log 3\n"
    }
  }
  let(:client) { Aws::S3::Client.new(stub_responses: true) }

  before do
    Aws.config[:stub_responses] = true
  end

  it "requires a bucket name" do
    expect { described_class.new }.to raise_error ArgumentError
  end

  it "runs" do
    expect { described_class.new(bucket_name: "test") }.to_not raise_error
  end

  describe "#download_logs" do
    let(:libgem) { described_class.new(bucket_name: "test") }
    before do
      client.stub_responses(:list_objects_v2, fake_s3[:list_objects_v2])
      client.stub_responses(:get_object, -> (context) {
        binding.pry
        { body: fake_s3[:get_object][context.params[:key]] }
      })
    end

    it "downloads all files to ~/awslogs/cloudfront/tmp" do
      libgem.download_logs(since: "1 hour ago")



      expect
    end
  end
end
