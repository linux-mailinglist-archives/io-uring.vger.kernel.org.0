Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FEB36E7F9
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 11:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhD2J3C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 05:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhD2J3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 05:29:02 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C284C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 02:28:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l2so13815450wrm.9
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 02:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfT7N35neR7XxnK8Io1to9V5fd7ttZVvS1/DZ370O3k=;
        b=F/PkjiV1GvppL8e+GByGPu8D9LKSv0a97uKq5CLSRxA+b3vQg4yj5Hv1YtmZOhwGZD
         C4xUKiltfbloBd61gB05KSQOvzIGta2pnOQNaMYFdDHovCLHarfoJCckUgtdZq6/PyA9
         +pNMlzIhtNfgurcru8u0obPW06e5kcpBmmxg6TREVwl55wxyovww4FsaRG8+Kj5XSSz1
         2M5MtY6JDROZP9YSWxVr3nMFYShJV8UqAJDjT44Uo4dhuTtHjoZLP3dHYT+e7mFDO6iY
         DfepAfNWcdtM7+/zV/55YkyOOMnL/LjsQh3w5ysaucaoM4yhMDGXvcIWXo6xgBrvLmf5
         TrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfT7N35neR7XxnK8Io1to9V5fd7ttZVvS1/DZ370O3k=;
        b=Zw+eZTNmfiP+xp7C7OkHxU5/MkZQ24WaM80x34/wLcEXCFjOBdRJ9Ab+scAuzuEqEZ
         TcbsfX77Tda8K3RF2bNijJd+uPAO/Mrl82AmGU6MgJO6Hpw2u8NBgRhwZ3SQI3L5nrzb
         gc8bH0ZmeK8i1UP+VEbnMijTo772CTQojpy9RXHJW9V6X8wmnXTcNn5dGbLPf6ha9F0p
         2Zxb1zxk4DgnXcuziGMiF0QdDLkuo59Bdn919YExs+bHqO4OaUg4MVoY7clcOAqh0ZeZ
         sKG0Bl7ttEo3Ym0OXhHlmMWov0b18pNq6bmHEm9yUhJc0k2qjw3Tsdx0XgITggoJSxhY
         2oJw==
X-Gm-Message-State: AOAM532Q6OAX/cOavfCmEVTxOwrNW0Z7WwtYDZ5muzScWXv7hhjBxgf6
        sh/V3ogTZ7JczRg3V94ra6eoBGrO8Ps=
X-Google-Smtp-Source: ABdhPJyWbApSqI38R3MaXkym4phekFXx5ny5i5q0J/56SbZTW1m1PtQtj+E0t5lMac/6c2brN//POA==
X-Received: by 2002:adf:d084:: with SMTP id y4mr1166228wrh.0.1619688494346;
        Thu, 29 Apr 2021 02:28:14 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id y11sm3015480wmi.41.2021.04.29.02.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 02:28:13 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <6cc0020d-bfad-d723-6cc3-8bb2b8c4d313@gmail.com>
 <ab087171-9396-2b68-beab-ca1a4ad25bb0@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ae26b825-37b8-11d3-4c44-9b23a27e2d69@gmail.com>
Date:   Thu, 29 Apr 2021 10:28:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <ab087171-9396-2b68-beab-ca1a4ad25bb0@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 5:37 AM, Hao Xu wrote:
> 在 2021/4/28 下午10:37, Pavel Begunkov 写道:
>> On 4/28/21 3:34 PM, Pavel Begunkov wrote:
>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>> number of sqes in the original task context.
>>>> Tests result below:
>>>
>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>> leading to a high maintenance burden. Hence, if we consider the change,
>>> I'd rather want to limit the userspace exposure, so it can be removed
>>> if needed.
>>>
>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>> the ring can be passed to a task from a completely another thread group,
>>> and so the feature would execute from that context, not from the
>>> original/sqpoll one.
>>
>> So maybe something like:
>> if (same_thread_group()) {
>>     /* submit */
>> }I thought this case(cross independent processes) for some time, Pavel,
> could you give more hints about how this may trigger errors?

Currently? We need to audit cancellation, but don't think it's a problem.

But as said, it's about the future. Your patch adds a new quirky
userspace behaviour (submitting from alien context as described), and
once commited it can't be removed and should be maintained. 

I can easily imagine it either over-complicating cancellations (and
we had enough of troubles with it), or just preventing more important
optimisations, or anything else often happening with new features.


>>
>>>
>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>> ignored if the previous point is addressed.
>>
>> I'd question whether it'd be better with the flag or without doing
>> this feature by default.
> Just like what Jens said, the flag here is to allow users to do their
> decision, there may be cases like a application wants to offload as much
> as possible IO related work to sqpoll, so that it can be dedicated to
> computation work etc.
>>
>>>
>>>>
>>>> 99th latency:
>>>> iops\idle    10us    60us    110us    160us    210us    260us    310us    360us    410us    460us    510us
>>>> with this patch:
>>>> 2k          13    13    12    13    13    12    12    11    11    10.304    11.84
>>>> without this patch:
>>>> 2k          15    14    15    15    15    14    15    14    14    13    11.84
>>>
>>> Not sure the second nine describes it well enough, please can you
>>> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
> Sure, I will.

Forgot but it's important, should compared with non-sqpoll as well
because the feature is taking the middle ground between them.

>>>
>>> Btw, how happened that only some of the numbers have fractional part?
>>> Can't believe they all but 3 were close enough to integer values.
> This confused me a little bit too, but it is indeed what fio outputs.

That's just always when I see such, something tells me that data has
been manipulated. Even if it's fio, it's really weird and suspicious, 
and worth to look what's wrong with it.

>>>
>>>> fio config:
>>>> ./run_fio.sh
>>>> fio \
>>>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>>>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>>>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>>>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>>>> --io_sq_thread_idle=${2}
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>>>   include/uapi/linux/io_uring.h |  1 +
>>>>   2 files changed, 24 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 1871fad48412..f0a01232671e 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>>>   {
>>>>       struct io_ring_ctx *ctx = req->ctx;
>>>>       struct io_kiocb *link = io_prep_linked_timeout(req);
>>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>>> +    struct io_uring_task *tctx = NULL;
>>>> +
>>>> +    if (ctx->sq_data && ctx->sq_data->thread)
>>>> +        tctx = ctx->sq_data->thread->io_uring;
>>>
>>> without park it's racy, sq_data->thread may become NULL and removed,
>>> as well as its ->io_uring.
>>>
>>>> +    else
>>>> +        tctx = req->task->io_uring;
>>>>         BUG_ON(!tctx);
>>>>       BUG_ON(!tctx->io_wq);
>>>
>>> [snip]
>>>
>>
> 

-- 
Pavel Begunkov
