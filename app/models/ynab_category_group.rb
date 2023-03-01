class YnabCategoryGroup < ApplicationRecord
  include YnabDataImporter

  # Overrides YnabDataImporter implementation
  def self.transform(category_groups)
    super(
      category_groups.map do |category_group|
        category_group.except("categories")
      end
    )
  end
end
