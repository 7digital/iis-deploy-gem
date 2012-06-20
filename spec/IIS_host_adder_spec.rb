require 'IIS_host_adder'

describe IISHostAdder do
	siteName = "7digital.com"
	appcmdPath = "%windir%\\system32\\inetsrv\\appcmd.exe"

	context 'adding a host entry' do

		before(:each) do
			@iisHostAdder = IISHostAdder.new(siteName)
		end

		it 'add sucessfully' do
			hostEntry = "www.7digital.com"
			expect_shell_with_parameter("#{appcmdPath} set config -section:system.applicationHost/sites /+\"[name='#{siteName}'].bindings.[protocol='http',bindingInformation='*:80:#{hostEntry}']\" /commit:apphost']")
			@iisHostAdder.addSingle(hostEntry)
		end

		it 'should add multiple sites when using array' do
			hostEntrys = ["de.7digital.com", "fr.7digital.com", "ie.7digital.com"]
			@iisHostAdder.expects(:sh).with(includes(hostEntrys[0]))
			@iisHostAdder.expects(:sh).with(includes(hostEntrys[1]))
			@iisHostAdder.expects(:sh).with(includes(hostEntrys[2]))
			@iisHostAdder.addMultiple(hostEntrys)
		end
	end

	private
	def expect_shell_with_parameter(parameter)
		@iisHostAdder.expects(:sh).with(parameter).once
		@iisHostAdder.stubs(:sh).with(Not(equals(parameter)))
	end
end