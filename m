Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431BE4084CB
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 08:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhIMGih (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 02:38:37 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53629 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237412AbhIMGif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 02:38:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo7Sptr_1631515038;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo7Sptr_1631515038)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 14:37:19 +0800
Subject: Re: [PATCH 1/4] io-wq: tweak return value of io_wqe_create_worker()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-2-haoxu@linux.alibaba.com>
 <9c01cd26-a569-7a99-964a-9436c8baa57f@kernel.dk>
 <1175a5b4-5c95-ff84-22cd-355590946e87@linux.alibaba.com>
 <06e27618-8b47-f926-5c7e-5346423006ea@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d75cf9ee-e9ae-e32b-b92c-8e12c2977b8f@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 14:37:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <06e27618-8b47-f926-5c7e-5346423006ea@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/13 上午5:34, Jens Axboe 写道:
> On 9/12/21 1:02 PM, Hao Xu wrote:
>> 在 2021/9/13 上午2:10, Jens Axboe 写道:
>>> On 9/11/21 1:40 PM, Hao Xu wrote:
>>>> The return value of io_wqe_create_worker() should be false if we cannot
>>>> create a new worker according to the name of this function.
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>    fs/io-wq.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>>> index 382efca4812b..1b102494e970 100644
>>>> --- a/fs/io-wq.c
>>>> +++ b/fs/io-wq.c
>>>> @@ -267,7 +267,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>>>    		return create_io_worker(wqe->wq, wqe, acct->index);
>>>>    	}
>>>>    
>>>> -	return true;
>>>> +	return false;
>>>>    }
>>>
>>> I think this is just a bit confusing. It's not an error case, we just
>>> didn't need to create a worker. So don't return failure, or the caller
>>> will think that we failed while we did not.
>> hmm, I think it is an error case----'we failed to create a new worker
>> since nr_worker == max_worker'. nr_worker == max_worker doesn't mean
>> 'no need', we may meet situation describled in 4/4: max_worker is 1,
> 
> But that's not an error case in the sense of "uh oh, we need to handle
> this as an error". If we're at the max worker count, the work simply has
> to wait for another work to be done and process it.
> 
>> currently 1 worker is running, and we return true here:
>>
>>             did_create = io_wqe_create_worker(wqe, acct);
>>
>>                //*******nr_workers changes******//
>>
>>             if (unlikely(!did_create)) {
>>                     raw_spin_lock(&wqe->lock);
>>                     /* fatal condition, failed to create the first worker */
>>                     if (!acct->nr_workers) {
>>                             raw_spin_unlock(&wqe->lock);
>>                             goto run_cancel;
>>                     }
>>                     raw_spin_unlock(&wqe->lock);
>>             }
>>
>> we will miss the next check, but we have to do the check, since
>> number of workers may decrease to 0 in //******// place.
> 
> If that happens, then the work that we have inserted has already been
> run. Otherwise how else could we have dropped to zero workers?
> 
Sorry, I see. I forgot the fix moved the place of nr_workers...
There is no problems now. Thanks for explanation, Jens.

  io_wqe_enqueue                   worker1
                                no work there and timeout
                                nr_workers--(after fix)
                                unlock(wqe->lock)
  ->insert work

  ->io_wqe_create_worker

                                ->io_worker_exit
                                  ->nr_workers--(before fix)



