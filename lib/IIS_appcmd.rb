class IISAppCmd
	def execute(arugment)
		`c:\\windows\\system32\\inetsrv\\appcmd.exe #{arugment}`
	end
end
