require 'rake'
require 'IIS_appcmd'

# Used to manage IIS App Pool

class IISAppPoolBuilder
	# Params:
	# +siteName+:: siteName string used to identify site (e.g)
	def initialize(siteName, iisAppCmd = IISAppcmd.new)
		@siteName = siteName	
		@iisAppCmd = iisAppCmd
	end

	def create
		puts "creating app pool : #{@siteName}"
		@iisAppCmd.execute("ADD APPPOOL /name:#{@siteName} /managedRuntimeVersion:v4.0")
		self
	end
	
	def delete
		puts "deleting app pool : #{@siteName}"
		@iisAppCmd.execute("DELETE APPPOOL #{@siteName}")
		self
	end

	def assign
		puts "assigning app pool : #{@siteName} to site #{@siteName}"
		@iisAppCmd.execute("SET SITE /site.name:#{@siteName} /applicationDefaults.applicationPool:#{@siteName}")
		self
	end
end