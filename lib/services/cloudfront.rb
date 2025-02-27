require "aws-sdk-s3"
require "time"
require "fileutils"

module Awslogs
  class Cloudfront < Base
    def initialize(local_folder: "~/.awslogs/cloudfront/logs", *args)
      super(local_folder: local_folder, *args))
    end

    def download_logs(since:, until: "now", query: nil)
      filter_criteria = []
      filter_criteria << "prefix" if start_time || end_time
      filter_criteria << "regex" if query

      options = {}
      options[:starts_with] = Time.now.strftime("%Y-%m-%d") if start_time.nil?
      options[:ends_with] = Time.now.strftime("%Y-%m-%d") if end_time.nil?
      options[:contains] = query if query

      bucket = s3_client.list_objects_v2(bucket: bucket_name, **options)

      FileUtils.mkdir_p(output_folder) unless Dir.exist?(output_folder)

      bucket.contents.each do |object|
        next unless object.key =~ /\.log$/ # Assuming logs are in .log files
        file_path = "#{output_folder}/#{object.key}"
        s3_client.get_object(bucket: bucket_name, key: object.key) do |chunk|
          File.open(file_path, "ab") { |f| f.write(chunk) }
        end
      end
    end

    private

    def s3_client
      @s3_client ||= Aws::S3::Client.new if creds_set?
    end

    def aws_credentials
      Aws::SharedCredentials.new
    end

    def creds_set?
      if !Aws::SharedCredentials.new.set?
        puts "AWS credentials not found or invalid."
        print "Enter your AWS Access Key ID: "
        access_key_id = gets.chomp
        print "Enter your AWS Secret Access Key: "
        secret_access_key = gets.chomp
        print "Enter the region (default 'us-east-1'): "
        region = gets.chomp || 'us-east-1'

        Aws.config.update({
          credentials: Aws::Credentials.new(access_key_id, secret_access_key),
          region: region,
        })
      end

      true
    end
  end
end

# download_logs("midgard-cloudfront-logs", start_time, end_time, keywords, output_folder)
