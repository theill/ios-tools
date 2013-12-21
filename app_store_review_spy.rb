require 'open-uri'
require 'nokogiri'

#
# Based on an App Store application ID and a version it will find all reviers
# of a specific version.
#
# Useful if you want to poke friends to update their review for latest release
# of your app.
#
# Usage:
#   ruby -e 'AppStoreReviewSpy.new('402391159', '1.4.2').reviewers'
#
class AppStoreReviewSpy

	def initialize(app_id, version)
		@app_id = app_id
		@version = version
	end

	def app_stores	
		['ar','at','ca','de','dk','es','gb','hk','ie','in','it','mx','no','se','us']
	end

	def url_for_app_store(app_store)
		"https://itunes.apple.com/#{app_store}/rss/customerreviews/id=#{@app_id}/sortBy=mostRecent/xml"
	end

	def reviewers_for_store(app_store)
		doc = Nokogiri::HTML(open(url_for_app_store(app_store))) rescue nil
		return [] if doc.nil?
		
		doc.xpath("//entry/version[.='#{@version}']/../author/name").map &:content
	end

	def reviewers
		combined_list = []
		app_stores.each do |app_store|
			combined_list += reviewers_for_store(app_store)
		end
		combined_list.uniq
	end

end

if ARGV.count == 2
  print AppStoreReviewSpy.new(ARGV[0], ARGV[1]).reviewers.to_s + "\n"
else
  print "Specify <app_id> <version>\n"
end

# Wallpapery
#print AppStoreReviewSpy.new('402391159', '1.4.2').reviewers.to_s + "\n"

# Click A Taxi
# print AppStoreReviewSpy.new('468086221', '3.0.9').reviewers.to_s + "\n"

# Drivr
# print AppStoreReviewSpy.new('679834950', '1.1.0').reviewers.to_s + "\n"
