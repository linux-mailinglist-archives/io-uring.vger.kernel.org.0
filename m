Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8874C3DF3E0
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhHCRZv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 13:25:51 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:4649 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238069AbhHCRZu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 13:25:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UhtjYqf_1628011537;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UhtjYqf_1628011537)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 Aug 2021 01:25:37 +0800
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
To:     Jens Axboe <axboe@kernel.dk>, Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <12e58686-bffe-ba42-d7a3-20d35b26eaf7@linux.alibaba.com>
Date:   Wed, 4 Aug 2021 01:25:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/3 下午10:37, Jens Axboe 写道:
> On 8/3/21 7:22 AM, Jens Axboe wrote:
>> On 8/2/21 7:05 PM, Nadav Amit wrote:
>>> Hello Jens,
>>>
>>> I encountered an issue, which appears to be a race between
>>> io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to address
>>> this issue and whether I am missing something, since this seems to
>>> occur in a common scenario. Your feedback (or fix ;-)) would be
>>> appreciated.
>>>
>>> I run on 5.13 a workload that issues multiple async read operations
>>> that should run concurrently. Some read operations can not complete
>>> for unbounded time (e.g., read from a pipe that is never written to).
>>> The problem is that occasionally another read operation that should
>>> complete gets stuck. My understanding, based on debugging and the code
>>> is that the following race (or similar) occurs:
>>>
>>>
>>>    cpu0					cpu1
>>>    ----					----
>>> 					io_wqe_worker()
>>> 					 schedule_timeout()
>>> 					 // timed out
>>>    io_wqe_enqueue()
>>>     io_wqe_wake_worker()
>>>      // work_flags & IO_WQ_WORK_CONCURRENT
>>>      io_wqe_activate_free_worker()
>>> 					 io_worker_exit()
>>>
>>>
>>> Basically, io_wqe_wake_worker() can find a worker, but this worker is
>>> about to exit and is not going to process further work. Once the
>>> worker exits, the concurrency level decreases and async work might be
>>> blocked by another work. I had a look at 5.14, but did not see
>>> anything that might address this issue.
>>>
>>> Am I missing something?
>>>
>>> If not, all my ideas for a solution are either complicated (track
>>> required concurrency-level) or relaxed (span another worker on
>>> io_worker_exit if work_list of unbounded work is not empty).
>>>
>>> As said, feedback would be appreciated.
>>
>> You are right that there's definitely a race here between checking the
>> freelist and finding a worker, but that worker is already exiting. Let
>> me mull over this a bit, I'll post something for you to try later today.
> 
> Can you try something like this? Just consider it a first tester, need
> to spend a bit more time on it to ensure we fully close the gap.
> 
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cf086b01c6c6..e2da2042ee9e 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -42,6 +42,7 @@ struct io_worker {
>   	refcount_t ref;
>   	unsigned flags;
>   	struct hlist_nulls_node nulls_node;
> +	unsigned long exiting;
>   	struct list_head all_list;
>   	struct task_struct *task;
>   	struct io_wqe *wqe;
> @@ -214,15 +215,20 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
>   	struct hlist_nulls_node *n;
>   	struct io_worker *worker;
>   
> -	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
> -	if (is_a_nulls(n))
> -		return false;
> -
> -	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
> -	if (io_worker_get(worker)) {
> -		wake_up_process(worker->task);
> +	/*
> +	 * Iterate free_list and see if we can find an idle worker to
> +	 * activate. If a given worker is on the free_list but in the process
> +	 * of exiting, keep trying.
> +	 */
> +	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
> +		if (!io_worker_get(worker))
> +			continue;
> +		if (!test_bit(0, &worker->exiting)) {
> +			wake_up_process(worker->task);
> +			io_worker_release(worker);
> +			return true;
> +		}
>   		io_worker_release(worker);
> -		return true;
>   	}
>   
>   	return false;
> @@ -560,8 +566,17 @@ static int io_wqe_worker(void *data)
>   		if (ret)
>   			continue;
>   		/* timed out, exit unless we're the fixed worker */
> -		if (!(worker->flags & IO_WORKER_F_FIXED))
> +		if (!(worker->flags & IO_WORKER_F_FIXED)) {
> +			/*
> +			 * Someone elevated our refs, which could be trying
> +			 * to re-activate for work. Loop one more time for
> +			 * that case.
> +			 */
> +			if (refcount_read(&worker->ref) != 1)
> +				continue;
> +			set_bit(0, &worker->exiting);
>   			break;
> +		}
>   	}
>   
>   	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
> 

refcount check may not be enough, we may need another bit worker->in_use
and:
     io_wqe_activate_free_worker                io_wqe_worker

      set_bit(worker->in_use)               set_bit(worker->exiting)
      !test_bit(worker->exiting)            test_bit(worker->in_use)
      wake_up(worker)                       goto handle work
