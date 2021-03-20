Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC80343012
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 23:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCTWjK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 18:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhCTWjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 18:39:03 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04E3C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:39:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l1so4643595plg.12
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7NZQ5Ih9EId3GOjeRQBWcWyq53rJC7Hq5ccDaCIc3so=;
        b=GR320Bk/0ZsTEqEEV2ehV/9ayP2SY4McL19Tv1IPUkLkQ+amXvEgVvgdFb1WImG6IF
         0GULtcB0LpDXWSW3KL1YKMg82inZ8YxI6N4RrufyRjqzsOM2yEY54rwTrA87kb4FvbZ+
         z9NQ9Vf4LWNY4K6woatkp1sqmaGqqKUCrgG2Lz5HwAN1JA+HOB3zubS+mpv1jkDuq0aH
         Tu7NlnVVV3nF0MBJ7fdoaoAhoS01AQ0Mg2e2czv+o6kk0GrgEEp31Ifo8u5JHUGYUmgd
         USjDHoEriZXbxueAPOGV+/5IPDgCxmPX0S3TxibojTxdRn6ih3wDoQ1vMxIjj+d/HWC/
         9QLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7NZQ5Ih9EId3GOjeRQBWcWyq53rJC7Hq5ccDaCIc3so=;
        b=FBCdZxHxX/75nhvjXFYS2fmPjpRjiXOQNtVOAkAsb7CgSDtp0gBbhaHcDUFzvKcaKK
         xFibBJ0ncGI5A9l4x8537jz7+5K+x2DyQLKK2N68MMR7CO0MDFKX8IMYi0QA2qgnmiXp
         EdhvCBEJjKDZ2x4upYoMSm5xzIlvc7TUrXgyEbcdE1M9uM/4eggXVN0e113sWF0dQcOh
         acfjn57BHaSrCHMlmgL5/PHXCdw5uAOg3f0I1enm3tqdbUxjWzduXhvSv4pN9SJM+Y42
         o939FkkZCRf/FBh16bTe901bCHcEzBuXG2a34XQ7MUkl2s8lfGbSJ959iNMeLqUKn13o
         emWg==
X-Gm-Message-State: AOAM531ldJ0Xx8+F/KHsUJHm8UHiUkh4JoqYt8gUvnmjcQ5PX9MU9okm
        ZrwLjwsBPn55+pyvRBwF0faHYRQQkF2s0Q==
X-Google-Smtp-Source: ABdhPJzonjbnykbt1lPmulpuHRPMd9owK+Cpu8GFeWstEhWK4WJZYExGrYFAZ56+xwi4Z2Eh1YFgmQ==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr5560311pji.69.1616279942835;
        Sat, 20 Mar 2021 15:39:02 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v126sm9210051pfv.163.2021.03.20.15.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:39:02 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Complete setup before calling wake_up_new_task()
 and improve task->comm
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
 <cover.1616197787.git.metze@samba.org>
 <61c5e1b6-210e-fb04-5afa-4b12c3a22daa@kernel.dk>
 <7e75d8c0-6c20-316e-0a27-961b343c724a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a38f4102-ab18-934b-c724-7b97f24d66a7@kernel.dk>
Date:   Sat, 20 Mar 2021 16:39:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e75d8c0-6c20-316e-0a27-961b343c724a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 1:22 PM, Stefan Metzmacher wrote:
> 
> Am 20.03.21 um 02:24 schrieb Jens Axboe:
>> On 3/19/21 6:00 PM, Stefan Metzmacher wrote:
>>> Hi,
>>>
>>> now that we have an explicit wake_up_new_task() in order to start the
>>> result from create_io_thread(), we should things up before calling
>>> wake_up_new_task().
>>>
>>> There're also some improvements around task->comm:
>>> - We return 0 bytes for /proc/<pid>/cmdline
>>>
>>> While doing this I noticed a few places we check for
>>> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
>>> have something like a PS_IS_KERNEL_THREAD_MASK() macro
>>> that should be used in generic places and only
>>> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
>>> difference matters.
>>>
>>> There are also quite a number of cases where we use
>>> same_thread_group(), I guess these need to be checked.
>>> Should that return true if userspace threads and their iothreds
>>> are compared?
>>
>> Any particular ones you are worried about here?
> 
> The signal problems and it's used to allow certain modifications
> between threads in the same group.

Gotcha

> With your same_thread_group_account() change it should be all fixed
> magically. I guess the thread also doesn't appear in /proc/pid/tasks/
> any more, correct?

I think it'll still show up there, as they are still linked.

> Would 'top' still hide them with the thread group
> and only show them with 'H' (which show the individual threads)?

I think it'll show them as a thread group still.

> In future we may want to have /proc/pid/iothreads/ instead...

Maybe?

>>> I did some basic testing and found the problems I explained here:
>>> https://lore.kernel.org/io-uring/F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk/T/#t
>>> They appear with and without my changes.
>>>
>>> Changes in v2:
>>>
>>> - I dropped/deferred these changes:
>>>   - We no longer allow a userspace process to change
>>>     /proc/<pid>/[task/<tid>]/comm
>>>   - We dynamically generate comm names (up to 63 chars)
>>>     via io_wq_worker_comm(), similar to wq_worker_comm()
>>>
>>> Stefan Metzmacher (5):
>>>   kernel: always initialize task->pf_io_worker to NULL
>>>   io_uring: io_sq_thread() no longer needs to reset
>>>     current->pf_io_worker
>>>   io-wq: call set_task_comm() before wake_up_new_task()
>>>   io_uring: complete sq_thread setup before calling wake_up_new_task()
>>>   fs/proc: hide PF_IO_WORKER in get_task_cmdline()
>>>
>>>  fs/io-wq.c     | 17 +++++++++--------
>>>  fs/io_uring.c  | 22 +++++++++++-----------
>>>  fs/proc/base.c |  3 +++
>>>  kernel/fork.c  |  1 +
>>>  4 files changed, 24 insertions(+), 19 deletions(-)
>>
>> I don't disagree with any of this, but view them more as cleanups than
>> fixes. In which case I think 5.13 is fine, and that's where they should
>> go. That seems true for both the first two fixes, and the comm related
>> ones too.
>>
>> If you don't agree, can you detail why? The comm changes seem fine, but
>> doesn't change the visible name. We can make it wider, sure, but any
>> reason to?
> 
> Ok, I guess we want to take only 'fs/proc: hide PF_IO_WORKER in
> get_task_cmdline()' so that ps and top show them as '[iou_mgr_12345]'
> instead of showing the userspace cmd.

That one makes sense, to keep it consistent with earlier to some extent,
and not to have 5.12 be the odd one out compared to later kernels as
well.

> And with your same_thread_group_account() change we only need this hunk:
> 
> @@ -1822,7 +1826,7 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
>         kuid_t uid;
>         kgid_t gid;
> 
> -       if (unlikely(task->flags & PF_KTHREAD)) {
> +       if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>                 *ruid = GLOBAL_ROOT_UID;
>                 *rgid = GLOBAL_ROOT_GID;
>                 return;
> 
> From here:
> https://lore.kernel.org/io-uring/97ad63bef490139bb4996e75dea408af1e78fa47.1615826736.git.metze@samba.org/T/#u
> 
> I think we should also take that hunk...
> 
> What do you think?

I'll have to look into that, on the face of it it seems wrong. Why just
assign global root uid/gid for the io worker? It's using the same
credentials as the original task.

-- 
Jens Axboe

