shared_examples "has valid getters" do
  it { expect(user.name).to eq("Denis") }
  it { expect(user.programmer).to eq(true) }
  it { expect(user.age).to eq(25) }
  it { expect(user.data).to eq({ "field1" => 'field1', "field2" => 'field2' }) }
end