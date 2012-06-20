require 'rake'

class IISSiteBuilder

	def initialize(siteName, sitePath, webSiteIdentifier = WebSiteIdentifier.new)
		@siteName = siteName
		@sitePath = sitePath
		@webSiteIdentifier = webSiteIdentifier
	end
	
	def delete
		if @webSiteIdentifier.exists(@siteName)
			sh "%windir%\\system32\\inetsrv\\appcmd.exe DELETE SITE #{@siteName}"
		end
		self
	end

	def create
		sh "%windir%\\system32\\inetsrv\\appcmd.exe ADD SITE /name:#{@siteName} /physicalPath:#{@sitePath}"
		self
	end
end
