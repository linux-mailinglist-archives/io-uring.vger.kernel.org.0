Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B6351649A
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 15:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243590AbiEAN23 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 09:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237373AbiEAN23 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 09:28:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F93943ED0
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 06:25:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i1so4551320plg.7
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 06:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=rPyHnicQQLhCUD10b/555HD7ch/Z58vZBzZ8QB5/TDY=;
        b=TPyQ8InPZPBbVosvmr/UTvMxnh4heZMvhwnnVgPOvSAq9aJyrtMh0eadyt9hRiiZk7
         Pk4KUMjqCP8hk+EhDW27xryQ83XLZQLnq7Wza2GDwg/Q2KZ/680uGy/5CwmEsihsstXu
         KXaTbBvs7az7VO2bzTrvJWF77Wz3dbvhzFCReNWX748dG1N8uqhMMH+hiTZsIROoi9CQ
         YiUXJtX4dYWu/PZkrR+ow2hbPjXmiMrE44hzhYg0HRMlo+Mn088PSQZs/NVNQJqJJTtI
         XExveVH2sM5Cl4kWQT876Bc5q4rYM7a/HEQ7mXt4TIHukOxch78TrSLCXksl0qyIVIB/
         /Ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=rPyHnicQQLhCUD10b/555HD7ch/Z58vZBzZ8QB5/TDY=;
        b=6tY+pGjcC/lOEQk1wPOv+SSG/ZSzNHQQjbSzvoE2lhRVYMJZ231j/l9pgfFqDqqpTh
         024zWw3xQyx7wA13i7vUfn7GwgtQGARCRPCt/fIvYlfS/+bHadI1WhFYqZ6JGpoKrY1L
         m1jMJJsN40KHSmDZT7RktkMVFbkLw7iBO6IIkx6MPpWvHxKctSLTB96gTrjUYedbtRhy
         GsSLD80vP0i5OSscXPhU6S40wxKdO96Iby4wdLdSrlufN2DcDtyIfNrwKp1PLv/CZx8h
         zNGBDxr1qJxZTLcG6oi8SCsEumG+/Xy0tizkMo6Q3MxQhvDlR1jvvDcj0BQAbAOj/KFc
         gD6Q==
X-Gm-Message-State: AOAM533ZJmOsGMQgL9pAlKEwtorBdKRNaLJyt3Y8uBw0a5j2ua2huSjf
        Ytuf+u9+IEwuqvePer5fDwLTLDs6Q2Kg1lv1
X-Google-Smtp-Source: ABdhPJyPtxx0RXOkWyzYNysukrGDgLiRlGS6kQD1ebd6meOI/2v2yzcvLRbU6YjC8lMzMVOvNKGkNQ==
X-Received: by 2002:a17:90a:a58d:b0:1db:ed34:e46d with SMTP id b13-20020a17090aa58d00b001dbed34e46dmr13260238pjq.124.1651411502362;
        Sun, 01 May 2022 06:25:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090a290100b001d840f4eee0sm18084340pjd.20.2022.05.01.06.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 06:25:01 -0700 (PDT)
Message-ID: <55fcf48b-b742-e02d-b0d2-509ebbd9a92e@kernel.dk>
Date:   Sun, 1 May 2022 07:25:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 12/12] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20220430205022.324902-1-axboe@kernel.dk>
 <20220430205022.324902-13-axboe@kernel.dk>
 <604a172092b18514b325d809f641c988a9f6184e.camel@fb.com>
 <3fbf89e6-f656-4c51-2273-6aab46214dd7@kernel.dk>
