Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC2407C84
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 11:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhILJFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 05:05:32 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:47567 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232845AbhILJFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 05:05:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo24LUX_1631437456;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo24LUX_1631437456)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 17:04:16 +0800
Subject: Re: [PATCH 3/4] io-wq: fix worker->refcount when creating worker in
 work exit
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-4-haoxu@linux.alibaba.com>
 <e9ca65e1-46d7-de2d-e897-8cb3393c88f2@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e84feefc-7c71-a55c-1463-e74d800162d9@linux.alibaba.com>
Date:   Sun, 12 Sep 2021 17:04:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e9ca65e1-46d7-de2d-e897-8cb3393c88f2@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/12 上午6:13, Jens Axboe 写道:
> On 9/11/21 1:40 PM, Hao Xu wrote:
>> We may enter the worker creation path from io_worker_exit(), and
>> refcount is already zero, which causes definite failure of worker
>> creation.
>> io_worker_exit
>>                                ref = 0
>> ->io_wqe_dec_running
>>    ->io_queue_worker_create
>>      ->io_worker_get           failure since ref is 0
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 0e1288a549eb..75e79571bdfd 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -188,7 +188,9 @@ static void io_worker_exit(struct io_worker *worker)
>>   	list_del_rcu(&worker->all_list);
>>   	acct->nr_workers--;
>>   	preempt_disable();
>> +	refcount_set(&worker->ref, 1);
>>   	io_wqe_dec_running(worker);
>> +	refcount_set(&worker->ref, 0);
> 
> That kind of refcount manipulation is highly suspect. And in fact it
> should not be needed, io_worker_exit() clears ->flags before going on
> with worker teardown. Hence you can't hit worker creation from
> io_wqe_dec_running().
Doesn't see the relationship between worker->flags and the creation.
But yes, the creation path does io_worker_get() which causes failure
if it's from io_worker_exit(), Now I understand it is more like a
feature, isn't it? Anyway, the issue in 4/4 seems still there.

Regards,
Hao
> 

