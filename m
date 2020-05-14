Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D021D2A02
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgENIZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 04:25:55 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60480 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbgENIZz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 04:25:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TyW0w0i_1589444749;
Received: from 30.225.32.37(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TyW0w0i_1589444749)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 May 2020 16:25:49 +0800
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
Date:   Thu, 14 May 2020 16:25:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> +
> +static void io_req_cache_free_bulk(struct req_batch *rb)
> +{
> +	struct io_kiocb_cache_entry *ce;
> +	struct io_kiocb_cache *cache;
> +
> +	if (rb->irq_comp)
> +		local_irq_disable();
> +	else
> +		preempt_disable();
> +
> +	cache = this_cpu_ptr(alloc_cache);
> +	ce = &cache->caches[rb->irq_comp];
> +
> +	list_splice_init(&rb->list, &ce->alloc_list);
> +	ce->nr_avail += rb->to_free;
> +	if (ce->nr_avail > IO_KIOCB_CACHE_MAX)
> +		io_req_cache_reclaim(ce);
> +
> +	if (rb->irq_comp)
> +		local_irq_enable();
> +	else
> +		preempt_enable();
> +}
> +
> +static void io_req_cache_free(struct io_kiocb *req)
> +{
> +	const bool irq_comp = io_op_defs[req->opcode].irq_comp;
> +	struct io_kiocb_cache_entry *ce;
> +	struct io_kiocb_cache *cache;
> +	unsigned long flags;
> +
> +	if (irq_comp)
> +		local_irq_save(flags);
> +	else
> +		preempt_disable();
> +
> +	cache = this_cpu_ptr(alloc_cache);
> +	ce = &cache->caches[irq_comp];
> +
> +	list_add(&req->list, &ce->alloc_list);
> +	if (++ce->nr_avail > IO_KIOCB_CACHE_MAX)
> +		io_req_cache_reclaim(ce);
Above codes seem that io_req_cache_reclaim() will free all reqs in alloc_list,
then we'll need to kmem_cache_alloc() again, I guess indeed you intend to reserve
IO_KIOCB_CACHE_MAX reqs in alloc_list?

I still use my previous io_uring_nop_stress tool to evaluate the improvement
in a physical machine. Memory 250GB and cpu is "Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz".
Before this patch:
$sudo taskset -c 60 ./io_uring_nop_stress -r 300
total ios: 1608773840
IOPS:      5362579

With this patch:
sudo taskset -c 60 ./io_uring_nop_stress -r 300
total ios: 1676910736
IOPS:      5589702
About 4.2% improvement.

Regards,
Xiaoguang Wang
> +
> +	if (irq_comp)
> +		local_irq_restore(flags);
> +	else
> +		preempt_enable();
> +}
> +
> +static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx, int opcode)
> +{
> +	struct io_kiocb *req;
> +
> +	req = io_req_cache_alloc(opcode);
> +	if (req) {
> +		req->opcode = opcode;
> +		return req;
> +	}
> +
> +	return io_get_fallback_req(ctx, opcode);
>   }
>   
>   static inline void io_put_file(struct io_kiocb *req, struct file *file,
> @@ -1345,7 +1449,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
>   	if (req->flags & REQ_F_NEED_CLEANUP)
>   		io_cleanup_req(req);
>   
> -	kfree(req->io);
> +	if (req->io)
> +		kfree(req->io);
>   	if (req->file)
>   		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>   	if (req->task)
> @@ -1371,28 +1476,21 @@ static void __io_free_req(struct io_kiocb *req)
>   
>   	percpu_ref_put(&req->ctx->refs);
>   	if (likely(!io_is_fallback_req(req)))
> -		kmem_cache_free(req_cachep, req);
> +		io_req_cache_free(req);
>   	else
>   		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
>   }
>   
> -struct req_batch {
> -	void *reqs[IO_IOPOLL_BATCH];
> -	int to_free;
> -	int need_iter;
> -};
> -
>   static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>   {
>   	if (!rb->to_free)
>   		return;
>   	if (rb->need_iter) {
> -		int i, inflight = 0;
> +		struct io_kiocb *req;
>   		unsigned long flags;
> +		int inflight = 0;
>   
> -		for (i = 0; i < rb->to_free; i++) {
> -			struct io_kiocb *req = rb->reqs[i];
> -
> +		list_for_each_entry(req, &rb->list, list) {
>   			if (req->flags & REQ_F_FIXED_FILE) {
>   				req->file = NULL;
>   				percpu_ref_put(req->fixed_file_refs);
> @@ -1405,9 +1503,7 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>   			goto do_free;
>   
>   		spin_lock_irqsave(&ctx->inflight_lock, flags);
> -		for (i = 0; i < rb->to_free; i++) {
> -			struct io_kiocb *req = rb->reqs[i];
> -
> +		list_for_each_entry(req, &rb->list, list) {
>   			if (req->flags & REQ_F_INFLIGHT) {
>   				list_del(&req->inflight_entry);
>   				if (!--inflight)
> @@ -1420,9 +1516,10 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>   			wake_up(&ctx->inflight_wait);
>   	}
>   do_free:
> -	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
> +	io_req_cache_free_bulk(rb);
>   	percpu_ref_put_many(&ctx->refs, rb->to_free);
> -	rb->to_free = rb->need_iter = 0;
> +	rb->to_free = 0;
> +	rb->need_iter = rb->irq_comp = false;
>   }
>   
>   static bool io_link_cancel_timeout(struct io_kiocb *req)
> @@ -1670,11 +1767,12 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
>   		return false;
>   
>   	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
> -		rb->need_iter++;
> +		rb->need_iter |= true;
> +	if (!rb->irq_comp && io_op_defs[req->opcode].irq_comp)
> +		rb->irq_comp |= true;
>   
> -	rb->reqs[rb->to_free++] = req;
> -	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
> -		io_free_req_many(req->ctx, rb);
> +	list_add(&req->list, &rb->list);
> +	rb->to_free++;
>   	return true;
>   }
>   
> @@ -1697,10 +1795,14 @@ static int io_put_kbuf(struct io_kiocb *req)
>   static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>   			       struct list_head *done)
>   {
> -	struct req_batch rb;
> +	struct req_batch rb = {
> +		.list		= LIST_HEAD_INIT(rb.list),
> +		.to_free	= 0,
> +		.need_iter	= false,
> +		.irq_comp	= false
> +	};
>   	struct io_kiocb *req;
>   
> -	rb.to_free = rb.need_iter = 0;
>   	while (!list_empty(done)) {
>   		int cflags = 0;
>   
> @@ -5703,8 +5805,6 @@ static void io_submit_state_end(struct io_submit_state *state)
>   {
>   	blk_finish_plug(&state->plug);
>   	io_file_put(state);
> -	if (state->free_reqs)
> -		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
>   }
>   
>   /*
> @@ -5714,7 +5814,6 @@ static void io_submit_state_start(struct io_submit_state *state,
>   				  unsigned int max_ios)
>   {
>   	blk_start_plug(&state->plug);
> -	state->free_reqs = 0;
>   	state->file = NULL;
>   	state->ios_left = max_ios;
>   }
> @@ -5784,7 +5883,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   	 * link list.
>   	 */
>   	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
> -	req->opcode = READ_ONCE(sqe->opcode);
>   	req->user_data = READ_ONCE(sqe->user_data);
>   	req->io = NULL;
>   	req->file = NULL;
> @@ -5872,14 +5970,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>   			io_consume_sqe(ctx);
>   			break;
>   		}
> -		req = io_alloc_req(ctx, statep);
> +		req = io_alloc_req(ctx, READ_ONCE(sqe->opcode));
>   		if (unlikely(!req)) {
>   			if (!submitted)
>   				submitted = -EAGAIN;
>   			break;
>   		}
>   
> -		err = io_init_req(ctx, req, sqe, statep, async);
> +		err = io_init_req(ctx, req, sqe, NULL, async);
>   		io_consume_sqe(ctx);
>   		/* will complete beyond this point, count as submitted */
>   		submitted++;
> @@ -7626,6 +7724,17 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>   					req->task->task_works != NULL);
>   	}
>   	spin_unlock_irq(&ctx->completion_lock);
> +	seq_printf(m, "AllocCache:\n");
> +	for_each_possible_cpu(i) {
> +		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, i);
> +		int j;
> +
> +		for (j = 0; j < ARRAY_SIZE(cache->caches); j++) {
> +			struct io_kiocb_cache_entry *ce = &cache->caches[j];
> +
> +			seq_printf(m, "  cpu%d: irq=%d, nr_free=%d, nr_avail=%d\n", i, j, ce->nr_free, ce->nr_avail);
> +		}
> +	}
>   	mutex_unlock(&ctx->uring_lock);
>   }
>   
> @@ -8101,8 +8210,130 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>   	return ret;
>   }
>   
> +static unsigned long io_uring_cache_count(struct shrinker *shrink,
> +					  struct shrink_control *sc)
> +{
> +	unsigned long count = 0;
> +	int cpu, i;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct io_kiocb_cache *cache;
> +
> +		cache = per_cpu_ptr(alloc_cache, cpu);
> +		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
> +			struct io_kiocb_cache_entry *ce = &cache->caches[i];
> +
> +			count += ce->nr_free;
> +		}
> +	}
> +
> +	return count;
> +}
> +
> +static unsigned long __io_uring_cache_shrink(struct io_kiocb_cache_entry *ce,
> +					     int irq_comp, int *nr_to_scan)
> +{
> +	unsigned long freed = 0;
> +	struct io_kiocb *req;
> +	LIST_HEAD(free_list);
> +
> +	if (!ce->nr_free)
> +		return 0;
> +
> +	if (irq_comp)
> +		spin_lock_irq(&ce->free_lock);
> +	else
> +		spin_lock(&ce->free_lock);
> +
> +	while (!list_empty(&ce->free_list)) {
> +		req = list_first_entry(&ce->free_list, struct io_kiocb, list);
> +		list_move(&req->list, &free_list);
> +		freed++;
> +		if (!--(*nr_to_scan))
> +			break;
> +	}
> +
> +	if (irq_comp)
> +		spin_unlock_irq(&ce->free_lock);
> +	else
> +		spin_unlock(&ce->free_lock);
> +
> +	while (!list_empty(&free_list)) {
> +		req = list_first_entry(&free_list, struct io_kiocb, list);
> +		list_del(&req->list);
> +		kmem_cache_free(req_cachep, req);
> +	}
> +
> +	return freed;
> +}
> +
> +static unsigned long io_uring_cache_shrink(int nr_to_scan)
> +{
> +	long freed = 0;
> +	int cpu, i;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
> +
> +		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
> +			struct io_kiocb_cache_entry *ce = &cache->caches[i];
> +
> +			freed += __io_uring_cache_shrink(ce, i, &nr_to_scan);
> +			if (!nr_to_scan)
> +				break;
> +		}
> +		if (!nr_to_scan)
> +			break;
> +	}
> +
> +	return freed ?: SHRINK_STOP;
> +}
> +
> +static unsigned long io_uring_cache_scan(struct shrinker *shrink,
> +					 struct shrink_control *sc)
> +{
> +	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
> +		return SHRINK_STOP;
> +
> +	return io_uring_cache_shrink(sc->nr_to_scan);
> +}
> +
> +static struct shrinker io_uring_shrinker = {
> +	.count_objects	= io_uring_cache_count,
> +	.scan_objects	= io_uring_cache_scan,
> +	.seeks		= DEFAULT_SEEKS,
> +};
> +
> +static void io_uring_kill_ce(struct io_kiocb_cache_entry *ce, bool irq_comp)
> +{
> +	struct io_kiocb *req;
> +
> +	list_splice_init(&ce->alloc_list, &ce->free_list);
> +
> +	while (!list_empty(&ce->free_list)) {
> +		req = list_first_entry(&ce->free_list, struct io_kiocb, list);
> +		list_del(&req->list);
> +		kmem_cache_free(req_cachep, req);
> +	}
> +
> +	ce->nr_free = ce->nr_avail = 0;
> +}
> +
> +static int io_uring_notify_dead(unsigned int cpu)
> +{
> +	struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cache->caches); i++)
> +		io_uring_kill_ce(&cache->caches[i], i);
> +
> +	return 0;
> +}
> +
>   static int __init io_uring_init(void)
>   {
> +	int cpu, i;
> +
>   #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
>   	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
>   	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
> @@ -8142,6 +8373,25 @@ static int __init io_uring_init(void)
>   	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>   	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>   	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> +
> +	alloc_cache = alloc_percpu(struct io_kiocb_cache);
> +	for_each_possible_cpu(cpu) {
> +		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
> +
> +		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
> +			struct io_kiocb_cache_entry *ce = &cache->caches[i];
> +
> +			INIT_LIST_HEAD(&ce->alloc_list);
> +			spin_lock_init(&ce->free_lock);
> +			INIT_LIST_HEAD(&ce->free_list);
> +			ce->nr_free = 0;
> +			ce->nr_avail = 0;
> +		}
> +	}
> +
> +	cpuhp_setup_state_nocalls(CPUHP_IOURING_DEAD, "io_uring:dead", NULL,
> +					io_uring_notify_dead);
> +	WARN_ON(register_shrinker(&io_uring_shrinker));
>   	return 0;
>   };
>   __initcall(io_uring_init);
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 77d70b633531..3b80556572a5 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -60,6 +60,7 @@ enum cpuhp_state {
>   	CPUHP_LUSTRE_CFS_DEAD,
>   	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
>   	CPUHP_PADATA_DEAD,
> +	CPUHP_IOURING_DEAD,
>   	CPUHP_WORKQUEUE_PREP,
>   	CPUHP_POWER_NUMA_PREPARE,
>   	CPUHP_HRTIMERS_PREPARE,
> 
