Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835C4000A3
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 15:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhICNj4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 09:39:56 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60248 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235786AbhICNjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 09:39:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un6qQ3i_1630676333;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un6qQ3i_1630676333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 21:38:54 +0800
Subject: Re: [PATCH 1/6] io_uring: enhance flush completion logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-2-haoxu@linux.alibaba.com>
 <fd529494-96d4-bc91-8e0c-0adf731b9052@gmail.com>
 <302430f6-f83e-4096-448e-9d35f8f4303e@linux.alibaba.com>
 <5dd28d14-24b5-e2dc-aa55-a68cb5d9f4e8@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <53d4f2b4-b0eb-fa4a-9659-794c2c363a7f@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 21:38:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5dd28d14-24b5-e2dc-aa55-a68cb5d9f4e8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/3 下午8:27, Pavel Begunkov 写道:
> On 9/3/21 1:08 PM, Hao Xu wrote:
>> 在 2021/9/3 下午7:42, Pavel Begunkov 写道:
>>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>>> Though currently refcount of a req is always one when we flush inline
>>>
>>> It can be refcounted and != 1. E.g. poll requests, or consider
>> It seems poll requests don't leverage comp cache, do I miss anything?
> 
> Hmm, looks so. Not great that it doesn't, but probably it's because
> of trying to submit next reqs right in io_poll_task_func().
> 
> I'll be pushing for some changes around tw, with it should be easy
> to hook poll completion batching with no drawbacks. Would be great
> if you will be willing to take a shot on it.
Sure, I'll take a look.
> 
>>> that tw also flushes, and you may have a read that goes to apoll
>>> and then get tw resubmitted from io_async_task_func(). And other
>> when it goes to apoll, (say no double wait entry) ref is 1, then read
>> completes inline and then the only ref is droped by flush.
> 
> Yep, but some might have double entry. It also will have elevated
double entry should be fine.
> refs if there was a linked timeout. Another case is io-wq, which
Haven't dig into linked timeout yet.
> takes a reference, and if iowq doesn't put it for a while (e.g. got
> rescheduled) but requests goes to tw (resubmit, poll, whatever)
> you have the same picture.
Gotcha, thanks.
> 
>>> cases.
>>>
>>>> completions, but still a chance there will be exception in the future.
>>>> Enhance the flush logic to make sure we maintain compl_nr correctly.
>>>
>>> See below
>>>
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>
>>>> we need to either removing the if check to claim clearly that the req's
>>>> refcount is 1 or adding this patch's logic.
>>>>
>>>>    fs/io_uring.c | 6 ++++--
>>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 2bde732a1183..c48d43207f57 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2291,7 +2291,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>>        __must_hold(&ctx->uring_lock)
>>>>    {
>>>>        struct io_submit_state *state = &ctx->submit_state;
>>>> -    int i, nr = state->compl_nr;
>>>> +    int i, nr = state->compl_nr, remain = 0;
>>>>        struct req_batch rb;
>>>>          spin_lock(&ctx->completion_lock);
>>>> @@ -2311,10 +2311,12 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>>              if (req_ref_put_and_test(req))
>>>>                io_req_free_batch(&rb, req, &ctx->submit_state);
>>>> +        else
>>>> +            state->compl_reqs[remain++] = state->compl_reqs[i];
>>>
>>> Our ref is dropped, and something else holds another reference. That
>>> "something else" is responsible to free the request once it put the last
>>> reference. This chunk would make the following io_submit_flush_completions()
>>> to underflow refcount and double free.
>> True, I see. Thanks Pavel.
>>>
>>>>        }
>>>>          io_req_free_batch_finish(ctx, &rb);
>>>> -    state->compl_nr = 0;
>>>> +    state->compl_nr = remain;
>>>>    }
>>>>      /*
>>>>
>>>
>>
> 

