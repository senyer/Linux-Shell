## cat命令

> cat命令用于连接文件并打印到标准输出设备上。
>
> 语法格式： cat [-AbeEnstTuv]  [--help ]  [ --version ] fileName

参数说明：

-**-n 或 --number**：由 1 开始对所有输出的行数编号。

**-b 或 --number-nonblank**：和 -n 相似，只不过对于空白行不编号。

**-s 或 --squeeze-blank**：当遇到有连续两行以上的空白行，就代换为一行的空白行。

**-v 或 --show-nonprinting**：使用 ^ 和 M- 符号，除了 LFD 和 TAB 之外。

**-E 或 --show-ends** : 在每行结束处显示 $。

**-T 或 --show-tabs**: 将 TAB 字符显示为 ^I。

**-A, --show-all**：等价于 -vET。

**-e：**等价于"-vE"选项；

**-t：**等价于"-vT"选项；



例子：

> 将文本的文档内容加上行号输入到另一个文本
>
> cat -n textfile1 > textfile2



## chmod命令

linux/unix 的文件调用权限分为三级：文件拥有者、群组、其他。chmod可以控制文件如何被他人所使用。

> chmod [ -cfvR ] [ --help ] [ --version ] mode file

参数说明：

Mode:权限字符串，格式如下：

> [ ugoa... ] [[ +== ] [rwxX] ...]

* u 表示文件拥有者，g表示与该文件的拥有者属于同一个群组，o表示其他意外的人。a表示这三者都是。
* +表示增加权限，-表示取下权限，=表示唯一设定权限
* r：表示读取、w表示写入、x表示可执行、X表示只有当该文件是子目录或者该文件已经被设定过可执行。

例子：

> chmod ugo+r file.txt  	# 所有人都可以读取

>chmod a+r file.txt		# 所有人都可以读取

>Chmod 777 file.txt	

chmod可以用数字表示权限。

> 语法： chmod abc file

**a、b、c、各位一个数字。分别表示user、group、以及other的权限：**

r=4，w=2，x=1

* 若需要rwx属性，则4+2+1=7。表示有所有权限
* 若需要rw-属性，则4+2=6。 表示可读可写不可执行
* 若需要r-x属性，则4+1=5    表示 可以读可执行不可写

