Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB8E2FE019
	for <lists+io-uring@lfdr.de>; Thu, 21 Jan 2021 04:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbhAUDkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 22:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbhAUCFU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 21:05:20 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB1BC061757
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 18:04:35 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c124so168862wma.5
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 18:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vx2A5e3jUNPeegDaybjpiQRfkGl2uFKyG0BNvUS7vpQ=;
        b=uO7mngCzmhtnF1m9fztNTMr+g5yaHgF6kcaPL67NfjRWnreDwKVJTcSsELRML8xy3a
         SeVsrHlIDGa8IIirYk4LNW+hNpaAbwnToo3El8mIApCFSjYWjxrmycfVD59iOW6QwVMw
         so4Lhm0qQMjT1zGrettoZ1CXQUXmawQ7VkXp1DeR6OqHMuOiavhobGWgS7eqqUIzalWM
         dza9VWtvPD3KpNzW8lP/Rj4s8VGGqYWIwq/VmckzXzB019LXTUYfWhZqSCtsanJ+9Aqt
         0/sMxuxUgia5GjMai1R/mVwzk7yKgUseaCQrQUP/O2EoDxFBQT9dzzv5Si5+lUq7ThvS
         W37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Vx2A5e3jUNPeegDaybjpiQRfkGl2uFKyG0BNvUS7vpQ=;
        b=qiD8vao/+le4z/VXxwBWTNMXql3P4Y+ZKzWzqylU0u/mG49NL1BAIP8oZJL0Qn5ELY
         EnbUzaokqbMSN1JGj+N6Xxthe7H+uxxye1Xg2sA0o6vwD3AyKXcDlOX8U88dlqxsK7Xz
         uZigOWfDkd5ygJG4ftcbFxCX4QKzRkfu9fYPVjAEC6FKTrPsFZCZ48689RoRiy47k1a/
         uyOs/Vom46p9x8tGY0LN0NbfCg1HNJ0nKRFD4jPi++iNe/jNMafERgFAwhDVu3v9YwuZ
         67Cyaht+I9yqcO2YbSXWUQM0D2qWAx+suo5WUWBAIaXKLaVZOByZibqaituup86EF1h0
         ER7g==
X-Gm-Message-State: AOAM533Q/h1ZyYiUUe4Vyu0qujztrgaJJ5UsbUrz1RXspA3pbq0Ru5Xd
        h+2sQRq3Xc4QUHFDZYnXIfVUI5v+kR0=
X-Google-Smtp-Source: ABdhPJwsSYZ7oV0vSsdVL2WQoaQoDWwTLC7e9LcIT5gBJ4TPn9Y9FibvijaU8CeSkYMnWO9U+EZqhg==
X-Received: by 2002:a1c:a7c5:: with SMTP id q188mr6657588wme.108.1611194673981;
        Wed, 20 Jan 2021 18:04:33 -0800 (PST)
Received: from [192.168.8.143] ([148.252.129.228])
        by smtp.gmail.com with ESMTPSA id k16sm6391208wmj.45.2021.01.20.18.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 18:04:33 -0800 (PST)
Subject: Re: [PATCH] io_uring: leave clean req to be done in flush overflow
To:     Joseph Qi <jiangqi903@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
 <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
 <0de4ca7e-fd6b-2821-00cd-6c69deb1d9e0@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f20150ed-b201-7653-1295-7c78e6c1d763@gmail.com>
Date:   Thu, 21 Jan 2021 02:00:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0de4ca7e-fd6b-2821-00cd-6c69deb1d9e0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/01/2021 01:37, Joseph Qi wrote:
> 
> 
> On 1/20/21 8:35 PM, Pavel Begunkov wrote:
>> On 20/01/2021 08:11, Joseph Qi wrote:
>>> Abaci reported the following BUG:
>>>
>>> [   27.629441] BUG: sleeping function called from invalid context at fs/file.c:402
>>> [   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1012, name: io_wqe_worker-0
>>> [   27.633220] 1 lock held by io_wqe_worker-0/1012:
>>> [   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock){....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
>>> [   27.636487] irq event stamp: 66658
>>> [   27.637302] hardirqs last  enabled at (66657): [<ffffffff8144ba02>] kmem_cache_free+0x1f2/0x3b0
>>> [   27.639211] hardirqs last disabled at (66658): [<ffffffff82003a77>] _raw_spin_lock_irqsave+0x17/0x50
>>> [   27.641196] softirqs last  enabled at (64686): [<ffffffff824003c5>] __do_softirq+0x3c5/0x5aa
>>> [   27.643062] softirqs last disabled at (64681): [<ffffffff8220108f>] asm_call_irq_on_stack+0xf/0x20
>>> [   27.645029] CPU: 1 PID: 1012 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc4+ #68
>>> [   27.646651] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>>> [   27.649249] Call Trace:
>>> [   27.649874]  dump_stack+0xac/0xe3
>>> [   27.650666]  ___might_sleep+0x284/0x2c0
>>> [   27.651566]  put_files_struct+0xb8/0x120
>>> [   27.652481]  __io_clean_op+0x10c/0x2a0
>>> [   27.653362]  __io_cqring_fill_event+0x2c1/0x350
>>> [   27.654399]  __io_req_complete.part.102+0x41/0x70
>>> [   27.655464]  io_openat2+0x151/0x300
>>> [   27.656297]  io_issue_sqe+0x6c/0x14e0
>>> [   27.657170]  ? lock_acquire+0x31a/0x440
>>> [   27.658068]  ? io_worker_handle_work+0x24e/0x8a0
>>> [   27.659119]  ? find_held_lock+0x28/0xb0
>>> [   27.660026]  ? io_wq_submit_work+0x7f/0x240
>>> [   27.660991]  io_wq_submit_work+0x7f/0x240
>>> [   27.661915]  ? trace_hardirqs_on+0x46/0x110
>>> [   27.662890]  io_worker_handle_work+0x501/0x8a0
>>> [   27.663917]  ? io_wqe_worker+0x135/0x520
>>> [   27.664836]  io_wqe_worker+0x158/0x520
>>> [   27.665719]  ? __kthread_parkme+0x96/0xc0
>>> [   27.666663]  ? io_worker_handle_work+0x8a0/0x8a0
>>> [   27.667726]  kthread+0x134/0x180
>>> [   27.668506]  ? kthread_create_worker_on_cpu+0x90/0x90
>>> [   27.669641]  ret_from_fork+0x1f/0x30
>>>
>>> It blames we call cond_resched() with completion_lock when clean
>>> request. In fact we will do it during flush overflow and it seems we
>>> have no reason to do it before. So just remove io_clean_op() in
>>> __io_cqring_fill_event() to fix this BUG.
>>
>> Nope, it would be broken. You may override, e.g. iov pointer
>> that is dynamically allocated, and the function makes sure all
>> those are deleted and freed. Most probably there will be problems
>> on flush side as well.
>>
>> Looks like the problem is that we do spin_lock_irqsave() in
>> __io_req_complete() and then just spin_lock() for put_files_struct().
>> Jens, is it a real problem?
>>
> From the code, it is because it might sleep in close_files():

Makes sense. The diff should handle it, but let's see if
it would ever be applicable after some other bug fixes.

> 
> ...
> if (file) {
> 	filp_close(file, files);
> 	cond_resched();
> }
> 
> 
> Thanks,
> Joseph
> 
>> At least for 5.12 there is a cleanup as below, moving drop_files()
>> into io_req_clean_work/io_free_req(), which is out of locks. Depends
>> on that don't-cancel-by-files patch, but I guess can be for 5.11

-- 
Pavel Begunkov
