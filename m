Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9F07D540B
	for <lists+io-uring@lfdr.de>; Tue, 24 Oct 2023 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjJXOaJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Oct 2023 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbjJXOaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Oct 2023 10:30:08 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB4910C6
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 07:30:05 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3574c225c14so3049025ab.0
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 07:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698157805; x=1698762605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJKquyT/R2kA2C6b0ULsNCZa1KBpHAWLZyr660nwFqY=;
        b=JvDzK+WND8Bsa22JuXO/cU+6w06i2iAM1sQFsV/1wuNtH1bCutqXnezo2bRLlQhkPk
         sQJWZcGtCCJrb4xxt+rRoP1I8cPLf9Jm2Kw6dtaOw41GHIZSsIC8hEilzg4lrUw5zSuV
         bGqz4N+wbIemO4rDhLMBJiD4c1dDnP7SLjFIsk3axDAI+5uh2HhBBSZETVxoR89YhkI8
         R5g6PZraHA7IZymBafLuXvJ+Wf8hzKdB+8ZpqoNbHIY6xffF5NaSlwOBZX4CH2F3edWM
         Elbo5P5Eql1vkk/xdSlYRIWK+FBvPZ+3s/a9S8SBNbu7u8TlHJ/4CF6q7Wff1oWf7n0j
         eD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698157805; x=1698762605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJKquyT/R2kA2C6b0ULsNCZa1KBpHAWLZyr660nwFqY=;
        b=tty9x7PqatXCDacLlh6nV/VfZ/OCPhMStAixDgz1uMOwksx1woxC/WGvgEnoaojV8p
         tKNpQeBKqlNifL5NqnpaZRlIh1WUo4j2ylPK3aYIGHnJYPy0iN9KUrWmBBrkFhlc3TTV
         k8AYuQorb2YVpf30b3KC0EFWyzmtYaxk6fBT8z3AYb50N67gCwSUt/4MD0Yz5o+Pspvt
         SzLU5meyayOUYAW/7FAEqH8mxIqcGdOm9WZHqFhfkQhDGEzwE8sE5Z3/+4On9PYfB1AL
         RuSABr+19pFVd6CYjTEh70dyR6/M2CJYR3P9TC/LeVA1N7gfQ6kXBlZGjZbxeaYw5zJW
         i2kQ==
X-Gm-Message-State: AOJu0YzOBTVggroFy87w/6e6OPbUdVMFY39g0nq3t8ZgkVPnP9s96jkG
        m0jwUnfY3/EB2mYpA17aJgHOGQ==
X-Google-Smtp-Source: AGHT+IH/z9ZR3qsgvsCN7TXs45+otEUl1mR83dbFC+3YUTy1Yy4yXnW/j8NBqTjIiY0Vcn/PJYutzg==
X-Received: by 2002:a5e:a502:0:b0:79f:8cd3:fd0e with SMTP id 2-20020a5ea502000000b0079f8cd3fd0emr12076902iog.1.1698157804636;
        Tue, 24 Oct 2023 07:30:04 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gn7-20020a0566382c0700b0042b0ce92dddsm2871282jab.161.2023.10.24.07.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 07:30:03 -0700 (PDT)
Message-ID: <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
Date:   Tue, 24 Oct 2023 08:30:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: task hung in ext4_fallocate #2
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Andres Freund <andres@anarazel.de>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        =?UTF-8?Q?Ricardo_Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/23/23 7:12 PM, Dave Chinner wrote:
> [cc Jens, io-uring]

Thanks!

