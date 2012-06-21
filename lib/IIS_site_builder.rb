require 'rake'
require 'web_site_identifier'
require 'IIS_appcmd'

class IISSiteBuilder
	attr_accessor :webSiteIdentifier

	def initialize(siteName, sitePath, webSiteIdentifier = WebSiteIdentifier.new, iisAppCmd = IISAppCmd.new)
		@siteName = siteName
		@sitePath = sitePath
		@webSiteIdentifier = webSiteIdentifier
		@iisAppCmd = iisAppCmd
	end
	
	def delete
		puts "attempting delete of #{@siteName}"
		if @webSiteIdentifier.exists(@siteName)
			@iisAppCmd.execute("%windir%\\system32\\inetsrv\\appcmd.exe DELETE SITE #{@siteName}")
			puts "deleted site #{@siteName}"
		end
		self
	end

	def create
		puts "creating site #{@siteName}"
		@iisAppCmd.execute("%windir%\\system32\\inetsrv\\appcmd.exe ADD SITE /name:#{@siteName} /bindings:http://#{@siteName}:80 /physicalPath:#{@sitePath}")
		self
	end
end