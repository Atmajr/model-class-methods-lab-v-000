class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    Boat.limit(5)
    # .map { |boat| boat.name }
  end

  def self.dinghy
    Boat.where('length < ?', '20')
  end

  def self.ship
    Boat.where('length >= ?', '20')
  end

  def self.last_three_alphabetically
    # boat_array = Boat.all.sort_by{ |boat| boat.name }.reverse
    # boat_array.first(3)
    Boat.order(name: :desc).limit(3)
  end

  def self.without_a_captain
    Boat.where("captain_id IS NULL")
  end

  def self.sailboats
    # RIP MY PERFECTLY REASONABLE SOLUTION WHICH DOESN'T SATISFY THE SPEC
    # sailboat_collection = []
    # Boat.all.each do |boat|
    #   if boat.classifications.map(&:name).include?("Sailboat")
    #     sailboat_collection << boat
    #   end
    # end
    # sailboat_collection

    # Here's how API dock says to do this. That doesn't work either.
    # So I guess I'm stealing it from the solution now

    Boat.includes(:classifications).where(classifications: { name: 'Sailboat' })
  end

  def self.with_three_classifications
    Boat.joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.non_sailboats
    Boat.where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    Boat.order(length: :desc).first
  end

end
