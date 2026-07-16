Scenario: "Tokamachi": Troubleshooting a Named Pipe

Level: Easy

Description: There's a process reading from the named pipe /home/admin/namedpipe.

If you run this command that writes to that pipe:

/bin/bash -c 'while true; do echo "this is a test message being sent to the pipe" > /home/admin/namedpipe; done' &

And check the reader log with tail -f reader.log

You'll see that after a minute or so it works for a while (the reader receives some messages) and then it stops working (no more received messages are printed to the reader log or it takes a long time to process one). Troubleshoot and fix (for example changing the writer command) so that the writer keeps sending the messages and the reader is able to read all of them.

Test: There should be a process running where a message is being sent to the pipe and that while that is running, another message can be sent to the pipe and read back.
The "Check My Solution" button runs the script /home/admin/agent/check.sh, which you can see and execute.

Time to Solve: 15 minutes.

OS: Debian 11

Root (sudo) Access: No
