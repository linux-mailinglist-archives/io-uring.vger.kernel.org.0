Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A3A1DE1EB
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 10:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgEVIdf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 04:33:35 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55126 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729068AbgEVIdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 04:33:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzGTfK9_1590136407;
Received: from 30.225.32.72(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzGTfK9_1590136407)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 May 2020 16:33:27 +0800
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
Date:   Fri, 22 May 2020 16:33:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi Pavel,

First thanks for reviewing!
> On 20/05/2020 14:56, Xiaoguang Wang wrote:
>>
>> To fix this issue, when io_uring instance uses IORING_SETUP_SQ_AFF to specify a
>> cpu,  we create a percpu io sq_thread to handle multiple io_uring instances' io
>> requests serially. With this patch, in same environment, we get a huge improvement:
> 
> Consider that a user can issue a long sequence of requests, say 2^15 of them,
> and all of them will happen in a single call to io_submit_sqes(). Just preparing
> them would take much time, apart from that it can do some effective work for
> each of them, e.g. copying a page. And now there is another io_uring, caring
> much about latencies and nevertheless waiting for _very_ long for its turn.
Indeed I had thought this case before and don't clearly know how to optimize it yet.
But I think if user has above usage scenarios, they probably shouldn't make io_uring
instances share same cpu core. I'd like to explain more about our usage scenarios.
In a physical machine, say there are 96 cores, and it runs multiple cgroups, every
cgroup run same application and will monopoly 16 cpu cores. This application will
create 16 io threads and every io thread will create an io_uring instance and every
thread will be bound to a different cpu core, these io threads will receive io requests.
If we enable SQPOLL for these io threads, we allocate one or two cpu cores for these
io_uring instances at most, so they must share allocated cpu core. It's totally disaster
that some io_uring instances' busy loop in their sq_thread_idle period will impact other
io_uring instances which have io requests to handle.

> 
> Another problem is that with it a user can't even guess when its SQ would be
> emptied, and would need to constantly poll.
In this patch, in every iteration, we only handle io requests already queued,
will not constantly poll.

> 
> In essence, the problem is in bypassing thread scheduling, and re-implementing
> poor man's version of it (round robin by io_uring).
Yes :) Currently I use round robin strategy to handle multiple io_uring instance
in every iteration.

> The idea and the reasoning are compelling, but I think we need to do something
> about unrelated io_uring instances obstructing each other. At least not making
> it mandatory behaviour.
> 
> E.g. it's totally fine by me, if a sqpoll kthread is shared between specified
> bunch of io_urings -- the user would be responsible for binding them and not
> screwing up latencies/whatever. Most probably there won't be much (priviledged)
> users using SQPOLL, and they all be a part of a single app, e.g. with
> multiple/per-thread io_urings.
Did you read my patch? In this patch, I have implemented this idea :)

> 
> Another way would be to switch between io_urings faster, e.g. after processing
> not all requests but 1 or some N of them. But that's very thin ice, and I
> already see other bag of issues.
Sounds good, could you please lift detailed issues? Thanks.

