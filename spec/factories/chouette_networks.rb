Factory.define :network, :class => "Chouette::Network" do |network|
  network.sequence(:name) { |n| "Network #{n}" }
  network.sequence(:objectid) { |n| "Network:#{n}" }
end
