require 'spec_helper'

describe Contact do

  it "has a valid factory" do
    expect(FactoryGirl.build(:contact)).to be_valid
  end

  it "is valid with a firstname, lastname and email" do
    contact = Contact.new(firstname:  "Aaron", lastname: "Sumner", email: "tester@example.com")
    expect(contact).to be_valid
  end

  it "is invalid without a firstname" do
    contact = FactoryGirl.build(:contact, firstname: nil)
    expect(contact).to have(1).errors_on(:firstname)
  end

  it "is invalid without a lastname" do
    contact = FactoryGirl.build(:contact, lastname: nil)
    expect(contact).to have(1).errors_on(:lastname)
  end

  it "is invalid without an email address" do
    contact = FactoryGirl.build(:contact, email: nil)
    expect(contact).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicated email address" do
    FactoryGirl.create(:contact, email: "tester@example.com")
    contact = FactoryGirl.build(:contact, email: "tester@example.com")
    expect(contact).to have(1).errors_on(:email)
  end

  it "returns a contact's full name as string" do
    contact = FactoryGirl.build(:contact, firstname: "Aaron", lastname: "Sumner")
    expect(contact.name).to eq 'Aaron Sumner'
  end

  describe "filter last name by letter" do

    before :each do
      @smith = Contact.create(firstname: "John", lastname: "Smith", email: "jsmith@example.com")
      @jones = Contact.create(firstname: "John", lastname: "Jones", email: "jjones@example.com")
      @johnson = Contact.create(firstname: "John", lastname: "Johnson", email: "jjohnson@example.com")
      @contacts = Contact.by_letter("J")
    end

    context "matching letters" do
      it "returns a sorted array of results that match" do
        expect(@contacts).to eq [@johnson, @jones]
      end
    end

    context "non-matching letters" do
      it "returns a sorted array of results that match" do
        expect(@contacts).to_not include @smith
      end
    end

  end

end