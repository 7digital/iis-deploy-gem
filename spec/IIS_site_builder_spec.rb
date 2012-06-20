require 'support/spec_helper'
require 'IIS_site_builder'

describe IISSiteBuilder do
	appcmdPath = "%windir%\\system32\\inetsrv\\appcmd.exe"
	siteName = "7digital.com"
	sitePath = "some/path/here"
	
	before(:each) do 
		@webSiteIdentifier = mock()
		@webSiteIdentifier.stubs(:exists).returns(true)
		@iisSiteBuilder = IISSiteBuilder.new(siteName, sitePath, @webSiteIdentifier)
	end
	
	
	context 'deploying a site to iis' do	
		it 'is fluent' do
			@iisSiteBuilder.expects(:sh).with(includes(appcmdPath)).times 2
			@iisSiteBuilder.delete().create()
		end

		it 'creates a new site' do
			expect_shell_with_parameter("#{appcmdPath} ADD SITE /name:#{siteName} /physicalPath:#{sitePath}")
			@iisSiteBuilder.create()
		end
	end

	context 'deleteing website' do

		it 'tears down the old site' do
			expect_shell_with_parameter("#{appcmdPath} DELETE SITE #{siteName}")
			@iisSiteBuilder.delete()
		end

		it 'does not tear down the website if it exists'  do
			@webSiteIdentifier.stubs(:exists).returns(false)
			@iisSiteBuilder.expects(:sh).with("#{appcmdPath} DELETE SITE #{siteName}").never
			@iisSiteBuilder.delete()
		end
	end
	
	private
	def expect_shell_with_parameter(parameter)
		@iisSiteBuilder.expects(:sh).with(parameter).once
		@iisSiteBuilder.stubs(:sh).with(Not(equals(parameter)))
	end
end
