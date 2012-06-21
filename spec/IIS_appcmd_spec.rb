require 'IIS_appcmd'

describe IISAppCmd  do
	
	before(:each) do
		@iisAppCmd = IISAppCmd.new
	end

	context "executing app cmd arugment" do
		it "use given arument" do
			arugment = "do this"
			@iisAppCmd.expects(:`).with("c:\\windows\\system32\\inetsrv\\appcmd.exe #{arugment}").returns("")
			@iisAppCmd.execute(arugment)
		end
	end
end
