Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799E34A822
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCZNcN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 09:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhCZNcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 09:32:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAB3C0613AA;
        Fri, 26 Mar 2021 06:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=+G7xhqZIogjE5B+cBFT2l8M5NjZzGtGfGiHV0te9vOI=; b=d0/ipG4pmFjEnE+dCec0de4FsE
        9Vc7oBnfn6Cd6LUIXikZN9YSNv5vCLgAfpWbWXQrXPpClYeMhgnma8vwjUzHRRby4Ax7Wrpde0PEV
        s378eqXYHwC3zj1qFVqC6WI4/x0aot+2z/yUvuh3q1mENtBZjTpP1x3i13u8GTABAOTlxQ5xNcIjk
        XP+drfrUeqT2w6HBprw089GSM55e45KzPwpvyED+/YAA3m3jx5y4wGswueJbtld9rby65t7G472T/
        3NkVKfdncPUPPKry3mZJJIuf1njERGbBzfueIQtwc0MmkqYJr0W8YDEo5Ivz2b36ac6m60dAUwIp+
        0uHw6SON8OtolqrAHvNR+S1KrmqX+IvogMM75kUHRYa8W1gCOHWb1k4vqIbbmnQOl5rQYRsdLkhbH
        FUXFr3AXiXiBe35e0aaAxDAgWAzFi+NC6GohlG/7DU8VHaLNsqteIxRDIukpw0pGu9E8Wsl1vxt0J
        ghhWu3/xOhwL7ympFFg3EbG9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPmZF-0002dN-FP; Fri, 26 Mar 2021 13:32:01 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
