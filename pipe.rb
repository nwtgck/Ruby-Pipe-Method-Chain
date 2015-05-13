# 以下の書き方を
# puts ("%f" % 0.12012).rjust 10
# 以下のようにできます
# "%f" % 0.12012 | :rjust[10] ^ :puts
#
# 全体をカッコで囲むときに威力を発揮します
# 例えば、「"%f" % 0.12012」にrjustするとき、全体をカッコで囲み「("%f" % 0.12012)」と書き換えなくてはいけなくなります
# そして、それを出力しようと思ったら、行頭に戻って puts を書く必要がありますが、「^ :puts」と書くだけでOKです

# メソッド名と引数を管理するため
class SymMethod
	attr_reader :name, :params, :block
	def initialize(name, params, &block)
		@name, @params, @block = name, params, block
	end
end

# シンボル[]をした時にSymMethodを返すようにする
class Symbol
	# method(10)が:method[10]
	def [] *params, &block
		SymMethod.new(self, params, &block)
	end
end


# すべてのクラスに適応する
Object.constants.select{|c| Object.const_get(c).class == Class}.map{|c| Object.const_get(c)}.each do |clazz|
	clazz.class_eval do
		# 「|」あるときは「__|__」に退避させる
		alias_method(:__bar, :|) if method_defined?(:|)
		alias_method(:__hat, :'^') if method_defined?(:'^')

		private :__bar if method_defined?(:__bar)
		private :__hat if method_defined?(:__hat)

		# self.method が self | :methodで動くように
		def | (method, *others, &block)
			# method名がシンボルなら
			if method.class == Symbol
				self.send(method)
			elsif method.class == SymMethod
				self.send(method.name, *method.params, &method.block)
			else
				# method名がシンボルでないなら、普通の「|」を呼ぶ
				__bar(method, *others, &block) if self.class.private_method_defined? :__bar
			end
		end

		# puts "hello"を "hello" ^ :putsで動かす
		def ^(func, *others, &block)
			if func.class == Symbol
				send(func, self)
			else
				# 普通の「^」を呼ぶ
				send(:__hat, func, *others, &block) if self.class.private_method_defined? :__hat
			end
			
		end

	end
end


