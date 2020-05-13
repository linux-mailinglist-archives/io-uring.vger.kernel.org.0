Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28201D1B10
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbgEMQas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 12:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbgEMQar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 12:30:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A846CC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 09:30:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j13so1214927pjm.2
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 09:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qrHWMVg8HqQKeYBy9e2iStXguAqDbwXxqlsAO5xfgvY=;
        b=ir5FZvexUq1RH3KXJxljRD3XmeUtlk303kx6ay8i7rG7MvqqyBEhmLfUxqeMzrPKbL
         er3tt6gPU5RER5ZeDXJsHq3OHlWnYNcJY7F1/cI2givXp/1Tcm6EiLWQWi6UkKoLxQ4j
         U2sm94WWLSfiOeH+fsSQuXOs/BgV6vWyXjhZNKp+7t2IXKPvrJGTvZasUBT9anBMN4/w
         11RyF71E6n1YKgREWwgpitjWSiLZcU24MuncQbtgH1k/zUblZ503sMjcGgyCOoERCODJ
         h8IrRNdy+TZSmqZsh3Sm4FGFYscfKUIu02/8pRJjdW33JOM+yj3ItsT1dhUB9Rbp8/6R
         Terw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qrHWMVg8HqQKeYBy9e2iStXguAqDbwXxqlsAO5xfgvY=;
        b=Ru56wmEkrKhudqrLMH1DhTS75mpoF92Fdqn86jfnvc62CiTlMFHHLiPbNYPa0LxFW/
         IrAC6KqZbGViNUi1juPwxTSKDV7S6c9I5M4JQAuhtcwaDGmunh5RtAouqx3tXS7BJq36
         pEOy+CV8aq7TqVPulc3HfS5mrkNWVWI1VNuutwkpSF9icNcvQyJGgTBD0hVPal29+jlY
         jHadgMfunyoHpmJfb1C3558E4L9vnUk+sZo0/cmj3qvG0jIrfUdqbM3yggKW44vnDvUA
         mvJ9bF3VmXDL9VnOeLAHllTO93yLJ4x56C2OwNjzKhzbyvcnJCUlhbUK3w5tY7ipHSF9
         i5HA==
X-Gm-Message-State: AOAM532h3iG5CeAECTGWxzoAdkxNyvk/mHmYXQlrvcoUGb3kbF0XAG1N
        HoQqKijuDJTLGmJKuoVmN+vMqA==
X-Google-Smtp-Source: ABdhPJw06ODMpo5XYwJU2nkUCnFEH57yW5c/0RQOusSAJ3YTe+cl7pE3v/n+Tse7gREIODDJ1t3nHw==
X-Received: by 2002:a17:90a:4e07:: with SMTP id n7mr2113880pjh.34.1589387446869;
        Wed, 13 May 2020 09:30:46 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:e16c:b526:b72a:3095? ([2605:e000:100e:8c61:e16c:b526:b72a:3095])
        by smtp.gmail.com with ESMTPSA id u12sm179593pgg.22.2020.05.13.09.30.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 09:30:46 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC} io_uring: io_kiocb alloc cache
Message-ID: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
Date:   Wed, 13 May 2020 10:30:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I turned the quick'n dirty from the other day into something a bit
more done. Would be great if someone else could run some performance
testing with this, I get about a 10% boost on the pure NOP benchmark
with this. But that's just on my laptop in qemu, so some real iron
testing would be awesome.

The idea here is to have a percpu alloc cache. There's two sets of
state:

1) Requests that have IRQ completion. preempt disable is not enough
   there, we need to disable local irqs. This is a lot slower in
   certain setups, so we keep this separate.

2) No IRQ completion, we can get by with just disabling preempt.

Outside of that, any freed requests goes to the ce->alloc_list.
Attempting to alloc a request will check there first. When freeing
a request, if we're over some threshold, move requests to the
ce->free_list. This list can be browsed by the shrinker to free
up memory. If a CPU goes offline, all requests are reaped.

