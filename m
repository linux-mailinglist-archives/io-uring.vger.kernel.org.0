Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702003747B8
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 20:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhEESDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 14:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbhEESCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 14:02:55 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACFC061237
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 10:44:19 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m9so2765721wrx.3
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 10:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8TJk0BVIvomaENk5s/D9J9tWIONpWWt5SPlzC/6eL/w=;
        b=DYi4yGzsY+Lp6YFckrLpal0P3czqHrhPjKeUECv1xPHma1esugT6f+KOE4vIJMxlZx
         ZI8vxHtRmKtjH0sHooWQHO8pKP/SBylABiCJunlvoKlSbEnmw0jv1/bl53FxtfuQNSnu
         /ugWn7z8A4iOrAbSjasY4dFYw8/7dz94IBxUNnW9TdySFKRM9NIq3hh9wODwiYDmMbsu
         Wm4wYPkOktKU9GnY23pwGHLEyLLlivg4lWT7z50WUW5N698Dn12mN8JKwKn+bV/Dato5
         HoGJBmcne24rpmufFUlW0F66gw4nWAPxy6iPh0s0pAOiedBKJV9o2zUBN07iO7h9uUPC
         2SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TJk0BVIvomaENk5s/D9J9tWIONpWWt5SPlzC/6eL/w=;
        b=SId14twLBUmH0Xlp0X3UFJzpdNU/n/oT5ktQzy+uPWAhpbQeEgD8JLpkE/4OE5lvDj
         8IDT9Uxl4CYOlGO++DX1XpHjEiyKTlLYFPk0rTzYwFrBbNOz47fLPnJuW6ZQmfiNlm/b
         R4TMnnLZ9tCiY4oOJv51uUaqNrdt7+lKxAe3wKMgBDIEMLibgQbX7RvQTKX4peQiqFY1
         o8i6L/va/H6vzMetxpUkeQ6/jlT7YwAxDOu+FHCFOLnQMrFRF7ESMSK7Jvfwv2hdktpM
         JvaiWs0P0/SAHZMyOx9qP30TAc7UcvpvqDYYlDhtpPSHMHzH3DKeJbbb07mbDHYdyr6i
         JwLg==
X-Gm-Message-State: AOAM532PY2MhbehGTEafkMPzSajx2H9ShC7cf9agJ0lu40N+fO0p5c3b
        DX5eoQtjPLxEKet6PHF1KGQ=
X-Google-Smtp-Source: ABdhPJwK0461SlZoA/8brtD5fO15qe2PzdJI7qYMQ9puKZiuPUVpvhf92OFJDumeZ/+wZBFuHSxSaQ==
X-Received: by 2002:adf:ef4d:: with SMTP id c13mr187178wrp.277.1620236658544;
        Wed, 05 May 2021 10:44:18 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.196])
        by smtp.gmail.com with ESMTPSA id a126sm6526051wmh.37.2021.05.05.10.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 10:44:17 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <755e4e92-9ff2-9246-75c0-63fb79ae1646@linux.alibaba.com>
 <aa74a284-b897-6406-7337-ee87a1714342@gmail.com>
 <06927a9b-42ad-61ef-1f6a-fe54011d05c4@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6e57217f-5dde-093f-ef8e-6e8ac847ea4d@gmail.com>
Date:   Wed, 5 May 2021 18:44:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <06927a9b-42ad-61ef-1f6a-fe54011d05c4@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 2:10 PM, Hao Xu wrote:
> 在 2021/4/30 上午6:10, Pavel Begunkov 写道:
>> On 4/29/21 9:44 AM, Hao Xu wrote:
>>> 在 2021/4/28 下午10:34, Pavel Begunkov 写道:
>>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>>> number of sqes in the original task context.
>>>>> Tests result below:
>>>>
>>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>>> leading to a high maintenance burden. Hence, if we consider the change,
>>>> I'd rather want to limit the userspace exposure, so it can be removed
>>>> if needed.
>>>>
>>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>>> the ring can be passed to a task from a completely another thread group,
>>>> and so the feature would execute from that context, not from the
>>>> original/sqpoll one.
>>>>
>>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>>> ignored if the previous point is addressed.
>>>>
>>>>>
>>>>> 99th latency:
>>>>> iops\idle    10us    60us    110us    160us    210us    260us    310us    360us    410us    460us    510us
>>>>> with this patch:
>>>>> 2k          13    13    12    13    13    12    12    11    11    10.304    11.84
>>>>> without this patch:
>>>>> 2k          15    14    15    15    15    14    15    14    14    13    11.84
>>>>
>>>> Not sure the second nine describes it well enough, please can you
>>>> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
>>>>
>>>> Btw, how happened that only some of the numbers have fractional part?
>>>> Can't believe they all but 3 were close enough to integer values.
>>>>
>>>>> fio config:
>>>>> ./run_fio.sh
>>>>> fio \
>>>>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>>>>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>>>>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>>>>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>>>>> --io_sq_thread_idle=${2}
>>>>>
>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>> ---
>>>>>    fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>>>>    include/uapi/linux/io_uring.h |  1 +
>>>>>    2 files changed, 24 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 1871fad48412..f0a01232671e 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>>>>    {
>>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>>        struct io_kiocb *link = io_prep_linked_timeout(req);
>>>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>>>> +    struct io_uring_task *tctx = NULL;
>>>>> +
>>>>> +    if (ctx->sq_data && ctx->sq_data->thread)
>>>>> +        tctx = ctx->sq_data->thread->io_uring;
>>>>
>>>> without park it's racy, sq_data->thread may become NULL and removed,
>>>> as well as its ->io_uring.
>>> I now think that it's ok to queue async work to req->task->io_uring. I
>>> look through all the OPs, seems only have to take care of async_cancel:
>>>
>>> io_async_cancel(req) {
>>>     cancel from req->task->io_uring;
>>>     cancel from ctx->tctx_list
>>> }
>>>
>>> Given req->task is 'original context', the req to be cancelled may in
>>> ctx->sq_data->thread->io_uring's iowq. So search the req from
>>> sqthread->io_uring is needed here. This avoids overload in main code
>>> path.
>>> Did I miss something else?
>>
>> It must be req->task->io_uring, otherwise cancellations will
>> be broken. And using it should be fine in theory because io-wq/etc.
>> should be set up by io_uring_add_task_file()
>>
>>
>> One more problem to the pile is io_req_task_work_add() and notify
>> mode it choses. Look for IORING_SETUP_SQPOLL in the function.
> How about:
> notify = TWA_SIGNAL
> if ( (is sq mode) and (sqd->thread == NULL or == req->task))
>    notify = TWA_NONE;

notify = (sqd && tsk == sqd->thread) ? TWA_NONE : TWA_SIGNAL;

Like that? Should work


>> Also, IOPOLL+SQPOLL io_uring_try_cancel_requests() looks like
>> may fail (didn't double check it). Look again for IORING_SETUP_SQPOLL.
>>
> I've excluded IOPOLL. This change will only affect SQPOLL mode.
>> I'd rather recommend to go over all uses of IORING_SETUP_SQPOLL
>> and think whether it's flawed.
> I'm working on this. (no obvious problem through eyes, will put the code
> change on more tests)
>>
>>>
>>>
>>>>
>>>>> +    else
>>>>> +        tctx = req->task->io_uring;
>>>>>          BUG_ON(!tctx);
>>>>>        BUG_ON(!tctx->io_wq);
>>>>
>>>> [snip]
>>>>
>>>
>>
> 

-- 
Pavel Begunkov
