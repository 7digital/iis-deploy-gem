require 'rake'

class IISAppPoolBuilder
	
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