Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D437D9C42
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345924AbjJ0Ozl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 10:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345845AbjJ0Ozk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 10:55:40 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77725106
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 07:55:37 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3579874b5easo412615ab.1
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 07:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698418537; x=1699023337; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFsU9jeD7RU70nHde8K3vwOxVJS3tmKj0LIhCekxbrU=;
        b=TDyI7v6ZNUYGxtmQl5Pjin/YlrjfFwPux4LRE2dWtDQ0Jtci3vX3syzKDaN0i+UELs
         uQruPBm7s7QSkmZ42oUONDyab7dFC0FRuGWtvyd0osfEmQS1HyPdybqOfqUobWNOE/Pl
         FQpHxeBwMcyAYIyUUiAe951YWGVLqVCoBjNsP1RbGRJX3JbvM/ZeQeeBJSLFiZmNZ9w2
         WXy+qcf7O0x+vRYj0iGV9OpyQ7EGCmZxLrmjN2S4EXi9hqOT18sNktvI/pc2BVYl5ThK
         qyEYM2NkzZ38cJJDFsleJDY2Fuow4QkYLMcFRj/BgMXe/lxvytZbLYCpOTIFZIps6qBL
         /CqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698418537; x=1699023337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SFsU9jeD7RU70nHde8K3vwOxVJS3tmKj0LIhCekxbrU=;
        b=F9IaBH+ezrWrZtW3kqRIbIZ+xPxHnSyPvX0ltKb5twi2K0ggzRo887T2p8nLy0HRpm
         6j/EemNm0rhfTRvPPYEOuWqZvQh9Vs8v2E5Jl/2j4doE5SALlK4dF+4stUXmKXGDfV4v
         w/splCl7HuuBXChTrDaJsf+Yw+27fHmLSd9Eilu3rzkRzJ2/NHmfGW68CjcFPskT0raw
         wwKhf/HhlUCzVUQDh6Jy17xRU3yZpMzv94hbfdiBubSZ6kv48sKdRs4/vddbBAO06Jq+
         OV1iZvT/COtFHFnGyrkIrnFAVDtVLJ6kAwxCIDbGxdHv2Hr1Ze01ownnbiU0vcayMYjk
         DAkA==
X-Gm-Message-State: AOJu0Yw8mN5md36RmWi0pa0qExOpi/Ib15xMYeMdg7xD+YFJj72Tl8TE
        U9s49gzTCOf59U/j8oqv0TK6Pg==
X-Google-Smtp-Source: AGHT+IEQzj+UFlLASkIGgdxDxGo2LzR1jEPx3AOkbgmUqyNogZRHE+2aIWF8Czi6sLD/Siy/8BjQiw==
X-Received: by 2002:a6b:5c10:0:b0:790:958e:a667 with SMTP id z16-20020a6b5c10000000b00790958ea667mr3021146ioh.2.1698418536450;
        Fri, 27 Oct 2023 07:55:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r4-20020a5e9504000000b0079fd98bbe9bsm501631ioj.15.2023.10.27.07.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 07:55:35 -0700 (PDT)
Message-ID: <c34467c5-2d57-436a-a357-a230727214ed@kernel.dk>
Date:   Fri, 27 Oct 2023 08:55:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: task hung in ext4_fallocate #2
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     Andres Freund <andres@anarazel.de>, Theodore Ts'o <tytso@mit.edu>,
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
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
 <ZTmWjWeNCgGcdIy+@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZTmWjWeNCgGcdIy+@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/23 4:28 PM, Dave Chinner wrote:
