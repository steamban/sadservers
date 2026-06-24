Scenario: "Lhasa": Easy Math

Level: Easy

Type: Do

Tags: bash  

Access: Email

Description: There's a file /home/admin/scores.txt with two columns (the first number is a line number and the second one is a test score for example).

Find the average (more precisely; the arithmetic mean: sum of numbers divided by how many numbers are there) of the numbers in the second column (find the average score).

Use exactly two digits to the right of the decimal point. i. e., use exactly two "decimal digits" without any rounding. E.g.: if average = 21.349 , the solution is 21.34. If average = 33.1 , the solution is 33.10.

Save the solution in the /home/admin/solution file, for example: echo "123.45" > ~/solution

Tip: There's bc, Python3, Golang and sqlite3 installed in this VM.

Root (sudo) Access: False

Test: md5sum /home/admin/solution returns 6d4832eb963012f6d8a71a60fac77168 solution

Time to Solve: 15 minutes.
