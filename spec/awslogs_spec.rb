require "spec_helper"

describe Awslogs::Base do
  before do
    Aws.config[:stub_responses] = true
  end

  it "requires a bucket name" do
    expect { described_class.new }.to raise_error ArgumentError
  end

  it "initializes" do
    expect { described_class.new(bucket_name: "test") }.to_not raise_error
  end

  describe "#s3_client" do
    let(:subject) { described_class.new(bucket_name: "test") }

    it "downloads all files to ~/awslogs/cloudfront/tmp" do
      expect(subject.s3_client).to be_a(Aws::S3::Client)
    end
  end
end
