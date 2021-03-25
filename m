Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20A349BCC
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 22:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCYVou (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 17:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhCYVoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 17:44:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CB5C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 14:44:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id l3so3404165pfc.7
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 14:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J/IaPDWlyESPBjuEFjvieEnFpJiImUCs8aDCvk5o8PQ=;
        b=L/C9NLOeQ2l5FZ0u4/4VhunOoS4k/oStnVH9K/855kJYoapep6I0g5UR8D+VRegpdt
         DpuQZeDzSGpivq/6+xhi93Of0bYWtSO/0EWbodikfDmSprLAHDgSPktTQ9qGalcHWiJb
         jaC1EQrLmzlYCnaFvXOMv+gRPBKiqrzz1f6pLv7pKcs9G7Spd8ClTPrigMz7upJTQFPc
         Gpl6TNYwQO1IH3hztybaQ27txI3FZjz2FzIEiLZnGzjFh8geuyuZGxhmgA9F88lx2krq
         dYhhGOTq5KPFBOIccmI2/Kyvsbi+XiX4ov5LYVcMHKFMwSn+wFavhU1e8kZuZT+gr7YP
         btkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J/IaPDWlyESPBjuEFjvieEnFpJiImUCs8aDCvk5o8PQ=;
        b=tjnHczY1lHw9AvLdE2WNKds+fibDuVOTE/+hfPk4yHNCcLSJmb4Divf/rvmlvMuDwF
         hCbtKHJxq1KuanW7+PDKvyGBfCQxSsJdgPTJoQYQOZaDpVYgU93iKa/jbZSknHolEYZh
         gaRzfWpWQyJvHQLd0cQSbO0UPLS6Q1anKmD8HT+q7V6JKB4/zkLQGKXJLz7/Mhx2Zalh
         8q+XM+V1yiufPfFdj+oXe21st+AOt8Omb6R0rzwo92q2QbbrMhvZx4GaoTXCBh+aNxOo
         KsGVS8PBSoojKRs4Lf5V5Qb/HMnf32trlmCpGDaOOw5gwfQqFHCQuMju3oEJR0j0hBjU
         ai/w==
X-Gm-Message-State: AOAM531cdIP3BpX+6k6xqONTYejUIHKOolv1fT9oOUXe1aHG3GfQQFaj
        lodwqy5pPctVn1xLqvUzIx+U8A==
X-Google-Smtp-Source: ABdhPJyjR3Khh6xoFGMAl9gDuU2mVXTbqmKEFb7RFPctOhkXnBij9eaTDNdSIhPolZ/ZMvX/vd23Pg==
X-Received: by 2002:a17:902:708b:b029:e6:77ca:3cb6 with SMTP id z11-20020a170902708bb02900e677ca3cb6mr12027570plk.84.1616708665154;
        Thu, 25 Mar 2021 14:44:25 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mp19sm10220294pjb.2.2021.03.25.14.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 14:44:24 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <ad21da2b-01ea-e77c-70b2-0401059e322b@kernel.dk>
Message-ID: <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
Date:   Thu, 25 Mar 2021 15:44:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ad21da2b-01ea-e77c-70b2-0401059e322b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 2:40 PM, Jens Axboe wrote:
> On 3/25/21 2:12 PM, Linus Torvalds wrote:
>> On Thu, Mar 25, 2021 at 12:42 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> I don't know what the gdb logic is, but maybe there's some other
>>>> option that makes gdb not react to them?
>>>
>>> .. maybe we could have a different name for them under the task/
>>> subdirectory, for example (not  just the pid)? Although that probably
>>> messes up 'ps' too..
>>
>> Actually, maybe the right model is to simply make all the io threads
>> take signals, and get rid of all the special cases.
>>
>> Sure, the signals will never be delivered to user space, but if we
>>
>>  - just made the thread loop do "get_signal()" when there are pending signals
>>
>>  - allowed ptrace_attach on them
>>
>> they'd look pretty much like regular threads that just never do the
>> user-space part of signal handling.
>>
>> The whole "signals are very special for IO threads" thing has caused
>> so many problems, that maybe the solution is simply to _not_ make them
>> special?
> 
> Just to wrap up the previous one, yes it broke all sorts of things to
> make the 'tid' directory different. They just end up being hidden anyway
> through that, for both ps and top.
> 
> Yes, I do think that maybe it's better to just embrace maybe just
> embrace the signals, and have everything just work by default. It's
> better than continually trying to make the threads special. I'll see
> if there are some demons lurking down that path.

In the spirit of "let's just try it", I ran with the below patch. With
that, I can gdb attach just fine to a test case that creates an io_uring
and a regular thread with pthread_create(). The regular thread uses
the ring, so you end up with two iou-mgr threads. Attach:

[root@archlinux ~]# gdb -p 360
[snip gdb noise]
Attaching to process 360
[New LWP 361]
[New LWP 362]
[New LWP 363]

warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

warning: Architecture rejected target-supplied description
Error while reading shared library symbols for /usr/lib/libpthread.so.0:
Cannot find user-level thread for LWP 363: generic error
0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
(gdb) info threads
  Id   Target Id             Frame 
* 1    LWP 360 "io_uring"    0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 ()
   from /usr/lib/libc.so.6
  2    LWP 361 "iou-mgr-360" 0x0000000000000000 in ?? ()
  3    LWP 362 "io_uring"    0x00007f7aa52a0a9d in syscall () from /usr/lib/libc.so.6
  4    LWP 363 "iou-mgr-362" 0x0000000000000000 in ?? ()
(gdb) thread 2
[Switching to thread 2 (LWP 361)]
#0  0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0
(gdb) cont
Continuing.
^C
Thread 1 "io_uring" received signal SIGINT, Interrupt.
[Switching to LWP 360]
0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
(gdb) q
A debugging session is active.

	Inferior 1 [process 360] will be detached.

Quit anyway? (y or n) y
Detaching from program: /root/git/fio/t/io_uring, process 360
[Inferior 1 (process 360) detached]

The iou-mgr-x threads are stopped just fine, gdb obviously can't get any
real info out of them. But it works... Regular test cases work fine too,
just a sanity check. Didn't expect them not to.

Only thing that I dislike a bit, but I guess that's just a Linuxism, is
that if can now kill an io_uring owning task by sending a signal to one
of its IO thread workers.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index b7c1fa932cb3..2dbdc552f3ba 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -505,8 +505,14 @@ static int io_wqe_worker(void *data)
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (try_to_freeze() || ret)
 			continue;
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			get_signal(&ksig);
+			continue;
+		}
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 		    !(worker->flags & IO_WORKER_F_FIXED))
@@ -715,8 +721,15 @@ static int io_wq_manager(void *data)
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
 		try_to_freeze();
