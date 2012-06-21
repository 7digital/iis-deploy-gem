require 'IIS_appcmd'

class IISHostAdder
	def initialize(siteName, iisAppCmd = IISAppcmd.new)
		@siteName = siteName
		@iisAppCmd = iisAppCmd
	end

	def addSingle(host)
		puts "adding host #{host} to site #{@siteName}"
		@iisAppCmd.execute("SET CONFIG -section:system.applicationHost/sites /+\"[name='#{@siteName}'].bindings.[protocol='http',bindingInformation='*:80:#{host}']\" /commit:apphost']")
	end

	def addMultiple(hosts)
		puts "adding multiple sites for site #{@siteName}"
		hosts.each {|host| addSingle(host) }
	end
end