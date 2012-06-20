require 'IIS_host_adder'

describe IISHostAdder do
	siteName = "7digital.com"
	appcmdPath = "%windir%\\system32\\inetsrc\\appcmd.exe"

	context 'adding a host entry' do

		before(:each) do
			@iisHostAdder = IISHostAdder.new(siteName)
		end

		it 'add sucessfully' do
			hostEntry = "www.7digital.com"
			expect_shell_with_parameter("#{appcmdPath} set config -section:system.applicationHost/sites /+\"[name='#{siteName}'].bindings.[protocol='http',bindingInformation='*:80:#{hostEntry}']\" /commit:apphost']")
			@iisHostAdder.add(hostEntry)
		end
	end

	private
	def expect_shell_with_parameter(parameter)
		@iisHostAdder.expects(:sh).with(parameter).once
	end
end