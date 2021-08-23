Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7033F50A0
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhHWSqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 14:46:19 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:54864 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231857AbhHWSqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 14:46:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlQlpmV_1629744332;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlQlpmV_1629744332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Aug 2021 02:45:33 +0800
Subject: Re: [PATCH 2/2] io_uring: fix failed linkchain code logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823032506.34857-1-haoxu@linux.alibaba.com>
 <20210823032506.34857-3-haoxu@linux.alibaba.com>
 <7a680e7a-801e-4515-e67c-a3849c581d02@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d752f4b8-f5ed-d4db-8acc-4300fa010a00@linux.alibaba.com>
Date:   Tue, 24 Aug 2021 02:45:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7a680e7a-801e-4515-e67c-a3849c581d02@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/23 下午7:02, Pavel Begunkov 写道:
> On 8/23/21 4:25 AM, Hao Xu wrote:
>> Given a linkchain like this:
>> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
>>
>> There is a problem:
>>   - if some intermediate linked req like req1 's submittion fails, reqs
>>     after it won't be cancelled.
>>
>>     - sqpoll disabled: maybe it's ok since users can get the error info
>>       of req1 and stop submitting the following sqes.
>>
>>     - sqpoll enabled: definitely a problem, the following sqes will be
>>       submitted in the next round.
>>
>> The solution is to refactor the code logic to:
>>   - if a linked req's submittion fails, just mark it and the head(if it
>>     exists) as REQ_F_FAIL. Leverage req->result to indicate whether it
>>     is failed or cancelled.
>>   - submit or fail the whole chain when we come to the end of it.
> 
> This looks good to me, a couple of comments below.
> 
> 
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 45 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 44b1b2b58e6a..9ae8f2a5c584 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1776,8 +1776,6 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>   	req->ctx = ctx;
>>   	req->link = NULL;
>>   	req->async_data = NULL;
>> -	/* not necessary, but safer to zero */
>> -	req->result = 0;
> 
> Please leave it. I'm afraid of leaking stack to userspace because
> ->result juggling looks prone to errors. And preinit is pretty cold
> anyway.
> 
> [...]
> 
>>   
>> @@ -6637,19 +6644,25 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>   	ret = io_init_req(ctx, req, sqe);
>>   	if (unlikely(ret)) {
>>   fail_req:
>> +		/* fail even hard links since we don't submit */
>>   		if (link->head) {
>> -			/* fail even hard links since we don't submit */
>> -			io_req_complete_failed(link->head, -ECANCELED);
>> -			link->head = NULL;
>> +			req_set_fail(link->head);
> 
> I think it will be more reliable if we set head->result here, ...
Sure, I'll send v3 later.
> 
> if (!(link->head->flags & FAIL))
> 	link->head->result = -ECANCELED;
> 
>> -		ret = io_req_prep_async(req);
>> -		if (unlikely(ret))
>> -			goto fail_req;
>> +		if (!(req->flags & REQ_F_FAIL)) {
>> +			ret = io_req_prep_async(req);
>> +			if (unlikely(ret)) {
>> +				req->result = ret;
>> +				req_set_fail(req);
>> +				req_set_fail(link->head);
> 
> ... and here (a helper?), ...
> 
>> +			}
>> +		}
>>   		trace_io_uring_link(ctx, req, head);
>>   		link->last->link = req;
>>   		link->last = req;
>> @@ -6681,6 +6699,17 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>   		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
>>   			link->head = req;
>>   			link->last = req;
>> +			/*
>> +			 * we can judge a link req is failed or cancelled by if
>> +			 * REQ_F_FAIL is set, but the head is an exception since
>> +			 * it may be set REQ_F_FAIL because of other req's failure
>> +			 * so let's leverage req->result to distinguish if a head
>> +			 * is set REQ_F_FAIL because of its failure or other req's
>> +			 * failure so that we can set the correct ret code for it.
>> +			 * init result here to avoid affecting the normal path.
>> +			 */
>> +			if (!(req->flags & REQ_F_FAIL))
>> +				req->result = 0;
> 
> ... instead of delaying to this point. Just IMHO, it's easier to look
> after the code when it's set on the spot, i.e. may be easy to screw/forget
> something while changing bits around.
> 
> 
>>   		} else {
>>   			io_queue_sqe(req);
>>   		}
>>
> 

