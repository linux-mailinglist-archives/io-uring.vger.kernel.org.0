Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF6E2DA641
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgLOCbW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 21:31:22 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50218 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727531AbgLOCbR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 21:31:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UIgKCiK_1607999433;
Received: from 30.225.32.197(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UIgKCiK_1607999433)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Dec 2020 10:30:33 +0800
Subject: Re: [PATCH] io_uring: hold uring_lock to complete faild polled io in
 io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
 <23ec9427-e904-f87f-2345-d040d9b10673@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <39f3c4a2-a81d-b4cd-c01f-d4bf59d708d8@linux.alibaba.com>
Date:   Tue, 15 Dec 2020 10:28:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <23ec9427-e904-f87f-2345-d040d9b10673@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 14/12/2020 15:49, Xiaoguang Wang wrote:
>> io_iopoll_complete() does not hold completion_lock to complete polled
>> io, so in io_wq_submit_work(), we can not call io_req_complete() directly,
>> to complete polled io, otherwise there maybe concurrent access to cqring,
>> defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
>> let io_iopoll_complete() complete polled io") has fixed this issue, but
>> Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
>> IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is
>> not good.
>>
>> Given that io_iopoll_complete() is always called under uring_lock, so here
>> for polled io, we can also get uring_lock to fix this issue.
> 
> One thing I don't like is that io_wq_submit_work() won't be able to
> publish an event while someone polling io_uring_enter(ENTER_GETEVENTS),
> that's because both take the lock. The problem is when the poller waits
> for an event that is currently in io-wq (i.e. io_wq_submit_work()).
> The polling loop will eventually exit, so that's not a deadlock, but
> latency,etc. would be huge.
In this patch, we just hold uring_lock for polled io in error path, so I think
normally it maybe not an issue, and seems that the critical section is not
that big, so it also may not result in huge latecy.
I also noticed that current codes also hold uring_lock in io_wq_submit_work()
call chain:
==> io_wq_submit_work()
====> io_issue_sqe()
======> io_provide_buffers()
========> io_ring_submit_lock(ctx, !force_nonblock);

Regards,
Xiaoguang Wang
> 
>>
>> Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 25 +++++++++++++++----------
>>   1 file changed, 15 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f53356ced5ab..eab3d2b7d232 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6354,19 +6354,24 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
>>   	}
>>   
>>   	if (ret) {
>> +		bool iopoll_enabled = req->ctx->flags & IORING_SETUP_IOPOLL;
>> +
>>   		/*
>> -		 * io_iopoll_complete() does not hold completion_lock to complete
>> -		 * polled io, so here for polled io, just mark it done and still let
>> -		 * io_iopoll_complete() complete it.
>> +		 * io_iopoll_complete() does not hold completion_lock to complete polled
>> +		 * io, so here for polled io, we can not call io_req_complete() directly,
>> +		 * otherwise there maybe concurrent access to cqring, defer_list, etc,
>> +		 * which is not safe. Given that io_iopoll_complete() is always called
>> +		 * under uring_lock, so here for polled io, we also get uring_lock to
>> +		 * complete it.
>>   		 */
>> -		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>> -			struct kiocb *kiocb = &req->rw.kiocb;
>> +		if (iopoll_enabled)
>> +			mutex_lock(&req->ctx->uring_lock);
>>   
>> -			kiocb_done(kiocb, ret, NULL);
>> -		} else {
>> -			req_set_fail_links(req);
>> -			io_req_complete(req, ret);
>> -		}
>> +		req_set_fail_links(req);
>> +		io_req_complete(req, ret);
>> +
>> +		if (iopoll_enabled)
>> +			mutex_unlock(&req->ctx->uring_lock);
>>   	}
>>   
>>   	return io_steal_work(req);
>>
> 
