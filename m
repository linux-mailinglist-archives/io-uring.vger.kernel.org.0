Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72BA40C3FA
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhIOKwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 06:52:15 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:37300 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhIOKwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 06:52:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoTik-I_1631703049;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoTik-I_1631703049)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 18:50:49 +0800
Subject: Re: [PATCH 2/2] io_uring: fix race between poll completion and
 cancel_hash insertion
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-3-haoxu@linux.alibaba.com>
 <b4d71d4e-187d-c96e-2122-e50362c8ead0@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <7db1302e-4064-73db-5c3e-bc98c03e54c4@linux.alibaba.com>
Date:   Wed, 15 Sep 2021 18:50:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b4d71d4e-187d-c96e-2122-e50362c8ead0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/15 下午6:12, Pavel Begunkov 写道:
> On 9/12/21 5:23 PM, Hao Xu wrote:
>> If poll arming and poll completion runs parallelly, there maybe races.
>> For instance, run io_poll_add in iowq and io_poll_task_func in original
>> context, then:
>>               iowq                          original context
>>    io_poll_add
>>      vfs_poll
>>       (interruption happens
>>        tw queued to original
>>        context)                              io_poll_task_func
>>                                                generate cqe
>>                                                del from cancel_hash[]
>>      if !poll.done
>>        insert to cancel_hash[]
>>
>> The entry left in cancel_hash[], similar case for fast poll.
>> Fix it by set poll.done = true when del from cancel_hash[].
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>
>> Didn't find the exact commit to add Fixes: for..
>>
>>   fs/io_uring.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c16f6be3d46b..988679e5063f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5118,10 +5118,8 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
>>   	}
>>   	if (req->poll.events & EPOLLONESHOT)
>>   		flags = 0;
>> -	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
>> -		req->poll.done = true;
>> +	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
>>   		flags = 0;
>> -	}
>>   	if (flags & IORING_CQE_F_MORE)
>>   		ctx->cq_extra++;
>>   
>> @@ -5152,6 +5150,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>>   		if (done) {
>>   			io_poll_remove_double(req);
>>   			hash_del(&req->hash_node);
>> +			req->poll.done = true;
>>   		} else {
>>   			req->result = 0;
>>   			add_wait_queue(req->poll.head, &req->poll.wait);
>> @@ -5289,6 +5288,7 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>>   
>>   	hash_del(&req->hash_node);
>>   	io_poll_remove_double(req);
>> +	req->poll.done = true;
> 
> Only poll request has req->poll. E.g. it overwrites parts of req->rw.kiocb,
> I guess .ki_complete in particular.
> 
> struct async_poll *apoll = req->apoll;
> apoll->poll.done = true;
Thanks!
> 
> 
>>   	spin_unlock(&ctx->completion_lock);
>>   
>>   	if (!READ_ONCE(apoll->poll.canceled))
>>
> 

