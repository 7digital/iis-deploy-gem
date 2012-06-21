require 'rake'
require 'IIS_appcmd'

class WebSiteIdentifier

	def initialize(iisAppCmd = IISAppCmd.new)
		@iisAppCmd = iisAppCmd
	end
	
	def exists(siteName)
		siteInfo = @iisAppCmd.execute("LIST SITE")
		siteExits = siteInfo.include?(siteName)
		puts "checking if site #{siteName} exists : #{siteExits}"
		siteExits
	end

	def getId(siteName)
		siteInfo = @iisAppCmd.execute("LIST SITE /site.name:#{siteName}")
		parseId(siteInfo)
	end

	private
	def parseId(siteInfo)
		match = /id:(\d+),/.match(siteInfo)
		match[1].to_s
	end
end