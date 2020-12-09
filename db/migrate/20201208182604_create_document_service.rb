class CreateDocumentService < ActiveRecord::Migration[5.1]
  def change
    create_table :document_services do |t|
      t.string :name
      t.integer :type_item, default: 0
      t.string :folder_id
      t.text :content
      t.boolean :is_public, default: true
      t.string :owner_id
      t.string :share
      t.text :timestamp
      t.string :company_id
      t.string :share
    end
  end
end
