class HotelRecommendationsController < ApplicationController

  def show
		@member = Member.find_by_name(params[:name])
		@date = Date.new params[:date]['year'].to_i, params[:date]['month'].to_i, params[:date]['day'].to_i
		checkdate(@date)

		#error if we have not input a correct member name
  	unless @member.nil?
	  		@hotel = calculate(@member, @date)
  	else
  		flash.alert = "Please Enter a valid Member name!"
  		redirect_to hotel_recommendations_path
  	end

  rescue => e 
    flash.alert = "Please Enter valid options"
    redirect_to hotel_recommendations_path
  end

  private

  #check to be sure our given date is current
  def checkdate(date)
  	if date.nil? || date < Date.today
  		flash.alert = "Please Pick a Current Date"
	  	redirect_to hotel_recommendations_path
		end
	end

  #calculate and return our recommendation
  def calculate(member, date)
    #gather all unique stay hotel ids
    stays = HotelStay.find_all_by_member_id(member.id, :group => :hotel_id)
    #determine rating from this members' past by combining how many times a member has stayed there and the review rating.

    stays.each do |stay|
      stayscore = HotelStay.find_all_by_member_id_and_hotel_id(member.id, stay.hotel_id).count
      stay.finalscore = reviewmultiplier(member.id, stay.hotel_id, stayscore*10)
    end

    stay = determinerecommendation(stays)
  end

  #multiply hotel scores by the rating our members have rated them
  def reviewmultiplier(member, hotel, value)
    review = HotelReview.find_by_member_id_and_hotel_id(member, hotel)
    if review.nil?
      value *= 0.6
    else
      value *= review.score.to_f/10
    end
  end

  #Determine highest scored hotel and send it back
  def determinerecommendation(stays)
    if stays.count > 1
      max = stays.max { |a,b| a['finalscore'] <=> b['finalscore']}
      x= Hotel.find(max.hotel_id)
    else
      return stays
    end
  end
end
