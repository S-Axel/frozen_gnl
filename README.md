# frozen_gnl


### Tests for get_next_line project.

This shell script helps you test your get_next_line project.
- It does not test the bonus
- It does not test the leaks
- It tests the standard input with `-stdin` option (see below)
- It does many tests with different short files
- It tests many different sizes of buffer
- Use `-description` to see a description of each test (see below)



#### How To Test
just launch `./freeze.sh` and enjoy :-)


`./freeze.sh -description`
list and describe all tests

`./freeze.sh -description 05`
describe only test 05

`./freeze.sh -test 23`
launch test 23 only

`./freeze.sh -debug 06`
launch test 06 with lldb

`./freeze.sh -stdin`
test your gnl with standard input

You can also test your get_next_line like this:

```
echo -ne "2\nHello World\n\n\nGood luck" | ./freeze.sh -stdin
1|Hello World'
1|
1|
0|Good luck
```

Where `2\n` sets a buffer size of 2 and `Hello World\n\n\nGood luck` is read by your gnl through standard input.

 
 
