Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9555C342F36
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 20:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCTTWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCTTWY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 15:22:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6726C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 12:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=Qc4vcI9ATyLXpBXXuf/0WDG+YPUM9N6crgxK/O/JYC8=; b=MgnElvmIqcQhvY2HQNvBH0zERv
        K3bueEKtRO7I40znlf7vg2E5LcLhTWDPxQyFkIVrGQ6ZllrQ/KQgSRmQvuevqnO3Ff4EFNKXa4SAG
        wLKePrf1Xa6AD8boNLhZn4UdtBARaQ9zw8Fs1bRVBogTvMJ0ufoJXY//4eRW4Sha9FukZtkcuIjOO
        8iE7NmS+hOYLqni+WDDmU1NyVQMs3/YIboCEdQnBqMG5N7+Q395OuMPnEZS93mJ7VVTCojNF6nsrw
        sW4cbARnUeCEQnBv0yJYqGYrmEvfExV9Rc12JUA08/hwFt6okkbTHi7fkTE3B9vLt78GXPbkZL6xJ
        v+XIBtn95vDiioBNAXV5XrJC6eb3S8pJetO8wveUHcANkQuB81oG9CL2NC4oUwOldSKE91Q0TJzxv
        yZdQJLgAPZ1cVJEtwn1YC38r1EP83yLpDUPT1ZMnDgUICERjSeB/Kmotf1t6QbMeimYKouGsIClT6
        /fxao3ZtussKBVMCicA3yHWv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNhAq-0005sn-W6; Sat, 20 Mar 2021 19:22:13 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
 <cover.1616197787.git.metze@samba.org>
 <61c5e1b6-210e-fb04-5afa-4b12c3a22daa@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 0/5] Complete setup before calling wake_up_new_task()
 and improve task->comm
Message-ID: <7e75d8c0-6c20-316e-0a27-961b343c724a@samba.org>
Date:   Sat, 20 Mar 2021 20:22:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <61c5e1b6-210e-fb04-5afa-4b12c3a22daa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 20.03.21 um 02:24 schrieb Jens Axboe:
> On 3/19/21 6:00 PM, Stefan Metzmacher wrote:
>> Hi,
>>
>> now that we have an explicit wake_up_new_task() in order to start the
>> result from create_io_thread(), we should things up before calling
>> wake_up_new_task().
>>
>> There're also some improvements around task->comm:
>> - We return 0 bytes for /proc/<pid>/cmdline
>>
>> While doing this I noticed a few places we check for
>> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
>> have something like a PS_IS_KERNEL_THREAD_MASK() macro
>> that should be used in generic places and only
>> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
>> difference matters.
>>
>> There are also quite a number of cases where we use
>> same_thread_group(), I guess these need to be checked.
>> Should that return true if userspace threads and their iothreds
>> are compared?
> 
> Any particular ones you are worried about here?

The signal problems and it's used to allow certain modifications
between threads in the same group.

With your same_thread_group_account() change it should be all fixed
magically. I guess the thread also doesn't appear in /proc/pid/tasks/
any more, correct?

Would 'top' still hide them with the thread group
and only show them with 'H' (which show the individual threads)?

In future we may want to have /proc/pid/iothreads/ instead...

>> I did some basic testing and found the problems I explained here:
>> https://lore.kernel.org/io-uring/F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk/T/#t
>> They appear with and without my changes.
>>
>> Changes in v2:
>>
>> - I dropped/deferred these changes:
>>   - We no longer allow a userspace process to change
>>     /proc/<pid>/[task/<tid>]/comm
>>   - We dynamically generate comm names (up to 63 chars)
>>     via io_wq_worker_comm(), similar to wq_worker_comm()
>>
>> Stefan Metzmacher (5):
>>   kernel: always initialize task->pf_io_worker to NULL
>>   io_uring: io_sq_thread() no longer needs to reset
>>     current->pf_io_worker
>>   io-wq: call set_task_comm() before wake_up_new_task()
>>   io_uring: complete sq_thread setup before calling wake_up_new_task()
>>   fs/proc: hide PF_IO_WORKER in get_task_cmdline()
>>
>>  fs/io-wq.c     | 17 +++++++++--------
>>  fs/io_uring.c  | 22 +++++++++++-----------
>>  fs/proc/base.c |  3 +++
>>  kernel/fork.c  |  1 +
>>  4 files changed, 24 insertions(+), 19 deletions(-)
> 
> I don't disagree with any of this, but view them more as cleanups than
> fixes. In which case I think 5.13 is fine, and that's where they should
> go. That seems true for both the first two fixes, and the comm related
> ones too.
> 
> If you don't agree, can you detail why? The comm changes seem fine, but
> doesn't change the visible name. We can make it wider, sure, but any
> reason to?

Ok, I guess we want to take only 'fs/proc: hide PF_IO_WORKER in get_task_cmdline()'
so that ps and top show them as '[iou_mgr_12345]' instead of showing the userspace
cmd.

And with your same_thread_group_account() change we only need this hunk:

@@ -1822,7 +1826,7 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
        kuid_t uid;
        kgid_t gid;

-       if (unlikely(task->flags & PF_KTHREAD)) {
+       if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER))) {
                *ruid = GLOBAL_ROOT_UID;
                *rgid = GLOBAL_ROOT_GID;
                return;

From here:
https://lore.kernel.org/io-uring/97ad63bef490139bb4996e75dea408af1e78fa47.1615826736.git.metze@samba.org/T/#u

I think we should also take that hunk...

What do you think?

metze