-		if (fatal_signal_pending(current))
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				set_bit(IO_WQ_BIT_EXIT, &wq->state);
+			else
+				get_signal(&ksig);
+			continue;
+		}
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54ea561db4a5..3a9d021db328 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6765,8 +6765,14 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			get_signal(&ksig);
+			continue;
+		}
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
diff --git a/kernel/fork.c b/kernel/fork.c
index d3171e8e88e5..3b45d0f04044 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2436,6 +2436,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 	if (!IS_ERR(tsk)) {
 		sigfillset(&tsk->blocked);
 		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
+		sigdelsetmask(&tsk->blocked, sigmask(SIGSTOP));
 	}
 	return tsk;
 }
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 821cf1723814..61db50f7ca86 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -375,7 +375,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER)))
+	if (unlikely(task->flags & PF_KTHREAD))
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
diff --git a/kernel/signal.c b/kernel/signal.c
index f2a1b898da29..a5700557eb50 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -91,7 +91,7 @@ static bool sig_task_ignored(struct task_struct *t, int sig, bool force)
 		return true;
 
 	/* Only allow kernel generated signals to this kthread */
-	if (unlikely((t->flags & (PF_KTHREAD | PF_IO_WORKER)) &&
+	if (unlikely((t->flags & PF_KTHREAD) &&
 		     (handler == SIG_KTHREAD_KERNEL) && !force))
 		return true;
 
@@ -288,8 +288,7 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
 			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
 	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
 
-	if (unlikely(fatal_signal_pending(task) ||
-		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
+	if (unlikely(fatal_signal_pending(task) || task->flags & PF_EXITING))
 		return false;
 
 	if (mask & JOBCTL_STOP_SIGMASK)
@@ -834,9 +833,6 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
-	/* PF_IO_WORKER threads don't take any signals */
-	if (t->flags & PF_IO_WORKER)
-		return -ESRCH;
 
 	if (!si_fromuser(info))
 		return 0;

-- 
Jens Axboe