That's about it. If we go further with this, it'll be split into
a few separate patches. For now, just throwing this out there
for testing. The patch is against my for-5.8/io_uring branch.

It survives basic testing for me, with the exception being some issue
related to fixed files (the kworker will hang on exit).


diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2e37215d05a..4da8f4a9a285 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/fs_struct.h>
 #include <linux/splice.h>
 #include <linux/task_work.h>
+#include <linux/cpuhotplug.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -652,17 +653,10 @@ struct io_kiocb {
 };
 
 #define IO_PLUG_THRESHOLD		2
-#define IO_IOPOLL_BATCH			8
 
 struct io_submit_state {
 	struct blk_plug		plug;
 
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_IOPOLL_BATCH];
-	unsigned int		free_reqs;
-
 	/*
 	 * File reference cache
 	 */
@@ -673,6 +667,24 @@ struct io_submit_state {
 	unsigned int		ios_left;
 };
 
+struct io_kiocb_cache_entry {
+	struct list_head	alloc_list;
+	unsigned		nr_avail;
+
+	spinlock_t		free_lock;
+	struct list_head	free_list;
+	unsigned		nr_free;
+};
+
+struct io_kiocb_cache {
+	struct io_kiocb_cache_entry	caches[2];
+};
+
+#define IO_KIOCB_CACHE_MAX	256
+#define IO_KIOCB_CACHE_RECLAIM	 16
+
+static struct io_kiocb_cache *alloc_cache;
+
 struct io_op_def {
 	/* needs req->io allocated for deferral/async */
 	unsigned		async_ctx : 1;
@@ -695,6 +707,8 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
+	/* IRQ completion */
+	unsigned		irq_comp : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -706,6 +720,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -714,6 +729,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -722,12 +738,14 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -803,12 +821,14 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.irq_comp		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -1281,54 +1301,138 @@ static inline bool io_is_fallback_req(struct io_kiocb *req)
 			((unsigned long) req->ctx->fallback_req & ~1UL);
 }
 
-static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
+static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx, int op)
 {
 	struct io_kiocb *req;
 
 	req = ctx->fallback_req;
-	if (!test_and_set_bit_lock(0, (unsigned long *) &ctx->fallback_req))
+	if (!test_and_set_bit_lock(0, (unsigned long *) &ctx->fallback_req)) {
+		req->opcode = op;
 		return req;
+	}
 
 	return NULL;
 }
 
-static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
-				     struct io_submit_state *state)
+static struct io_kiocb *io_req_cache_alloc(int op)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-	struct io_kiocb *req;
+	const bool irq_comp = io_op_defs[op].irq_comp;
+	struct io_kiocb_cache_entry *ce;
+	struct io_kiocb_cache *cache;
+	struct io_kiocb *req = NULL;
 
-	if (!state) {
-		req = kmem_cache_alloc(req_cachep, gfp);
-		if (unlikely(!req))
-			goto fallback;
-	} else if (!state->free_reqs) {
-		size_t sz;
-		int ret;
+	if (irq_comp)
+		local_irq_disable();
+	else
+		preempt_disable();
 
-		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
-		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz, state->reqs);
+	cache = this_cpu_ptr(alloc_cache);
+	ce = &cache->caches[irq_comp];
 
