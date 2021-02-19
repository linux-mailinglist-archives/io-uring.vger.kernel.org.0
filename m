Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCD631F941
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 13:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhBSMPz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 07:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhBSMPc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 07:15:32 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066C2C061786
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 04:14:52 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id x4so7443233wmi.3
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 04:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EJYqS+WUCc2XZ3K8gVJ13xe3MflB4UICCx3lAWnnbxQ=;
        b=gPnBVv6KskM05wlwpqr/6UxpghdiM7seUX8qYWsQYgTmvkHfXI3/0NVVs3k0LosbkV
         lRbMEdh7bU9mWFerZ0fBvy9YDVMhdoj+OtwdlyouQGA/qRvYUdG8KeaiYCL2YMm1HUFf
         f6sBn10PoBpi3nLmIxQqt5OcsEX8iEbjV0V9HiPb2216EfKg7AXzYtcRubkBW332OY0H
         3Zx415Gaabm3TekIW2z6aXc14LKYpZAjcmCwUrPM1yj0MK4Onc6tDieTYSMs2EdSWSle
         1qP7u8lOjl/oXoDDdc4WctEBA3smn9QWcukj398VXb7Qa/hsNrEXg3neKqnHPt+3mD0H
         0dvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EJYqS+WUCc2XZ3K8gVJ13xe3MflB4UICCx3lAWnnbxQ=;
        b=Aj4uCGn2LcT5HyPtc65XUW7ZjPkFYyXOspiiDEa56ZeA1RpkD6b00BHuOjKOZC7H7n
         cO3kinbFWltscbVfWOdSil7w8KQzpIJxBgLOMrhXjeF/g6JDWhaGJIqzTB3vG4ibNIb/
         cmj7ymEu8t82lyKf5mDvWH5mbwhj/P8Tq04hd05aIQTpo3eNhEBFn28l6ClvAou9sElM
         1ZqfGz5Q3F3k1+WG3bQwEthmNp+T/9amJ5E/puCcKQyYO7NqKKuS2JNDHjm31Mse+BKT
         FaUupvbDN2epjxfqRKZCQJvHuX1qz3MPrL2warOTWc9eqjqEI/Mh4uLbME+2MCS2XgH5
         vqJw==
X-Gm-Message-State: AOAM533Uw1f/zCS/X0Xe4dXCxHBqIYokkYmJMNsY6tfXJMsEZBKjwz0K
        L3AjPcMSSAcCdhLCNFojCp/HYoiVB9WkSQ==
X-Google-Smtp-Source: ABdhPJy5XuO8MVzMzrrSUr/5hlmoDJFtHkYOnFp34z9YgyBYLLh9oOIm8RWDvA0lx9OKGymFb8l2Uw==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr1760874wmi.6.1613736890751;
        Fri, 19 Feb 2021 04:14:50 -0800 (PST)
Received: from [192.168.8.137] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id h12sm16316760wru.18.2021.02.19.04.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 04:14:50 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't recursively hold ctx->uring_lock in
 io_wq_submit_work()
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611394824-73078-1-git-send-email-haoxu@linux.alibaba.com>
 <45a0221a-bd2b-7183-e35d-2d2550f687b5@kernel.dk>
 <d5ff7e3d-db29-ea00-9be5-50b65c69769c@linux.alibaba.com>
 <da91697b-9f7e-2258-9ecc-fb19fc945042@gmail.com>
 <3c9c851b-ec14-3683-91b7-527032044c85@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <599539b1-fe36-1053-a4b7-6b4a363a777d@gmail.com>
