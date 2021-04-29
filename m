Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17A36F276
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 00:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhD2WLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 18:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhD2WLG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 18:11:06 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D099DC06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:10:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l2so16103601wrm.9
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l/VaDSXkUNTfWmr9Ex/9IPmov3LaljJD7+GwSEXe6WQ=;
        b=FqHNDSkZjGfBcEM79WewiIhA3R81AnYShOuEK9nWKH0bbBc56IC3iLwYWJ0yxFLFTK
         f/wu1Q1IrhdFPIBDn/8qD72Zm4z6eosC495MhTZK8FlgkxRlnZbbarO/OVsbTWIMXy95
         32ToP+zbVSUq78XGcMrxExP9BJGE+80uI6W67qzvSfdwAI5SXoijpAr9oGWcmdqIo/bn
         7icQbttGqjP4urUPRi/poMDECa+kjOF6/c5Mq3YPeUXnefKyn1a4OFuJk3AgXhr6vHG2
         U5wtb5xvBD2OF1BWZFkDwiXc6NtNvjbcznGa7l7D3ZtXYW7taO7hRiNgCjoGpdWg1jpl
         XE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l/VaDSXkUNTfWmr9Ex/9IPmov3LaljJD7+GwSEXe6WQ=;
        b=kkudrTZFlg5Rb5nI3GrfAoLDkrAqxuSL8WohHR43/EZ16hxXiqqwsD4Y4l7RsQgaFG
         QD8BEIrKqp/GhgpYSsQKeDcNz26gZURuvBjsYSbf17qkpOvBhtJ3X7T2aer1prCSpAap
         uN7npYfWcvFi8rLzCqA9bp049wZyJOllpmMFjloexk+28oei8IM0fZKPDRvaNQ4v2EhU
         ZBVzRYOksgcYwXZbtNxyVv63lUosVNVF4RuRkjO7ReZS+u6g32yzD/jVzK3/C6RlkfEn
         Mw80CXz5A4AVD1srBVeYEO4y6pcjUrF30OxsxbkNvd9+TFCLgDKijswQaZ8CB5mLIlX+
         xt0w==
X-Gm-Message-State: AOAM530U8x3ZB+POruSC59/ESdh3kOT1Ui/grQY8+GmiQay1GQCoRA2H
        Sc2hogdc/Q+XqE8IzDzgxRw=
X-Google-Smtp-Source: ABdhPJxhk5VqjyjQZD27oZm1HH8eRZiUacqDy/icYeL337vnF/SuoBlMVRcj/T+hgXdiU7knV3K7PQ==
X-Received: by 2002:a5d:6da8:: with SMTP id u8mr2266786wrs.48.1619734216632;
        Thu, 29 Apr 2021 15:10:16 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id i20sm11118451wmq.29.2021.04.29.15.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 15:10:16 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <755e4e92-9ff2-9246-75c0-63fb79ae1646@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <aa74a284-b897-6406-7337-ee87a1714342@gmail.com>
Date:   Thu, 29 Apr 2021 23:10:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <755e4e92-9ff2-9246-75c0-63fb79ae1646@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 9:44 AM, Hao Xu wrote:
> 在 2021/4/28 下午10:34, Pavel Begunkov 写道:
>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>> sqes are submitted by sqthread when it is leveraged, which means there
>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>> number of sqes in the original task context.
>>> Tests result below:
>>
>> Frankly, it can be a nest of corner cases if not now then in the future,
>> leading to a high maintenance burden. Hence, if we consider the change,
>> I'd rather want to limit the userspace exposure, so it can be removed
>> if needed.
>>
>> A noticeable change of behaviour here, as Hao recently asked, is that
>> the ring can be passed to a task from a completely another thread group,
>> and so the feature would execute from that context, not from the
>> original/sqpoll one.
>>
>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>> ignored if the previous point is addressed.
>>
>>>
>>> 99th latency:
>>> iops\idle    10us    60us    110us    160us    210us    260us    310us    360us    410us    460us    510us
>>> with this patch:
>>> 2k          13    13    12    13    13    12    12    11    11    10.304    11.84
>>> without this patch:
>>> 2k          15    14    15    15    15    14    15    14    14    13    11.84
>>
>> Not sure the second nine describes it well enough, please can you
>> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
>>
>> Btw, how happened that only some of the numbers have fractional part?
>> Can't believe they all but 3 were close enough to integer values.
>>
>>> fio config:
>>> ./run_fio.sh
>>> fio \
>>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>>> --io_sq_thread_idle=${2}
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>>   include/uapi/linux/io_uring.h |  1 +
>>>   2 files changed, 24 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 1871fad48412..f0a01232671e 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>>   {
>>>       struct io_ring_ctx *ctx = req->ctx;
>>>       struct io_kiocb *link = io_prep_linked_timeout(req);
>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>> +    struct io_uring_task *tctx = NULL;
>>> +
>>> +    if (ctx->sq_data && ctx->sq_data->thread)
>>> +        tctx = ctx->sq_data->thread->io_uring;
>>
>> without park it's racy, sq_data->thread may become NULL and removed,
>> as well as its ->io_uring.
> I now think that it's ok to queue async work to req->task->io_uring. I
> look through all the OPs, seems only have to take care of async_cancel:
> 
> io_async_cancel(req) {
>    cancel from req->task->io_uring;
>    cancel from ctx->tctx_list
> }
> 
> Given req->task is 'original context', the req to be cancelled may in
> ctx->sq_data->thread->io_uring's iowq. So search the req from
> sqthread->io_uring is needed here. This avoids overload in main code
> path.
> Did I miss something else?

It must be req->task->io_uring, otherwise cancellations will
be broken. And using it should be fine in theory because io-wq/etc.
should be set up by io_uring_add_task_file()


One more problem to the pile is io_req_task_work_add() and notify
mode it choses. Look for IORING_SETUP_SQPOLL in the function.

Also, IOPOLL+SQPOLL io_uring_try_cancel_requests() looks like
may fail (didn't double check it). Look again for IORING_SETUP_SQPOLL.

I'd rather recommend to go over all uses of IORING_SETUP_SQPOLL
and think whether it's flawed.

> 
> 
>>
>>> +    else
>>> +        tctx = req->task->io_uring;
>>>         BUG_ON(!tctx);
>>>       BUG_ON(!tctx->io_wq);
>>
>> [snip]
>>
> 

-- 
Pavel Begunkov
