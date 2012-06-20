require 'support/spec_helper'
require 'IIS_apppool_builder'

describe IISAppPoolBuilder do
	siteName = "7digital.com"
	appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"

	before(:each) do 
		@iisAppPoolBuilder = IISAppPoolBuilder.new(siteName)
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