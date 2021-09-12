Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8C6407F92
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhILTDW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 15:03:22 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50601 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234680AbhILTDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 15:03:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo51NL0_1631473324;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo51NL0_1631473324)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 03:02:05 +0800
Subject: Re: [PATCH 1/4] io-wq: tweak return value of io_wqe_create_worker()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-2-haoxu@linux.alibaba.com>
 <9c01cd26-a569-7a99-964a-9436c8baa57f@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1175a5b4-5c95-ff84-22cd-355590946e87@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 03:02:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9c01cd26-a569-7a99-964a-9436c8baa57f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/13 上午2:10, Jens Axboe 写道:
> On 9/11/21 1:40 PM, Hao Xu wrote:
>> The return value of io_wqe_create_worker() should be false if we cannot
>> create a new worker according to the name of this function.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 382efca4812b..1b102494e970 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -267,7 +267,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>   		return create_io_worker(wqe->wq, wqe, acct->index);
>>   	}
>>   
>> -	return true;
>> +	return false;
>>   }
> 
> I think this is just a bit confusing. It's not an error case, we just
> didn't need to create a worker. So don't return failure, or the caller
> will think that we failed while we did not.
hmm, I think it is an error case----'we failed to create a new worker
since nr_worker == max_worker'. nr_worker == max_worker doesn't mean
'no need', we may meet situation describled in 4/4: max_worker is 1,
currently 1 worker is running, and we return true here:

           did_create = io_wqe_create_worker(wqe, acct);

              //*******nr_workers changes******//

           if (unlikely(!did_create)) {
                   raw_spin_lock(&wqe->lock);
                   /* fatal condition, failed to create the first worker */
                   if (!acct->nr_workers) {
                           raw_spin_unlock(&wqe->lock);
                           goto run_cancel;
                   }
                   raw_spin_unlock(&wqe->lock);
           }

we will miss the next check, but we have to do the check, since
number of workers may decrease to 0 in //******// place.

or maybe we can see the return value as 'do we create a new worker or
not', and the next code do safe check if it is false.
> 

