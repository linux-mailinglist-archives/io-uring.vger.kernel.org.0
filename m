Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9F4531AD6
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbiEWQ1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 12:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiEWQ1G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 12:27:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68062CC3
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 09:27:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id v11so14156911pff.6
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 09:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uoJYpBJ6QLJVLsDS6atWy2np3lENkAg6JVyz8O1lfUY=;
        b=JZCLpmgx9+39/An9f85kW9g0CZcciBGg/YNr866pIWExky6MAjp3Xjjow9uMciMWc1
         cD9v+2aT3r3/JSvfs6JHRn6rjywNCf40ydQ/G1AxKVu1dBV4PhGN0nsbiO6RvXZ08W+2
         0q0JzP+7XfDwq/3KGlRLm1tEf/xAqzyJxtacNtOeV4Bg/09WQJZuzs/9dJGW+tfXeZXn
         i553hfDiiT977qM0CRtKJRTLIlLfAHdIrmf0TNIUAhCXEhXhA6Jc1TuU0mbug3pPE8VG
         ZYg4uh3iwj+Ku6M0Th+CHnJIIJH7fYEy6zH219+s034wT8A0pBaofFoXq1ESXtiaPPQA
         XbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uoJYpBJ6QLJVLsDS6atWy2np3lENkAg6JVyz8O1lfUY=;
        b=yoWd5bG/LnmFDihCTbUvrnJhDGoj9H5EJAE0yqLXWUY7OcjZW4WMxU4k8CfGtrKj+Z
         SZ24FlYgAMXIZLgeDOAYa4my1Oj6WLtDkx9fQwKlksVdCGz/Qp5dlGav5hdcBDwAhYcM
         L5ify4vhx9GL6Hafa3m1h3G0OMjHxfowXbZVt4uHNQJZAADKG9P2N3tZdcOdR6V6V/xu
         i/8hXjrgIzirbvI5efg+QqCoY8Nrbf8hTTaTc+5K8oTAOngsOvW2RhA/HOLWUJ9KkqNB
         0SrFFlsgDVcqaegRkJbiGfa2GQOYYGRYp81kvHRsBjr+/GbmiSobPoRd0DyjJimKTPJI
         gDWQ==
X-Gm-Message-State: AOAM530zZYRKYGa5VpJv032S2kcG3eNNxOo6H1vhG2mh+cD5bP/qrfPD
        qBHNxre8jpt+M5RSy6io0+N4UDUoL0IZjg==
X-Google-Smtp-Source: ABdhPJzaTeyB1iPLquXDw9Y+TMFzBZIqFPok72UvRWCtVeSz8X7/YbHcdcjSVZPEz+nhvxyPJ2eMPQ==
X-Received: by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id v8-20020a655c48000000b0038202c728e9mr21176213pgr.472.1653323223144;
        Mon, 23 May 2022 09:27:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d10-20020a62f80a000000b0050e0a43712esm7391647pfh.63.2022.05.23.09.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 09:27:02 -0700 (PDT)
Message-ID: <717768b3-4f3c-a5d8-5ca3-189a49b4c481@kernel.dk>
Date:   Mon, 23 May 2022 10:27:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] io_uring: add a schedule condition in io_submit_sqes
Content-Language: en-US
To:     Guo Xuenan <guoxuenan@huawei.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     houtao1@huawei.com, yi.zhang@huawei.com, chengzhihao1@huawei.com,
        linux-kernel@vger.kernel.org
References: <20220521143327.3959685-1-guoxuenan@huawei.com>
 <00772002-8df8-3a41-6e6c-20e3854ad3f0@kernel.dk>
 <a2b0340c-7bf7-a00e-6338-aca8ca02a1e2@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2b0340c-7bf7-a00e-6338-aca8ca02a1e2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/22 8:45 AM, Guo Xuenan wrote:
