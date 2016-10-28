require 'securerandom'
require 'json'
require 'aws-sdk'

module Giman
  class PresignedUrlController < ApplicationController
    def show
      resp = bucket.presigned_post(
        key: s3_key,
        success_action_status: '201',
        acl: 'public-read',
        content_length_range: 1..(1024*1024*1024),
        content_type_starts_with: ""
      )

      render json: {
        "url" => resp.url,
        "fields" => resp.fields
      }
    end

    private

    def s3_key
      "uploads/#{SecureRandom.uuid}/${filename}"
    end

    def bucket
      Aws::S3::Resource.new.bucket(s3_bucket_param)
    end

    def s3_bucket_param
      ENV['AWS_S3_BUCKET']
    end
  end
end