module Giman
  class FileUpload < ApplicationRecord
    belongs_to :attachable, polymorphic: true, required: false
  end
end