In-Reply-To: <3fbf89e6-f656-4c51-2273-6aab46214dd7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 6:25 AM, Jens Axboe wrote:
>>> @@ -1564,21 +1585,30 @@ static inline void
>>> io_req_set_rsrc_node(struct io_kiocb *req,
>>>  
>>>  static unsigned int __io_put_kbuf(struct io_kiocb *req, struct
>>> list_head *list)
>>>  {
>>> -       struct io_buffer *kbuf = req->kbuf;
>>>         unsigned int cflags;
>>>  
>>> -       cflags = IORING_CQE_F_BUFFER | (kbuf->bid <<
>>> IORING_CQE_BUFFER_SHIFT);
>>> -       req->flags &= ~REQ_F_BUFFER_SELECTED;
>>> -       list_add(&kbuf->list, list);
>>> -       req->kbuf = NULL;
>>> -       return cflags;
>>> +       if (req->flags & REQ_F_BUFFER_RING) {
>>> +               if (req->buf_list)
>>> +                       req->buf_list->tail++;
>>
>> does this need locking? both on buf_list being available or atomic
>> increment on tail.
> 
> This needs some comments and checks around the expectation. But the idea
> is that the fast path will invoke eg the recv with the uring_lock
> already held, and we'll hold it until we complete it.
> 
> Basically we have two cases:
> 
> 1) Op invoked with uring_lock held. Either the request completes
>    successfully in this invocation, and we put the kbuf with it still
>    held. The completion just increments the tail, buf now consumed. Or
>    we need to retry somehow, and we can just clear REQ_F_BUFFER_RING to
>    recycle the buf, that's it.
> 
> 2) Op invoked without uring_lock held. We get a buf and increment the
>    tail, as we'd otherwise need to grab it again for the completion.
>    We're now stuck with the buf, hold it until the request completes.
> 
> #1 is the above code, just need some checks and safe guards to ensure
> that if ->buf_list is still set, we are still holding the lock.

Here's a debug patch that does a lock sequence check for it. Totally
untested, but it'd be able to catch a violation of the above.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 28654864201e..51e3536befe2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -389,6 +389,7 @@ struct io_ring_ctx {
 	/* submission data */
 	struct {
 		struct mutex		uring_lock;
+		int			__lock_seq;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -1004,6 +1005,7 @@ struct io_kiocb {
 		 struct {
 			 struct io_buffer_list	*buf_list;
 			 __u32			bid;
+			 int			buf_lock_seq;
 		 };
 	};
 
@@ -1443,11 +1445,32 @@ static inline bool io_file_need_scm(struct file *filp)
 }
 #endif
 
+static inline void ctx_lock(struct io_ring_ctx *ctx)
+{
+	mutex_lock(&ctx->uring_lock);
+	ctx->__lock_seq++;
+}
+
+static inline bool ctx_trylock(struct io_ring_ctx *ctx)
+{
+	if (mutex_trylock(&ctx->uring_lock)) {
+		ctx->__lock_seq++;
+		return true;
+	}
+	return false;
+}
+
+static inline void ctx_unlock(struct io_ring_ctx *ctx)
+{
+	ctx->__lock_seq++;
+	mutex_unlock(&ctx->uring_lock);
+}
+
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, unsigned issue_flags)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 }
 
 static void io_ring_submit_lock(struct io_ring_ctx *ctx, unsigned issue_flags)
@@ -1459,14 +1482,14 @@ static void io_ring_submit_lock(struct io_ring_ctx *ctx, unsigned issue_flags)
 	 * from an async worker thread, grab the lock for that case.
 	 */
 	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 		*locked = true;
 	}
 }
@@ -1588,8 +1611,10 @@ static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 	unsigned int cflags;
 
 	if (req->flags & REQ_F_BUFFER_RING) {
-		if (req->buf_list)
+		if (req->buf_list) {
+			WARN_ON_ONCE(req->buf_lock_seq != req->ctx->__lock_seq);
 			req->buf_list->tail++;
+		}
 
 		cflags = req->bid << IORING_CQE_BUFFER_SHIFT;
 		req->flags &= ~REQ_F_BUFFER_RING;
@@ -1777,7 +1802,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	if (locked) {
 		io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 	}
 	percpu_ref_put(&ctx->refs);
 }
@@ -2237,10 +2262,10 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_lock(&ctx->uring_lock);
+			ctx_lock(ctx);
 		ret = __io_cqring_overflow_flush(ctx, false);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 	}
 
 	return ret;
@@ -2698,7 +2723,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 		return;
 	if (*locked) {
 		io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 		*locked = false;
 	}
 	percpu_ref_put(&ctx->refs);
