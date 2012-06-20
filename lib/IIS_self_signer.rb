require 'rake'
require 'web_site_identifier'

class IISSelfSigning
	attr_accessor :webSiteIdentifier

	def initialize(siteName, webSiteIdentifier = WebSiteIdentifier.new)
		@siteName = siteName
		@webSiteIdentifier = webSiteIdentifier
	end

	def sign
		@siteId = @webSiteIdentifier.getId(@siteName)
		sh "%programfiles(x86)%\\IIS Resources\\SelfSSL\\selfssl.exe /T /N:CN=#{@siteName} /S:#{@siteId} /Q"
	end
end
