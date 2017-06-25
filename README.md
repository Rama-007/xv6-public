# xv6-public
Better and more functional xv6 implementation . This is a testing repo where I try add more features and functionality to xv6.
The new call will be int waitx(int *wtime, int *rtime). The two arguments are pointers to integers to which waitx will assign the total number of clock ticks during which process was waiting and total number of clock ticks when the process was running. The return values for waitx should be same as that of wait system-call.
