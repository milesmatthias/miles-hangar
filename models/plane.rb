require 'yaml'

class Plane
	attr_reader :id, :name, :charter_price_cents_usd,
		:downpayment_price_cents_usd, :image_filename

  def initialize(item)
    @id                          = item["id"]
    @name                        = item["name"]
    @charter_price_cents_usd     = item["charter_price_cents_usd"].to_i rescue nil
    @downpayment_price_cents_usd = item["downpayment_price_cents_usd"].to_i rescue nil
    @image_filename              = item["image_filename"]
  end

  def self.all
    YAML.load_file("./config/planes.yml").map do |item|
      Plane.new(item)
    end
  end

  def self.find_by_id(id)
    self.all.find{|plane| plane.id == id}
  end

  def self.find_by_ids(ids)
    self.all.select{|plane| ids.include?(plane.id)}
  end

	def self.total_cost_cents_usd(plane_ids)
		if ENV["CUBAN_MODE"].nil?
			self.find_by_ids(plane_ids).sum{|plane| plane.charter_price_cents_usd}
		else
			self.find_by_ids(plane_ids).sum{|plane| plane.downpayment_price_cents_usd}
		end
	end
end
