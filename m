Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDC3E3487
	for <lists+io-uring@lfdr.de>; Sat,  7 Aug 2021 11:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhHGJ4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 05:56:44 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59149 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhHGJ4o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 05:56:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiDAP20_1628330184;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiDAP20_1628330184)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 07 Aug 2021 17:56:25 +0800
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-3-haoxu@linux.alibaba.com>
 <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
Date:   Sat, 7 Aug 2021 17:56:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/6 下午10:27, Jens Axboe 写道:
> On Thu, Aug 5, 2021 at 4:05 AM Hao Xu <haoxu@linux.alibaba.com> wrote:
>>
>> There is an acct->nr_worker visit without lock protection. Think about
>> the case: two callers call io_wqe_wake_worker(), one is the original
>> context and the other one is an io-worker(by calling
>> io_wqe_enqueue(wqe, linked)), on two cpus paralelly, this may cause
>> nr_worker to be larger than max_worker.
>> Let's fix it by adding lock for it, and let's do nr_workers++ before
>> create_io_worker. There may be a edge cause that the first caller fails
>> to create an io-worker, but the second caller doesn't know it and then
>> quit creating io-worker as well:
>>
>> say nr_worker = max_worker - 1
>>          cpu 0                        cpu 1
>>     io_wqe_wake_worker()          io_wqe_wake_worker()
>>        nr_worker < max_worker
>>        nr_worker++
>>        create_io_worker()         nr_worker == max_worker
>>           failed                  return
>>        return
>>
>> But the chance of this case is very slim.
>>
>> Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index cd4fd4d6268f..88d0ba7be1fb 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -247,9 +247,14 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>          ret = io_wqe_activate_free_worker(wqe);
>>          rcu_read_unlock();
>>
>> -       if (!ret && acct->nr_workers < acct->max_workers) {
>> -               atomic_inc(&acct->nr_running);
>> -               atomic_inc(&wqe->wq->worker_refs);
>> +       if (!ret) {
>> +               raw_spin_lock_irq(&wqe->lock);
>> +               if (acct->nr_workers < acct->max_workers) {
>> +                       atomic_inc(&acct->nr_running);
>> +                       atomic_inc(&wqe->wq->worker_refs);
>> +                       acct->nr_workers++;
>> +               }
>> +               raw_spin_unlock_irq(&wqe->lock);
>>                  create_io_worker(wqe->wq, wqe, acct->index);
>>          }
>>   }
> 
> There's a pretty grave bug in this patch, in that you no call
> create_io_worker() unconditionally. This causes obvious problems with
> misaccounting, and stalls that hit the idle timeout...
> 
This is surely a silly mistake, I'll check this patch and the 3/3 again.


