require 'rake'

class IISSiteBuilder

	def initialize(siteName, sitePath)
		@siteName = siteName
		@sitePath = sitePath
	end
	
	def delete
		sh "%windir%\\system32\\inetsrc\\appcmd.exe DELETE SITE #{@siteName}"
		self
	end

	def create
		sh "%windir%\\system32\\inetsrc\\appcmd.exe ADD SITE /name:#{@siteName} /physicalPath:#{@sitePath}"
		self
	end
end
