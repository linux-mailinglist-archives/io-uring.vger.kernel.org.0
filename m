Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6451E0514
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 05:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbgEYDQh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 23:16:37 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51346 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388419AbgEYDQg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 23:16:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzVMaSb_1590376592;
Received: from 30.225.32.162(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzVMaSb_1590376592)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 May 2020 11:16:32 +0800
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
To:     Yu Jian Wu <yujian.wu1@gmail.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com, asml.silence@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <047242f8-ebc4-d2bd-5ca0-4cce45a96100@linux.alibaba.com>
 <20200522111732.GA20291@amber>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e0f47684-8431-599d-7451-bed64b18c401@linux.alibaba.com>
Date:   Mon, 25 May 2020 11:16:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522111732.GA20291@amber>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On Wed, May 20, 2020 at 08:11:04PM +0800, Xiaoguang Wang wrote:
>> hi,
>>
>> There're still some left work to do, fox example, use srcu to protect multiple
>> ctxs iteration to reduce mutex lock competition, make percpu thread aware of
>> cpu hotplug, but I send it now for some early comments, thanks in advance!
>>
>> Regards,
>> Xiaoguang Wang
> 
> Hi,
> 
> Thanks for doing this!
> Speaking as someone who tried this and really struggled with a few parts.
> 
> Few comments below.
> 
> W.r.t Pavel's comments on how to do this fairly, I think the only way is
> for this multiple ctx thread to handle all the ctxs fairly is to queue all
> the work and do it async rather than inline.
Look like that you mean every io_sq_thread always uses REQ_F_FORCE_ASYNC to
submit reqs. I'm not sure it's efficient. Queuing works to io-wq should be
a fast job, then that means io_sq_thread will just do busy loop other than
queuing works most of time, which will waste cpu resource the io_sq_thread
is bound to. What I want to express is that io_sq_thead should do some real
job, not just queue the work.

>>> +		needs_wait = true;
>>> +		prepare_to_wait(&t->sqo_percpu_wait, &wait, TASK_INTERRUPTIBLE);
>>> +		mutex_lock(&t->lock);
>>> +		list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node) {
>>> +			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>>> +			    !list_empty_careful(&ctx->poll_list)) {
>>> +				needs_wait = false;
>>> +				break;
>>> +			}
>>> +			to_submit = io_sqring_entries(ctx);
> 
> Unless I'm mistaken, I don't think these are submitted anywher
Yes, before io_sq_thread goes to sleep, it'll check whether some ctxs has
new sqes to handle, if "to_submit" is greater than zero, io_sq_thread will
skip the sleep and continue to handle these new sqes.

> 
>>> +			if (to_submit && ctx->submit_status != -EBUSY) {
>>> @@ -6841,6 +6990,52 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>>>    	return ret;
>>>    }
>>> +static void create_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
>>> +{
>>> +	struct io_percpu_thread *t;
>>> +
>>> +	t = per_cpu_ptr(percpu_threads, cpu);
>>> +	mutex_lock(&t->lock);
>>> +	if (!t->sqo_thread) {
>>> +		t->sqo_thread = kthread_create_on_cpu(io_sq_percpu_thread, t,
>>> +					cpu, "io_uring_percpu-sq");
>>> +		if (IS_ERR(t->sqo_thread)) {
>>> +			ctx->sqo_thread = t->sqo_thread;
>>> +			t->sqo_thread = NULL;
>>> +			mutex_unlock(&t->lock);
>>> +			return;
>>> +		}
>>> +	}
>>> +
>>> +	if (t->sq_thread_idle < ctx->sq_thread_idle)
>>> +		t->sq_thread_idle = ctx->sq_thread_idle;
> 
> Is max really the best way to do this?
> Or should it be per ctx?
Because these ctxs are sharing same io_sq_thread, and I think sq_thread_idle is to
control when io_sq_thread can go to sleep, so we should choose a max value.

Regards,
Xiaoguang Wang

> 
> Suppose the first ctx has a
> sq_thread_idle of something very small, and the second has a
> sq_thread_idle of 500ms, this will cause the loop to iterate over the
> first ctx even though it should have been considered idle a long time
> ago.

> 
>>> +	ctx->sqo_wait = &t->sqo_percpu_wait;
>>> +	ctx->sq_thread_cpu = cpu;
>>> +	list_add_tail(&ctx->node, &t->ctx_list);
>>> +	ctx->sqo_thread = t->sqo_thread;
>>> +	mutex_unlock(&t->lock);
>>> +}
>>> +
>>> +static void destroy_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
>>> +{
>>> +	struct io_percpu_thread *t;
>>> +	struct task_struct *sqo_thread = NULL;
>>> +
>>> +	t = per_cpu_ptr(percpu_threads, cpu);
>>> +	mutex_lock(&t->lock);
>>> +	list_del(&ctx->node);
>>> +	if (list_empty(&t->ctx_list)) {
>>> +		sqo_thread = t->sqo_thread;
>>> +		t->sqo_thread = NULL;
>>> +	}
>>> +	mutex_unlock(&t->lock);
>>> +
>>> +	if (sqo_thread) {
>>> +		kthread_park(sqo_thread);
>>> +		kthread_stop(sqo_thread);
>>> +	}
>>> +}
>>> +
>>>    static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>    			       struct io_uring_params *p)
>>>    {
>>> @@ -6867,9 +7062,7 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>    			if (!cpu_online(cpu))
>>>    				goto err;
>>> -			ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
>>> -							ctx, cpu,
>>> -							"io_uring-sq");
>>> +			create_io_percpu_thread(ctx, cpu);
>>>    		} else {
>>>    			ctx->sqo_thread = kthread_create(io_sq_thread, ctx,
>>>    							"io_uring-sq");
>>> @@ -7516,7 +7709,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>    		if (!list_empty_careful(&ctx->cq_overflow_list))
>>>    			io_cqring_overflow_flush(ctx, false);
>>>    		if (flags & IORING_ENTER_SQ_WAKEUP)
>>> -			wake_up(&ctx->sqo_wait);
>>> +			wake_up(ctx->sqo_wait);
>>>    		submitted = to_submit;
>>>    	} else if (to_submit) {
>>>    		mutex_lock(&ctx->uring_lock);
>>> @@ -8102,6 +8295,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>>>    static int __init io_uring_init(void)
>>>    {
>>> +	int cpu;
>>> +
>>>    #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
>>>    	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
>>>    	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
>>> @@ -8141,6 +8336,18 @@ static int __init io_uring_init(void)
>>>    	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>>>    	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>>>    	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
>>> +
>>> +	percpu_threads = alloc_percpu(struct io_percpu_thread);
>>> +	for_each_possible_cpu(cpu) {
>>> +		struct io_percpu_thread *t;
>>> +
>>> +		t = per_cpu_ptr(percpu_threads, cpu);
>>> +		INIT_LIST_HEAD(&t->ctx_list);
>>> +		init_waitqueue_head(&t->sqo_percpu_wait);
>>> +		mutex_init(&t->lock);
>>> +		t->sqo_thread = NULL;
>>> +		t->sq_thread_idle = 0;
>>> +	}
>>>    	return 0;
>>>    };
>>>    __initcall(io_uring_init);
>>>
> Thanks!
> 
