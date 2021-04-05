Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987943544E8
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhDEQLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 12:11:22 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:36945 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239590AbhDEQLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 12:11:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUcSP0S_1617639070;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUcSP0S_1617639070)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 06 Apr 2021 00:11:10 +0800
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
 <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
 <b3db5da8-1bce-530b-5542-c6f9b589a191@gmail.com>
 <49152a6e-6d8a-21f1-fd9c-8b764c21b2d3@linux.alibaba.com>
 <59d15355-4317-99af-c7c4-364d0e7c1682@gmail.com>
 <bc90166c-99ce-46c5-da7e-462dee896ad7@linux.alibaba.com>
 <dc62f2aa-3f08-2f6f-e2bc-274ea8b3910c@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <5392cd6d-9468-a04f-c58d-96ca60ef015b@linux.alibaba.com>
Date:   Tue, 6 Apr 2021 00:11:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <dc62f2aa-3f08-2f6f-e2bc-274ea8b3910c@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/5 上午7:07, Jens Axboe 写道:
> On 4/3/21 12:58 AM, Hao Xu wrote:
>> 在 2021/4/2 上午6:29, Pavel Begunkov 写道:
>>> On 01/04/2021 15:55, Hao Xu wrote:
>>>> 在 2021/4/1 下午6:25, Pavel Begunkov 写道:
>>>>> On 01/04/2021 07:53, Hao Xu wrote:
>>>>>> 在 2021/4/1 上午6:06, Pavel Begunkov 写道:
>>>>>>>
>>>>>>>
>>>>>>> On 31/03/2021 10:01, Hao Xu wrote:
>>>>>>>> Now that we have multishot poll requests, one sqe can emit multiple
>>>>>>>> cqes. given below example:
>>>>>>>>         sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>>>>>>>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>>>>>>>> is a multishot poll request, sqe2 may be issued after sqe0's event
>>>>>>>> triggered twice before sqe1 completed. This isn't what users leverage
>>>>>>>> drain requests for.
>>>>>>>> Here a simple solution is to ignore all multishot poll cqes, which means
>>>>>>>> drain requests  won't wait those request to be done.
>>>>>>>>
>>>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>      fs/io_uring.c | 9 +++++++--
>>>>>>>>      1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>> index 513096759445..cd6d44cf5940 100644
>>>>>>>> --- a/fs/io_uring.c
>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>> @@ -455,6 +455,7 @@ struct io_ring_ctx {
>>>>>>>>          struct callback_head        *exit_task_work;
>>>>>>>>            struct wait_queue_head        hash_wait;
>>>>>>>> +    unsigned                        multishot_cqes;
>>>>>>>>            /* Keep this last, we don't need it for the fast path */
>>>>>>>>          struct work_struct        exit_work;
>>>>>>>> @@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>>>>>>>>          if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>>>>>>>>              struct io_ring_ctx *ctx = req->ctx;
>>>>>>>>      -        return seq != ctx->cached_cq_tail
>>>>>>>> -                + READ_ONCE(ctx->cached_cq_overflow);
>>>>>>>> +        return seq + ctx->multishot_cqes != ctx->cached_cq_tail
>>>>>>>> +            + READ_ONCE(ctx->cached_cq_overflow);
>>>>>>>>          }
>>>>>>>>            return false;
>>>>>>>> @@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>>>>      {
>>>>>>>>          struct io_ring_ctx *ctx = req->ctx;
>>>>>>>>          unsigned flags = IORING_CQE_F_MORE;
>>>>>>>> +    bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
>>>>>>>>            if (!error && req->poll.canceled) {
>>>>>>>>              error = -ECANCELED;
>>>>>>>> @@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>>>>              req->poll.done = true;
>>>>>>>>              flags = 0;
>>>>>>>>          }
>>>>>>>> +    if (multishot_poll)
>>>>>>>> +        ctx->multishot_cqes++;
>>>>>>>> +
>>>>>>>
>>>>>>> We need to make sure we do that only for a non-final complete, i.e.
>>>>>>> not killing request, otherwise it'll double account the last one.
>>>>>> Hi Pavel, I saw a killing request like iopoll_remove or async_cancel call io_cqring_fill_event() to create an ECANCELED cqe for the original poll request. So there could be cases like(even for single poll request):
>>>>>>      (1). add poll --> cancel poll, an ECANCELED cqe.
>>>>>>                                                      1sqe:1cqe   all good
>>>>>>      (2). add poll --> trigger event(queued to task_work) --> cancel poll,            an ECANCELED cqe --> task_work runs, another ECANCELED cqe.
>>>>>>                                                      1sqe:2cqes
>>>>>
>>>>> Those should emit a CQE on behalf of the request they're cancelling
>>>>> only when it's definitely cancelled and not going to fill it
>>>>> itself. E.g. if io_poll_cancel() found it and removed from
>>>>> all the list and core's poll infra.
>>>>>
>>>>> At least before multi-cqe it should have been working fine.
>>>>>
>>>> I haven't done a test for this, but from the code logic, there could be
>>>> case below:
>>>>
>>>> io_poll_add()                         | io_poll_remove
>>>> (event happen)io_poll_wake()          | io_poll_remove_one
>>>>                                         | io_poll_remove_waitqs
>>>>                                         | io_cqring_fill_event(-ECANCELED)
>>>>                                         |
>>>> task_work run(io_poll_task_func)      |
>>>> io_poll_complete()                    |
>>>> req->poll.canceled is true, \         |
>>>> __io_cqring_fill_event(-ECANCELED)    |
>>>>
>>>> two ECANCELED cqes, is there anything I missed?
>>>
>>> Definitely may be be, but need to take a closer look
>>>
>> I'll do some test to test if this issue exists, and make some change if
>> it does.
> 
> How about something like this? Seems pointless to have an extra
> variable for this, when we already track if we're going to do more
> completions for this event or not. Also places the variable where
> it makes the most sense, and plenty of pad space there too.
> 
> Warning: totally untested. Would be great if you could, and hoping
> you're going to send out a v2.
> 
I'm writting a test for it, will send them together soon.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f94b32b43429..1eea4998ad9b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -423,6 +423,7 @@ struct io_ring_ctx {
>   		unsigned		cq_mask;
>   		atomic_t		cq_timeouts;
>   		unsigned		cq_last_tm_flush;
> +		unsigned		cq_extra;
>   		unsigned long		cq_check_overflow;
>   		struct wait_queue_head	cq_wait;
>   		struct fasync_struct	*cq_fasync;
> @@ -1183,8 +1184,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>   	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>   		struct io_ring_ctx *ctx = req->ctx;
>   
> -		return seq != ctx->cached_cq_tail
> -				+ READ_ONCE(ctx->cached_cq_overflow);
> +		return seq + ctx->cq_extra != ctx->cached_cq_tail
> +			+ READ_ONCE(ctx->cached_cq_overflow);
>   	}
>   
>   	return false;
> @@ -4894,6 +4895,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>   		req->poll.done = true;
>   		flags = 0;
>   	}
> +	if (flags & IORING_CQE_F_MORE)
> +		ctx->cq_extra++;
> +
>   	io_commit_cqring(ctx);
>   	return !(flags & IORING_CQE_F_MORE);
>   }
> 