> On Tue, Oct 24, 2023 at 06:34:05PM -0600, Jens Axboe wrote:
>> On 10/24/23 6:06 PM, Dave Chinner wrote:
>>> On Tue, Oct 24, 2023 at 12:35:26PM -0600, Jens Axboe wrote:
>>>> On 10/24/23 8:30 AM, Jens Axboe wrote:
>>>>> I don't think this is related to the io-wq workers doing non-blocking
>>>>> IO.
>>>
>>> The io-wq worker that has deadlocked _must_ be doing blocking IO. If
>>> it was doing non-blocking IO (i.e. IOCB_NOWAIT) then it would have
>>> done a trylock and returned -EAGAIN to the worker for it to try
>>> again later. I'm not sure that would avoid the issue, however - it
>>> seems to me like it might just turn it into a livelock rather than a
>>> deadlock....
>>
>> Sorry typo, yes they are doing blocking IO, that's all they ever do. My
>> point is that it's not related to the issue.
>>
>>>>> The callback is eventually executed by the task that originally
>>>>> submitted the IO, which is the owner and not the async workers. But...
>>>>> If that original task is blocked in eg fallocate, then I can see how
>>>>> that would potentially be an issue.
>>>>>
>>>>> I'll take a closer look.
>>>>
>>>> I think the best way to fix this is likely to have inode_dio_wait() be
>>>> interruptible, and return -ERESTARTSYS if it should be restarted. Now
>>>> the below is obviously not a full patch, but I suspect it'll make ext4
>>>> and xfs tick, because they should both be affected.
>>>
>>> How does that solve the problem? Nothing will issue a signal to the
>>> process that is waiting in inode_dio_wait() except userspace, so I
>>> can't see how this does anything to solve the problem at hand...
>>
>> Except task_work, which when it completes, will increment the i_dio
>> count again. This is the whole point of the half assed patch I sent out.
> 
> What task_work is that?  When does that actually run?
> 
> Please don't assume that everyone is intimately familiar with the
> subtle complexities of io_uring infrastructure - if the fix relies
> on a signal from -somewhere- then you need to explain where
> that signal comes from and why we should be able to rely on that...

Sorry yes, I should explain that more clearly.

For buffered reads/writes, we get the completion on the IRQ side, as you
know. io_uring posts the completion from task context, for which it uses
task_work to do so. task_work is run by the task itself, when it exits
to userspace from the kernel. TIF_NOTIFY_SIGNAL is used for this, which
is like per-thread signals, not shared across thread groups. But they do
break waiting, so we can exit and process them.

With the iomap workqueue punt, we get the block layer callback and then
queue processing to the workqueue. Once that is run, we'll queue up the
task_work and post the completion. With DIO_CALLER_COMP, we move more of
this context to the task_work, most notably the inode_dio_end(). And
this is where our problem is coming from. Now we need the task to
actually run this task_work, and when the task does inode_dio_wait() and
blocks in there, we have a deadlock where we are waiting on task_work
being run to run inode_dio_end(), yet preventing it from actually
running.

>>> I'm also very leary of adding new error handling complexity to paths
>>> like truncate, extent cloning, fallocate, etc which expect to block
>>> on locks until they can perform the operation safely.
>>
>> I actually looked at all of them, ext4 and xfs specifically. It really
>> doesn't seem to bad.
>>
>>> On further thinking, this could be a self deadlock with
>>> just async direct IO submission - submit an async DIO with
>>> IOCB_CALLER_COMP, then run an unaligned async DIO that attempts to
>>> drain in-flight DIO before continuing. Then the thread waits in
>>> inode_dio_wait() because it can't run the completion that will drop
>>> the i_dio_count to zero.
>>
>> No, because those will be non-blocking. Any blocking IO will go via
>> io-wq, and that won't then hit the deadlock. If you're doing
>> inode_dio_wait() from the task itself for a non-blocking issue, then
>> that would surely be an issue. But we should not be doing that, and we
>> are checking for it.
> 
> There's no documentation that says IO submission inside a
> IOCB_DIO_CALLER_COMP context must be IOCB_NOWAIT.
> 
> I don't recall it being mentioned during patch submission or review,
> and if it was ithe implications certainly didn't register with me -
> I would not have given a rvb without such a landmine either being
> removed or very well documented.
> 
> I don't see anywhere that is checked and I don't see how it can be,
> because the filesystem IO submission path itself has no idea if the
> caller is already has a IOCB_DIO_CALLER_COMP IO in flight and
> pending completion.

The io-wq threads can do IOCB_DIO_CALLER_COMP with blocking writes just
fine, as they are not the ones that will ultimately run the task_work
that does inode_dio_end(). Hence there's no deadlock from that
perspective.

The task that runs the task_work that does inode_dio_end() must not be
calling inode_dio_wait() blocking, that would run into this deadlock
we're currently seeing with fallocate. See end-of-email for a lockdep
addition for this.

>>> Hence it appears to me that we've missed some critical constraints
>>> around nesting IO submission and completion when using
>>> IOCB_CALLER_COMP. Further, it really isn't clear to me how deep the
>>> scope of this problem is yet, let alone what the solution might be.
>>
>> I think you're missing exactly what the deadlock is.
> 
> Then you need to explain exactly what it is, not send undocumented
> hacks that appear to do absolutely nothing to fix the problem.

