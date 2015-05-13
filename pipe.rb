# 以下の書き方を
# puts ("%f" % 0.12012).rjust 10
# 以下のようにできます
# "%f" % 0.12012 | :rjust[10] ^ :puts
#
# 全体をカッコで囲むときに威力を発揮します
# 例えば、「"%f" % 0.12012」にrjustするとき、全体をカッコで囲み「("%f" % 0.12012)」と書き換えなくてはいけなくなります
# そして、それを出力しようと思ったら、行頭に戻って puts を書く必要がありますが、「^ :puts」と書くだけでOKです

class Symbol
	# シンボルから引数を取り出すために
	@@sym2params = Hash.new([])

	# method(10)が:method[10]
	def [] *params
		@@sym2params[self] += params
		self
	end

	# シンボルに渡されている引数を返す
	def params
		@@sym2params[self]
	end

	# シンボルに登録されている引数を削除
	def clear_params
		@@sym2params[self] = []
	end
end

# すべてのクラスに適応する
Object.constants.select{|c| Object.const_get(c).class == Class}.map{|c| Object.const_get(c)}.each do |clazz|
	clazz.class_eval do
		# 「|」あるときはbarに退避させる
		alias_method(:bar, :|) if method_defined?(:|)
		alias_method(:hat, :"^") if method_defined?(:"^") 

		# self.method が self | :methodで動くように
		def | (method, *others)
			# method名がシンボルなら
			if method.class == Symbol
				# パラメータを読み込んでメソッドを呼ぶ
				res = self.send(method, *method.params)
				# シンボルに登録されているparamsを削除する
				method.clear_params
				# 結果を返す
				res
			else
				# method名がシンボルでないなら、普通の「|」を呼ぶ
				bar(method, *others) if self.class.method_defined? :bar
			end
		end

		# puts "hello"を "hello" ^ :putsで動かす
		def ^(func)
			send(func, self) if self.class.method_defined? :hat
		end

	end
end