@@ -2731,7 +2756,7 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 			ctx_flush_and_put(*ctx, uring_locked);
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
-			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
+			*uring_locked = ctx_trylock(*ctx);
 			percpu_ref_get(&(*ctx)->refs);
 			if (unlikely(!*uring_locked))
 				spin_lock(&(*ctx)->completion_lock);
@@ -2762,7 +2787,7 @@ static void handle_tw_list(struct io_wq_work_node *node,
 			ctx_flush_and_put(*ctx, locked);
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
-			*locked = mutex_trylock(&(*ctx)->uring_lock);
+			*locked = ctx_trylock(*ctx);
 			percpu_ref_get(&(*ctx)->refs);
 		}
 		req->io_task_work.func(req, locked);
@@ -3126,7 +3151,7 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	while (!wq_list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
@@ -3137,12 +3162,12 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		 * Also let task_work, etc. to progress by releasing the mutex
 		 */
 		if (need_resched()) {
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			cond_resched();
-			mutex_lock(&ctx->uring_lock);
+			ctx_lock(ctx);
 		}
 	}
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 }
 
 static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
@@ -3183,9 +3208,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		if (wq_list_empty(&ctx->iopoll_list)) {
 			u32 tail = ctx->cached_cq_tail;
 
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			io_run_task_work();
-			mutex_lock(&ctx->uring_lock);
+			ctx_lock(ctx);
 
 			/* some requests don't go through iopoll_list */
 			if (tail != ctx->cached_cq_tail ||
@@ -3347,7 +3372,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
 	if (unlikely(needs_lock))
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
@@ -3385,7 +3410,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 		    wq_has_sleeper(&ctx->sq_data->wait))
 			wake_up(&ctx->sq_data->wait);
 
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 	}
 }
 
@@ -3674,8 +3699,10 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->bid = buf->bid;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED))
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		req->buf_lock_seq = req->ctx->__lock_seq;
 		return u64_to_user_ptr(buf->addr);
+	}
 
 	/*
 	 * If we came in unlocked, we have no choice but to
@@ -8740,7 +8767,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
 
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 		if (!wq_list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, true);
 
@@ -8751,7 +8778,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
@@ -9165,17 +9192,17 @@ static __cold int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		/* kill initial ref, already quiesced if zero */
 		if (atomic_dec_and_test(&data->refs))
 			break;
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 		flush_delayed_work(&ctx->rsrc_put_work);
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
-			mutex_lock(&ctx->uring_lock);
+			ctx_lock(ctx);
 			if (atomic_read(&data->refs) > 0) {
 				/*
 				 * it has been revived by another thread while
 				 * we were unlocked
 				 */
-				mutex_unlock(&ctx->uring_lock);
+				ctx_unlock(ctx);
 			} else {
 				break;
 			}
@@ -9187,7 +9214,7 @@ static __cold int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		reinit_completion(&data->done);
 
 		ret = io_run_task_work_sig();
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 	} while (ret >= 0);
 	data->quiesce = false;
 
@@ -9572,7 +9599,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 		if (prsrc->tag) {
 			if (ctx->flags & IORING_SETUP_IOPOLL)
-				mutex_lock(&ctx->uring_lock);
+				ctx_lock(ctx);
 
 			spin_lock(&ctx->completion_lock);
 			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
@@ -9581,7 +9608,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 			io_cqring_ev_posted(ctx);
 
 			if (ctx->flags & IORING_SETUP_IOPOLL)
-				mutex_unlock(&ctx->uring_lock);
+				ctx_unlock(ctx);
 		}
 
 		rsrc_data->do_put(ctx, prsrc);
@@ -9879,19 +9906,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	struct io_wq_data data;
 	unsigned int concurrency;
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	hash = ctx->hash_map;
 	if (!hash) {
 		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
 		if (!hash) {
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			return ERR_PTR(-ENOMEM);
 		}
 		refcount_set(&hash->refs, 1);
 		init_waitqueue_head(&hash->wait);
 		ctx->hash_map = hash;
 	}
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 
 	data.hash = hash;
 	data.task = task;
