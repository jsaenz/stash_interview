require 'spec_helper'

describe HotelRecommendationsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "redirects to hotel_recommendations_path" do
      get 'show'
      response.should redirect_to(hotel_recommendations_path)
    end
  end


  describe "POST 'show" do

    before(:each) do
      hotel = Hotel.create!(:name =>"Whiney", :id => 1 )
      m = Member.create!(:id => 1, :name => "Doc")
      stay = HotelStay.create!(:id => 1, :member_id => m.id, :hotel_id => hotel.id, :checkout_at => "2013-01-03")
      review = HotelReview.create!(id: 1, :member_id => m.id, :hotel_id => hotel.id, :score => 8)
    end

    describe "with valid params" do
      it "returns http success" do
        post :show, {"name"=>'Doc', "date"=>{"year"=>2020,"month"=>5,"day"=>15}}
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "redirects to hotel_recommendations_path" do
        post :show, {"name"=>'Josh', "date"=>{"year"=>2020,"month"=>5,"day"=>15}}
        response.should redirect_to(hotel_recommendations_path)
      end
      it "redirects to hotel_recommendations_path" do
        post :show, {"name"=>'Doc', "date"=>{"year"=>2012,"month"=>5,"day"=>15}}
        response.should redirect_to(hotel_recommendations_path)
      end
    end
        
  end

end