-		/*
-		 * Bulk alloc is all-or-nothing. If we fail to get a batch,
-		 * retry single alloc to be on the safe side.
-		 */
-		if (unlikely(ret <= 0)) {
-			state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
-			if (!state->reqs[0])
-				goto fallback;
-			ret = 1;
-		}
-		state->free_reqs = ret - 1;
-		req = state->reqs[ret - 1];
-	} else {
-		state->free_reqs--;
-		req = state->reqs[state->free_reqs];
+	if (!list_empty(&ce->alloc_list)) {
+		req = list_first_entry(&ce->alloc_list, struct io_kiocb, list);
+		list_del(&req->list);
+		ce->nr_avail--;
 	}
 
-	return req;
-fallback:
-	return io_get_fallback_req(ctx);
+	if (irq_comp)
+		local_irq_enable();
+	else
+		preempt_enable();
+
+	if (req)
+		return req;
+
+	return kmem_cache_alloc(req_cachep, GFP_KERNEL);
+}
+
+static void io_req_cache_reclaim(struct io_kiocb_cache_entry *ce)
+{
+	LIST_HEAD(free_list);
+	int nr = 0;
+
+	while (!list_empty(&ce->alloc_list)) {
+		struct io_kiocb *req;
+
+		req = list_last_entry(&ce->alloc_list, struct io_kiocb, list);
+		list_move(&req->list, &free_list);
+		nr++;
+	}
+
+	spin_lock(&ce->free_lock);
+	list_splice(&free_list, &ce->free_list);
+	ce->nr_free += nr;
+	ce->nr_avail -= nr;
+	spin_unlock(&ce->free_lock);
+}
+
+struct req_batch {
+	struct list_head list;
+	int to_free;
+	bool need_iter;
+	bool irq_comp;
+};
+
+static void io_req_cache_free_bulk(struct req_batch *rb)
+{
+	struct io_kiocb_cache_entry *ce;
+	struct io_kiocb_cache *cache;
+
+	if (rb->irq_comp)
+		local_irq_disable();
+	else
+		preempt_disable();
+
+	cache = this_cpu_ptr(alloc_cache);
+	ce = &cache->caches[rb->irq_comp];
+
+	list_splice_init(&rb->list, &ce->alloc_list);
+	ce->nr_avail += rb->to_free;
+	if (ce->nr_avail > IO_KIOCB_CACHE_MAX)
+		io_req_cache_reclaim(ce);
+
+	if (rb->irq_comp)
+		local_irq_enable();
+	else
+		preempt_enable();
+}
+
+static void io_req_cache_free(struct io_kiocb *req)
+{
+	const bool irq_comp = io_op_defs[req->opcode].irq_comp;
+	struct io_kiocb_cache_entry *ce;
+	struct io_kiocb_cache *cache;
+	unsigned long flags;
+
+	if (irq_comp)
+		local_irq_save(flags);
+	else
+		preempt_disable();
+
+	cache = this_cpu_ptr(alloc_cache);
+	ce = &cache->caches[irq_comp];
+
+	list_add(&req->list, &ce->alloc_list);
+	if (++ce->nr_avail > IO_KIOCB_CACHE_MAX)
+		io_req_cache_reclaim(ce);
+
+	if (irq_comp)
+		local_irq_restore(flags);
+	else
+		preempt_enable();
+}
+
+static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx, int opcode)
+{
+	struct io_kiocb *req;
+
+	req = io_req_cache_alloc(opcode);
+	if (req) {
+		req->opcode = opcode;
+		return req;
+	}
+
+	return io_get_fallback_req(ctx, opcode);
 }
 
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
@@ -1345,7 +1449,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
-	kfree(req->io);
+	if (req->io)
+		kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->task)
@@ -1371,28 +1476,21 @@ static void __io_free_req(struct io_kiocb *req)
 
 	percpu_ref_put(&req->ctx->refs);
 	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
+		io_req_cache_free(req);
 	else
 		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
 }
 
