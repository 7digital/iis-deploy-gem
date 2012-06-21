class IISAppCmd
	def execute(arugment)
		response = `c:\\windows\\system32\\inetsrv\\appcmd.exe #{arugment}`
		#puts response
		response
	end
end
