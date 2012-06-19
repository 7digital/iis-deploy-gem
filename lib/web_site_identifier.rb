class WebSiteIdentifier
	def getId(siteInfo)
		match = /id:(\d+),/.match(siteInfo)
		match[1].to_s
	end 
end