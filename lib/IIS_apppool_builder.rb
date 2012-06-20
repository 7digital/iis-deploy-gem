require 'rake'

# Used to manage IIS App Pool
class IISAppPoolBuilder
	# Params:
	# +siteName+:: siteName string used to identify site (e.g 7digital.com)
	def initialize(siteName)
		@siteName = siteName	
	end

	def create
		sh "%windir%\\system32\\inetsrc\\appcmd.exe ADD APPPOOL /name:#{@siteName} /managedRuntimeVersion:v4.0"
		self
	end
	
	def delete
		sh "%windir%\\system32\\inetsrc\\appcmd.exe DELETE APPPOOL #{@siteName}"
		self
	end

	def assign
		sh "%windir%\\system32\\inetsrc\\appcmd.exe SET SITE /site.name:#{@siteName} /applicationDefaults.applicationPool:#{@siteName}"
		self
	end
end