-struct req_batch {
-	void *reqs[IO_IOPOLL_BATCH];
-	int to_free;
-	int need_iter;
-};
-
 static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 {
 	if (!rb->to_free)
 		return;
 	if (rb->need_iter) {
-		int i, inflight = 0;
+		struct io_kiocb *req;
 		unsigned long flags;
+		int inflight = 0;
 
-		for (i = 0; i < rb->to_free; i++) {
-			struct io_kiocb *req = rb->reqs[i];
-
+		list_for_each_entry(req, &rb->list, list) {
 			if (req->flags & REQ_F_FIXED_FILE) {
 				req->file = NULL;
 				percpu_ref_put(req->fixed_file_refs);
@@ -1405,9 +1503,7 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 			goto do_free;
 
 		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		for (i = 0; i < rb->to_free; i++) {
-			struct io_kiocb *req = rb->reqs[i];
-
+		list_for_each_entry(req, &rb->list, list) {
 			if (req->flags & REQ_F_INFLIGHT) {
 				list_del(&req->inflight_entry);
 				if (!--inflight)
@@ -1420,9 +1516,10 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 			wake_up(&ctx->inflight_wait);
 	}
 do_free:
-	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
+	io_req_cache_free_bulk(rb);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	rb->to_free = rb->need_iter = 0;
+	rb->to_free = 0;
+	rb->need_iter = rb->irq_comp = false;
 }
 
 static bool io_link_cancel_timeout(struct io_kiocb *req)
@@ -1670,11 +1767,12 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 		return false;
 
 	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
-		rb->need_iter++;
+		rb->need_iter |= true;
+	if (!rb->irq_comp && io_op_defs[req->opcode].irq_comp)
+		rb->irq_comp |= true;
 
-	rb->reqs[rb->to_free++] = req;
-	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-		io_free_req_many(req->ctx, rb);
+	list_add(&req->list, &rb->list);
+	rb->to_free++;
 	return true;
 }
 
@@ -1697,10 +1795,14 @@ static int io_put_kbuf(struct io_kiocb *req)
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			       struct list_head *done)
 {
-	struct req_batch rb;
+	struct req_batch rb = {
+		.list		= LIST_HEAD_INIT(rb.list),
+		.to_free	= 0,
+		.need_iter	= false,
+		.irq_comp	= false
+	};
 	struct io_kiocb *req;
 
-	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
@@ -5703,8 +5805,6 @@ static void io_submit_state_end(struct io_submit_state *state)
 {
 	blk_finish_plug(&state->plug);
 	io_file_put(state);
-	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 }
 
 /*
@@ -5714,7 +5814,6 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
-	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
 }
@@ -5784,7 +5883,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * link list.
 	 */
 	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
-	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
 	req->file = NULL;
@@ -5872,14 +5970,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, statep);
+		req = io_alloc_req(ctx, READ_ONCE(sqe->opcode));
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
 
-		err = io_init_req(ctx, req, sqe, statep, async);
+		err = io_init_req(ctx, req, sqe, NULL, async);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
@@ -7626,6 +7724,17 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					req->task->task_works != NULL);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	seq_printf(m, "AllocCache:\n");
+	for_each_possible_cpu(i) {
+		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, i);
+		int j;
+
+		for (j = 0; j < ARRAY_SIZE(cache->caches); j++) {
+			struct io_kiocb_cache_entry *ce = &cache->caches[j];
+
+			seq_printf(m, "  cpu%d: irq=%d, nr_free=%d, nr_avail=%d\n", i, j, ce->nr_free, ce->nr_avail);
+		}
+	}
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -8101,8 +8210,130 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	return ret;
 }
 
+static unsigned long io_uring_cache_count(struct shrinker *shrink,
+					  struct shrink_control *sc)
+{
+	unsigned long count = 0;
+	int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		struct io_kiocb_cache *cache;
+
+		cache = per_cpu_ptr(alloc_cache, cpu);
+		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
+			struct io_kiocb_cache_entry *ce = &cache->caches[i];
+
+			count += ce->nr_free;
+		}
+	}
+
+	return count;
+}
+
+static unsigned long __io_uring_cache_shrink(struct io_kiocb_cache_entry *ce,
+					     int irq_comp, int *nr_to_scan)
+{
+	unsigned long freed = 0;
+	struct io_kiocb *req;
+	LIST_HEAD(free_list);
+
+	if (!ce->nr_free)
+		return 0;
+
+	if (irq_comp)
+		spin_lock_irq(&ce->free_lock);
+	else
+		spin_lock(&ce->free_lock);
+
+	while (!list_empty(&ce->free_list)) {
+		req = list_first_entry(&ce->free_list, struct io_kiocb, list);
+		list_move(&req->list, &free_list);
+		freed++;
+		if (!--(*nr_to_scan))
+			break;
+	}
+
+	if (irq_comp)
+		spin_unlock_irq(&ce->free_lock);
+	else
+		spin_unlock(&ce->free_lock);
+
+	while (!list_empty(&free_list)) {
+		req = list_first_entry(&free_list, struct io_kiocb, list);
+		list_del(&req->list);
+		kmem_cache_free(req_cachep, req);
+	}
+
+	return freed;
+}
+
+static unsigned long io_uring_cache_shrink(int nr_to_scan)
+{
+	long freed = 0;
+	int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
+
+		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
+			struct io_kiocb_cache_entry *ce = &cache->caches[i];
+
+			freed += __io_uring_cache_shrink(ce, i, &nr_to_scan);
+			if (!nr_to_scan)
+				break;
+		}
+		if (!nr_to_scan)
+			break;
+	}
+
+	return freed ?: SHRINK_STOP;
+}
+
+static unsigned long io_uring_cache_scan(struct shrinker *shrink,
+					 struct shrink_control *sc)
+{
+	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
+		return SHRINK_STOP;
+
+	return io_uring_cache_shrink(sc->nr_to_scan);
+}
+
+static struct shrinker io_uring_shrinker = {
+	.count_objects	= io_uring_cache_count,
+	.scan_objects	= io_uring_cache_scan,
+	.seeks		= DEFAULT_SEEKS,
+};
+
+static void io_uring_kill_ce(struct io_kiocb_cache_entry *ce, bool irq_comp)
+{
+	struct io_kiocb *req;
+
+	list_splice_init(&ce->alloc_list, &ce->free_list);
+
+	while (!list_empty(&ce->free_list)) {
+		req = list_first_entry(&ce->free_list, struct io_kiocb, list);
+		list_del(&req->list);
+		kmem_cache_free(req_cachep, req);
+	}
+
+	ce->nr_free = ce->nr_avail = 0;
+}
+
+static int io_uring_notify_dead(unsigned int cpu)
+{
+	struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cache->caches); i++)
+		io_uring_kill_ce(&cache->caches[i], i);
+
+	return 0;
+}
+
 static int __init io_uring_init(void)
 {
+	int cpu, i;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -8142,6 +8373,25 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+
+	alloc_cache = alloc_percpu(struct io_kiocb_cache);
+	for_each_possible_cpu(cpu) {
+		struct io_kiocb_cache *cache = per_cpu_ptr(alloc_cache, cpu);
+
+		for (i = 0; i < ARRAY_SIZE(cache->caches); i++) {
+			struct io_kiocb_cache_entry *ce = &cache->caches[i];
+
+			INIT_LIST_HEAD(&ce->alloc_list);
+			spin_lock_init(&ce->free_lock);
+			INIT_LIST_HEAD(&ce->free_list);
+			ce->nr_free = 0;
+			ce->nr_avail = 0;
+		}
+	}
+
+	cpuhp_setup_state_nocalls(CPUHP_IOURING_DEAD, "io_uring:dead", NULL,
+					io_uring_notify_dead);
+	WARN_ON(register_shrinker(&io_uring_shrinker));
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 77d70b633531..3b80556572a5 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -60,6 +60,7 @@ enum cpuhp_state {
 	CPUHP_LUSTRE_CFS_DEAD,
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
 	CPUHP_PADATA_DEAD,
+	CPUHP_IOURING_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,

-- 
Jens Axboe

