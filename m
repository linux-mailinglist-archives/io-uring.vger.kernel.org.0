Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA72401F47
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 19:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhIFRmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 13:42:04 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48832 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244010AbhIFRmD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 13:42:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnW7BEi_1630950057;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnW7BEi_1630950057)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Sep 2021 01:40:57 +0800
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
 <b3ea4817-98d9-def8-d75e-9758ca7d1c33@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <8f3046d9-d678-f755-e7af-a0e5040699ca@linux.alibaba.com>
Date:   Tue, 7 Sep 2021 01:40:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b3ea4817-98d9-def8-d75e-9758ca7d1c33@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/6 下午11:56, Pavel Begunkov 写道:
> On 9/3/21 12:00 PM, Hao Xu wrote:
>> For operations like accept, multishot is a useful feature, since we can
>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>> be good for other operations in the future.
> 
> __io_arm_poll_handler()         |
>    -> vfs_poll()                 |
>                                  | io_async_task_func() // post CQE
>                                  | ...
>                                  | do_apoll_rewait();
>    -> continues after vfs_poll(),|
>       removing poll->head of     |
>       the second poll attempt.   |
> 
> 
Sorry.. a little bit confused by this case, would you mind explain a bit
more..is the right part a system-workqueue context? and is
do_apoll_rewait() io_poll_rewait() function?
> One of the reasons for forbidding multiple apoll's is that it
> might be racy. I haven't looked into this implementation, but
> we should check if there will be problems from that.
> 
> FWIW, putting aside this patchset, the poll/apoll is not in
> the best shape and can use some refactoring.
> 
> 
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index d6df60c4cdb9..dae7044e0c24 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>>   		return;
>>   	}
>>   
>> -	hash_del(&req->hash_node);
>> -	io_poll_remove_double(req);
>> +	if (READ_ONCE(apoll->poll.canceled))
>> +		apoll->poll.events |= EPOLLONESHOT;
>> +	if (apoll->poll.events & EPOLLONESHOT) {
>> +		hash_del(&req->hash_node);
>> +		io_poll_remove_double(req);
>> +	} else {
>> +		add_wait_queue(apoll->poll.head, &apoll->poll.wait);
>> +	}
>> +
>>   	spin_unlock(&ctx->completion_lock);
>>   
>>   	if (!READ_ONCE(apoll->poll.canceled))
>> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   	struct async_poll *apoll;
>>   	struct io_poll_table ipt;
>> -	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
>> +	__poll_t ret, mask = POLLERR | POLLPRI;
>>   	int rw;
>>   
>>   	if (!req->file || !file_can_poll(req->file))
>> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>   		rw = WRITE;
>>   		mask |= POLLOUT | POLLWRNORM;
>>   	}
>> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>> +		mask |= EPOLLONESHOT;
>>   
>>   	/* if we can't nonblock try, then no point in arming a poll handler */
>>   	if (!io_file_supports_nowait(req, rw))
>>
> 

