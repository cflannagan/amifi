namespace :amifi do
  desc "Overwrites your local YNAB data with latest"
  task upsert_all_from_ynab: :environment do
    puts "\n Are you sure you want to overwrite existing local YNAB data? [Y/N]"
    answer = $stdin.gets.chomp
    if answer == "Y"
      [YnabAccount, YnabCategory, YnabTransaction].map do |klass|
        puts "Importing #{klass} data from YNAB..."
        klass.import_into_table(import_from_ynab: true)
      end
      puts "Import & Upserting of YNAB data completed!"
      puts <<~TEXT
        There is now #{YnabAccount.count} accounts, #{YnabTransaction.count} transactions,
          #{YnabCategoryGroup.count} category groups and #{YnabCategory.count} categories.
      TEXT
    end
  end
end
