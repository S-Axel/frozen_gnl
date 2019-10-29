# frozen_gnl


### Tests for get_next_line project.

#### --Work In Progress--
These tests will improve as I progress on the get_next_line project.

You can expect regular updates.

To give me feedbacks, ask questions or come work with me on gnl: I am on slack, my login is asabotie


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
Your get_next_line returned '1' with the following line: 'Hello World'
Your get_next_line returned '1' with the following line: ''
Your get_next_line returned '1' with the following line: ''
Your get_next_line returned '1' with the following line: 'Good luck'
get_next_line return value: 0
```

Where `2\n` sets a buffer size of 2 and `Hello World\n\n\nGood luck` is read by your gnl through standard input.

 
 
