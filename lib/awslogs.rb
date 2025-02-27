require "aws-sdk-s3"
require "time"
require "fileutils"

module Awslogs
  class Base
    def initialize(bucket_name:, output_folder: "~/.awslogs/logs")
      @bucket_name = bucket_name
      @output_folder = output_folder
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new if creds_set?
    end

    private

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
