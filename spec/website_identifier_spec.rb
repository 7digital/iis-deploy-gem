require 'support/spec_helper'
require 'web_site_identifier'

describe WebSiteIdentifier do
	siteName = "7digital.com"
	listOfSites = "
				SITE \"territoriesApi\" (id:3,bindings:http/*:80:territoriesapi,state:Started)
				SITE \"#{siteName}\" (id:1,bindings:http/*:80:sevenspace.local,net.tcp/808:*,net.pipe/*,net.msmq/localhost,msmq.formatname/localhost,state:Stopped)
				SITE \"SevenDigital.Web.Stores\" (id:5,bindings:http/*:80:stores.7digital.local,http/*:80:,state:Stopped)
				SITE \"mailout\" (id:6,bindings:http/*:80:mailout.7digital.locallocal,state:Stopped)
				"

	before(:each) do
		@iisAppCmd = mock()
		@webSiteIdentifier = WebSiteIdentifier.new(@iisAppCmd)
	end
	
	context 'Given an appcmd result' do	
		it 'gets website identifier' do
			@iisAppCmd.expects(:execute).with("LIST SITE /site.name:#{siteName}").returns('SITE "7digital.com" (id:13,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result = @webSiteIdentifier.getId(siteName)
			result.should == "13" 
		end

		it 'gets website identifier with big number' do
			@iisAppCmd.expects(:execute).with("LIST SITE /site.name:#{siteName}").returns('SITE "7digital.com" (id:123333,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result = @webSiteIdentifier.getId(siteName)
			result.should == "123333" 
		end
	end

	context 'given a website name' do
		it 'can check the website when exists' do
			@iisAppCmd.expects(:execute).with("LIST SITE").returns(listOfSites)
			@webSiteIdentifier.exists(siteName).should be_true
		end

		it 'can check the website when it does not exist' do
			@iisAppCmd.expects(:execute).with("LIST SITE").returns(listOfSites)
			@webSiteIdentifier.exists("dsadsadas").should be_false
		end
	end
end


