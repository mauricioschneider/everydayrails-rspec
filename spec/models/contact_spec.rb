require 'spec_helper'

describe Contact do

  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end

  it "is invalid without a firstname" do
    contact = build(:contact, firstname: nil)
    expect(contact).to have(1).errors_on(:firstname)
  end

  it "is invalid without a lastname" do
    contact = build(:contact, lastname: nil)
    expect(contact).to have(1).errors_on(:lastname)
  end

  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    expect(contact).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicated email address" do
    create(:contact, email: "tester@example.com")
    contact = build(:contact, email: "tester@example.com")
    expect(contact).to have(1).errors_on(:email)
  end

  it "returns a contact's full name as string" do
    contact = build(:contact, firstname: "Aaron", lastname: "Sumner")
    expect(contact.name).to eq 'Aaron Sumner'
  end

  describe "filter last name by letter" do

    before :each do
      @smith = create(firstname: "John", lastname: "Smith", email: "jsmith@example.com")
      @jones = create(firstname: "John", lastname: "Jones", email: "jjones@example.com")
      @johnson = create(firstname: "John", lastname: "Johnson", email: "jjohnson@example.com")
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