Date:   Fri, 26 Mar 2021 14:31:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 13:56 schrieb Jens Axboe:
> On 3/26/21 5:48 AM, Stefan Metzmacher wrote:
>>
>> Am 26.03.21 um 01:39 schrieb Jens Axboe:
>>> Hi,
>>>
>>> As discussed in a previous thread today, the seemingly much saner approach
>>> is just to allow signals (including SIGSTOP) for the PF_IO_WORKER IO
>>> threads. If we just have the threads call get_signal() for
>>> signal_pending(), then everything just falls out naturally with how
>>> we receive and handle signals.
>>>
>>> Patch 1 adds support for checking and calling get_signal() from the
>>> regular IO workers, the manager, and the SQPOLL thread. Patch 2 unblocks
>>> SIGSTOP from the default IO thread blocked mask, and the rest just revert
>>> special cases that were put in place for PF_IO_WORKER threads.
>>>
>>> With this done, only two special cases remain for PF_IO_WORKER, and they
>>> aren't related to signals so not part of this patchset. But both of them
>>> can go away as well now that we have "real" threads as IO workers, and
>>> then we'll have zero special cases for PF_IO_WORKER.
>>>
>>> This passes the usual regression testing, my other usual 24h run has been
>>> kicked off. But I wanted to send this out early.
>>>
>>> Thanks to Linus for the suggestion. As with most other good ideas, it's
>>> obvious once you hear it. The fact that we end up with _zero_ special
>>> cases with this is a clear sign that this is the right way to do it
>>> indeed. The fact that this series is 2/3rds revert further drives that
>>> point home. Also thanks to Eric for diligent review on the signal side
>>> of things for the past changes (and hopefully ditto on this series :-))
>>
>> Ok, I'm testing a8ff6a3b20bd16d071ef66824ae4428529d114f9 from
>> your io_uring-5.12 branch.
>>
>> And using this patch:
>> diff --git a/examples/io_uring-cp.c b/examples/io_uring-cp.c
>> index cc7a227a5ec7..6e26a4214015 100644
>> --- a/examples/io_uring-cp.c
>> +++ b/examples/io_uring-cp.c
>> @@ -116,13 +116,16 @@ static void queue_write(struct io_uring *ring, struct io_data *data)
>>         io_uring_submit(ring);
>>  }
>>
>> -static int copy_file(struct io_uring *ring, off_t insize)
>> +static int copy_file(struct io_uring *ring, off_t _insize)
>>  {
>> +       off_t insize = _insize;
>>         unsigned long reads, writes;
>>         struct io_uring_cqe *cqe;
>>         off_t write_left, offset;
>>         int ret;
>>
>> +again:
>> +       insize = _insize;
>>         write_left = insize;
>>         writes = reads = offset = 0;
>>
>> @@ -221,6 +224,12 @@ static int copy_file(struct io_uring *ring, off_t insize)
>>                 }
>>         }
>>
>> +       {
>> +               struct timespec ts = { .tv_nsec = 999999, };
>> +               nanosleep(&ts, NULL);
>> +               goto again;
>> +       }
>> +
>>         return 0;
>>  }
>>
>> Running ./io_uring-cp ~/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
>> What I see is this:
>>
>> kill -SIGSTOP to any thread I used a worker with pid 2061 here, results in
>>
>> root@ub1704-166:~# head /proc/2061/status
>> Name:   iou-wrk-2041
>> Umask:  0022
>> State:  R (running)
>> Tgid:   2041
>> Ngid:   0
>> Pid:    2061
>> PPid:   1857
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2041/status
>> Name:   io_uring-cp
>> Umask:  0022
>> State:  T (stopped)
>> Tgid:   2041
>> Ngid:   0
>> Pid:    2041
>> PPid:   1857
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2042/status
>> Name:   iou-mgr-2041
>> Umask:  0022
>> State:  T (stopped)
>> Tgid:   2041
>> Ngid:   0
>> Pid:    2042
>> PPid:   1857
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>>
>> So userspace and iou-mgr-2041 stop, but the workers don't.
>> 49 workers burn cpu as much as possible.
>>
>> kill -KILL 2061
>> results in this:
>> - all workers are gone
>> - iou-mgr-2041 is gone
>> - io_uring-cp waits in status D forever
>>
>> root@ub1704-166:~# head /proc/2041/status
>> Name:   io_uring-cp
>> Umask:  0022
>> State:  D (disk sleep)
>> Tgid:   2041
>> Ngid:   0
>> Pid:    2041
>> PPid:   1857
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# cat /proc/2041/stack
>> [<0>] io_wq_destroy_manager+0x36/0xa0
>> [<0>] io_wq_put_and_exit+0x2b/0x40
>> [<0>] io_uring_clean_tctx+0xc5/0x110
>> [<0>] __io_uring_files_cancel+0x336/0x4e0
>> [<0>] do_exit+0x16b/0x13b0
>> [<0>] do_group_exit+0x8b/0x140
>> [<0>] get_signal+0x219/0xc90
>> [<0>] arch_do_signal_or_restart+0x1eb/0xeb0
>> [<0>] exit_to_user_mode_prepare+0x115/0x1a0
>> [<0>] syscall_exit_to_user_mode+0x27/0x50
>> [<0>] do_syscall_64+0x45/0x90
>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The 3rd problem is that gdb in a ubuntu 20.04 userspace vm hangs forever:
>>
>> root@ub1704-166:~/samba.git# LANG=C strace -o /dev/shm/strace.txt -f -ttT gdb --pid 2417
>> GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
>> Copyright (C) 2020 Free Software Foundation, Inc.
>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>> This is free software: you are free to change and redistribute it.
>> There is NO WARRANTY, to the extent permitted by law.
>> Type "show copying" and "show warranty" for details.
>> This GDB was configured as "x86_64-linux-gnu".
>> Type "show configuration" for configuration details.
>> For bug reporting instructions, please see:
>> <http://www.gnu.org/software/gdb/bugs/>.
>> Find the GDB manual and other documentation resources online at:
>>     <http://www.gnu.org/software/gdb/documentation/>.
>>
>> For help, type "help".
>> Type "apropos word" to search for commands related to "word".
>> Attaching to process 2417
>> [New LWP 2418]
>> [New LWP 2419]
>>
>> <here it hangs forever>
>>
>> The related parts of 'pstree -a -t -p':
>>
>>       ├─bash,2048
>>       │   └─io_uring-cp,2417 /root/kernel/sn-devel-184-builds/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
>>       │       ├─{iou-mgr-2417},2418
>>       │       └─{iou-wrk-2417},2419
>>       ├─bash,2167
>>       │   └─strace,2489 -o /dev/shm/strace.txt -f -ttT gdb --pid 2417
>>       │       └─gdb,2492 --pid 2417
>>       │           └─gdb,2494 --pid 2417
>>
>> root@ub1704-166:~# cat /proc/sys/kernel/yama/ptrace_scope
>> 0
>>
>> root@ub1704-166:~# head /proc/2417/status
>> Name:   io_uring-cp
>> Umask:  0022
>> State:  t (tracing stop)
>> Tgid:   2417
>> Ngid:   0
>> Pid:    2417
>> PPid:   2048
>> TracerPid:      2492
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2418/status
>> Name:   iou-mgr-2417
>> Umask:  0022
>> State:  t (tracing stop)
>> Tgid:   2417
>> Ngid:   0
>> Pid:    2418
>> PPid:   2048
>> TracerPid:      2492
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2419/status
>> Name:   iou-wrk-2417
>> Umask:  0022
>> State:  R (running)
>> Tgid:   2417
>> Ngid:   0
>> Pid:    2419
>> PPid:   2048
>> TracerPid:      2492
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2492/status
>> Name:   gdb
>> Umask:  0022
>> State:  S (sleeping)
>> Tgid:   2492
>> Ngid:   0
>> Pid:    2492
>> PPid:   2489
>> TracerPid:      2489
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> root@ub1704-166:~# head /proc/2494/status
>> Name:   gdb
>> Umask:  0022
>> State:  t (tracing stop)
>> Tgid:   2494
>> Ngid:   0
>> Pid:    2494
>> PPid:   2492
>> TracerPid:      2489
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>>
>>
>> Maybe these are related and 2494 gets the SIGSTOP that was supposed to
>> be handled by 2419.
>>
>> strace.txt is attached.
>>
>> Just a wild guess (I don't have time to test this), but maybe this
>> will fix it:
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 07e7d61524c7..ee5a402450db 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -503,8 +503,7 @@ static int io_wqe_worker(void *data)
>>                 if (io_flush_signals())
>>                         continue;
>>                 ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>> -               if (try_to_freeze() || ret)
>> -                       continue;
>> +               try_to_freeze();
>>                 if (signal_pending(current)) {
>>                         struct ksignal ksig;
>>
>> @@ -514,8 +513,7 @@ static int io_wqe_worker(void *data)
>>                         continue;
>>                 }
>>                 /* timed out, exit unless we're the fixed worker */
>> -               if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
>> -                   !(worker->flags & IO_WORKER_F_FIXED))
>> +               if (ret == 0 && !(worker->flags & IO_WORKER_F_FIXED))
>>                         break;
>>         }
>>
>> When the worker got a signal I guess ret is not 0 and we'll
>> never hit the if (signal_pending()) statement...
> 
> Right, the logic was a bit wrong there, and we can also just drop
> try_to_freeze() from all of them now, we don't have to special
> case that anymore.

