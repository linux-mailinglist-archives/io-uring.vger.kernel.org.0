Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8434A7A4
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 13:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCZM4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 08:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhCZM4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 08:56:40 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD67AC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 05:56:40 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q5so4805221pfh.10
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 05:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X6EPhiRK/taHgjtaZtE0YztThvh8WuxOW6r0o0MhRwk=;
        b=agTGHZQmRcZ59AHBVncunatbuTPgGAIv/0EokDFl08b/10S1va/kw1sHlFdKY4xhD/
         Tl1YFGrmyAJ+5+y0vcm+FJt4i9+c8/S8siHsNyD860NGgwX4nF2OjvfPq8USMEDqTMPS
         hYJjE+b5rEASVH59XzfnrLAQ2t4SGWNOS3GXWC218rb4hGkiwCdZFELqsqFXf2jKLKO4
         LwuKlUDdvS8YyBcoNXd8IipZUGFFKrXxFLeOXPokYy/p+to/4KSRiu7+eOEPgrM+kipV
         WmSnfiuRvREquUEf44t1T2HvQr9sPIggA+StwJ3pCvqiXYg349pAxGEoRNP/5wN2TrCa
         GKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X6EPhiRK/taHgjtaZtE0YztThvh8WuxOW6r0o0MhRwk=;
        b=C21JcttXPesPoaizxgj5xJeR86/4JPane5CJORoM9Nk8Tr9zqMNy56BraGI7A/2McK
         JW/30iWoyATNOkOJh4lwmujg5ZamWPLci7trbMN+OaXJgKlybxyqq4g9lXDRMe+7/ntF
         oIi1TDEzrWfgS55fGfAXfbcUwO+49CN7edW60cwWGyer/G5JCMc96n/wdplVmbYVoRvV
         dX0Y1LMFqxNA4H/iY7U7cjE02/dF328RtlfcnZcgO7FqA/sMqtJRO4MVLyFuO4YpvhIS
         mWEpGbshpE1D7b7703pMfLM7kcL6e4fY2g6OH28FBiW5OU1cVhnSrWKdEwtGmJfdzLTc
         XxAw==
X-Gm-Message-State: AOAM530YN9jNeABYN1w6ME5qzTekAZe2ys/5gIXwxlEn1It9s6wH9vW+
        EgTC4XGsnzfeSjED0+T9zpWYpw==
X-Google-Smtp-Source: ABdhPJztF4r1hTr6Flpius64ydNCPmb40k97Q0f/Sz62cICY+SVmubHm5qNTNzYRMA+Yvaqc+MJxQA==
X-Received: by 2002:a63:770e:: with SMTP id s14mr11616586pgc.377.1616763400240;
        Fri, 26 Mar 2021 05:56:40 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a204sm9018159pfd.106.2021.03.26.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 05:56:39 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
