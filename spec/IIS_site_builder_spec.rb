require 'support/spec_helper'
require 'IIS_site_builder'

describe IISSiteBuilder do
	siteName = "7digital.com"
	sitePath = "some/path/here"
	
	before(:each) do 
		@webSiteIdentifier = mock()
		@webSiteIdentifier.stubs(:exists).returns(true)
		@iisAppCmd = mock()
		@iisSiteBuilder = IISSiteBuilder.new(siteName, sitePath, @webSiteIdentifier, @iisAppCmd)
	end
	
	context 'deploying a site to iis' do	
		it 'is fluent' do
			@iisAppCmd.expects(:execute).times 2
			@iisSiteBuilder.delete().create()
		end

		it 'creates a new site' do
			@iisAppCmd.expects(:execute).with("ADD SITE /name:#{siteName} /bindings:http://#{siteName}:80 /physicalPath:#{sitePath}")
			@iisSiteBuilder.create()
		end
	end

	context 'creating a new iis site builder' do
		it 'create its own webSiteIdentifier' do
			siteBuilder = IISSiteBuilder.new(siteName, sitePath)
			siteBuilder.webSiteIdentifier.should_not == nil
		end
	end

	context 'deleteing website' do
		it 'tears down the old site' do
			@iisAppCmd.expects(:execute).with("DELETE SITE #{siteName}")
			@iisSiteBuilder.delete()
		end

		it 'does not tear down the website if it exists'  do
			@webSiteIdentifier.stubs(:exists).returns(false)
			@iisAppCmd.expects(:execute).with("DELETE SITE #{siteName}").never
			@iisSiteBuilder.delete()
		end
	end
end
