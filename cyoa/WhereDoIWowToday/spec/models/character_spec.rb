require 'rails_helper'

RSpec.describe Character, type: :model do
  describe ".refresh_individual" do
    context "when the character is not in the database" do
      before { Character.destroy_all }

      context "when the character is valid" do
        before { Realm.create!(name: "Earthen Ring", slug: "earthen-ring") }

        let(:json_body) { character_json_factory.create("Sal", "Earthen Ring") }

        it "should fetch the character's data from blizzard and store it" do
          url_pattern = /us.api.battle.net\/wow\/character\/earthen-ring\/Sal.*/
          stub = stub_request(:get, url_pattern).
                 to_return(body: json_body, status: 200)

          Character.refresh_individual(name: "Sal", realm: "Earthen Ring")

          expect(stub).to have_been_requested.once
          expect(Character.count).to eq(1)
          expect(Character.find_by_name("Sal").realm).to eq("Earthen Ring")
        end
      end
    end
  end
  
  describe "#zone_summaries" do
    let(:character) { FactoryGirl.create(:character) }

    context "when the character does not have character_zone_activities" do
      it "should have an empty return value" do
        expect(character.zone_summaries).to be_empty
      end
    end

    context "when the character has character_zone_activities" do
      before do
        3.times do
          FactoryGirl.create(:character_zone_activity, :quest,
                             character: character, category_name: "Duskwood")
        end
        2.times do
          FactoryGirl.create(:character_zone_activity, :quest,
                             character: character, category_name: "Ashenvale")
        end
      end
      
      it "should return a summary for each character_zone_activity" do
        expect(character.zone_summaries.count).to eq(2)
        expect(character.zone_summaries).to have_key("Duskwood")
        expect(character.zone_summaries).to have_key("Ashenvale")
      end

      it "should include the category id in the summary" do
        duskwood_summary = character.zone_summaries["Duskwood"]
        duskwood = Category.find_by_name("Duskwood")
        expect(duskwood_summary[:id]).to eq(duskwood.id)
      end
    end
  end
end

def character_json_factory
  def create(name, realm)
    {
     "lastModified": 1439777849000,
     "name": name,
     "realm": realm,
     "battlegroup": "Vindication",
     "class": 2,
     "race": 3,
     "gender": 1,
     "level": 100,
     "achievementPoints": 16520,
     "thumbnail": "earthen-ring/133/4118149-avatar.jpg",
     "calcClass": "b",
     "totalHonorableKills": 2271,
    }.to_json
  end
end
