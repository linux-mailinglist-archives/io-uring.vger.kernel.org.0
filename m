Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212C736D24A
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 08:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhD1GjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 02:39:13 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33566 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhD1GjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 02:39:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX2Q1dq_1619591907;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX2Q1dq_1619591907)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 14:38:27 +0800
Subject: Re: [PATCH 5.13] io_uring: don't set IORING_SQ_NEED_WAKEUP when
 sqthread is dying
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619527526-103300-1-git-send-email-haoxu@linux.alibaba.com>
 <24c7503d-769f-953e-854f-5090b4bfca3b@gmail.com>
 <68ce18b8-7bbd-f655-c745-f7cfaac76457@linux.alibaba.com>
Message-ID: <dbc1ccd4-54ae-3bf1-d15a-0322cfeeb885@linux.alibaba.com>
Date:   Wed, 28 Apr 2021 14:38:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <68ce18b8-7bbd-f655-c745-f7cfaac76457@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/27 下午10:35, Hao Xu 写道:
> 在 2021/4/27 下午9:13, Pavel Begunkov 写道:
>> On 4/27/21 1:45 PM, Hao Xu wrote:
>>> we don't need to re-fork the sqthread over exec, so no need to set
>>> IORING_SQ_NEED_WAKEUP when sqthread is dying.
>>
>> It forces users to call io_uring_enter() for it to return
>> -EOWNERDEAD. Consider that scenario with the ring given
>> away to some other task not in current group, e.g. via socket.
>>
> Ah, I see. Thank you Pavel.
Here I've a question: for processes that aren't in same group, io_uring
is now designed that sqthread cannot be shared between these processes?
But It seems if users do fork(), they can still call io_uring_enter()
in the forked task?
>> if (ctx->flags & IORING_SETUP_SQPOLL) {
>>     io_cqring_overflow_flush(ctx, false);
>>
>>     ret = -EOWNERDEAD;
>>     if (unlikely(ctx->sq_data->thread == NULL)) {
>>         goto out;
>>     }
>>     ...
>> }
>>
>> btw, can use a comment
>>
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 6b578c380e73..92dcd1c21516 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -6897,8 +6897,6 @@ static int io_sq_thread(void *data)
>>>       io_uring_cancel_sqpoll(sqd);
>>>       sqd->thread = NULL;
>>> -    list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>>> -        io_ring_set_wakeup_flag(ctx);
>>>       io_run_task_work();
>>>       io_run_task_work_head(&sqd->park_task_work);
>>>       mutex_unlock(&sqd->lock);
>>>
>>

