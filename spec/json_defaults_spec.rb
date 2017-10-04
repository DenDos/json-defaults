require 'spec_helper'
require 'active_record'
require 'json_defaults'
require 'support/shared_examples.rb'

ActiveRecord::Base.establish_connection adapter: "postgresql"
require 'support/models' 


RSpec.describe "Json Defaults" do
  let(:user) { User.create() }

  context "valid" do
    
    it { expect(user.valid?).to eq(true) }

    it_behaves_like "has valid getters"

    it "can update fields directly" do
      user.name = "Test"
      expect(user.name).to eq("Test") 
    end

    context "validation" do
      it "for integer fields" do 
        user.age = "30"
        expect(user.age).to eq(30) 
      end

      it "for boolean fields" do 
        user.programmer = 'true'
        expect(user.programmer).to eq(false) 

        user.programmer = 1
        expect(user.programmer).to eq(true) 

        user.programmer = false
        expect(user.programmer).to eq(false) 
      end
    end

    context "after delete all fields" do
      before do
        user.update params: {}
      end

      it_behaves_like "has valid getters"
    end

    context "after delete param in hash field" do
      before do
        params = user.params
        params['data'].delete('field1')
        user.update params: params
        user.reload
      end
      it_behaves_like "has valid getters"
    end

    context "after add new fields" do
      before do
        params = user.params
        params["new_field"] = 'new_field'
        user.update params: params
        user.reload
      end

      it_behaves_like "has valid getters"

      it { expect(user.params['new_field']).to eq('new_field') }
    end

    context "after create user with data" do
      let(:user) { User.create( params: {test: 'test'} ) }

      it_behaves_like "has valid getters"
      
      it { expect(user.params['test']).to eq('test') }
    end

    context "user with name" do
      let(:user) { UserWithName.create() }

      it { expect(user.name).to eq('test') }

    end
    
  end

end