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


class IisAppPoolBuilder
	@siteName
	def initialize(siteName)
		@siteName = siteName	
	end

	def create
		execute "%windir%\\system32\\inetsrc\\appcmd.exe ADD APPPOOL /name:#{@siteName} /managedRuntimeVersion:v4.0"
		self
	end
	
	def delete
		execute "%windir%\\system32\\inetsrc\\appcmd.exe DELETE APPPOOL #{@siteName}"
		self
	end

	def assign
		execute "%windir%\\system32\\inetsrc\\appcmd.exe SET SITE /site.name:#{@siteName} /applicationDefaults.applicationPool:#{@siteName}"
		self
	end

	private
	def execute(command)
		sh command
	end
end

class IISSelfSigning
end

require 'support/spec_helper'


describe IisAppPoolBuilder do
	siteName = "7digital.com"
	appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"

	before(:each) do 
		@iisAppPoolBuilder = IisAppPoolBuilder.new(siteName)
	end

	context 'setting up app pool' do
		it 'is fluent' do
			@iisAppPoolBuilder.expects(:sh).with(includes(appcmdPath)).times 3
			@iisAppPoolBuilder.delete().create().assign()
		end

		it 'creates a new app pool' do
			expect_shell_with_parameter("#{appcmdPath} ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0")
			@iisAppPoolBuilder.create
		end
		it 'tears down the app pool' do
			expect_shell_with_parameter("#{appcmdPath} DELETE APPPOOL #{siteName}")
			@iisAppPoolBuilder.delete
		end

		it 'sets application pool' do
			expect_shell_with_parameter("#{appcmdPath} SET SITE /site.name:#{siteName} /applicationDefaults.applicationPool:#{siteName}")
			@iisAppPoolBuilder.assign
		end
	end

	private
	def expect_shell_with_parameter(parameter)
		@iisAppPoolBuilder.expects(:sh).with(parameter).once
		@iisAppPoolBuilder.stubs(:sh).with(Not(equals(parameter)))
	end
end

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