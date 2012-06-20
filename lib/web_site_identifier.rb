require 'rake'

class WebSiteIdentifier

	def getId(siteName)
		siteInfo = sh "%windir%\\system32\\inetsrc\\appcmd.exe LIST SITE /site.name:#{siteName}"
		parseId(siteInfo)
	end

	private
	def parseId(siteInfo)
		match = /id:(\d+),/.match(siteInfo)
		match[1].to_s
	end
end