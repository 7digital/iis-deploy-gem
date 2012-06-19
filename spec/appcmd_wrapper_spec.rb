require 'rake'

#SET appcmd="C:\windows\System32\inetsrv\appcmd.exe"

#C:\Program Files (x86)\IIS Resources\SelfSSL>selfssl.exe /T /N:CN=7digital.com /S:13 /Q


class AppcmdWrapper
	def Create(siteName, sitePath)
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE APPPOOL #{siteName}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE SITE #{siteName}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe ADD SITE /name:#{siteName} /physicalPath:#{sitePath}"
		execute "%windir%\\system32\\inetsrc\\appcmd.exe SET SITE /site.name:#{siteName} /applicationDefaults.applicationPool:#{siteName}"
	end

	private
	def execute(command)
		sh command
	end
end



require 'support/spec_helper'

describe AppcmdWrapper do
	context 'deploying a site to iis' do	
		appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"
		siteName = "7digital.com"
		sitePath = "some/path/here"

		before(:each) do 
			@appcmdWrapper = AppcmdWrapper.new
		end
		
		it 'tears down the old site' do
			expect_shell_with_parameter("#{appcmdPath} DELETE SITE #{siteName}")
			@appcmdWrapper.Create(siteName,"a/path")
		end
		
		it 'tears down the app pool' do
			expect_shell_with_parameter("#{appcmdPath} DELETE APPPOOL #{siteName}")
			@appcmdWrapper.Create(siteName,"a/path")
		end

		it 'creates a new app pool' do
			expect_shell_with_parameter("#{appcmdPath} ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0")
			@appcmdWrapper.Create(siteName,"a/path")
		end

		it 'creates a new site' do
			expect_shell_with_parameter("#{appcmdPath} ADD SITE /name:#{siteName} /physicalPath:#{sitePath}")
			@appcmdWrapper.Create(siteName, sitePath)
		end


		it 'sets application pool' do
			expect_shell_with_parameter("#{appcmdPath} SET SITE /site.name:#{siteName} /applicationDefaults.applicationPool:#{siteName}")
			@appcmdWrapper.Create(siteName, sitePath)
		end

		private 
		def expect_shell_with_parameter(parameter)
			@appcmdWrapper.expects(:sh).with(parameter).once
			@appcmdWrapper.stubs(:sh).with(Not(equals(parameter)))
		end
	end
end