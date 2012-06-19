require 'rake'

#SET appcmd="C:\windows\System32\inetsrv\appcmd.exe"

#%appcmd% ADD SITE /name:%sitename% /bindings:"http://www.7digital.local:80" /physicalPath:"c:\work\sevendigital-com\src\SevenDigital.Com.Web"
#%appcmd% SET SITE /site.name:%sitename% /applicationDefaults.applicationPool:%sitename%
#C:\Program Files (x86)\IIS Resources\SelfSSL>selfssl.exe /T /N:CN=7digital.com /S:13 /Q



class AppcmdWrapper
	def Create(siteName, sitePath)
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE SITE #{siteName}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE APPPOOL #{siteName}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0"
	end

	private
	def execute(command)
		sh command
	end
end



require 'support/spec_helper'

describe AppcmdWrapper do
	context 'Given creating a new site' do	
		appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"
		siteName = "7digital.com"
		sitePath = "some/path/here"

		before(:each) do
			@appcmdWrapper = AppcmdWrapper.new
		end
		
		it 'should tear down the old site' do
			expect_shell_with_parameter("#{appcmdPath} DELETE SITE #{siteName}")
			@appcmdWrapper.Create(siteName,"a/path")
		end
		
		it 'should tear down the app pool' do
			expect_shell_with_parameter("#{appcmdPath} DELETE APPPOOL #{siteName}")
			@appcmdWrapper.Create(siteName,"a/path")
		end

		it 'should create a new app pool' do
			expect_shell_with_parameter("#{appcmdPath} ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0")
			@appcmdWrapper.Create(siteName,"a/path")
		end

		it 'should create a new site' do
			expect_shell_with_parameter("#{appcmdPath} ADD SITE /name:#{siteName} /physicalPath:#{sitePath}")
			@appcmdWrapper.Create(siteName,"a/path")
		end

		private 
		def expect_shell_with_parameter(parameter)
			@appcmdWrapper.expects(:sh).with(parameter).once
			@appcmdWrapper.stubs(:sh).with(Not(equals(parameter)))
		end
	end
end