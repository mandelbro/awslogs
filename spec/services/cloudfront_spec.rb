require "spec_helper"

describe Awslogs::Cloudfront do
  let(:fake_s3) {{
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
  }}
  let(:client) { Aws::S3::Client.new(stub_responses: true) }

  before do
    Aws.config[:stub_responses] = true
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

    it "downloads all files to ~/.awslogs/cloudfront/tmp" do
      libgem.download_logs(since: "1 hour ago")

      # Ensure the directory exists and is a directory
      expect(File).to exist(cloudfront_logs_directory)
      expect(File.directory?(cloudfront_logs_directory)).to be true

      # Get the list of files in the directory
      files = Dir.entries(cloudfront_logs_directory).select do |entry|
        File.file?("#{cloudfront_logs_directory}/#{entry}")
      end

      # Check if there are exactly 3 files
      expect(files.size).to eq(3)
    end
  end

  def cloudfront_logs_directory
    File.expand_path('~/.awslogs/cloudfront/logs')
  end
end
