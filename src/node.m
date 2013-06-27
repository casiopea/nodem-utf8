node() ;;
 ;
 ; patched node.m for UTF-8, Javascript like escape() encode and unescape() decode Version
 ; Written by Kiyoshi Sawada <casiopea.tpine@gmail.com>
 ; Copyright (c) 2013 Japan DynaSystems Inc.
 ; 
 ; 
 ; 
 ; Original node.m Written by David Wicksell <dlw@linux.com>
 ; https://github.com/dlwicksell/nodem/blob/master/src/node.m
 ; Copyright (c) 2012,2013 Fourth Watch Software, LC
 ; 
 ; This program is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU Affero General Public License (AGPL)
 ; as published by the Free Software Foundation, either version 3 of
 ; the License, or (at your option) any later version.
 ; 
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 ; GNU Affero General Public License for more details.
 ;
 ; You should have received a copy of the GNU Affero General Public License
 ; along with this program. If not, see http://www.gnu.org/licenses/.
 ;
 ;
 quit:$q "Call an API entry point" w "Call an API entry point" quit
 ;
 ;
parse:(subs) ;parse an argument list or list of subscripts
 n i,num,sub,temp,tmp
 ;
 s (temp,tmp)=""
 ;
 i '$d(subs)#10 s subs=""
 i subs'="" d
 . f  q:subs=""  d
 . . s num=+subs,$e(subs,1,$l(num)+1)=""
 . . s sub=$e(subs,1,num)
 . . i sub["""" d
 . . . f i=1:1:$l(sub) d
 . . . . i $e(sub,i)="""" s tmp=tmp_""""_$e(sub,i)
 . . . . e  s tmp=tmp_$e(sub,i)
 . . . ;
 . . . s sub=tmp
 . . s sub=$$unescape(sub)   ;;  already escaped from MUMPS.NODE, escap() by Javascript function
 . . i (sub'=+sub&($e(sub,1,2)'="0."))!($e(sub)=".") s sub=""""_sub_""","
 . . e  s sub=sub_","
 . . ;
 . . s temp=temp_sub,$e(subs,1,num+1)=""
 s subs=temp
 s subs=$e(subs,1,$l(subs)-1)
 ;
 quit subs
 ;
 ;
construct:(glvn,subs) ;construct a global reference
 n globalname,subscripts
 ;
 s subscripts=$$parse(.subs)
 s globalname="^"_glvn_$s(subscripts'="":"("_subscripts_")",1:"")
 ;
 quit globalname
 ;
 ;
escapeORG:(data) ;escape quotes or ctrl chars within a string in mumps
 n i,charh,charl,ndata
 ;
 s ndata=""
 f i=1:1:$l(data) d
 . i $e(data,i)=""""!($e(data,i)="\") s ndata=ndata_"\"_$e(data,i)
 . e  i $e(data,i)?1c d
 . . s charh=$a($e(data,i))\16,charh=$e("0123456789abcdef",charh+1)
 . . s charl=$a($e(data,i))#16,charl=$e("0123456789abcdef",charl+1)
 . . s ndata=ndata_"\u00"_charh_charl
 . e  s ndata=ndata_$e(data,i)
 ;
 quit ndata
 ;
 ;
version() ;return the version string
 quit "Node.js Adaptor for GT.M: Version: 0.2.1.a (FWSLC) for UTF-8; "_$zv
 ;
zchset() ;  $ZCHSET can have only two values --"M", or "UTF-8".
 quit $ZCHSET
 ;
set(glvn,subs,data) ;set a global node
 n globalname,ok,result,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 s @globalname=$$unescape(data)  ;;  already escaped from MUMPS.NODE, escap()
 ;
 s ok=1,result=0
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""result"": "_result_"}"
 ;
 quit return
 ;
 ;
get(glvn,subs) ;get one node of a global
 n data,defined,globalname,ok,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 ;
 s data=$g(@globalname)
 ;; s:data[""""!(data["\")!(data?.e1c.e) data=$$escape(data)
 s data=$$escape(data)  ;;  Force escaped to MUMPS.NODE
 ;
 i (data'=+data&($e(data,1,2)'="0."))!($e(data)=".") s data=""""_data_""""
 ;
 s defined=$d(@globalname)#10
 s ok=1
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""data"": "_data_", ""defined"": "_defined_"}"
 ;
 quit return
 ;
 ;
