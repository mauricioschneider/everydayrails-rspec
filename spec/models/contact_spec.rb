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

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  it "returns a contact's full name as string" do
    contact = build(:contact, firstname: "Aaron", lastname: "Sumner")
    expect(contact.name).to eq 'Aaron Sumner'
  end

  it "is visible by default" do
    contact = create(:contact)
    expect(contact.hidden?).to be(false)
  end

  describe "filter last name by letter" do

    before :each do
      @smith = create(:contact, firstname: "John", lastname: "Smith", email: "jsmith@example.com")
      @jones = create(:contact, firstname: "John", lastname: "Jones", email: "jjones@example.com")
      @johnson = create(:contact, firstname: "John", lastname: "Johnson", email: "jjohnson@example.com")
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

  describe "hiding the contact" do

    before :each do
      @contact = create(:contact)
    end

    context "when it's already hidden" do
      it "stays hidden" do
        @contact.update_attribute(:hidden, true)
        expect(@contact.hidden?).to be(true)
        @contact.change_visibility :hide
        expect(@contact.hidden?).to be(true)
      end
    end

    context "when it's not hidden" do
      it "hides the contact" do
        @contact.change_visibility :hide
        expect(@contact.hidden?).to be(true)
      end
    end

  end

  describe "unhiding the contact" do

    before :each do
      @contact = create(:contact)
    end

    context "when it's not hidden" do
      it "stays unhidden" do
        @contact.change_visibility :unhide
        expect(@contact.hidden?).to be(false)
      end
    end

    context "when it's hidden" do
      it "unhides it" do
        @contact.update_attribute(:hidden, true)
        expect(@contact.hidden?).to be(true)
        @contact.change_visibility :unhide
        expect(@contact.hidden?).to be(false)
      end
    end

  end

end