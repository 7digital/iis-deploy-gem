require 'support/spec_helper'
require 'web_site_identifier'

describe WebSiteIdentifier do
	siteName = "7digital.com"

	before(:each) do
		@webSiteIdentifier = WebSiteIdentifier.new
	end
	context 'Given an appcmd result' do	
		it 'gets website identifier' do
			@webSiteIdentifier.stubs(:sh).with(includes(siteName)).returns('SITE "7digital.com" (id:13,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result = @webSiteIdentifier.getId(siteName)
			result.should == "13" 
		end

		it 'gets website identifier with big number' do
			@webSiteIdentifier.stubs(:sh).with(includes(siteName)).returns('SITE "7digital.com" (id:123333,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result = @webSiteIdentifier.getId(siteName)
			result.should == "123333" 
		end
	end

	context 'given a website name' do
		it 'calls appcmd list website' do
			expect_shell_with_parameter("%windir%\\system32\\inetsrc\\appcmd.exe LIST SITE /site.name:#{siteName}")
			@webSiteIdentifier.getId(siteName)
		end
	end

	private
	def expect_shell_with_parameter(parameter)
		@webSiteIdentifier.expects(:sh).with(parameter).once.returns('SITE "7digital.com" (id:13,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
		@webSiteIdentifier.stubs(:sh).with(Not(equals(parameter)))
	end
end