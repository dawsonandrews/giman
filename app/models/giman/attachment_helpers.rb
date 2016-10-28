module Giman
  module AttachmentHelpers
    extend ActiveSupport::Concern

    included do
    end

    class_methods do
      def has_giman_attachment(name = :upload)
        has_one name.to_sym, class_name: "Giman::FileUpload", as: :attachable

        define_method("#{name}_id=".to_sym) do |val|
          if upload = Giman::FileUpload.find_by(id: val)
            self.send("#{name}=".to_sym, upload)
          end
        end

        define_method("#{name}_id".to_sym) do
          self.send("#{name}".to_sym).try(:id)
        end

        define_method("#{name}_url".to_sym) do
          self.send("#{name}".to_sym).try(:url)
        end
      end

      def has_giman_attachments(name = :uploads)
        has_many name.to_sym, class_name: "Giman::FileUpload", as: :attachable
      end
    end
  end
end