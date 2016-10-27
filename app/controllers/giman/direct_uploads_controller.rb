module Giman
  class DirectUploadsController < ApplicationController
    def create
      file = Giman::FileUpload.new(file_params)

      if file.save
        render json: file.attributes.slice("id", *file_fields), status: 201
      else
        render json: { message: "Validation failed", errors: file.errors.full_messages }, status: 400
      end
    end

    private

    def file_params
      params.permit(*file_fields)
    end

    def file_fields
      %w(url s3_path content_type size filename last_modified_at)
    end
  end
end