Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E8C3F174B
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhHSKax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 06:30:53 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49688 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238043AbhHSKaw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 06:30:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uk1dW06_1629369014;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uk1dW06_1629369014)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Aug 2021 18:30:14 +0800
Subject: Re: [PATCH 2/3] io_uring: fix failed linkchain code logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
 <20210818074316.22347-3-haoxu@linux.alibaba.com>
 <d23478e6-2d2f-dbc1-91c0-b091b3c6cbc9@gmail.com>
 <9a27608b-bb14-e3e8-09e3-08f182260937@linux.alibaba.com>
 <6c8941c1-c56d-3c4e-9d71-e5ed73a9db41@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <644e922d-fc79-ed8a-1633-f88c5e7ee58f@linux.alibaba.com>
Date:   Thu, 19 Aug 2021 18:30:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <6c8941c1-c56d-3c4e-9d71-e5ed73a9db41@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/18 下午10:40, Pavel Begunkov 写道:
> On 8/18/21 1:22 PM, Hao Xu wrote:
>> 在 2021/8/18 下午6:20, Pavel Begunkov 写道:
>>> On 8/18/21 8:43 AM, Hao Xu wrote:
>>>> Given a linkchain like this:
>>>> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
>>>>
> [...]
>>>>        struct io_submit_link *link = &ctx->submit_state.link;
>>>> +    bool is_link = sqe->flags & (IOSQE_IO_LINK | IOSQE_IO_HARDLINK);
>>>> +    struct io_kiocb *head;
>>>>        int ret;
>>>>    +    /*
>>>> +     * we don't update link->last until we've done io_req_prep()
>>>> +     * since linked timeout uses old link->last
>>>> +     */
>>>> +    if (link->head)
>>>> +        link->last->link = req;
>>>> +    else if (is_link)
>>>> +        link->head = req;
>>>> +    head = link->head;
>>>
>>> It's a horrorsome amount of overhead. How about to set the fail flag
>>> if failed early and actually fail on io_queue_sqe(), as below. It's
>>> not tested and a couple more bits added, but hopefully gives the idea.
>> I get the idea, it's truely with less change. But why do you think the
>> above code bring in more overhead, since anyway we have to link the req
>> to the linkchain. I tested it with fio-direct-4k-read-with/without-sqpoll, didn't see performance regression.
> 
> Well, it's an exaggeration :) However, we were cutting the overhead,
> and there is no atomics or other heavy operations left in the hot path,
> just pure number of instructions a request should go through. That's
> just to clear the reason why I don't want extras on the path.
> 
> For the non-linked path, first it adds 2 ifs in front and removes one
> at the end. Then there is is_link, which is most likely to be saved
> on stack. And same with @head which I'd expect to be saved on stack.
Agree on most part except the @head, despite cache hit, a direct stack
variable head is better than a stack pointer link.
I'm excited to see io_uring is becoming faster and faster since we are
actively using it. Thanks for the great work, the recent refcount
optimization is amazing.
I'll send a v2 patchset.

Thanks,
Hao
> 
> If we have a way to avoid it, that's great, and it looks we can.
> 
> [...]
>>>    -    ret = io_req_prep(req, sqe);
>>> -    if (unlikely(ret))
>>> -        goto fail_req;
>>>          /* don't need @sqe from now on */
>>>        trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
>>> @@ -6670,8 +6670,10 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>            struct io_kiocb *head = link->head;
>>>    
>> maybe better to add an if(head & FAIL) here, since we don't need to
>> prep_async if we know it will be cancelled.
> 
> Such an early fail is marginal enough to not care about performance,
> but I agree that the check is needed as io_req_prep_async() won't be
> able to handle it. E.g. if it failed to grab a file.
> 

