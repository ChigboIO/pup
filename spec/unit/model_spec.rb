require "spec_helper"
require "unit/factory/model_factory"

describe Pup::Model do
  before(:each) { ModelFactory.create(name: "Emmanuel", age: 40) }

  after(:each) { ModelFactory.destroy_all }

  let(:model) { ModelFactory.find(1) }

  it "should have a valid factory" do
    expect(subject).to be_a(Pup::Model)
  end

  it "responds to the instance methods" do
    expect(model).to respond_to(:id, :name, :age, :save, :destroy)
  end

  it "responds to the 'private' instance methods", :private do
    expect(model).to respond_to(
      :table_fields, :columns_except_id, :values_placeholders,
      :table_values, :update_field_set
    )
  end

  describe "private class methods" do
    it { expect(ModelFactory).to respond_to(:table_name) }
    it { expect(ModelFactory).to respond_to(:fields) }
  end

  describe "#id" do
    it { expect(model.id).not_to be_nil }
  end

  describe "#name" do
    it { expect(model.name).to eq "Emmanuel" }
  end

  describe "#age" do
    it { expect(model.age).to eq 40 }
  end

  describe "#table_fields", :private do
    it { expect(model.table_fields).to eq("name, age") }
  end

  describe "#values_placeholders", :private do
    it { expect(model.values_placeholders).to eq("?, ?") }
  end

  describe "#update_field_set", :private do
    it { expect(model.update_field_set).to eq("name = ? , age = ? ") }
  end

  describe ".columns_array", :private do
    it { expect(ModelFactory.columns_array).to eq([:id, :name, :age]) }
  end

  describe ".table_name", :private do
    it { expect(ModelFactory.table_name).to eq("users") }
  end

  describe "the column builder module methods" do
    describe ".autoincrement" do
      it "returns the 'AUTOINCREMENT' string if the value is true" do
        expect(ModelFactory.send(:autoincrement, true)).to eq("AUTOINCREMENT")
      end
    end

    describe ".default" do
      it { expect(ModelFactory.send(:default, 30)).to eq("DEFAULT `30`") }
    end

    describe ".nullable" do
      it { expect(ModelFactory.send(:nullable, false)).to eq("NOT NULL") }
    end

    describe ".nullable" do
      it { expect(ModelFactory.send(:nullable, true)).to eq("NULL") }
    end

    describe ".primary_key" do
      it { expect(ModelFactory.send(:primary_key, true)).to eq("PRIMARY KEY") }
    end

    describe ".primary_key" do
      it { expect(ModelFactory.send(:primary_key, false)).to eq("") }
    end
  end

  describe "the orm methods" do
    describe ".all" do
      it "returns an array of Model Objects" do
        all_model = ModelFactory.all

        expect(all_model).to be_an Array
        expect(all_model.size).to eq 1
        expect(all_model.first).to be_an ModelFactory
        expect(all_model.first.name).to eq "Emmanuel"
        expect(all_model.first.age).to eq 40
      end
    end

    describe ".find" do
      it "return an instance of the Model Object" do
        one_model = ModelFactory.find(1)

        expect(one_model).to be_an ModelFactory
        expect(one_model.id).to eq 1
        expect(one_model.name).to eq "Emmanuel"
        expect(one_model.age).to eq 40
      end
    end

    describe ".destroy" do
      it "deletes the record with the given id" do
        ModelFactory.destroy(1)
        one_model = ModelFactory.find(1)

        expect(one_model).to be_nil
      end
    end

    describe ".destroy_all" do
      it "deletes all the records in the database table" do
        ModelFactory.destroy_all
        all_models = ModelFactory.all

        expect(all_models).to be_an Array
        expect(all_models).to be_empty
      end
    end

    describe "#destroy" do
      it "deletes the current model object from the DB" do
        one_model = ModelFactory.find(1)
        expect(one_model).not_to be_nil

        one_model.destroy
        one_model = ModelFactory.find(1)
        expect(one_model).to be_nil
      end
    end

    describe "#save" do
      it "updates the current model record" do
        one_model = ModelFactory.find(1)
        one_model.name = "Chigbo"
        one_model.save

        # one_model = ModelFactory.find(1)
        expect(one_model.name).to eq("Chigbo")
      end
    end

    describe ".create" do
      it "create a new instance of the model with the given parameters" do
        one_model = ModelFactory.create(name: "Emmanuel", age: 35)
        expect(one_model).to be_a(Pup::Model)
        expect(one_model.name).to eq("Emmanuel")
        expect(one_model.age).to eq(35)
      end
    end

    describe "#update" do
      it "updates a given instance of the model with the given parameters" do
        model.update(name: "Chigbo", age: 50)

        expect(model).to be_a(Pup::Model)
        expect(model.name).to eq("Chigbo")
        expect(model.age).to eq(50)
      end
    end
  end
end
