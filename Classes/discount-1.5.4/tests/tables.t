./echo "tables"

rc=0
MARKDOWN_FLAGS=

try() {
    unset FLAGS
    case "$1" in
    -*) FLAGS=$1
	shift ;;
    esac
    
    ./echo -n "  $1" '..................................' | ./cols 36

    Q=`./echo "$2" | ./markdown $FLAGS`

    if [ "$3" = "$Q" ]; then
	./echo " ok"
    else
	./echo " FAILED"
	./echo "wanted: $3"
	./echo "got   : $Q"
	rc=1
    fi
}


try 'single-column table' \
    '|hello
|-----
|sailor' \
    '<table>
<thead>
<tr>
<th></th>
<th>hello</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>sailor</td>
</tr>
</tbody>
</table>'


try 'two-column table' \
    '
  a  |  b
-----|------
hello|sailor' \
    '<table>
<thead>
<tr>
<th>  a  </th>
<th>  b</th>
</tr>
</thead>
<tbody>
<tr>
<td>hello</td>
<td>sailor</td>
</tr>
</tbody>
</table>'

try 'three-column table' \
'a|b|c
-|-|-
hello||sailor'\
    '<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
<th>c</th>
</tr>
</thead>
<tbody>
<tr>
<td>hello</td>
<td></td>
<td>sailor</td>
</tr>
</tbody>
</table>'

try 'two-column table with empty cells' \
    '
  a  |  b
-----|------
hello|
     |sailor' \
    '<table>
<thead>
<tr>
<th>  a  </th>
<th>  b</th>
</tr>
</thead>
<tbody>
<tr>
<td>hello</td>
<td></td>
</tr>
<tr>
<td>     </td>
<td>sailor</td>
</tr>
</tbody>
</table>'

try 'two-column table with alignment' \
    '
  a  |  b
----:|:-----
hello|sailor' \
    '<table>
<thead>
<tr>
<th align="right">  a  </th>
<th align="left">  b</th>
</tr>
</thead>
<tbody>
<tr>
<td align="right">hello</td>
<td align="left">sailor</td>
</tr>
</tbody>
</table>'
    
try 'table with extra data column' \
    '
  a  |  b
-----|------
hello|sailor|boy' \
    '<table>
<thead>
<tr>
<th>  a  </th>
<th>  b</th>
</tr>
</thead>
<tbody>
<tr>
<td>hello</td>
<td>sailor|boy</td>
</tr>
</tbody>
</table>'


try -fnotables 'tables with -fnotables' \
    'a|b
-|-
hello|sailor' \
    '<p>a|b
&ndash;|&ndash;
hello|sailor</p>'


exit $rc
