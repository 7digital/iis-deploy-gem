require 'IIS_host_adder'

describe IISHostAdder do
	siteName = "7digital.com"

	context 'adding a host entry' do

		before(:each) do
			@iisAppcmd = mock()
			@iisHostAdder = IISHostAdder.new(siteName, @iisAppcmd)
		end

		it 'add sucessfully' do
			hostEntry = "www.7digital.com"
			@iisAppcmd.expects(:execute).with("SET CONFIG -section:system.applicationHost/sites /+\"[name='#{siteName}'].bindings.[protocol='http',bindingInformation='*:80:#{hostEntry}']\" /commit:apphost']")
			@iisHostAdder.addSingle(hostEntry)
		end

		it 'should add multiple sites when using array' do
			hostEntrys = ["de.7digital.com", "fr.7digital.com", "ie.7digital.com"]
			@iisAppcmd.expects(:execute).with(includes(hostEntrys[0]))
			@iisAppcmd.expects(:execute).with(includes(hostEntrys[1]))
			@iisAppcmd.expects(:execute).with(includes(hostEntrys[2]))
			@iisHostAdder.addMultiple(hostEntrys)
		end
	end
end