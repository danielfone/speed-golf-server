class CreateTeams < ActiveRecord::Migration
  def change
    create_table "teams", force: true do |t|
      t.string   "name"
      t.text     "scores"
      t.decimal  "total"
    end
  end
end