Regards,
Xiaoguang Wang
> 
> Ideas?
> 
> 
>> Run status group 0 (all jobs):
>>     READ: bw=3231MiB/s (3388MB/s), 3231MiB/s-3231MiB/s (3388MB/s-3388MB/s),
>> io=379GiB (407GB), run=120001-120001msec
>>
>> Link: https://lore.kernel.org/io-uring/c94098d2-279e-a552-91ec-8a8f177d770a@linux.alibaba.com/T/#t
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 257 +++++++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 232 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ed0c22eb9808..e49ff1f67681 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -258,8 +258,13 @@ struct io_ring_ctx {
>>   	/* IO offload */
>>   	struct io_wq		*io_wq;
>>   	struct task_struct	*sqo_thread;	/* if using sq thread polling */
>> +	wait_queue_head_t	*sqo_wait;
>> +	int			submit_status;
>> +	int			sq_thread_cpu;
>> +	struct list_head	node;
>> +
>>   	struct mm_struct	*sqo_mm;
>> -	wait_queue_head_t	sqo_wait;
>> +	wait_queue_head_t	__sqo_wait;
>>   
>>   	/*
>>   	 * If used, fixed file set. Writers must ensure that ->refs is dead,
>> @@ -330,6 +335,16 @@ struct io_ring_ctx {
>>   	struct work_struct		exit_work;
>>   };
>>   
>> +struct io_percpu_thread {
>> +	struct list_head ctx_list;
>> +	wait_queue_head_t sqo_percpu_wait;
>> +	struct mutex lock;
>> +	struct task_struct *sqo_thread;
>> +	unsigned int sq_thread_idle;
>> +};
>> +
>> +static struct io_percpu_thread __percpu *percpu_threads;
>> +
>>   /*
>>    * First field must be the file pointer in all the
>>    * iocb unions! See also 'struct kiocb' in <linux/fs.h>
>> @@ -926,9 +941,11 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>   		goto err;
>>   
>>   	ctx->flags = p->flags;
>> -	init_waitqueue_head(&ctx->sqo_wait);
>> +	init_waitqueue_head(&ctx->__sqo_wait);
>> +	ctx->sqo_wait = &ctx->__sqo_wait;
>>   	init_waitqueue_head(&ctx->cq_wait);
>>   	INIT_LIST_HEAD(&ctx->cq_overflow_list);
>> +	INIT_LIST_HEAD(&ctx->node);
>>   	init_completion(&ctx->completions[0]);
>>   	init_completion(&ctx->completions[1]);
>>   	idr_init(&ctx->io_buffer_idr);
>> @@ -1157,8 +1174,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>>   {
>>   	if (waitqueue_active(&ctx->wait))
>>   		wake_up(&ctx->wait);
>> -	if (waitqueue_active(&ctx->sqo_wait))
>> -		wake_up(&ctx->sqo_wait);
>> +	if (waitqueue_active(ctx->sqo_wait))
>> +		wake_up(ctx->sqo_wait);
>>   	if (io_should_trigger_evfd(ctx))
>>   		eventfd_signal(ctx->cq_ev_fd, 1);
>>   }
>> @@ -1980,8 +1997,8 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>>   		list_add_tail(&req->list, &ctx->poll_list);
>>   
>>   	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
>> -	    wq_has_sleeper(&ctx->sqo_wait))
>> -		wake_up(&ctx->sqo_wait);
>> +	    wq_has_sleeper(ctx->sqo_wait))
>> +		wake_up(ctx->sqo_wait);
>>   }
>>   
>>   static void io_file_put(struct io_submit_state *state)
>> @@ -5994,7 +6011,7 @@ static int io_sq_thread(void *data)
>>   				continue;
>>   			}
>>   
>> -			prepare_to_wait(&ctx->sqo_wait, &wait,
>> +			prepare_to_wait(ctx->sqo_wait, &wait,
>>   						TASK_INTERRUPTIBLE);
>>   
>>   			/*
>> @@ -6006,7 +6023,7 @@ static int io_sq_thread(void *data)
>>   			 */
>>   			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>>   			    !list_empty_careful(&ctx->poll_list)) {
>> -				finish_wait(&ctx->sqo_wait, &wait);
>> +				finish_wait(ctx->sqo_wait, &wait);
>>   				continue;
>>   			}
>>   
>> @@ -6018,23 +6035,23 @@ static int io_sq_thread(void *data)
>>   			to_submit = io_sqring_entries(ctx);
>>   			if (!to_submit || ret == -EBUSY) {
>>   				if (kthread_should_park()) {
>> -					finish_wait(&ctx->sqo_wait, &wait);
>> +					finish_wait(ctx->sqo_wait, &wait);
>>   					break;
>>   				}
>>   				if (current->task_works) {
>>   					task_work_run();
>> -					finish_wait(&ctx->sqo_wait, &wait);
>> +					finish_wait(ctx->sqo_wait, &wait);
>>   					continue;
>>   				}
>>   				if (signal_pending(current))
>>   					flush_signals(current);
>>   				schedule();
>> -				finish_wait(&ctx->sqo_wait, &wait);
>> +				finish_wait(ctx->sqo_wait, &wait);
>>   
>>   				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>>   				continue;
>>   			}
>> -			finish_wait(&ctx->sqo_wait, &wait);
>> +			finish_wait(ctx->sqo_wait, &wait);
>>   
>>   			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>>   		}
>> @@ -6058,6 +6075,133 @@ static int io_sq_thread(void *data)
>>   	return 0;
>>   }
>>   
>> +static int process_ctx(struct io_ring_ctx *ctx)
>> +{
>> +	unsigned int to_submit;
>> +	int ret = 0;
>> +
>> +	if (!list_empty(&ctx->poll_list)) {
>> +		unsigned nr_events = 0;
>> +
>> +		mutex_lock(&ctx->uring_lock);
>> +		if (!list_empty(&ctx->poll_list))
>> +			io_iopoll_getevents(ctx, &nr_events, 0);
>> +		mutex_unlock(&ctx->uring_lock);
>> +	}
>> +
>> +	to_submit = io_sqring_entries(ctx);
>> +	if (to_submit) {
>> +		mutex_lock(&ctx->uring_lock);
>> +		if (likely(!percpu_ref_is_dying(&ctx->refs)))
>> +			ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>> +		mutex_unlock(&ctx->uring_lock);
>> +	}
>> +
>> +	if (current->task_works)
>> +		task_work_run();
>> +
>> +	io_sq_thread_drop_mm(ctx);
>> +	return ret;
>> +}
>> +
>> +static int io_sq_percpu_thread(void *data)
>> +{
>> +	struct io_percpu_thread *t = data;
>> +	struct io_ring_ctx *ctx, *tmp;
>> +	mm_segment_t old_fs;
>> +	const struct cred *saved_creds, *cur_creds, *old_creds;
>> +	unsigned long timeout;
>> +	DEFINE_WAIT(wait);
>> +	int iters = 0;
>> +
>> +	timeout = jiffies + t->sq_thread_idle;
>> +	old_fs = get_fs();
>> +	set_fs(USER_DS);
>> +	saved_creds = cur_creds = NULL;
>> +	while (!kthread_should_park()) {
>> +		bool continue_run;
>> +		bool needs_wait;
>> +		unsigned int to_submit;
>> +
>> +		mutex_lock(&t->lock);
>> +again:
>> +		continue_run = false;
>> +		list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node) {
>> +			if (cur_creds != ctx->creds) {
>> +				old_creds = override_creds(ctx->creds);
>> +				cur_creds = ctx->creds;
>> +				if (saved_creds)
>> +					put_cred(old_creds);
>> +				else
>> +					saved_creds = old_creds;
>> +			}
>> +			ctx->submit_status = process_ctx(ctx);
>> +
>> +			to_submit = io_sqring_entries(ctx);
>> +			if (!continue_run &&
>> +			    ((to_submit && ctx->submit_status != -EBUSY) ||
>> +			    !list_empty(&ctx->poll_list)))
>> +				continue_run = true;
>> +		}
>> +		if (continue_run && (++iters & 7)) {
>> +			timeout = jiffies + t->sq_thread_idle;
>> +			goto again;
>> +		}
>> +		mutex_unlock(&t->lock);
>> +		if (continue_run) {
>> +			timeout = jiffies + t->sq_thread_idle;
>> +			continue;
>> +		}
>> +		if (!time_after(jiffies, timeout)) {
>> +			cond_resched();
>> +			continue;
>> +		}
>> +
>> +		needs_wait = true;
>> +		prepare_to_wait(&t->sqo_percpu_wait, &wait, TASK_INTERRUPTIBLE);
>> +		mutex_lock(&t->lock);
>> +		list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node) {
>> +			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>> +			    !list_empty_careful(&ctx->poll_list)) {
>> +				needs_wait = false;
>> +				break;
>> +			}
>> +			to_submit = io_sqring_entries(ctx);
>> +			if (to_submit && ctx->submit_status != -EBUSY) {
>> +				needs_wait = false;
>> +				break;
>> +			}
>> +		}
>> +		if (needs_wait) {
>> +			list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node)
>> +				ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
>> +			smp_mb();
>> +
>> +		}
>> +		mutex_unlock(&t->lock);
>> +
>> +		if (needs_wait) {
>> +			schedule();
>> +			mutex_lock(&t->lock);
>> +			list_for_each_entry_safe(ctx, tmp,
>> +						 &t->ctx_list, node)
>> +				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>> +			mutex_unlock(&t->lock);
>> +			finish_wait(&t->sqo_percpu_wait, &wait);
>> +		} else
>> +			finish_wait(&t->sqo_percpu_wait, &wait);
>> +		timeout = jiffies + t->sq_thread_idle;
>> +		cond_resched();
>> +	}
>> +
>> +	if (current->task_works)
>> +		task_work_run();
>> +	set_fs(old_fs);
>> +	revert_creds(saved_creds);
>> +	kthread_parkme();
>> +	return 0;
>> +}
>> +
>>   struct io_wait_queue {
>>   	struct wait_queue_entry wq;
>>   	struct io_ring_ctx *ctx;
>> @@ -6219,18 +6363,23 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>   	return 0;
>>   }
>>   
>> +static void destroy_io_percpu_thread(struct io_ring_ctx *ctx, int cpu);
>> +
>>   static void io_sq_thread_stop(struct io_ring_ctx *ctx)
>>   {
>>   	if (ctx->sqo_thread) {
>> -		wait_for_completion(&ctx->completions[1]);
>> -		/*
>> -		 * The park is a bit of a work-around, without it we get
>> -		 * warning spews on shutdown with SQPOLL set and affinity
>> -		 * set to a single CPU.
>> -		 */
>> -		kthread_park(ctx->sqo_thread);
>> -		kthread_stop(ctx->sqo_thread);
>> -		ctx->sqo_thread = NULL;
>> +		if (!(ctx->flags & IORING_SETUP_SQ_AFF)) {
>> +			wait_for_completion(&ctx->completions[1]);
>> +			/*
>> +			 * The park is a bit of a work-around, without it we get
>> +			 * warning spews on shutdown with SQPOLL set and affinity
>> +			 * set to a single CPU.
>> +			 */
>> +			kthread_park(ctx->sqo_thread);
>> +			kthread_stop(ctx->sqo_thread);
>> +			ctx->sqo_thread = NULL;
>> +		} else
>> +			destroy_io_percpu_thread(ctx, ctx->sq_thread_cpu);
>>   	}
>>   }
>>   
>> @@ -6841,6 +6990,52 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>>   	return ret;
>>   }
>>   
>> +static void create_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
>> +{
>> +	struct io_percpu_thread *t;
>> +
>> +	t = per_cpu_ptr(percpu_threads, cpu);
>> +	mutex_lock(&t->lock);
>> +	if (!t->sqo_thread) {
>> +		t->sqo_thread = kthread_create_on_cpu(io_sq_percpu_thread, t,
>> +					cpu, "io_uring_percpu-sq");
>> +		if (IS_ERR(t->sqo_thread)) {
>> +			ctx->sqo_thread = t->sqo_thread;
>> +			t->sqo_thread = NULL;
>> +			mutex_unlock(&t->lock);
>> +			return;
>> +		}
>> +	}
>> +
>> +	if (t->sq_thread_idle < ctx->sq_thread_idle)
>> +		t->sq_thread_idle = ctx->sq_thread_idle;
>> +	ctx->sqo_wait = &t->sqo_percpu_wait;
>> +	ctx->sq_thread_cpu = cpu;
>> +	list_add_tail(&ctx->node, &t->ctx_list);
>> +	ctx->sqo_thread = t->sqo_thread;
>> +	mutex_unlock(&t->lock);
>> +}
>> +
>> +static void destroy_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
>> +{
>> +	struct io_percpu_thread *t;
>> +	struct task_struct *sqo_thread = NULL;
>> +
>> +	t = per_cpu_ptr(percpu_threads, cpu);
>> +	mutex_lock(&t->lock);
>> +	list_del(&ctx->node);
>> +	if (list_empty(&t->ctx_list)) {
>> +		sqo_thread = t->sqo_thread;
>> +		t->sqo_thread = NULL;
>> +	}
>> +	mutex_unlock(&t->lock);
>> +
>> +	if (sqo_thread) {
>> +		kthread_park(sqo_thread);
>> +		kthread_stop(sqo_thread);
>> +	}
>> +}
>> +
>>   static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>   			       struct io_uring_params *p)
>>   {
>> @@ -6867,9 +7062,7 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>   			if (!cpu_online(cpu))
>>   				goto err;
>>   
>> -			ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
>> -							ctx, cpu,
>> -							"io_uring-sq");
>> +			create_io_percpu_thread(ctx, cpu);
>>   		} else {
>>   			ctx->sqo_thread = kthread_create(io_sq_thread, ctx,
>>   							"io_uring-sq");
>> @@ -7516,7 +7709,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>   		if (!list_empty_careful(&ctx->cq_overflow_list))
>>   			io_cqring_overflow_flush(ctx, false);
>>   		if (flags & IORING_ENTER_SQ_WAKEUP)
>> -			wake_up(&ctx->sqo_wait);
>> +			wake_up(ctx->sqo_wait);
>>   		submitted = to_submit;
>>   	} else if (to_submit) {
>>   		mutex_lock(&ctx->uring_lock);
>> @@ -8102,6 +8295,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>>   
>>   static int __init io_uring_init(void)
>>   {
>> +	int cpu;
>> +
>>   #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
>>   	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
>>   	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
>> @@ -8141,6 +8336,18 @@ static int __init io_uring_init(void)
>>   	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>>   	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>>   	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
>> +
>> +	percpu_threads = alloc_percpu(struct io_percpu_thread);
>> +	for_each_possible_cpu(cpu) {
>> +		struct io_percpu_thread *t;
>> +
>> +		t = per_cpu_ptr(percpu_threads, cpu);
>> +		INIT_LIST_HEAD(&t->ctx_list);
>> +		init_waitqueue_head(&t->sqo_percpu_wait);
>> +		mutex_init(&t->lock);
>> +		t->sqo_thread = NULL;
>> +		t->sq_thread_idle = 0;
>> +	}
>>   	return 0;
>>   };
>>   __initcall(io_uring_init);
>>
> 
