require 'rake'
require 'web_site_identifier'

class IISSelfSigner
	def initialize(siteName, webSiteIdentifier = WebSiteIdentifier.new)
		@siteName = siteName
		@webSiteIdentifier = webSiteIdentifier
	end

	def sign
		@siteId = @webSiteIdentifier.getId(@siteName)
		certName = @siteName+":#{(0..16).to_a.map{|a| rand(16).to_s(16)}.join}"
		`"C:\\Program Files (x86)\\IIS Resources\\SelfSSL\\selfssl.exe" /T /N:CN=#{certName} /S:#{@siteId} /Q`
	end
end