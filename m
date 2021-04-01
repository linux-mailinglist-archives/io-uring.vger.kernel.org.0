Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6167F350F78
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 08:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhDAGxU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 02:53:20 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38588 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhDAGxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 02:53:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UU2kGaR_1617259986;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UU2kGaR_1617259986)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 01 Apr 2021 14:53:06 +0800
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
Date:   Thu, 1 Apr 2021 14:53:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/1 上午6:06, Pavel Begunkov 写道:
> 
> 
> On 31/03/2021 10:01, Hao Xu wrote:
>> Now that we have multishot poll requests, one sqe can emit multiple
>> cqes. given below example:
>>      sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>> is a multishot poll request, sqe2 may be issued after sqe0's event
>> triggered twice before sqe1 completed. This isn't what users leverage
>> drain requests for.
>> Here a simple solution is to ignore all multishot poll cqes, which means
>> drain requests  won't wait those request to be done.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 513096759445..cd6d44cf5940 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -455,6 +455,7 @@ struct io_ring_ctx {
>>   	struct callback_head		*exit_task_work;
>>   
>>   	struct wait_queue_head		hash_wait;
>> +	unsigned                        multishot_cqes;
>>   
>>   	/* Keep this last, we don't need it for the fast path */
>>   	struct work_struct		exit_work;
>> @@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>>   	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>>   		struct io_ring_ctx *ctx = req->ctx;
>>   
>> -		return seq != ctx->cached_cq_tail
>> -				+ READ_ONCE(ctx->cached_cq_overflow);
>> +		return seq + ctx->multishot_cqes != ctx->cached_cq_tail
>> +			+ READ_ONCE(ctx->cached_cq_overflow);
>>   	}
>>   
>>   	return false;
>> @@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>   {
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   	unsigned flags = IORING_CQE_F_MORE;
>> +	bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
>>   
>>   	if (!error && req->poll.canceled) {
>>   		error = -ECANCELED;
>> @@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>   		req->poll.done = true;
>>   		flags = 0;
>>   	}
>> +	if (multishot_poll)
>> +		ctx->multishot_cqes++;
>> +
> 
> We need to make sure we do that only for a non-final complete, i.e.
> not killing request, otherwise it'll double account the last one.
Hi Pavel, I saw a killing request like iopoll_remove or async_cancel 
call io_cqring_fill_event() to create an ECANCELED cqe for the original 
poll request. So there could be cases like(even for single poll request):
   (1). add poll --> cancel poll, an ECANCELED cqe.
                                                   1sqe:1cqe   all good
   (2). add poll --> trigger event(queued to task_work) --> cancel poll, 
            an ECANCELED cqe --> task_work runs, another ECANCELED cqe.
                                                   1sqe:2cqes
I suggest we shall only emit one ECANCELED cqe.
Currently I only account cqe through io_poll_complete(), so ECANCELED 
cqe from io_poll_remove or async_cancel etc are not counted in.
> E.g. is failed __io_cqring_fill_event() in io_poll_complete() fine?
> Other places?
a failed __io_cqring_fill_event() doesn't produce a cqe but increment 
ctx->cached_cq_overflow, as long as a cqe is produced or 
cached_cq_overflow is +=1, it is ok.
> 
> Btw, we can use some tests :)
I'll do more tests.
> 
> 
>>   	io_commit_cqring(ctx);
>>   	return !(flags & IORING_CQE_F_MORE);
>>   }
>>
> 

