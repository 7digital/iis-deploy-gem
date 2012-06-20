require 'support/spec_helper'
require 'IIS_site_builder'

describe IISSiteBuilder do
	appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"
	siteName = "7digital.com"
	sitePath = "some/path/here"
	
	before(:each) do 
		@iisSiteBuilder = IISSiteBuilder.new(siteName, sitePath)
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

		it 'tears down the old site' do
			expect_shell_with_parameter("#{appcmdPath} DELETE SITE #{siteName}")
			@iisSiteBuilder.delete()
		end
	end
	
	private
	def expect_shell_with_parameter(parameter)
		@iisSiteBuilder.expects(:sh).with(parameter).once
		@iisSiteBuilder.stubs(:sh).with(Not(equals(parameter)))
	end
end
