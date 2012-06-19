require 'support/spec_helper'
require 'web_site_identifier'

describe WebSiteIdentifier do
	context 'Given an appcmd result' do	
		before(:each) do
			@webSiteIdentifier = WebSiteIdentifier.new
		end

		it 'gets website identifier' do
			result = @webSiteIdentifier.getId('SITE "7digital.com" (id:13,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result.should == "13" 
		end

		it 'gets website identifier with big number' do
			result = @webSiteIdentifier.getId('SITE "7digital.com" (id:123333,bindings:http/*:80:www.7digital.local,https/:443:,state:Started)')
			result.should == "123333" 
		end

	end
end