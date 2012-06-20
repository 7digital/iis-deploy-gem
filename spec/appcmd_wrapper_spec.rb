require 'rake'

#SET appcmd="C:\windows\System32\inetsrv\appcmd.exe"


class IISSiteBuilder
	def Create(siteName, sitePath)
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE SITE #{siteName}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe ADD SITE /name:#{siteName} /physicalPath:#{sitePath}"
	end

	def SelfSignSite(siteName)
		execute "C:\\Program Files (x86)\\IIS Resources\\SelfSSL>selfssl.exe /T /N:CN=#{siteName} /S:13 /Q"
	end

	private
	def execute(command)
		sh command
	end
end




class IISSelfSigning
end

require 'support/spec_helper'




describe IISSiteBuilder do

	before(:each) do 
		@iisSiteBuilder = IISSiteBuilder.new
	end
	
	context 'self signing iis site' do
		selfSignPath = "C:\\Program Files (x86)\\IIS Resources\\SelfSSL>selfssl.exe"
		siteName = "7digital.com"
		
		it 'get site info' do
			expect_shell_with_parameter("#{selfSignPath} /T /N:CN=#{siteName} /S:13 /Q")
			@iisSiteBuilder.SelfSignSite(siteName)
		end
	end

	context 'deploying a site to iis' do	
		appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"
		siteName = "7digital.com"
		sitePath = "some/path/here"

		it 'creates a new site' do
			expect_shell_with_parameter("#{appcmdPath} ADD SITE /name:#{siteName} /physicalPath:#{sitePath}")
			@iisSiteBuilder.Create(siteName, sitePath)
		end

		it 'tears down the old site' do
			expect_shell_with_parameter("#{appcmdPath} DELETE SITE #{siteName}")
			@iisSiteBuilder.Create(siteName,"a/path")
		end
		
		
	end
	
	private
	def expect_shell_with_parameter(parameter)
		@iisSiteBuilder.expects(:sh).with(parameter).once
		@iisSiteBuilder.stubs(:sh).with(Not(equals(parameter)))
	end
end