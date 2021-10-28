Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA3543E98F
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJ1Ueu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhJ1Uet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:34:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D9AC061570;
        Thu, 28 Oct 2021 13:32:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o14so12259289wra.12;
        Thu, 28 Oct 2021 13:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=Fj3d8L+Tu5plhp0oURJ8bfnGKwtrSzamN+RMCCiJX+E=;
        b=lwMU2t2KYxi+doRDlM9Asav7Ntly0/MRqmO5gK8DX5l5bzNjzPUg47D33oywP2jMdp
         RqifkhgcS8IqJDcFzKsKylYgXaE/o2P1wMQ6QjaDtncRycDEgDTQJeYLbvlsZOrv2F4Z
         dQoUSLkEEiYL+yfSJ3iOD7uCCz/sPPgsuYpzXc62bxs/HFTxAlbR6FEurcX6sWQn2Qx6
         MzSZ76sMdig8zy/xzocmuGotxPSBkD20+cnvQdXu34KzBz+fCYPs9VjrNp/y9U/15k3X
         RemHC3ZK3Ipay9yFNS344Blrso7XPEowbIYogvBFJFiTgjKJksFSsKQKiqshsTcavHlX
         zMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=Fj3d8L+Tu5plhp0oURJ8bfnGKwtrSzamN+RMCCiJX+E=;
        b=osLDnanwHoXcNBoLcUH9x55bEgKbKimIwh2yaYcofZCZhvh6Eiu9bZK2JtBrUwhhG5
         ekfKwP7/Py0GF8w90+neFlsHvZTkh0s6XeQKL4H6xPz4R0ewzsVO8aauJ3O2xhTISPHj
         sH6WqQQilgpefrnfW214pFKScJq5VkxmO7daBgKq6tLkKK2P3kvsAf7Onk2vCXiHG2ts
         OupcfrBqkcVHlNYvNJix5DHLzwhTe9jNT/DOmvayxvWs+0y2iBVz4PxUGrxv0NSLGr1i
         6lrpEHZVfbsk8OHsvHRp6xagCZOUAqkfMBoiDzdXCHMT9RJ2W7NIEK+gsKy1U+bXS170
         9P6A==
X-Gm-Message-State: AOAM530ttdJXEP2KXrvHU816ohA2c4KdUa4DvIST+mLRKPYtiTUHKRPM
        eGKC3zAKHSA+WXPj8UsCVl6bU6qNKu0=
X-Google-Smtp-Source: ABdhPJxXHSJBH1d+T2z6uFyQ4LXTPpMxyVe5FiGcWl0Q3z34KN2uC5v4LkbP0lNZzUaJYR8U/i91Zw==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr8520088wry.12.1635453140975;
        Thu, 28 Oct 2021 13:32:20 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id y8sm4063049wrq.77.2021.10.28.13.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 13:32:20 -0700 (PDT)
Message-ID: <2b0d6d98-b6f6-e1b1-1ea8-3126f41ec0ce@gmail.com>
Date:   Thu, 28 Oct 2021 21:32:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000012fb05cee99477@google.com>
 <85f96aab-4127-f494-9718-d7bfc035db54@gmail.com>
 <27280d59-88ff-7eeb-1e43-eb9bd23df761@gmail.com>
In-Reply-To: <27280d59-88ff-7eeb-1e43-eb9bd23df761@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 14:57, Pavel Begunkov wrote:
> On 10/22/21 14:49, Pavel Begunkov wrote:
>> On 10/22/21 05:38, syzbot wrote:
>>> Hello,
>>>
>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>> INFO: task hung in io_wqe_worker
>>>
>>> INFO: task iou-wrk-9392:9401 blocked for more than 143 seconds.
>>>        Not tainted 5.15.0-rc2-syzkaller #0
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> task:iou-wrk-9392    state:D stack:27952 pid: 9401 ppid:  7038 flags:0x00004004
>>> Call Trace:
>>>   context_switch kernel/sched/core.c:4940 [inline]
>>>   __schedule+0xb44/0x5960 kernel/sched/core.c:6287
>>>   schedule+0xd3/0x270 kernel/sched/core.c:6366
>>>   schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>>>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>>>   __wait_for_common kernel/sched/completion.c:106 [inline]
>>>   wait_for_common kernel/sched/completion.c:117 [inline]
>>>   wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
>>>   io_worker_exit fs/io-wq.c:183 [inline]
>>>   io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

#syz test: https://github.com/isilence/linux.git syz_coredump



>>
>> Easily reproducible, it's stuck in
>>
>> static void io_worker_exit(struct io_worker *worker)
>> {
>>      ...
>>      wait_for_completion(&worker->ref_done);
>>      ...
>> }
>>
>> The reference belongs to a create_worker_cb() task_work item. It's expected
>> to either be executed or cancelled by io_wq_exit_workers(), but the owner
>> task never goes __io_uring_cancel (called in do_exit()) and so never
>> reaches io_wq_exit_workers().
>>
>> Following the owner task, cat /proc/<pid>/stack:
>>
>> [<0>] do_coredump+0x1d0/0x10e0
>> [<0>] get_signal+0x4a3/0x960
>> [<0>] arch_do_signal_or_restart+0xc3/0x6d0
>> [<0>] exit_to_user_mode_prepare+0x10e/0x190
>> [<0>] irqentry_exit_to_user_mode+0x9/0x20
>> [<0>] irqentry_exit+0x36/0x40
>> [<0>] exc_page_fault+0x95/0x190
>> [<0>] asm_exc_page_fault+0x1e/0x30
>>
>> (gdb) l *(do_coredump+0x1d0-5)
>> 0xffffffff81343ccb is in do_coredump (fs/coredump.c:469).
>> 464
>> 465             if (core_waiters > 0) {
>> 466                     struct core_thread *ptr;
>> 467
>> 468                     freezer_do_not_count();
>> 469                     wait_for_completion(&core_state->startup);
>> 470                     freezer_count();
>>
>> Can't say anything more at the moment as not familiar with coredump
> 
> A simple hack allowing task works to be executed from there
> workarounds the problem
> 
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 3224dee44d30..f6f9dfb02296 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -466,7 +466,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
>           struct core_thread *ptr;
> 
>           freezer_do_not_count();
> -        wait_for_completion(&core_state->startup);
> +        while (wait_for_completion_interruptible(&core_state->startup))
> +            tracehook_notify_signal();
>           freezer_count();
>           /*
>            * Wait for all the threads to become inactive, so that
> 
> 
> 

-- 
Pavel Begunkov
