Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85E67795E9
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbjHKRMu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 13:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbjHKRMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 13:12:50 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1B519F
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:49 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6874a386ec7so444850b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691773969; x=1692378769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IeLmPwkOtb7aCpuCVbLUcYmpCAqMY8ZL2UkOox5v28o=;
        b=vljPUcqJCG/Qyyz3yaOqYtOblTnbTHpj6eNWhzg3NNizL405SG4vaAWOMLrlYlk7Qp
         zsWIgvEcljp5TmVg3p4IfBUgSWTe+Rcsi4rE952KYy8beSKDOL41je9GikdRfb5+Qizd
         V5QCRnvBCxk5UJG130mzx5MuHQBMGXrJ9T0Lbhkubt6xNXh0OsbtxDKWUceuGIk+F1AT
         yCQCT9BQAgVwQoNm1/xE2bh/T69+9UUfy7mVvEkfaNVFl+J5pOp5WI8RiA9NQPFHbudc
         Gd+lXsLXFYQE7l8/ekrsTHA2fVm35Wcek/3PPimzb/xUnMOwZyb9yYJm84BMlqUg1rtR
         h1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691773969; x=1692378769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IeLmPwkOtb7aCpuCVbLUcYmpCAqMY8ZL2UkOox5v28o=;
        b=A01f6xn9C4B3GZiIFyP3YgQJayg2R2rAYWKgmlfy/3o/Ijk+08oyuzy3dqS6OgSDNr
         5UGv3gM6bc+aOe788pn/KLViqKDhT2JoPDH8BHNsKnipvJaC1phI6Edn6wybY6DEIsZs
         DqpzagxcBagIhYOwittx2skTZDzdNxWGbgpe7VfTnTiSN09EFokIuSz4KNWq3RslDY+G
         E7MX42Q+RkIn7WGz/EP/tjwepYdWwxx6PrZyBLlSnXORKOu4aTvU648sRpYeoWSLSL57
         r8RWlbCC47fQnTmSotqZ4QFp7KfIQph8OyNmHjpLBVDsVW0kbPI/eAJAfCKbnEz7EhN/
         sAAQ==
X-Gm-Message-State: AOJu0YyaHSijq9SYboZ6RvhCkWJwZb3w3g0J4GSrRWtu5dHOaJV8vCKz
        5e7FylW2sU/85hfSBJs2D15hYk3axolYpSsANcE=
X-Google-Smtp-Source: AGHT+IGxfMP7Xs6slW08+5B1uPdlJJY5/diNqiwb4Sgr+eObxFm7TjjZf1MtHwtQeHt4Ltqeiz2G8Q==
X-Received: by 2002:a05:6a00:1ca9:b0:668:834d:4bd with SMTP id y41-20020a056a001ca900b00668834d04bdmr2531617pfw.0.1691773968627;
        Fri, 11 Aug 2023 10:12:48 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u20-20020a62ed14000000b006870b923fb3sm3541250pfh.52.2023.08.11.10.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 10:12:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: move to using private ring references
Date:   Fri, 11 Aug 2023 11:12:40 -0600
Message-Id: <20230811171242.222550-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811171242.222550-1-axboe@kernel.dk>
References: <20230811171242.222550-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring currently uses percpu refcounts for the ring reference. This
works fine, but exiting a ring requires an RCU grace period to lapse
and this slows down ring exit quite a lot.

Add a basic per-cpu counter for our references instead, and use that.
This is in preparation for doing a sync wait on on any request (notably
file) references on ring exit. As we're going to be waiting on ctx refs
going away as well with that, the RCU grace period wait becomes a
noticeable slowdown.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/Makefile              |  3 +-
 io_uring/io_uring.c            | 36 +++++++++--------------
 io_uring/refs.c                | 51 +++++++++++++++++++++++++++++++++
 io_uring/refs.h                | 52 ++++++++++++++++++++++++++++++++++
 io_uring/rw.c                  |  3 +-
 io_uring/sqpoll.c              |  3 +-
 7 files changed, 124 insertions(+), 26 deletions(-)
 create mode 100644 io_uring/refs.c

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f04ce513fadb..c30c267689bb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -223,7 +223,7 @@ struct io_ring_ctx {
 
 		struct io_rings			*rings;
 		struct task_struct		*submitter_task;
-		struct percpu_ref		refs;
+		unsigned long			ref_ptr;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..fcd08a173d61 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o refs.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e189158ebbdd..fa0d4c2fd458 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -230,13 +230,6 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 }
 