Date:   Fri, 19 Feb 2021 12:11:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3c9c851b-ec14-3683-91b7-527032044c85@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/02/2021 03:16, Hao Xu wrote:
> 在 2021/2/19 上午3:15, Pavel Begunkov 写道:
>> On 18/02/2021 17:16, Hao Xu wrote:
>>> 在 2021/1/25 下午12:31, Jens Axboe 写道:
>>>> On 1/23/21 2:40 AM, Hao Xu wrote:
>>>>> Abaci reported the following warning:
>>>>>
>>>>> [   97.862205] ============================================
>>>>> [   97.863400] WARNING: possible recursive locking detected
>>>>> [   97.864640] 5.11.0-rc4+ #12 Not tainted
>>>>> [   97.865537] --------------------------------------------
>>>>> [   97.866748] a.out/2890 is trying to acquire lock:
>>>>> [   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>>> io_wq_submit_work+0x155/0x240
>>>>> [   97.869735]
>>>>> [   97.869735] but task is already holding lock:
>>>>> [   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>>> __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>>> [   97.873074]
>>>>> [   97.873074] other info that might help us debug this:
>>>>> [   97.874520]  Possible unsafe locking scenario:
>>>>> [   97.874520]
>>>>> [   97.875845]        CPU0
>>>>> [   97.876440]        ----
>>>>> [   97.877048]   lock(&ctx->uring_lock);
>>>>> [   97.877961]   lock(&ctx->uring_lock);
>>>>> [   97.878881]
>>>>> [   97.878881]  *** DEADLOCK ***
>>>>> [   97.878881]
>>>>> [   97.880341]  May be due to missing lock nesting notation
>>>>> [   97.880341]
>>>>> [   97.881952] 1 lock held by a.out/2890:
>>>>> [   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>>> __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>>> [   97.885108]
>>>>> [   97.885108] stack backtrace:
>>>>> [   97.886209] CPU: 0 PID: 2890 Comm: a.out Not tainted 5.11.0-rc4+ #12
>>>>> [   97.887683] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS
>>>>> rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>>>>> [   97.890457] Call Trace:
>>>>> [   97.891121]  dump_stack+0xac/0xe3
>>>>> [   97.891972]  __lock_acquire+0xab6/0x13a0
>>>>> [   97.892940]  lock_acquire+0x2c3/0x390
>>>>> [   97.893853]  ? io_wq_submit_work+0x155/0x240
>>>>> [   97.894894]  __mutex_lock+0xae/0x9f0
>>>>> [   97.895785]  ? io_wq_submit_work+0x155/0x240
>>>>> [   97.896816]  ? __lock_acquire+0x782/0x13a0
>>>>> [   97.897817]  ? io_wq_submit_work+0x155/0x240
>>>>> [   97.898867]  ? io_wq_submit_work+0x155/0x240
>>>>> [   97.899916]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
>>>>> [   97.901101]  io_wq_submit_work+0x155/0x240
>>>>> [   97.902112]  io_wq_cancel_cb+0x162/0x490
>>>>> [   97.903084]  ? io_uring_get_socket+0x40/0x40
>>>>> [   97.904126]  io_async_find_and_cancel+0x3b/0x140
>>>>> [   97.905247]  io_issue_sqe+0x86d/0x13e0
>>>>> [   97.906186]  ? __lock_acquire+0x782/0x13a0
>>>>> [   97.907195]  ? __io_queue_sqe+0x10b/0x550
>>>>> [   97.908175]  ? lock_acquire+0x2c3/0x390
>>>>> [   97.909122]  __io_queue_sqe+0x10b/0x550
>>>>> [   97.910080]  ? io_req_prep+0xd8/0x1090
>>>>> [   97.911044]  ? mark_held_locks+0x5a/0x80
>>>>> [   97.912042]  ? mark_held_locks+0x5a/0x80
>>>>> [   97.913014]  ? io_queue_sqe+0x235/0x470
>>>>> [   97.913971]  io_queue_sqe+0x235/0x470
>>>>> [   97.914894]  io_submit_sqes+0xcce/0xf10
>>>>> [   97.915842]  ? xa_store+0x3b/0x50
>>>>> [   97.916683]  ? __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>>> [   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
>>>>> [   97.918995]  ? lockdep_hardirqs_on_prepare+0xde/0x180
>>>>> [   97.920204]  ? syscall_enter_from_user_mode+0x26/0x70
>>>>> [   97.921424]  do_syscall_64+0x2d/0x40
>>>>> [   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>> [   97.923538] RIP: 0033:0x7f0b62601239
>>>>> [   97.924437] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00
>>>>> 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
>>>>>      05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01
>>>>>         48
>>>>> [   97.928628] RSP: 002b:00007f0b62cc4d28 EFLAGS: 00000246 ORIG_RAX:
>>>>> 00000000000001aa
>>>>> [   97.930422] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>>>>> 00007f0b62601239
>>>>> [   97.932073] RDX: 0000000000000000 RSI: 0000000000006cf6 RDI:
>>>>> 0000000000000005
>>>>> [   97.933710] RBP: 00007f0b62cc4e20 R08: 0000000000000000 R09:
>>>>> 0000000000000000
>>>>> [   97.935369] R10: 0000000000000000 R11: 0000000000000246 R12:
>>>>> 0000000000000000
>>>>> [   97.937008] R13: 0000000000021000 R14: 0000000000000000 R15:
>>>>> 00007f0b62cc5700
>>>>>
>>>>> This is caused by try to hold uring_lock in io_wq_submit_work() without
>>>>> checking if we are in io-wq thread context or not. It can be in original
>>>>> context when io_wq_submit_work() is called from IORING_OP_ASYNC_CANCEL
>>>>> code path, where we already held uring_lock.
>>>>
>>>> Looks like another fallout of the split CLOSE handling. I've got the
>>>> right fixes pending for 5.12:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.12/io_uring&id=6bb0079ef3420041886afe1bcd8e7a87e08992e1
>>>>
>>>> (and the prep patch before that in the tree). But that won't really
>>>> help us for 5.11 and earlier, though we probably should just queue
>>>> those two patches for 5.11 and get them into stable. I really don't
>>>> like the below patch, though it should fix it. But the root cause
>>>> is really the weird open cancelation...
>>>>
>>> Hi Jens,
>>> I've repro-ed this issue on branch for-5.12/io_uring-2021-02-17
>>> which contains the patch you give, the issue still exists.
>>> I think this one is not an async close specifical problem.
>>> The rootcause is we try to run an iowq work in the original
>>> context(queue an iowq work, then async cancel it).
>> If you mean cancellation executed from task_work or inline (during
>> submission), then yes, I agree.
>>
> Yea, that's what I mean.
>> Can you try a diff below?
> Tested, it works well, thanks Pavel.

Perfect, thanks

-- 
Pavel Begunkov