kill(glvn,subs) ;kill a global or global node
 n globalname,ok,result,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 k @globalname
 ;
 s ok=1,result=0
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""result"": "_result_"}"
 ;
 quit return
 ;
 ;
data(glvn,subs) ;find out if global node has data or children
 n globalname,defined,ok,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 s defined=$d(@globalname)
 ;
 s ok=1
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""defined"": "_defined_"}"
 ;
 quit return
 ;
 ;
order(glvn,subs,order) ;return the next global node at the same level
 n globalname,defined,ok,result,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 ;
 i $g(order)=-1 s result=$o(@globalname,-1)
 e  s result=$o(@globalname)
 ;
 ;;; s:result[""""!(result["\")!(result?.e1c.e) result=$$escape(result)
 ;
 i $e(result)="^" s $e(result)=""
 i (result'=+result&($e(result,1,2)'="0."))!($e(result)=".") d
 . s result=""""_result_""""
 s result=$$escape(result)  ;;  Force escaped to MUMPS.NODE
 ;
 s ok=1
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""result"": "_result_"}"
 ;
 quit return
 ;
 ;
previous(glvn,subs) ;same as order, only in reverse
 i '$d(subs)#10 s subs=""
 ;
 quit $$order(glvn,subs,-1)
 ;
 ;
nextNode(glvn,subs) ;
 quit "{""status"": ""next_node not yet implemented""}"
 ;
 ;
previousNode(glvn,subs) ;
 quit "{""status"": ""previous_node not yet implemented""}"
 ;
 ;
increment(glvn,subs,incr) ;increment the number in a global node
 n globalname,increment,ok,return
 ;
 i '$d(subs)#10 s subs=""
 ;
 s globalname=$$construct(glvn,subs)
 s increment=$i(@globalname,$g(incr,1))
 ;
 s ok=1
 ;
 s return="{""ok"": "_ok_", ""global"": """_glvn_""","
 s return=return_" ""data"": "_increment_"}"
 ;
 quit return
 ;
 ;
merge() ;
 quit "{""status"": ""merge not yet implemented""}"
 ;
 ;
globalDirectory(max,lo,hi) ;
 n flag,cnt,global,return
 ;
 i '$d(max)#10 s max=0
 ;
 s cnt=1,flag=0
 ;
 i $g(lo)'="" s global="^"_lo
 e  s global="^%"
 ;
 i $g(hi)="" s hi=""
 e  s hi="^"_hi
 ;
 s return="[" 
 ;
 i $d(@global) d
 . s return=return_""""_$e(global,2,$l(global))_""", "
 . i max=1 s flag=1 q
 . s:max>1 max=max-1
 ;
 f  s global=$o(@global) q:flag!(global="")!(global]]hi&(hi]""))  d
 . s return=return_""""_$e(global,2,$l(global))_""", "
 . i max>0 s cnt=cnt+1 s:cnt>max flag=1
 ;
 s:$l(return)>2 return=$e(return,1,$l(return)-2)
 s return=return_"]"
 ;
 quit return
 ;
 ;
lock() ;
 quit "{""status"": ""lock not yet implemented""}"
 ;
 ;
unlock() ;
 quit "{""status"": ""unlock not yet implemented""}"
 ;
 ;
