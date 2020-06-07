
## Shell语法汇总

### Shell变量

变量名和等号之间不能有空格。

1. 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
2. 中间不能有空格，可以用下划线。
3. 不能使用标点符号。
4. 不能使用Bash里面的关键字

变量引用： 在变量名前面加美元符号。变量名外面花括号可选。

建议给所有变量加上花括号。

* 已经定义的变量可以重新被定义。 my_name="Tob"   my_name="hhhe"

* ${dirname $0} 返回文件所在的目录。 $0表示当前动行的命令名。作用：切换到脚本所在的目录。

* 命令替换： 在bash中，$() 与 反引号 `` 都是用来作命令替换的。一般建议使用$()

* ${} 变量替换，  一般可以不加{}，但是识别度就差很多。

* $$ : 获取Shell本身的PID （ProcessID）

* $! ：获取Shell最后运行的后台Process的PID

* $? ：获取最后运行的命令的结束代码（返回值）

* $0 ：Shell本身的文件名

* 1~n   添加到Shell的各参数值。 $1是第一参数，$2是第二参数。

* 注意$可以引用变量，不能引用还赋值，这就很象PHP了。

* 只读变量，readonly 可以将变量定义为只读变量。只读变量值不能被改变。

* 使用 unset可以删除变量

  ### 变量类型

  * 局部变量： 在脚本中定义，仅仅再当前Shell中有效。
  * 环境变量：所有程序都可以访问环境变量，必要时可以通过shell来定义环境变量
  * shell变量：  shell程序设置的特殊变量。

  ### Shell字符串

  * 单引号：str='this is a string'      单引号里的变量是无效的，任何字符都会原样输出。

  * 双引号：里面可以有变量。 双引号可以有转义字符。
  * 获取字符串长度： ${#str}   runoob  ---》输出：  6
  * 提取子字符串： ${str:1:4}    runoob  ---》输出：   unoo   《即第一个字符的索引值为0》

  ### Shell数组

  shell 用括号表示数组。 数组元素用空格 分隔开。  数组名=(值1 值2 值3)

  读取数组： ${数组名[下标]}

  获取数组所有的元素，例如： echo ${array_name[@]}

  获取数组的长度： length=${#array_name[@]} 或者  length=${#array_name[*]}

  获取单个数组的长度：  length=${#array_name[n]}



  > Linux `source` 命令用法： 是当前shell读入路径为filepath的shell文件并以此执行文件的所有语句。 使用这个命令，即使没有执行权限也可以运行。



  ### Shell注释

  单行 #    多行 等

  ### Shell传递参数

  获取参数的格式： $n  。  n代表第几个参数。



  * $0是文件名！！

  * $# 传递到脚本的参数个数
  * $* 以一个单字符穿显示所有的脚本传递的参数。
  * $$ 脚本当前运行的进程ID。
  * $! 后台运行的最后一个进程的ID号，
  * $? 显示最后命令的推出状态。0 表示没有错误。
  * $@ 以一个单字符穿显示所有的脚本传递的参数。 输出的元素单独用双引号括起来。

  ### Shell基本运算符

  ### 算术运算符

  > `expr`是一款表达式计算工具。   可以完成表达式的求值操作

  ``` bash
  #!/bin/bash

  val=`expr 2 + 2`
  echo "两数之和为： ${val}"
  # 输出结果为4
  ```

  > 注意表达式和运算符之间要有空格。
  >
  > 完整的表达式要被``反引号包含，

  假设，变量a=10 、b=20

  则：

  `expr $a + $b` 结果为30

  `expr $a \* $b`结果为200

  [ $a == $b ] 返回false

  [ $a != $b ]

  > 注意！： 条件表达式 要放在方括号里面，并且一定要有空格。

  ### 关系运算符

  `-eq`   相等

  `-ne`   不相等

  `-gt`   大于

  `-lt`   小于

  `-ge`   大于等于

  `-le`    小于等于

  > 用法： [ $a -eq $b ]  返回false



### 布尔运算符

`-!`    非运算符

`-o` 或运算

`-a` 与运算

> 用法： [ $a -lt 5 -o $b -gt 100 ]

### 逻辑运算符

`&&` 逻辑的AND

`||` 逻辑的OR



> 用法：： [[ $a -lt 100 && $b -gt 100 ]]



### 字符串运算符

= 检测两个字符串时候相等，

-z 检测长度是否为0

-n 检测字符串长度是否不为0

$   检测字符串是否为空，不为空就返回true。  [ $a ]  返回的是true

### 文件测试运算符

| -b file | 检测文件是否是块设备文件，如果是，则返回 true。              | [ -b $file ] 返回 false。 |
| ------- | ------------------------------------------------------------ | ------------------------- |
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true。            | [ -c $file ] 返回 false。 |
| -d file | 检测文件是否是目录，如果是，则返回 true。                    | [ -d $file ] 返回 false。 |
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | [ -f $file ] 返回 true。  |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。            | [ -g $file ] 返回 false。 |
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。  | [ -k $file ] 返回 false。 |
| -p file | 检测文件是否是有名管道，如果是，则返回 true。                | [ -p $file ] 返回 false。 |
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。            | [ -u $file ] 返回 false。 |
| -r file | 检测文件是否可读，如果是，则返回 true。                      | [ -r $file ] 返回 true。  |
| -w file | 检测文件是否可写，如果是，则返回 true。                      | [ -w $file ] 返回 true。  |
| -x file | 检测文件是否可执行，如果是，则返回 true。                    | [ -x $file ] 返回 true。  |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。     | [ -s $file ] 返回 true。  |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true。          | [ -e $file ] 返回 true。  |



### Shell  echo命令

> 用法： exho "xxx xxx sdsdasd"   双引号，可以省略。



1. 显示普通字符串
2. 显示转义字符：  echo "/\\"It is a test/\\""  --> 输出： "It is a Test"
3. 显示换行： echo -e "OK!  \n" # -额 表示开启转义
4. 显示结果定向到文件：      echo  ”It is a test“ > myfile
5. 原样输出字符串，不进行转义或者获取变量（用单引号操作）。   echo ''$name\\"'  --> 输出：  $name\\"

### Shell printf命令

> 命令语法： printf format-string [ arguments... ]

用法：

```bash
#!/bin/bash

printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876

# 输出结果
# 姓名     性别   体重kg
# 郭靖     男      66.12
# 杨过     男      48.65
# 郭芙     女      47.99
```

> %s %d %c %f 都是格式替代符

`%-10s` 指一个宽度为10个字符 （- 表示左对齐，没有则右对齐），任何字符都会被显示在是个字符宽的字符内，如果不足则自动以空格填充，超过也会将全部内容显示出来。

`%-4.2f`指格式化为小数，其中.2 指保留2位小数。

`format-string` 用单引号和双引号都可以，甚至没有引号都是可以的。

#### printf的转义序列

| \a    | 警告字符，通常为ASCII的BEL字符                               |
| ----- | ------------------------------------------------------------ |
| \b    | 后退                                                         |
| \c    | 抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略 |
| \f    | 换页（formfeed）                                             |
| \n    | 换行                                                         |
| \r    | 回车（Carriage return）                                      |
| \t    | 水平制表符                                                   |
| \v    | 垂直制表符                                                   |
| \\    | 一个字面上的反斜杠字符                                       |
| \ddd  | 表示1到3位数八进制值的字符。仅在格式字符串中有效             |
| \0ddd | 表示1到3位的八进制值字符                                     |



### Shell test命令

#### 数值测试

``` bash

#!/bin/bash
num1=100
num2=100
if test $[num1] -eq $[num2]
then
	echo '两个数相等！'
else
	echo '两个数不等！'
fi

```

#### 字符串测试

> if test $num1 = $num2

#### 文件测试

* test -e  <文件名>  如果文件存在则为真
* test -r  可读
* test -w  可写
* test -x 可执行
* test -s 存在且至少有一个字符则为真
* test -d 为目录
* test -f 为普通文件
* test -c 为字符型特殊文件
* test -b 块特殊文件

### Shell 流程控制

> SH的流程控制不可以为空。else分支如果没有内容就不要写。

#### if-else

* if  - then - else

  语法格式：

``` bash
if condition
then
	do sth
else
	do sth
fi
```

也可写成一行：以分号作为截至，

if [ $(ps -ef | grep -c "ssh")   -gt  1  ]; then echo "true"; fi

> if   else-if  else

``` bash
if condition
then
	do sth1
elif
then
	do sth2
else
    do sth2
fi
```

### for循环

for循环一般格式：

``` bash
for var in item1 item2 ... itemN
do
	command1
	command2
	..
done
```

写成一行

> for var in item1 item2 ... itemN; do command1; comand2... done;

``` bash
for loop in 1 2 3 4 5
do
	echo "The value is: $loop"
done

```

> For循环的列表 可以包含替换、字符串和文件名

#### While循环

```bash
#!/bin/bash
int=1
while(( $int<=5 ))
do
	echo $int
	let "int++"
done

```

while 循环可以用于读取键盘信息

##### 无限循环

``` bash
# 第一种方式
while :
do
	command
done

# 第二种方式
while true
do
	command
done
```

##### until循环

```bash
until condition
do
    command
done
```

#### case

```bash
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

#### 跳出循环

break、 continue



### Shell函数

linux shell可以用户定义函数，然后在shell脚本中可以随便调用。

shell中函数的定义格式如下：

``` bash
[ function ] funname [ () ]
{
	action;
	[return int;]
}
```

> 备注说明：
>
> 1. 可以带function fun() 定义，也可以直接fun() 定义，不带任何参数。
> 2. 参数返回，可以显示加： return返回，**如果不加，将以最后一条命令运行结果作为返回值**。 return 后跟数值n (0~255)

``` bash
#!/bin/bash
demoFun(){
	echo "这是我的第一个 shell 函数"
}
echo " -------函数开始执行-----"
demoFun
echo "--------函数执行完毕-------"

```



定义一个带有return语句的函数：(按照顺序执行的特性)

``` bash
#!/bin/bash
funWithReturn(){
	echo "asdasdasd"
	read aNum
	echo "sdasdasddsa"
	read bNum
	echo "asdasd"
	return $(( $aNum+$bNum ))
}
funWithReturn
echo "return回来的结果： $?"
```

> 注意： 所有函数在使用前必须定义，这意味着必须将函数放在脚本开始部分，直到Shell脚本解释器首次发现它时，才可以使用。 调用战术只需要使用函数名就行。

#### 函数参数

shell中，调用函数可以传递参数，在函数体内部，通过`$n`的形式来获取参数的值

```bash
#!/bin/bash
funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```

> 注意，当n大于10的时候，必须带上大括号进行引用，大括号不可省略。

另外，有几个特殊字符可以用来处理参数

| 参数处理 | 说明                                                         |
| :------- | :----------------------------------------------------------- |
| $#       | 传递到脚本或函数的参数个数                                   |
| $*       | 以一个单字符串显示所有向脚本传递的参数                       |
| $$       | 脚本运行的当前进程ID号                                       |
| $!       | 后台运行的最后一个进程的ID号                                 |
| $@       | 与$*相同，但是使用时加引号，并在引号中返回每个参数。         |
| $-       | 显示Shell使用的当前选项，与set命令功能相同。                 |
| $?       | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 |

### Shell输入、输出重定向

| 命令            | 说明                                               |
| :-------------- | :------------------------------------------------- |
| command > file  | 将输出重定向到 file。                              |
| command < file  | 将输入重定向到 file。                              |
| command >> file | 将输出以追加的方式重定向到 file。                  |
| n > file        | 将文件描述符为 n 的文件重定向到 file。             |
| n >> file       | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| n >& m          | 将输出文件 m 和 n 合并。                           |
| n <& m          | 将输入文件 m 和 n 合并。                           |
| << tag          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

> 文件描述符：需要注意的是，文件描述符 0 通常是标准输入（STDIN） ，1是标准输出（STDOUT），2 是标准错误输出（STDERR）

`>` 是更新文件，`>>` 是追加文件

> Git命令插播(提交代码到新的分支里面)： git push origin new_branch:new_branch

> 默认情况下： `command > file` 将stdout重定向到file，command < file 将stdin重定向到file，

`$ comand 2 > file` 	stderr 重定向到file

`$ command 2 >> file` 	将stderr追加到file的文件末尾。

`$ command > file 2>&1` 	将 stdout 和stderr合并 重定向到file

#### Here Document

> 用来将输入重定向 到一个交互式的shell脚本或者程序。

基本形式如下：

``` bash
command << delimiter
		document
delimiter
```

作用： 将两个delimiter 之间的内容（document） 作为输入传递给command。

> 注意：
>
> 1. 结尾的delimiter 一定要顶格写，前面不能有字符，包括空格和tab缩进。
> 2. 开始的 delimiter前后的空格会被忽略掉



```bash
#!/bin/bash
cat << EOF
欢迎来到
Shell世界
EOF

# 输出结果
# 欢迎来到
# Shell世界
```



#### /dev/null 文件

> $ command > /dev/null

/dev/null 	是一个特殊的文件，写入到它的内容都会被丢弃。

将命令的输出重定向到它，会起到“禁止输出”的效果。如果希望品笔调stdout和stderr ，可以用命令：

> $ command > /dev/null 2>&1
>
> 注意：  0是标准输入、1是标准输出、2是标准错误输出。 2和>之间可以有空格。

###Sehll 文件包含

Shell 可以包含外部脚本，这样可以很方便的封装一些公用的代码作为一个独立的文件。



sehll文件包含的语法格式如下：

``` bash
. filename # 注意⚠️： （.）和文件名之间有空格。

# 或者：

source filename

```
