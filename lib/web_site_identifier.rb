require 'rake'

class WebSiteIdentifier
	def exists(siteName)
		siteInfo = sh "%windir%\\system32\\inetsrv\\appcmd.exe LIST SITE"
		siteExits = siteInfo.include?(siteName)
		siteExits
	end

	def getId(siteName)
		siteInfo = sh "%windir%\\system32\\inetsrv\\appcmd.exe LIST SITE /site.name:#{siteName}"
		parseId(siteInfo)
	end

	private
	def parseId(siteInfo)
		match = /id:(\d+),/.match(siteInfo)
		match[1].to_s
	end
end