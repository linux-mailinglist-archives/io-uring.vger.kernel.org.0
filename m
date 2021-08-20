Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750EF3F33F9
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 20:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhHTSlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 14:41:53 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:46669 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234249AbhHTSlx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 14:41:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UkQoNjv_1629484873;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UkQoNjv_1629484873)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 21 Aug 2021 02:41:13 +0800
Subject: Re: [PATCH 1/3] io_uring: flush completions for fallbacks
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
 <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
 <a02fcefe-3a55-51fb-9184-6a49596226cf@linux.alibaba.com>
 <0fcdffe3-024d-2f0f-78f1-938594f68995@gmail.com>
 <459bb482-e9bd-1457-95f9-3251394747c9@linux.alibaba.com>
 <332dad28-891b-f2ab-a2ae-fb044d1785d5@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <99a1643d-41d3-4333-0f58-c522c8124714@linux.alibaba.com>
Date:   Sat, 21 Aug 2021 02:41:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <332dad28-891b-f2ab-a2ae-fb044d1785d5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/20 下午8:26, Pavel Begunkov 写道:
> On 8/20/21 11:16 AM, Hao Xu wrote:
>> 在 2021/8/20 下午5:49, Pavel Begunkov 写道:
>>> On 8/20/21 10:21 AM, Hao Xu wrote:
>>>> 在 2021/8/18 下午7:42, Pavel Begunkov 写道:
>>>>> io_fallback_req_func() doesn't expect anyone creating inline
>>>>> completions, and no one currently does that. Teach the function to flush
>>>>> completions preparing for further changes.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>     fs/io_uring.c | 5 +++++
>>>>>     1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 3da9f1374612..ba087f395507 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1197,6 +1197,11 @@ static void io_fallback_req_func(struct work_struct *work)
>>>>>         percpu_ref_get(&ctx->refs);
>>>>>         llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>>>>>             req->io_task_work.func(req);
>>>>> +
>>>>> +    mutex_lock(&ctx->uring_lock);
>>>>> +    if (ctx->submit_state.compl_nr)
>>>>> +        io_submit_flush_completions(ctx);
>>>>> +    mutex_unlock(&ctx->uring_lock);
>>>> why do we protect io_submit_flush_completions() with uring_lock,
>>>> regarding that it is called in original context. Btw, why not
>>>> use ctx_flush_and_put()
>>>
>>> The fallback thing is called from a workqueue not the submitter task
>>> context. See delayed_work and so.
>>>
>>> Regarding locking, it touches struct io_submit_state, and it's protected by
>>> ->uring_lock. In particular we're interested in ->reqs and ->free_list.
>>> FWIW, there is refurbishment going on around submit state, so if proves
>>> useful the locking may change in coming months.
>>>
>>> ctx_flush_and_put() could have been used, but simpler to hand code it
>>> and avoid the (always messy) conditional ref grabbing and locking.
> 
>> I didn't get it, what do you mean 'avoid the (always messy) conditional
>> ref grabbing and locking'? the code here and in ctx_flush_and_put() are
>> same..though I think in ctx_flush_and_put(), there is a problem that
>> compl_nr should also be protected.
> 
> Ok, the long story. First, notice a ctx check at the beginning of
> ctx_flush_and_put(), that one is conditional. Even though we know
> it's not NULL, it's more confusing and might be a problem for
> static and human analysis.
> 
> Also, locking is never easy, and so IMHO it's preferable to keep
> lock() and a matching unlock (or get/put) in the same function if
> possible, much easier to read. Compare
> 
> ref_get();
> do_something();
> ref_put();
> 
> and
> 
> ref_get();
> do_something();
> flush_ctx();
> 
> I believe, the first one is of less mental overhead.
Thanks, got it.
> 