function(func,args) ;call an arbitrary extrinsic function
 n dev,function,ok,result,return
 ;
 i '$d(args)#10 s args=""
 s:args'="" args=$$parse(args)
 ;
 s function=func_$s(args'="":"("_args_")",1:"")
 x "s result=$$"_function
 ;
 ;;s:result[""""!(result["\")!(result?.e1c.e) result=$$escape(result)
 s result=$$escape(result)
 ;
 i (result'=+result&($e(result,1,2)'="0."))!($e(result)=".") d
 . s result=""""_result_""""
 ;
 s ok=1
 ;
 s return="{""ok"": "_ok_", ""function"": """_func_""","
 i $g(args)'="" s return=return_" ""arguments"": ["_args_"],"
 s return=return_" ""result"": "_result_"}"
 ;
 quit return
 ;
 ;
retrieve() ;
 quit "{""status"": ""retrieve not yet implemented""}"
 ;
 ;
update() ;
 quit "{""status"": ""update not yet implemented""}"
 ;
 ;
	;
	; URL encode and decode, escape and unescape utility 2013/06/25 17:37 K.S
	q
urlEscape(string)	q $$escape(string)   ; wapper escape fumction
escape(string)	;
	i string?1AN.AN QUIT string
	n esc,i,pass,c
	f i=33,36,39,40,41,42,45,46,47,95,96 s pass(i)=""
	s esc=""
	f i=1:1:$l(string) d  s esc=esc_c
	. s c=$e(string,i)
	. i $d(pass($za(c,1))) q
	. s c=$$code2unicode(c)
	QUIT esc
code2unicode(utf)	;
	; Function to convert UNICODE number input UTF-8 a string  2013/06/25 17:37 K.Sawada
	; input para: utf : a UTF-8 string
	n k
	f k=1:1:$zl(utf) s k(k)=$za(utf,k)
	i (k(1)'<0)&(k(1)'>127)   QUIT $s(utf?1AN:utf,1:"%"_$$hex(k(1)))
	i (k(1)'<192)&(k(1)'>223) QUIT "%u"_$$hex(((k(1)-192)*64)+(k(2)-128))
	i (k(1)'<224)&(k(1)'>239) QUIT "%u"_$$hex(((k(1)-224)*4096)+((k(2)-128)*64)+(k(3)-128))
	i (k(1)'<240)&(k(1)'>247) QUIT "%u"_$$hex(((k(1)-240)*262144)+((k(2)-128)*4096)+((k(3)-128)*64)+(k(4)-128))
	QUIT ""
urlUnescape(esc)	q $$unescape(esc)   ; wapper unescape fumction
unescape(esc)	;
	; Function converts form a JavaScript escaped string to a string with ASCII & UTF-8 charset
	; Input : esc : string source escaped with Javascript's escape() function
	; return strings with ASCII & UTF-8
	; K.Sawada 2012/05/14 18:43
	;
	i esc'["%" QUIT esc
	n c,string,pos,length
	n unicodeHexVal,unicode,hex,hexVal
	s string="",pos=1
	s length=$l(esc)
	f  q:pos>length  d
	. s c=$e(esc,pos)
	. i c="%" d
	. . s pos=pos+1
	. . s c=$e(esc,pos)
	. . i c="u" d
	. . . ;  a unicode character
	. . . s pos=pos+1
	. . . s unicodeHexVal=$e(esc,pos,pos+3)
	. . . s unicode=$$hexToDecimal(unicodeHexVal)
	. . . s string=string_$$code2utf(unicode)
	. . . s pos=pos+4
	. . e  d
	. . . ; an escaped ascii character
	. . . s hexVal=$e(esc,pos,pos+1)
	. . . s hex=$$hexToDecimal(hexVal)
	. . . s string=string_$c(hex)
	. . . s pos=pos+2
	. e  d
	. . s string=string_c
	. . s pos=pos+1
	QUIT string
	;
code2utf(num)	;
	; Function to convert UTF-8 character input num that number  2012/05/09 09:51 K.Sawada
	; input para: num : integer
	; return    : utf8char
	i num<128     QUIT $c(num)
	i num<2048    QUIT $ZCHAR(num\64+192,num#64+128)
	i num<65536   QUIT $ZCHAR(num\4096+224,(num\64)#64+128,num#64+128)
	i num<2097152 QUIT $ZCHAR(num\262144+240,(num\4096)#64+128,(num\64)#64+128,num#64+128)
	QUIT ""
	;----------------------------------------------------------------------------------
hex(number)	;
	n hex,no,str
	s hex="",str="123456789ABCDEF"
	f  d  q:number=0
	. s no=number#16,number=number\16
	. i no s no=$e(str,no)
	. s hex=no_hex
	QUIT hex
	;
hexDecode(hex)	QUIT $f("0123456789ABCDEF",hex)-2
hexToDecimal(hex)	;
	n i,num
	s num=0 f i=1:1:$l(hex) s num=num*16+$$hexDecode($e(hex,i))
	QUIT num
	;
