class Purchase < ApplicationRecord
  has_one_attached :receipt_file
end