I tested my version and it fixes the SIGSTOP problem, I guess your
branch will also fix it.

So the looping workers are gone and doesn't hang anymore.

But gdb still shows very strange things, with a 5.10 kernel I see this:

root@ub1704-166:~# LANG=C gdb --pid 1274
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word".
Attaching to process 1274
Reading symbols from /root/liburing/examples/io_uring-cp...
Reading symbols from /lib/x86_64-linux-gnu/libc.so.6...
Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/libc-2.31.so...
Reading symbols from /lib64/ld-linux-x86-64.so.2...
Reading symbols from /usr/lib/debug//lib/x86_64-linux-gnu/ld-2.31.so...
syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
38      ../sysdeps/unix/sysv/linux/x86_64/syscall.S: No such file or directory.
(gdb)


And now:

root@ub1704-166:~# LANG=C gdb --pid 1320
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word".
Attaching to process 1320
[New LWP 1321]
[New LWP 1322]

warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

warning: Architecture rejected target-supplied description
syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
38      ../sysdeps/unix/sysv/linux/x86_64/syscall.S: No such file or directory.
(gdb)

pstree -a -t -p looks like this:

      │   └─io_uring-cp,1320 /root/kernel/sn-devel-184-builds/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
      │       ├─{iou-mgr-1320},1321
      │       └─{iou-wrk-1320},1322

I'm wondering why there's the architecture related stuff...

> Can you try the current branch? I folded in fixes for that.
> That will definitely fix case 1+3, the #2 with kill -KILL is kind
> of puzzling. I'll try and reproduce that with the current tree and see
> what happens. But that feels like it's either not a new thing, or it's
> the same core issue as 1+3 (though I don't quite see how, unless the
> failure to catch the signal will elude get_signal() forever in the
> worker, I guess that's possible).

The KILL after STOP deadlock still exists.

Does io_wq_manager() exits without cleaning up on SIGKILL?

metze

