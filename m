Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0458836C7D2
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhD0Ogm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 10:36:42 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56359 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236411AbhD0Ogl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 10:36:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX-gULH_1619534156;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX-gULH_1619534156)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 22:35:56 +0800
Subject: Re: [PATCH 5.13] io_uring: don't set IORING_SQ_NEED_WAKEUP when
 sqthread is dying
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619527526-103300-1-git-send-email-haoxu@linux.alibaba.com>
 <24c7503d-769f-953e-854f-5090b4bfca3b@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <68ce18b8-7bbd-f655-c745-f7cfaac76457@linux.alibaba.com>
Date:   Tue, 27 Apr 2021 22:35:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <24c7503d-769f-953e-854f-5090b4bfca3b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/27 下午9:13, Pavel Begunkov 写道:
> On 4/27/21 1:45 PM, Hao Xu wrote:
>> we don't need to re-fork the sqthread over exec, so no need to set
>> IORING_SQ_NEED_WAKEUP when sqthread is dying.
> 
> It forces users to call io_uring_enter() for it to return
> -EOWNERDEAD. Consider that scenario with the ring given
> away to some other task not in current group, e.g. via socket.
> 
Ah, I see. Thank you Pavel.
> if (ctx->flags & IORING_SETUP_SQPOLL) {
> 	io_cqring_overflow_flush(ctx, false);
> 
> 	ret = -EOWNERDEAD;
> 	if (unlikely(ctx->sq_data->thread == NULL)) {
> 		goto out;
> 	}
> 	...
> }
> 
> btw, can use a comment
> 
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6b578c380e73..92dcd1c21516 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6897,8 +6897,6 @@ static int io_sq_thread(void *data)
>>   
>>   	io_uring_cancel_sqpoll(sqd);
>>   	sqd->thread = NULL;
>> -	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>> -		io_ring_set_wakeup_flag(ctx);
>>   	io_run_task_work();
>>   	io_run_task_work_head(&sqd->park_task_work);
>>   	mutex_unlock(&sqd->lock);
>>
> 

