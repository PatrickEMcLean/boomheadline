module codevalid

	def code_is_valid?(code)
		codesarray=[]
		codes=File.open('./codes.txt')

		codes.each do |line|
			codesarray.push(line.chomp)
		end


		codesarray.each do |validcode|
			if code == validcode
				return true
			end
		end
		return false
	end	




