# Ruby-Pipe-Method-Chain

＊基本的な使い方

    以下の書き方を
    "hello".rjust(10)
    => "     hello"
    
    以下のようにすることができるようになります
    "hello" | :rjust[10]
    
    また、表示したいときなどは、「^」の左を:putsの引数にすることができます
    pry(main)> "hello" | :rjust[10] ^ :puts
         hello

*便利な場面
    全体にカッコがつく、「([1, 3, 5] + array1 + array2).join」の場合は少し楽になります
    このようになります「[1, 3, 5] + array1 + array2 | :join」

そもそも、これを作った理由が、先頭に戻って、全体にカッコを付けるのが少しおっくうになるからでした。

ちゃんと既存の「|」も動くのでご安心ください
1 | 1
=> 1
1 | 0
=> 1

