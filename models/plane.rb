require 'yaml'

class Plane
	attr_reader :id, :name, :charter_price_cents_usd,
		:downpayment_price_cents_usd, :image_filename

  def initialize(item)
    @id                          = item["id"].to_s
    @name                        = item["name"]
    @charter_price_cents_usd     = item["charter_price_cents_usd"].to_i
    @downpayment_price_cents_usd = item["downpayment_price_cents_usd"].to_i
    @image_filename              = item["image_filename"]
  end

  def self.all
    YAML.load_file("./config/planes.yml").map do |item|
      Plane.new(item)
    end
  end

  def self.find_by_id(id)
    Plane.all.find{|plane| plane.id == id}
  end

  def self.find_by_ids(ids)
    ids.map do |id|
      Plane.find_by_id(id.to_s)
    end
  end

  def self.total_cost_cents_usd_for_planes(planes)
		if ENV["CUBAN_MODE"].nil?
			planes.sum{|plane| plane.charter_price_cents_usd}
		else
			planes.sum{|plane| plane.downpayment_price_cents_usd}
		end
  end

	def self.total_cost_cents_usd(plane_ids)
    planes = Plane.find_by_ids(plane_ids)
    Plane.total_cost_cents_usd_for_planes(planes)
	end

end
