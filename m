Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DBA3F356F
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbhHTUkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 16:40:05 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43057 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239307AbhHTUkF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 16:40:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UkTFmAa_1629491965;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UkTFmAa_1629491965)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 21 Aug 2021 04:39:25 +0800
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
Date:   Sat, 21 Aug 2021 04:39:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/21 上午2:59, Pavel Begunkov 写道:
> On 8/20/21 7:40 PM, Hao Xu wrote:
>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>> may cause problems when accessing it parallelly.
> 
> Did you hit any problem? It sounds like it should be fine as is:
> 
> The trick is that it's only responsible to flush requests added
> during execution of current call to tctx_task_work(), and those
> naturally synchronised with the current task. All other potentially
> enqueued requests will be of someone else's responsibility.
> 
> So, if nobody flushed requests, we're finely in-sync. If we see
> 0 there, but actually enqueued a request, it means someone
> actually flushed it after the request had been added.
> 
> Probably, needs a more formal explanation with happens-before
> and so.
I should put more detail in the commit message, the thing is:
say coml_nr > 0

   ctx_flush_and put                  other context
    if (compl_nr)                      get mutex
                                       coml_nr > 0
                                       do flush
                                           coml_nr = 0
                                       release mutex
         get mutex
            do flush (*)
         release mutex

in (*) place, we do a bunch of unnecessary works, moreover, we
call io_cqring_ev_posted() which I think we shouldn't.
> 
>>
>> Fixes: d10299e14aae ("io_uring: inline struct io_comp_state")
> 
> FWIW, it came much earlier than this commit, IIRC
> 
> commit 2c32395d8111037ae2cb8cab883e80bcdbb70713
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sun Feb 28 22:04:53 2021 +0000
> 
>      io_uring: fix __tctx_task_work() ctx race
> 
> 
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c755efdac71f..420f8dfa5327 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2003,11 +2003,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
>>   {
>>   	if (!ctx)
>>   		return;
>> -	if (ctx->submit_state.compl_nr) {
>> -		mutex_lock(&ctx->uring_lock);
>> +	mutex_lock(&ctx->uring_lock);
>> +	if (ctx->submit_state.compl_nr)
>>   		io_submit_flush_completions(ctx);
>> -		mutex_unlock(&ctx->uring_lock);
>> -	}
>> +	mutex_unlock(&ctx->uring_lock);
>>   	percpu_ref_put(&ctx->refs);
>>   }
>>   
>>
> 