> On Tue, Oct 17, 2023 at 07:50:09PM -0700, Andres Freund wrote:
>> Hi,
>>
>> On 2023-10-17 20:43:35 -0400, Theodore Ts'o wrote:
>>> On Mon, Oct 16, 2023 at 08:37:25PM -0700, Andres Freund wrote:
>>>> I just was able to reproduce the issue, after upgrading to 6.6-rc6 - this time
>>>> it took ~55min of high load (io_uring using branch of postgres, running a
>>>> write heavy transactional workload concurrently with concurrent bulk data
>>>> load) to trigger the issue.
>>>>
>>>> For now I have left the system running, in case there's something you would
>>>> like me to check while the system is hung.
>>>>
>>>> The first hanging task that I observed:
>>>>
>>>> cat /proc/57606/stack
>>>> [<0>] inode_dio_wait+0xd5/0x100
>>>> [<0>] ext4_fallocate+0x12f/0x1040
>>>> [<0>] vfs_fallocate+0x135/0x360
>>>> [<0>] __x64_sys_fallocate+0x42/0x70
>>>> [<0>] do_syscall_64+0x38/0x80
>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>
>>> This stack trace is from some process (presumably postgres) trying to
>>> do a fallocate() system call:
>>
>> Yes, it's indeed postgres.
>>
>>
>>>> [ 3194.579297] INFO: task iou-wrk-58004:58874 blocked for more than 122 seconds.
>>>> [ 3194.579304]       Not tainted 6.6.0-rc6-andres-00001-g01edcfe38260 #77
>>>> [ 3194.579310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> [ 3194.579314] task:iou-wrk-58004   state:D stack:0     pid:58874 ppid:52606  flags:0x00004000
>>>> [ 3194.579325] Call Trace:
>>>> [ 3194.579329]  <TASK>
>>>> [ 3194.579334]  __schedule+0x388/0x13e0
>>>> [ 3194.579349]  schedule+0x5f/0xe0
>>>> [ 3194.579361]  schedule_preempt_disabled+0x15/0x20
>>>> [ 3194.579374]  rwsem_down_read_slowpath+0x26e/0x4c0
>>>> [ 3194.579385]  down_read+0x44/0xa0
>>>> [ 3194.579393]  ext4_file_write_iter+0x432/0xa80
>>>> [ 3194.579407]  io_write+0x129/0x420
>>>
>>> This could potentially be a interesting stack trace; but this is where
>>> we really need to map the stack address to line numbers.  Is that
>>> something you could do?
>>
>> Converting the above with scripts/decode_stacktrace.sh yields:
>>
>> __schedule (kernel/sched/core.c:5382 kernel/sched/core.c:6695)
>> schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 13) kernel/sched/core.c:6772 (discriminator 13))
>> schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 (discriminator 10) kernel/sched/core.c:6831 (discriminator 10))
>> rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073 (discriminator 4))
>> down_read (./arch/x86/include/asm/preempt.h:95 kernel/locking/rwsem.c:1257 kernel/locking/rwsem.c:1263 kernel/locking/rwsem.c:1522)
>> ext4_file_write_iter (./include/linux/fs.h:1073 fs/ext4/file.c:57 fs/ext4/file.c:564 fs/ext4/file.c:715)
>> io_write (./include/linux/fs.h:1956 io_uring/rw.c:926)
>>
>> But I'm not sure that that stacktrace is quite right (e.g. what's
>> ./include/linux/fs.h:1073 doing in this stacktrace?). But with an optimized
>> build it's a bit hard to tell what's an optimization artifact and what's an
>> off stack trace...
>>
>>
>> I had the idea to look at the stacks (via /proc/$pid/stack) for all postgres
>> processes and the associated io-uring threads, and then to deduplicate them.
>>
>> 22x:
>> ext4_file_write_iter (./include/linux/fs.h:1073 fs/ext4/file.c:57 fs/ext4/file.c:564 fs/ext4/file.c:715)
>> io_write (./include/linux/fs.h:1956 io_uring/rw.c:926)
>> io_issue_sqe (io_uring/io_uring.c:1878)
>> io_wq_submit_work (io_uring/io_uring.c:1960)
>> io_worker_handle_work (io_uring/io-wq.c:596)
>> io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
>> ret_from_fork (arch/x86/kernel/process.c:147)
>> ret_from_fork_asm (arch/x86/entry/entry_64.S:312)
> 
> io_uring does some interesting stuff with IO completion and iomap
> now - IIRC IOCB_DIO_CALLER_COMP is new 6.6-rc1 functionality. This
> flag is set by io_write() to tell the iomap IO completion handler
> that the caller will the IO completion, avoiding a context switch
> to run the completion in a kworker thread.
> 
> It's not until the caller runs iocb->dio_complete() that
> inode_dio_end() is called to drop the i_dio_count. This happens when
> io_uring gets completion notification from iomap via
> iocb->ki_complete(iocb, 0);
> 
> It then requires the io_uring layer to process the completion
> and call iocb->dio_complete() before the inode->i_dio_count is
> dropped and inode_dio_wait() will complete.
> 
> So what I suspect here is that we have a situation where the worker
> that would run the completion is blocked on the inode rwsem because
> this isn't a IOCB_NOWAIT IO and the fallocate call holds the rwsem
> exclusive and is waiting on inode_dio_wait() to return.
> 
> Cc Jens, because I'm not sure this is actually an ext4 problem - I
> can't see why XFS won't have the same issue w.r.t.
> truncate/fallocate and IOCB_DIO_CALLER_COMP delaying the
> inode_dio_end() until whenever the io_uring code can get around to
> processing the delayed completion....

I don't think this is related to the io-wq workers doing non-blocking
IO. The callback is eventually executed by the task that originally
submitted the IO, which is the owner and not the async workers. But...
If that original task is blocked in eg fallocate, then I can see how
that would potentially be an issue.

I'll take a closer look.

-- 
Jens Axboe

