require 'aws-sdk-s3'
require 'time'
require 'fileutils'
class CFLogsearch
  def self.fetch_credentials
    creds = nil
    if File.exist?(File.expand_path('~/.netrc'))
      require 'netrc'
      netrc = Netrc.read(File.expand_path('~/.netrc'))
      if netrc['default']
        creds = { access_key_id: netrc['default']['aws_access_key_id'], secret_access_key: netrc['default']['aws_secret_access_key'] }
      end
    end

    unless creds
      puts "No AWS credentials found in ~/.netrc. Please enter your AWS credentials:"
      print "AWS Access Key ID: "
      access_key_id = gets.chomp
      print "AWS Secret Access Key: "
      secret_access_key = gets.chomp
      creds = { access_key_id: access_key_id, secret_access_key: secret_access_key }
    end

    creds
  end

  def self.download_logs(bucket_name, start_time, end_time, keywords, local_folder)
    Aws.config.update({
      region: 'us-east-1', # Change this to your desired AWS region if needed
      credentials: Aws::Credentials.new(fetch_credentials[:access_key_id], fetch_credentials[:secret_access_key])
    })

    s3 = Aws::S3::Client.new

    filter_criteria = []
    filter_criteria << "prefix" if start_time || end_time
    filter_criteria << "regex" if keywords

    options = {}
    options[:starts_with] = Time.now.strftime('%Y-%m-%d') if start_time.nil?
    options[:ends_with] = Time.now.strftime('%Y-%m-%d') if end_time.nil?
    options[:contains] = keywords if keywords

    bucket = s3.list_objects_v2(bucket: bucket_name, **options)

    FileUtils.mkdir_p(local_folder) unless Dir.exist?(local_folder)

    bucket.contents.each do |object|
      next unless object.key =~ /\.log$/ # Assuming logs are in .log files
      file_path = "#{local_folder}/#{object.key}"
      s3.get_object(bucket: bucket_name, key: object.key) do |chunk|
        File.open(file_path, 'ab') { |f| f.write(chunk) }
      end
    end
  end
end

download_logs('midgard-cloudfront-logs', start_time, end_time, keywords, local_folder)
