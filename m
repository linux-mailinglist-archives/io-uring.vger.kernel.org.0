Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5CD44524B
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhKDLh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Nov 2021 07:37:56 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:38944 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhKDLhz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Nov 2021 07:37:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uv1XkJq_1636025715;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uv1XkJq_1636025715)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Nov 2021 19:35:16 +0800
Subject: Re: [RFC] io-wq: decouple work_list protection from the big wqe->lock
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211031104945.224024-1-haoxu@linux.alibaba.com>
 <df8a6142-73f5-32e1-6ffd-7de1093abab9@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b77a69a7-5637-0d20-bbf1-d8d2936fdd16@linux.alibaba.com>
Date:   Thu, 4 Nov 2021 19:35:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <df8a6142-73f5-32e1-6ffd-7de1093abab9@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/4 上午3:10, Jens Axboe 写道:
> On 10/31/21 4:49 AM, Hao Xu wrote:
>> @@ -380,10 +382,14 @@ static void io_wqe_dec_running(struct io_worker *worker)
>>   	if (!(worker->flags & IO_WORKER_F_UP))
>>   		return;
>>   
>> +	raw_spin_lock(&acct->lock);
>>   	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
>> +		raw_spin_unlock(&acct->lock);
>>   		atomic_inc(&acct->nr_running);
>>   		atomic_inc(&wqe->wq->worker_refs);
>>   		io_queue_worker_create(worker, acct, create_worker_cb);
>> +	} else {
>> +		raw_spin_unlock(&acct->lock);
>>   	}
>>   }
> 
> I think this may be more readable as:
> 
> static void io_wqe_dec_running(struct io_worker *worker)
> 	__must_hold(wqe->lock)
> {
> 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
> 	struct io_wqe *wqe = worker->wqe;
> 
> 	if (!(worker->flags & IO_WORKER_F_UP))
> 		return;
> 	if (!atomic_dec_and_test(&acct->nr_running))
> 		return;
> 
> 	raw_spin_lock(&acct->lock);
> 	if (!io_acct_run_queue(acct)) {
> 		raw_spin_unlock(&acct->lock);
> 		return;
> 	}
> 
> 	raw_spin_unlock(&acct->lock);
> 	atomic_inc(&acct->nr_running);
> 	atomic_inc(&wqe->wq->worker_refs);
> 	io_queue_worker_create(worker, acct, create_worker_cb);
> }
> 
> ?
> 
> Patch looks pretty sane to me, but there's a lot of lock shuffling going
> on for it. Like in io_worker_handle_work(), and particularly in
> io_worker_handle_work(). I think it'd be worthwhile to spend some time
> to see if that could be improved. These days, lock contention is more
> about frequency of lock grabbing rather than hold time. Maybe clean
> nesting of wqe->lock -> acct->lock (which would be natural) can help
> that?
Sure, I'm working on reduce the lock contension further, will
update it and send the whole patchset later.

Regards,
Hao
> 

