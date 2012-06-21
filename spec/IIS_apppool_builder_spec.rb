require 'support/spec_helper'
require 'IIS_apppool_builder'

describe IISAppPoolBuilder do
	siteName = "7digital.com"

	before(:each) do
		@iisAppcmd = mock()
		@iisAppPoolBuilder = IISAppPoolBuilder.new(siteName, @iisAppcmd)
	end

	context 'setting up app pool' do
		it 'is fluent' do
			@iisAppcmd.expects(:execute).times 3
			@iisAppPoolBuilder.delete().create().assign()
		end

		it 'creates a new app pool' do
			@iisAppcmd.expects(:execute).with("ADD APPPOOL /name:#{siteName} /managedRuntimeVersion:v4.0")
			@iisAppPoolBuilder.create
		end
		it 'tears down the app pool' do
			@iisAppcmd.expects(:execute).with("DELETE APPPOOL #{siteName}")
			@iisAppPoolBuilder.delete
		end

		it 'sets application pool' do
			@iisAppcmd.expects(:execute).with("SET SITE /site.name:#{siteName} /applicationDefaults.applicationPool:#{siteName}")
			@iisAppPoolBuilder.assign
		end
	end
end