Date:   Fri, 26 Mar 2021 06:56:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e6de934a-a794-f173-088d-a140d0645188@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 5:48 AM, Stefan Metzmacher wrote:
> 
> Am 26.03.21 um 01:39 schrieb Jens Axboe:
>> Hi,
>>
>> As discussed in a previous thread today, the seemingly much saner approach
>> is just to allow signals (including SIGSTOP) for the PF_IO_WORKER IO
>> threads. If we just have the threads call get_signal() for
>> signal_pending(), then everything just falls out naturally with how
>> we receive and handle signals.
>>
>> Patch 1 adds support for checking and calling get_signal() from the
>> regular IO workers, the manager, and the SQPOLL thread. Patch 2 unblocks
>> SIGSTOP from the default IO thread blocked mask, and the rest just revert
>> special cases that were put in place for PF_IO_WORKER threads.
>>
>> With this done, only two special cases remain for PF_IO_WORKER, and they
>> aren't related to signals so not part of this patchset. But both of them
>> can go away as well now that we have "real" threads as IO workers, and
>> then we'll have zero special cases for PF_IO_WORKER.
>>
>> This passes the usual regression testing, my other usual 24h run has been
>> kicked off. But I wanted to send this out early.
>>
>> Thanks to Linus for the suggestion. As with most other good ideas, it's
>> obvious once you hear it. The fact that we end up with _zero_ special
>> cases with this is a clear sign that this is the right way to do it
>> indeed. The fact that this series is 2/3rds revert further drives that
>> point home. Also thanks to Eric for diligent review on the signal side
>> of things for the past changes (and hopefully ditto on this series :-))
> 
> Ok, I'm testing a8ff6a3b20bd16d071ef66824ae4428529d114f9 from
> your io_uring-5.12 branch.
> 
> And using this patch:
> diff --git a/examples/io_uring-cp.c b/examples/io_uring-cp.c
> index cc7a227a5ec7..6e26a4214015 100644
> --- a/examples/io_uring-cp.c
> +++ b/examples/io_uring-cp.c
> @@ -116,13 +116,16 @@ static void queue_write(struct io_uring *ring, struct io_data *data)
>         io_uring_submit(ring);
>  }
> 
> -static int copy_file(struct io_uring *ring, off_t insize)
> +static int copy_file(struct io_uring *ring, off_t _insize)
>  {
> +       off_t insize = _insize;
>         unsigned long reads, writes;
>         struct io_uring_cqe *cqe;
>         off_t write_left, offset;
>         int ret;
> 
> +again:
> +       insize = _insize;
>         write_left = insize;
>         writes = reads = offset = 0;
> 
> @@ -221,6 +224,12 @@ static int copy_file(struct io_uring *ring, off_t insize)
>                 }
>         }
> 
> +       {
> +               struct timespec ts = { .tv_nsec = 999999, };
> +               nanosleep(&ts, NULL);
> +               goto again;
> +       }
> +
>         return 0;
>  }
> 
> Running ./io_uring-cp ~/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
> What I see is this:
> 
> kill -SIGSTOP to any thread I used a worker with pid 2061 here, results in
> 
> root@ub1704-166:~# head /proc/2061/status
> Name:   iou-wrk-2041
> Umask:  0022
> State:  R (running)
> Tgid:   2041
> Ngid:   0
> Pid:    2061
> PPid:   1857
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2041/status
> Name:   io_uring-cp
> Umask:  0022
> State:  T (stopped)
> Tgid:   2041
> Ngid:   0
> Pid:    2041
> PPid:   1857
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2042/status
> Name:   iou-mgr-2041
> Umask:  0022
> State:  T (stopped)
> Tgid:   2041
> Ngid:   0
> Pid:    2042
> PPid:   1857
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> 
> So userspace and iou-mgr-2041 stop, but the workers don't.
> 49 workers burn cpu as much as possible.
> 
> kill -KILL 2061
> results in this:
> - all workers are gone
> - iou-mgr-2041 is gone
> - io_uring-cp waits in status D forever
> 
> root@ub1704-166:~# head /proc/2041/status
> Name:   io_uring-cp
> Umask:  0022
> State:  D (disk sleep)
> Tgid:   2041
> Ngid:   0
> Pid:    2041
> PPid:   1857
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# cat /proc/2041/stack
> [<0>] io_wq_destroy_manager+0x36/0xa0
> [<0>] io_wq_put_and_exit+0x2b/0x40
> [<0>] io_uring_clean_tctx+0xc5/0x110
> [<0>] __io_uring_files_cancel+0x336/0x4e0
> [<0>] do_exit+0x16b/0x13b0
> [<0>] do_group_exit+0x8b/0x140
> [<0>] get_signal+0x219/0xc90
> [<0>] arch_do_signal_or_restart+0x1eb/0xeb0
> [<0>] exit_to_user_mode_prepare+0x115/0x1a0
> [<0>] syscall_exit_to_user_mode+0x27/0x50
> [<0>] do_syscall_64+0x45/0x90
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The 3rd problem is that gdb in a ubuntu 20.04 userspace vm hangs forever:
> 
> root@ub1704-166:~/samba.git# LANG=C strace -o /dev/shm/strace.txt -f -ttT gdb --pid 2417
> GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
> Copyright (C) 2020 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.
> Type "show copying" and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
>     <http://www.gnu.org/software/gdb/documentation/>.
> 
> For help, type "help".
> Type "apropos word" to search for commands related to "word".
> Attaching to process 2417
> [New LWP 2418]
> [New LWP 2419]
> 
> <here it hangs forever>
> 
> The related parts of 'pstree -a -t -p':
> 
>       ├─bash,2048
>       │   └─io_uring-cp,2417 /root/kernel/sn-devel-184-builds/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
>       │       ├─{iou-mgr-2417},2418
>       │       └─{iou-wrk-2417},2419
>       ├─bash,2167
>       │   └─strace,2489 -o /dev/shm/strace.txt -f -ttT gdb --pid 2417
>       │       └─gdb,2492 --pid 2417
>       │           └─gdb,2494 --pid 2417
> 
> root@ub1704-166:~# cat /proc/sys/kernel/yama/ptrace_scope
> 0
> 
> root@ub1704-166:~# head /proc/2417/status
> Name:   io_uring-cp
> Umask:  0022
> State:  t (tracing stop)
> Tgid:   2417
> Ngid:   0
> Pid:    2417
> PPid:   2048
> TracerPid:      2492
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2418/status
> Name:   iou-mgr-2417
> Umask:  0022
> State:  t (tracing stop)
> Tgid:   2417
> Ngid:   0
> Pid:    2418
> PPid:   2048
> TracerPid:      2492
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2419/status
> Name:   iou-wrk-2417
> Umask:  0022
> State:  R (running)
> Tgid:   2417
> Ngid:   0
> Pid:    2419
> PPid:   2048
> TracerPid:      2492
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2492/status
> Name:   gdb
> Umask:  0022
> State:  S (sleeping)
> Tgid:   2492
> Ngid:   0
> Pid:    2492
> PPid:   2489
> TracerPid:      2489
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> root@ub1704-166:~# head /proc/2494/status
> Name:   gdb
> Umask:  0022
> State:  t (tracing stop)
> Tgid:   2494
> Ngid:   0
> Pid:    2494
> PPid:   2492
> TracerPid:      2489
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> 
> 
> Maybe these are related and 2494 gets the SIGSTOP that was supposed to
> be handled by 2419.
> 
> strace.txt is attached.
> 
> Just a wild guess (I don't have time to test this), but maybe this
> will fix it:
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 07e7d61524c7..ee5a402450db 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -503,8 +503,7 @@ static int io_wqe_worker(void *data)
>                 if (io_flush_signals())
>                         continue;
>                 ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
> -               if (try_to_freeze() || ret)
> -                       continue;
> +               try_to_freeze();
>                 if (signal_pending(current)) {
>                         struct ksignal ksig;
> 
> @@ -514,8 +513,7 @@ static int io_wqe_worker(void *data)
>                         continue;
>                 }
>                 /* timed out, exit unless we're the fixed worker */
> -               if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
> -                   !(worker->flags & IO_WORKER_F_FIXED))
> +               if (ret == 0 && !(worker->flags & IO_WORKER_F_FIXED))
>                         break;
>         }
> 
> When the worker got a signal I guess ret is not 0 and we'll
> never hit the if (signal_pending()) statement...

Right, the logic was a bit wrong there, and we can also just drop
try_to_freeze() from all of them now, we don't have to special
case that anymore.

Can you try the current branch? I folded in fixes for that.
That will definitely fix case 1+3, the #2 with kill -KILL is kind
of puzzling. I'll try and reproduce that with the current tree and see
what happens. But that feels like it's either not a new thing, or it's
the same core issue as 1+3 (though I don't quite see how, unless the
failure to catch the signal will elude get_signal() forever in the
worker, I guess that's possible).

-- 
Jens Axboe

