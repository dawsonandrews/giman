module Giman
  module ApplicationHelper
    def giman_hidden_fields(uploads, param: "upload")
      uploads.map { |upload| giman_hidden_field(upload, param: param) }.join("\n")
    end

    def giman_hidden_field(upload, param: "upload")
      hidden_field_tag param, upload.try(:id), data: { filename: upload.try(:filename), size: upload.try(:size), content_type: upload.try(:content_type) }
    end

    def giman_file_field(param, opts = {})
      opts[:data] ||= {}
      opts[:data][:giman_file_upload] = ""
      opts[:data][:giman_param] = param

      file_field_tag(nil, opts)
    end

    def giman_dropbox_field(param, opts = {}, &block)
      opts[:data] ||= {}
      file_field_opts = { data: {} }

      # ID to link two fields
      file_field_opts[:id] = SecureRandom.hex(8)
      file_field_opts[:style] = "display: none;"
      file_field_opts[:multiple] = true if opts[:multiple]
      if opts[:data][:supported_types].present?
        file_field_opts[:data][:supported_types] = opts[:data].delete(:supported_types)
      end
      opts[:data][:giman_drop_upload] = file_field_opts[:id]

      [
        giman_file_field(param, file_field_opts),
        content_tag(:div, opts, &block)
      ].join("\n").html_safe
    end
  end
end
