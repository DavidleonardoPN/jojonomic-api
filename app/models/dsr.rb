class Dsr < ApplicationRecord
  self.table_name = "document_services"
  enum type_item: [:folder, :file]
end