For the io-wq case, when a write completes, it's queued with the
_original_ task for processing, and the original task is the one that
will run the task_work and hence inode_dio_done(). This is why it's
totally fine for io-wq to do blocking writes, even hitting
inode_dio_wait() as well.

>>> With all this in mind, and how late this is in the 6.6 cycle, can we
>>> just revert the IOCB_CALLER_COMP changes for now?
>>
>> Yeah I'm going to do a revert of the io_uring side, which effectively
>> disables it. Then a revised series can be done, and when done, we could
>> bring it back.
> 
> Please revert the whole lot, I'm now unconvinced that this is
> functionality we can sanely support at the filesystem level without
> a whole lot more thought.

I'd prefer just eliminating the caller for now. I already have a full
series that does the inode_dio_wait(), so let's please give that a go
first. The only other potential user of CALLER_COMP would be aio, and
that would need some substantial changes to enable it as-is. So we
should not really be at risk here, and I'd rather avoid doing another
round of merge conflicts with the whole thing.

I'll be posting that soon, for a 6.8 target. It's obviously too late for
6.7 at this point.

I did also look into adding lockdep support for this, so we can detect
the dependency, and it seems to be working for me. Here's the test case
on current -git with lockdep enabled. This shows that we have a
dependency with someone having done inode_dio_begin() and then
inode_dio_wait() on the same inode. With that in place, we should be
able to catch any violations of this. Trace:

[   17.897351] ============================================
[   17.897677] WARNING: possible recursive locking detected
[   17.897999] 6.6.0-rc7-00123-g3a568e3a961b-dirty #4300 Not tainted
[   17.898413] --------------------------------------------
[   17.898783] falloc-dio/502 is trying to acquire lock:
[   17.899135] ffff000205318648 (inode){++++}-{3:3}, at: xfs_file_fallocate+0x74/0x40
[   17.899681] 
[   17.899681] but task is already holding lock:
[   17.900085] ffff000205318648 (inode){++++}-{3:3}, at: __iomap_dio_rw+0x164/0x87c
[   17.900606] 
[   17.900606] other info that might help us debug this:
[   17.901058]  Possible unsafe locking scenario:
[   17.901058] 
[   17.901472]        CPU0
[   17.901645]        ----
[   17.901820]   lock(inode);
[   17.902014]   lock(inode);
[   17.902209] 
[   17.902209]  *** DEADLOCK ***
[   17.902209] 
[   17.902619]  May be due to missing lock nesting notation
[   17.902619] 
[   17.903089] 4 locks held by falloc-dio/502:
[   17.903383]  #0: ffff000205318648 (inode){++++}-{3:3}, at: __iomap_dio_rw+0x164/0c
[   17.903926]  #1: ffff0000c3e9d3e8 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0
[   17.904512]  #2: ffff000205318338 (&sb->s_type->i_mutex_key#17){++++}-{3:3}, at: 4
[   17.905158]  #3: ffff0002053184c8 (mapping.invalidate_lock#3){+.+.}-{3:3}, at: xf4
[   17.905808] 
[   17.905808] stack backtrace:
[   17.906124] CPU: 0 PID: 502 Comm: falloc-dio Not tainted 6.6.0-rc7-00123-g3a568e30
[   17.906762] Hardware name: linux,dummy-virt (DT)
[   17.907094] Call trace:
[   17.907270]  dump_backtrace+0x90/0xe4
[   17.907537]  show_stack+0x14/0x1c
[   17.907770]  dump_stack_lvl+0x5c/0xa0
[   17.908038]  dump_stack+0x14/0x1c
[   17.908297]  print_deadlock_bug+0x24c/0x334
[   17.908612]  __lock_acquire+0xe18/0x20d4
[   17.908876]  lock_acquire+0x1e0/0x30c
[   17.909137]  inode_dio_wait+0xc8/0x114
[   17.909378]  xfs_file_fallocate+0x74/0x440
[   17.909672]  vfs_fallocate+0x1a0/0x2f0
[   17.909943]  ksys_fallocate+0x48/0x90
[   17.910212]  __arm64_sys_fallocate+0x1c/0x28
[   17.910518]  invoke_syscall+0x44/0x104
[   17.910759]  el0_svc_common.constprop.0+0xb4/0xd4
[   17.911085]  do_el0_svc+0x18/0x20
[   17.911334]  el0_svc+0x4c/0xec
[   17.911549]  el0t_64_sync_handler+0x118/0x124
[   17.911833]  el0t_64_sync+0x168/0x16c

-- 
Jens Axboe

