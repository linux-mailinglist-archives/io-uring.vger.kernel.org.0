Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448313F3652
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhHTWVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:21:49 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33494 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231334AbhHTWVq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:21:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UkUcj3f_1629498066;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UkUcj3f_1629498066)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 21 Aug 2021 06:21:07 +0800
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b56102e9-a518-3829-c589-99e5acd32d03@linux.alibaba.com>
Date:   Sat, 21 Aug 2021 06:21:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/21 上午6:09, Jens Axboe 写道:
> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>> may cause problems when accessing it parallelly.
>>>>
>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>
>>>> The trick is that it's only responsible to flush requests added
>>>> during execution of current call to tctx_task_work(), and those
>>>> naturally synchronised with the current task. All other potentially
>>>> enqueued requests will be of someone else's responsibility.
>>>>
>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>> 0 there, but actually enqueued a request, it means someone
>>>> actually flushed it after the request had been added.
>>>>
>>>> Probably, needs a more formal explanation with happens-before
>>>> and so.
>>> I should put more detail in the commit message, the thing is:
>>> say coml_nr > 0
>>>
>>>    ctx_flush_and put                  other context
>>>     if (compl_nr)                      get mutex
>>>                                        coml_nr > 0
>>>                                        do flush
>>>                                            coml_nr = 0
>>>                                        release mutex
>>>          get mutex
>>>             do flush (*)
>>>          release mutex
>>>
>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>
>> I wouldn't care about overhead, that shouldn't be much
>>
>>> call io_cqring_ev_posted() which I think we shouldn't.
>>
>> IMHO, users should expect spurious io_cqring_ev_posted(),
>> though there were some eventfd users complaining before, so
>> for them we can do
> 
> It does sometimes cause issues, see:
> 
> commit b18032bb0a883cd7edd22a7fe6c57e1059b81ed0
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Jan 24 16:58:56 2021 -0700
> 
>      io_uring: only call io_cqring_ev_posted() if events were posted
> 
> I would tend to agree with Hao here, and the usual optimization idiom
> looks like:
> 
> if (struct->nr) {
> 	mutex_lock(&struct->lock);
> 	if (struct->nr)
> 		do_something();
> 	mutex_unlock(&struct->lock);
> }
> 
> like you posted, which would be fine and avoid this whole discussion :-)
> 
> Hao, care to spin a patch that does that?
no problem.
> 