-static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
-{
-	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
-
-	complete(&ctx->ref_comp);
-}
-
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -290,8 +283,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
 		goto err;
-	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    0, GFP_KERNEL))
+	if (io_ring_ref_init(ctx))
 		goto err;
 
 	ctx->flags = p->flags;
@@ -1105,7 +1097,7 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 		ret = 1;
 	}
 
-	percpu_ref_get_many(&ctx->refs, ret);
+	io_ring_ref_get_many(ctx, ret);
 	for (i = 0; i < ret; i++) {
 		struct io_kiocb *req = reqs[i];
 
@@ -1162,7 +1154,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 		mutex_unlock(&ctx->uring_lock);
 		ts->locked = false;
 	}
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 static unsigned int handle_tw_list(struct llist_node *node,
@@ -1184,7 +1176,7 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
 			ts->locked = mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
+			io_ring_ref_get(*ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -1243,10 +1235,10 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 		if (sync && last_ctx != req->ctx) {
 			if (last_ctx) {
 				flush_delayed_work(&last_ctx->fallback_work);
-				percpu_ref_put(&last_ctx->refs);
+				io_ring_ref_put(last_ctx);
 			}
 			last_ctx = req->ctx;
-			percpu_ref_get(&last_ctx->refs);
+			io_ring_ref_get(last_ctx);
 		}
 		if (llist_add(&req->io_task_work.node,
 			      &req->ctx->fallback_llist))
@@ -1255,7 +1247,7 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 
 	if (last_ctx) {
 		flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
+		io_ring_ref_put(last_ctx);
 	}
 }
 
@@ -2829,7 +2821,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		nr++;
 	}
 	if (nr)
-		percpu_ref_put_many(&ctx->refs, nr);
+		io_ring_ref_put_many(ctx, nr);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2882,7 +2874,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 	io_rings_free(ctx);
 
-	percpu_ref_exit(&ctx->refs);
+	io_ring_ref_free(ctx);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
@@ -2908,7 +2900,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 	 * might've been lost due to loose synchronisation.
 	 */
 	wake_up_all(&ctx->poll_wq);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 static __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
@@ -2926,9 +2918,9 @@ static __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
 	 * only need to sync with it, which is done by injecting a tw
 	 */
 	init_task_work(&ctx->poll_wq_task_work, io_activate_pollwq_cb);
-	percpu_ref_get(&ctx->refs);
+	io_ring_ref_get(ctx);
 	if (task_work_add(ctx->submitter_task, &ctx->poll_wq_task_work, TWA_SIGNAL))
-		percpu_ref_put(&ctx->refs);
+		io_ring_ref_put(ctx);
 out:
 	spin_unlock(&ctx->completion_lock);
 }
@@ -3119,7 +3111,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	struct creds *creds;
 
 	mutex_lock(&ctx->uring_lock);
-	percpu_ref_kill(&ctx->refs);
+	io_ring_ref_kill(ctx);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	if (ctx->rings)
@@ -4322,7 +4314,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	 * We don't quiesce the refs for register anymore and so it can't be
 	 * dying as we're holding a file ref here.
 	 */
-	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
+	if (WARN_ON_ONCE(io_ring_ref_is_dying(ctx)))
 		return -ENXIO;
 
 	if (ctx->submitter_task && ctx->submitter_task != current)
