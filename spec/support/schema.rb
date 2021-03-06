ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.jsonb :params
    t.timestamps
  end

  create_table :user_with_names, :force => true do |t|
    t.string :name, default: 'test'
    t.jsonb :params
    t.timestamps
  end
end