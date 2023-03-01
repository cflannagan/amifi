class EnablePgCrypto < ActiveRecord::Migration[7.0]
  def change
    # this is needed in order to allow for uuid db columns
    enable_extension 'pgcrypto'    
  end
end
