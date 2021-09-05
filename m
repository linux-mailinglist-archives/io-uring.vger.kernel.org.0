Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDE8400E69
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 08:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhIEG0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Sep 2021 02:26:13 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41609 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbhIEG0L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Sep 2021 02:26:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnGCEB0_1630823106;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnGCEB0_1630823106)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 05 Sep 2021 14:25:06 +0800
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <3cdcd28b-4723-32f8-5a0f-59fab8f4af27@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1542ac87-c518-3aa4-55ca-061f2761a1db@linux.alibaba.com>
Date:   Sun, 5 Sep 2021 14:25:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3cdcd28b-4723-32f8-5a0f-59fab8f4af27@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/5 上午6:43, Pavel Begunkov 写道:
> On 9/3/21 12:00 PM, Hao Xu wrote:
>> Update io_accept_prep() to enable multishot mode for accept operation.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index eb81d37dce78..34612646ae3c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>   	struct io_accept *accept = &req->accept;
>> +	bool is_multishot;
>>   
>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>   		return -EINVAL;
>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>>   
>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>> +		return -EINVAL;
> 
> Why REQ_F_FORCE_ASYNC is not allowed? It doesn't sound like there
> should be any problem, would just eventually go looping
> poll_wait + tw
Hmm..The arm_poll facility is only on the io_submit_sqes() path. If
FORCE_ASYNC is set, the req goes to io_wq_submit_work-->io_issue_sqe.
Moreover, I guess theoretically poll based retry and async iowq are
two ways for users to handle their sqes, it may not be sane to go to
poll based retry path if a user already forcely choose iowq as their
prefer way.
> 
>> +
>>   	accept->file_slot = READ_ONCE(sqe->file_index);
>>   	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
>> -				  (accept->flags & SOCK_CLOEXEC)))
>> +				  (accept->flags & SOCK_CLOEXEC) || is_multishot))
>>   		return -EINVAL;
>> -	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
>> +	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK | IORING_ACCEPT_MULTISHOT))
>>   		return -EINVAL;
>>   	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
>>   		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
>> +	if (is_multishot) {
>> +		req->flags |= REQ_F_APOLL_MULTISHOT;
>> +		accept->flags &= ~IORING_ACCEPT_MULTISHOT;
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>>
> 

