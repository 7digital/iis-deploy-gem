class IISHostAdder
	def initialize(siteName)
		@siteName = siteName
	end

	def add(host)
		sh "%windir%\\system32\\inetsrc\\appcmd.exe set config -section:system.applicationHost/sites /+\"[name='#{@siteName}'].bindings.[protocol='http',bindingInformation='*:80:#{host}']\" /commit:apphost']"
	end
end