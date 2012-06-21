require 'support/spec_helper'
require 'IIS_self_signer'

describe IISSelfSigner do
	context 'self signing iis site' do
		selfSignPath = "%programfiles(x86)%\\IIS Resources\\SelfSSL\\selfssl.exe"
		siteName = "7digital.com"
		siteId = 13
		
		before(:each) do
			webSiteIdentifier = mock()
			webSiteIdentifier.stubs(:getId).returns(siteId) 
			
			@iisSelfSigner = IISSelfSigner.new(siteName, webSiteIdentifier)
		end

		it 'self signs site' do
			@iisSelfSigner.expects(:`).with(includes("/S:#{siteId} /Q")).once
			@iisSelfSigner.sign
		end
	end
end