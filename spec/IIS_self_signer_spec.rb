require 'support/spec_helper'
require 'IIS_self_signer'

describe IISSelfSigning do
	context 'self signing iis site' do
		selfSignPath = "%programfiles(x86)%\\IIS Resources\\SelfSSL\\selfssl.exe"
		siteName = "7digital.com"
		siteId = 13
		
		before(:each) do
			webSiteIdentifier = mock()
			webSiteIdentifier.stubs(:getId).returns(siteId) 
			
			@iisSelfSigner = IISSelfSigning.new(siteName, webSiteIdentifier)
		end

		it 'self signs site' do
			expect_shell_with_parameter("#{selfSignPath} /T /N:CN=#{siteName} /S:#{siteId} /Q")
			@iisSelfSigner.sign
		end

	end

	private
	def expect_shell_with_parameter(parameter)
		@iisSelfSigner.expects(:sh).with(parameter).once
		@iisSelfSigner.stubs(:sh).with(Not(equals(parameter)))
	end
end