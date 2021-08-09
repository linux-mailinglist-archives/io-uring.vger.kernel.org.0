Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832B53E4737
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 16:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhHIOIz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 10:08:55 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:41416 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233795AbhHIOIz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 10:08:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiVbxQc_1628518113;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiVbxQc_1628518113)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Aug 2021 22:08:33 +0800
Subject: Re: [PATCH 1/2] io-wq: fix bug of creating io-wokers unconditionally
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210808135434.68667-1-haoxu@linux.alibaba.com>
 <20210808135434.68667-2-haoxu@linux.alibaba.com>
 <eb56a09e-0c10-2aad-ad94-f84947367f07@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <36fa131c-0a86-81de-2a93-265af921c38a@linux.alibaba.com>
Date:   Mon, 9 Aug 2021 22:08:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <eb56a09e-0c10-2aad-ad94-f84947367f07@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/9 下午10:01, Jens Axboe 写道:
> On 8/8/21 7:54 AM, Hao Xu wrote:
>> The former patch to add check between nr_workers and max_workers has a
>> bug, which will cause unconditionally creating io-workers. That's
>> because the result of the check doesn't affect the call of
>> create_io_worker(), fix it by bringing in a boolean value for it.
>>
>> Fixes: 21698274da5b ("io-wq: fix lack of acct->nr_workers < acct->max_workers judgement")
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 19 ++++++++++++++-----
>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 12fc19353bb0..5536b2a008d1 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -252,14 +252,15 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>   
>>   		raw_spin_lock_irq(&wqe->lock);
>>   		if (acct->nr_workers < acct->max_workers) {
>> -			atomic_inc(&acct->nr_running);
>> -			atomic_inc(&wqe->wq->worker_refs);
>>   			acct->nr_workers++;
>>   			do_create = true;
>>   		}
>>   		raw_spin_unlock_irq(&wqe->lock);
>> -		if (do_create)
>> +		if (do_create) {
>> +			atomic_inc(&acct->nr_running);
>> +			atomic_inc(&wqe->wq->worker_refs);
>>   			create_io_worker(wqe->wq, wqe, acct->index);
>> +		}
>>   	}
> 
> I don't get this hunk - we already know we're creating a worker, what's the
> point in moving the incs?
> 
Actually not much difference, I think we don't need to protect
nr_running and worker_refs by wqe->lock, so narrow the range of
raw_spin_lock_irq - raw_spin_unlock_irq

