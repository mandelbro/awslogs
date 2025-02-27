require "spec_helper"

describe "bin/awslogs" do
  it "shows help info" do
    expect { system("bin/awslogs") }.to \
      output(a_string_including(
        "awslogs cloudfront BUCKET_NAME --since=SINCE  # Search logs in AWS Cloudfront S3 bucket"
      )).to_stdout_from_any_process
  end

  context "cloudfront" do
    it "raises an error if the since arg is not specified" do
      expect { system("bin/awslogs cloudfront test") }.to \
        output(a_string_including(
          "No value provided for required options '--since'"
        )).to_stderr_from_any_process
    end
  end
end
