module YnabDataImporter
  extend ActiveSupport::Concern
  # require 'rest-client' # not sure if need this, will test

  class_methods do # rubocop:disable Metrics/BlockLength
    # While working on updating importer logic, I like to create local json files from YNAB API and then
    # work with those files. So that way I don't abuse the API traffic while iterating over my changes or
    # get myself rate-limited by YNAB
    # rubocop:disable Layout/LineLength
    # accounts.json:     curl -H "Authorization: Bearer xxxx" https://api.youneedabudget.com/v1/budgets/xxxx/accounts >> ./tmp/accounts.json
    # transactions.json: curl -H "Authorization: Bearer xxxx" https://api.youneedabudget.com/v1/budgets/xxxx/transactions >> ./tmp/transactions.json
    # categories.json:   curl -H "Authorization: Bearer xxxx" https://api.youneedabudget.com/v1/budgets/xxxx/categories >> ./tmp/categories.json
    # rubocop:enable Layout/LineLength
    # accounts = YnabAccount.load_from_file
    # transactions = YnabTransaction.load_from_file
    # categories = YnabCategory.load_from_file
    def load_from_file
      file = File.read("./tmp/#{relation_name}.json")
      JSON.parse(file).dig("data", key_object_to_dig)
    end

    # accounts = YnabAccount.load_from_ynab
    # transactions = YnabTransaction.load_from_ynab
    # categories = YnabCategory.load_from_ynab
    def load_from_ynab
      url = "https://api.youneedabudget.com/v1/budgets/#{Rails.configuration.ynab.budget_id}/" + relation_name
      headers = { Authorization: "Bearer #{Rails.configuration.ynab.authorization_token}" }
      JSON.parse(RestClient.get(url, headers)).dig("data", key_object_to_dig)
    end

    # results = YnabAccount.import_into_table
    # results = YnabTransaction.import_into_table
    # results = YnabCategory.import_into_table
    def import_into_table(records = nil, import_from_ynab: false)
      records ||= import_from_ynab ? load_from_ynab : load_from_file
      records = transform(records)
      upsert_all(records, unique_by: :uuid)
    end

    def transform(records)
      records.map do |record|
        record["uuid"] = record["id"]
        record.except("id")
      end
    end

    def relation_name
      to_s.remove("Ynab").pluralize.downcase
    end

    # Usually it's just relation_name but for cases like YnabCategory, it's "category_groups"
    # This way we can override this implementation in classes like YnabCategory itself.
    def key_object_to_dig
      relation_name
    end
  end

  # included do
  # end
end