diff --git a/io_uring/refs.c b/io_uring/refs.c
new file mode 100644
index 000000000000..a1206b32cab3
--- /dev/null
+++ b/io_uring/refs.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/io_uring.h>
+
+#include "refs.h"
+
+int io_ring_ref_init(struct io_ring_ctx *ctx)
+{
+	size_t align = max_t(size_t, 1 << __PERCPU_REF_FLAG_BITS,
+				__alignof__(unsigned long));
+
+	ctx->ref_ptr = (unsigned long) __alloc_percpu(sizeof(unsigned long),
+						      align);
+	if (!ctx->ref_ptr)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void io_ring_ref_free(struct io_ring_ctx *ctx)
+{
+	unsigned long __percpu *refs = io_ring_ref(ctx);
+
+	free_percpu(refs);
+	ctx->ref_ptr = 0;
+}
+
+void __cold io_ring_ref_maybe_done(struct io_ring_ctx *ctx)
+{
+	unsigned long __percpu *refs = io_ring_ref(ctx);
+	unsigned long sum = 0;
+	int cpu;
+
+	preempt_disable();
+	for_each_possible_cpu(cpu)
+		sum += *per_cpu_ptr(refs, cpu);
+	preempt_enable();
+
+	if (!sum)
+		complete(&ctx->ref_comp);
+}
+
+void io_ring_ref_kill(struct io_ring_ctx *ctx)
+{
+	set_bit(CTX_REF_DEAD_BIT, &ctx->ref_ptr);
+	io_ring_ref_maybe_done(ctx);
+}
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 1336de3f2a30..6e32da514609 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -45,4 +45,56 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 {
 	__io_req_set_refcount(req, 1);
 }
+
+int io_ring_ref_init(struct io_ring_ctx *ctx);
+void io_ring_ref_free(struct io_ring_ctx *ctx);
+void __cold io_ring_ref_maybe_done(struct io_ring_ctx *ctx);
+void io_ring_ref_kill(struct io_ring_ctx *ctx);
+
+enum {
+	CTX_REF_DEAD_BIT	= 0UL,
+	CTX_REF_DEAD_MASK	= 1UL,
+};
+
+static inline unsigned long __percpu *io_ring_ref(struct io_ring_ctx *ctx)
+{
+	return (unsigned long __percpu *) (ctx->ref_ptr & ~CTX_REF_DEAD_MASK);
+}
+
+static inline bool io_ring_ref_is_dying(struct io_ring_ctx *ctx)
+{
+	return test_bit(CTX_REF_DEAD_BIT, &ctx->ref_ptr);
+}
+
+static inline void io_ring_ref_get_many(struct io_ring_ctx *ctx, unsigned long nr)
+{
+	unsigned long __percpu *refs = io_ring_ref(ctx);
+
+	preempt_disable();
+	this_cpu_add(*refs, nr);
+	preempt_enable();
+}
+
+static inline void io_ring_ref_get(struct io_ring_ctx *ctx)
+{
+	io_ring_ref_get_many(ctx, 1);
+}
+
+static inline void io_ring_ref_put_many(struct io_ring_ctx *ctx, unsigned long nr)
+{
+	unsigned long __percpu *refs = io_ring_ref(ctx);
+
+	preempt_disable();
+	this_cpu_sub(*refs, nr);
+	preempt_enable();
+
+	if (unlikely(io_ring_ref_is_dying(ctx)))
+		io_ring_ref_maybe_done(ctx);
+}
+
+static inline void io_ring_ref_put(struct io_ring_ctx *ctx)
+{
+	io_ring_ref_put_many(ctx, 1);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9b51afdae505..4c0ebcda48bf 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -18,6 +18,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "rsrc.h"
+#include "refs.h"
 #include "rw.h"
 
 struct io_rw {
@@ -199,7 +200,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
+	if (io_ring_ref_is_dying(ctx))
 		return false;
 	/*
 	 * Play it safe and assume not safe to re-import and reissue if we're
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 5e329e3cd470..4b4bfb0d432c 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "refs.h"
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -188,7 +189,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 * Don't submit if refs are dying, good for io_uring_register(),
 		 * but also it is relied upon by io_ring_exit_work()
 		 */
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		if (to_submit && likely(!io_ring_ref_is_dying(ctx)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.40.1