@@ -10642,7 +10669,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 	int nr = 0;
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	io_flush_cached_locked_reqs(ctx, state);
 
 	while (!io_req_cache_empty(ctx)) {
@@ -10656,7 +10683,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	}
 	if (nr)
 		percpu_ref_put_many(&ctx->refs, nr);
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 }
 
 static void io_wait_rsrc_data(struct io_rsrc_data *data)
@@ -10691,7 +10718,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_wait_rsrc_data(ctx->buf_data);
 	io_wait_rsrc_data(ctx->file_data);
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
@@ -10700,7 +10727,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	io_eventfd_unregister(ctx);
 	io_flush_apoll_cache(ctx);
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -10859,7 +10886,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	 * completion_lock, see io_req_task_submit(). Apart from other work,
 	 * this lock/unlock section also waits them to finish.
 	 */
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 
@@ -10871,11 +10898,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		if (WARN_ON_ONCE(ret))
 			continue;
 
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 		wait_for_completion(&exit.completion);
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 	}
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
@@ -10910,13 +10937,13 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	unsigned long index;
 	struct creds *creds;
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	percpu_ref_kill(&ctx->refs);
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 
 	/* failed during ring init, it couldn't have issued any requests */
 	if (ctx->rings) {
@@ -10991,7 +11018,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	enum io_wq_cancel cret;
 	bool ret = false;
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
@@ -11004,7 +11031,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 
 	return ret;
 }
@@ -11091,9 +11118,9 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 			return ret;
 		}
 
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 		list_add(&node->ctx_node, &ctx->tctx_list);
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 	}
 	tctx->last = ctx;
 	return 0;
@@ -11128,9 +11155,9 @@ static __cold void io_uring_del_tctx_node(unsigned long index)
 	WARN_ON_ONCE(current != node->task);
 	WARN_ON_ONCE(list_empty(&node->ctx_node));
 
-	mutex_lock(&node->ctx->uring_lock);
+	ctx_lock(node->ctx);
 	list_del(&node->ctx_node);
-	mutex_unlock(&node->ctx->uring_lock);
+	ctx_unlock(node->ctx);
 
 	if (tctx->last == node->ctx)
 		tctx->last = NULL;
@@ -11296,9 +11323,9 @@ static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
 	if (!nr_args || nr_args > IO_RINGFD_REG_MAX)
 		return -EINVAL;
 
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 	ret = io_uring_add_tctx_node(ctx);
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	if (ret)
 		return ret;
 
@@ -11583,15 +11610,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (unlikely(ret))
 			goto out;
 
-		mutex_lock(&ctx->uring_lock);
+		ctx_lock(ctx);
 		ret = io_submit_sqes(ctx, to_submit);
 		if (ret != to_submit) {
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			goto out;
 		}
 		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
 			goto iopoll_locked;
-		mutex_unlock(&ctx->uring_lock);
+		ctx_unlock(ctx);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
@@ -11602,7 +11629,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * prevent racing with polled issue that got punted to
 			 * a workqueue.
 			 */
-			mutex_lock(&ctx->uring_lock);
+			ctx_lock(ctx);
 iopoll_locked:
 			ret2 = io_validate_ext_arg(flags, argp, argsz);
 			if (likely(!ret2)) {
@@ -11610,7 +11637,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 						   ctx->cq_entries);
 				ret2 = io_iopoll_check(ctx, min_complete);
 			}
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 		} else {
 			const sigset_t __user *sig;
 			struct __kernel_timespec __user *ts;
@@ -12372,9 +12399,9 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 			 * a ref to the ctx.
 			 */
 			refcount_inc(&sqd->refs);
-			mutex_unlock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			mutex_lock(&sqd->lock);
-			mutex_lock(&ctx->uring_lock);
+			ctx_unlock(ctx);
 			if (sqd->thread)
 				tctx = sqd->thread->io_uring;
 		}
@@ -12668,9 +12695,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 	io_run_task_work();
 
-	mutex_lock(&ctx->uring_lock);
+	ctx_lock(ctx);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
-	mutex_unlock(&ctx->uring_lock);
+	ctx_unlock(ctx);
 	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
 out_fput:
 	fdput(f);

-- 
Jens Axboe