> Hi Jens
> 
> On 2022/5/22 10:42, Jens Axboe wrote:
>> On 5/21/22 8:33 AM, Guo Xuenan wrote:
>>> when set up sq ring size with IORING_MAX_ENTRIES, io_submit_sqes may
>>> looping ~32768 times which may trigger soft lockups. add need_resched
>>> condition to avoid this bad situation.
>>>
>>> set sq ring size 32768 and using io_sq_thread to perform stress test
>>> as follows:
>>> watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [iou-sqp-600:601]
>>> Kernel panic - not syncing: softlockup: hung tasks
>>> CPU: 2 PID: 601 Comm: iou-sqp-600 Tainted: G L 5.18.0-rc7+ #3
>>> Hardware name: linux,dummy-virt (DT)
>>> Call trace:
>>>   dump_backtrace+0x218/0x228
>>>   show_stack+0x20/0x68
>>>   dump_stack_lvl+0x68/0x84
>>>   dump_stack+0x1c/0x38
>>>   panic+0x1ec/0x3ec
>>>   watchdog_timer_fn+0x28c/0x300
>>>   __hrtimer_run_queues+0x1d8/0x498
>>>   hrtimer_interrupt+0x238/0x558
>>>   arch_timer_handler_virt+0x48/0x60
>>>   handle_percpu_devid_irq+0xdc/0x270
>>>   generic_handle_domain_irq+0x50/0x70
>>>   gic_handle_irq+0x8c/0x4bc
>>>   call_on_irq_stack+0x2c/0x38
>>>   do_interrupt_handler+0xc4/0xc8
>>>   el1_interrupt+0x48/0xb0
>>>   el1h_64_irq_handler+0x18/0x28
>>>   el1h_64_irq+0x74/0x78
>>>   console_unlock+0x5d0/0x908
>>>   vprintk_emit+0x21c/0x470
>>>   vprintk_default+0x40/0x50
>>>   vprintk+0xd0/0x128
>>>   _printk+0xb4/0xe8
>>>   io_issue_sqe+0x1784/0x2908
>>>   io_submit_sqes+0x538/0x2880
>>>   io_sq_thread+0x328/0x7b0
>>>   ret_from_fork+0x10/0x20
>>> SMP: stopping secondary CPUs
>>> Kernel Offset: 0x40f1e8600000 from 0xffff800008000000
>>> PHYS_OFFSET: 0xfffffa8c80000000
>>> CPU features: 0x110,0000cf09,00001006
>>> Memory Limit: none
>>> ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---
>>>
>>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>>> ---
>>>   fs/io_uring.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 92ac50f139cd..d897c6798f00 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7864,7 +7864,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>>>               if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
>>>                   break;
>>>           }
>>> -    } while (submitted < nr);
>>> +    } while (submitted < nr && !need_resched());
>>>         if (unlikely(submitted != nr)) {
>>>           int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
>> This is wrong, you'll potentially end up doing random short submits for
>> non-sqpoll as well.
> Sorry, Indeed, this is not a good solution. Since, the function
> io_submit_sqes not only called by io_sq_thread, it also called by
> syscall io_uring_enter sending large amounts of requests, will also
> trigger soft lockup.

Exactly.

>> sqpoll already supports capping how many it submits in one go, it just
>> doesn't do it if it's only running one ring. As simple as the below,
>> with 1024 pulled out of thin air. Would be great if you could experiment
>> and submit a v2 based on this principle instead. Might still need a
>
> yes, Jens, your patch sloved sq-poll-thread problem, but the problem
> may not completely solved; when using syscall io_uring_enter to
> subimit large amounts of requests.So in my opinion How about 1) add
> cond_resched() in the while cycle part of io_submit_sqes ?. OR 2) set
> macro IORING_MAX_ENTRIES smaller? (i'm curious about the value,why we
> set it with 32768)

I did suspect this isn't specific to SQPOLL at all.

Might make sense to cap batches of non-sqpoll as well, and for each
batch, have a cond_resched() just in case. If you change
IORING_MAX_ENTRIES to something smaller, you risk breaking applications
that currently (for whatever reason) may have set up an SQ ring of that
side. So that is not a viable solution, and honestly wouldn't be a good
option even if that weren't the case.

So the simple solution is just to do it in io_submit_sqes() itself, but
would need to be carefully benchmarked to make sure that it doesn't
regress anything. It's the very fast path, and for real use cases you'd
never run into this problem. Even for a synthetic use case, it sounds
highly suspicious that nothing in the call path ends up doing a
conditional reschedule. What kind of requests are being submitted when
you hit this?

-- 
Jens Axboe

