class YnabCategory < ApplicationRecord
  include YnabDataImporter

  # Overrides YnabDataImporter implementation
  def self.key_object_to_dig
    "category_groups"
  end

  # YNAB's API response for /categories is not as "neat" as other endpoints
  # so understandably this is a bit more chaotic than the other YnabModels.
  # TODO: Clean this up a bit more and make it more human-readable
  def self.import_into_table(records = nil, import_from_ynab: false)
    records ||= import_from_ynab ? load_from_ynab : load_from_file
    records.each do |category_group|
      categories = transform(category_group["categories"])
      upsert_all(categories, unique_by: :uuid) if categories.present?
    end
    records = YnabCategoryGroup.transform(records)
    YnabCategoryGroup.upsert_all(records, unique_by: :uuid)
  end
end
