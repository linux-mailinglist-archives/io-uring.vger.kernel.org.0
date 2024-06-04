Return-Path: <io-uring+bounces-2099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B68568FBC5D
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AA881F245CB
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA5614AD2D;
	Tue,  4 Jun 2024 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ei6NdeEF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7BD14AD20
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528407; cv=none; b=RlYD+coa8//gskyyPHMa4auVzadiOjTYCTWUXLxX65eKkK38BamoMm+EJ+azMeaUKgRM8Nk5LBXmrTUWgQBp65kO2/WCku3O5DNm8ZY1liY/NSWmCwSfFv2yoLIX/DoNjAz+aQZaDtID3hQ/tLgpqVdIpLLQp7SsZ/Bp9vTIqfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528407; c=relaxed/simple;
	bh=jLwjwVmgpmJV/5OeRd9c4e0euHdaOtuhURblzrIFA1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F73R+Ue3KacvYAJFmNY1Tbeq4Jsswcj4Pj26OSVaHWlBZtWM/Ffppy4O76dAtPe6xyuiF+w9yJizO1FNza0yzOIY52am/SfE9ZS7WUyrTwLxtvHCbGY47mxMBJNtSoMmf2ZOVDhzkGr0Yed7eKitYchNzh8xNXjqU9CBefru6pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ei6NdeEF; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2c1b16b9755so581816a91.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528403; x=1718133203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZPLrNRezmocE4Rkfvj0VL4ygrCPYVD0bCTIaofhj+g=;
        b=Ei6NdeEFadVz7c7TtFq4HfesJJKZd5efwriMQvN3MPLlCa7CUx0fXcG64I/FLsKe+9
         WaTdMYLx7knovnX4nVRU7IoWRm6/eGQBQRWatDyptQ2q761KZs5Fh6+izWvFWLENPdaN
         9pUGlH1xXdkzeRhDFZOdHF8qapiRLyKrd8n9fAPvuhuVvgiu4EqsBxoGdQnI7wC3Hch+
         bsuLQE3jJbh3GIaRPkeaVYgYBxRW9M80xOmScP/ALXMA61txi/kzD38mv+NOQNgg+mYU
         +N1L7Rq6yRUdMthHICfhpw2ivvmDzpiqwMs4GzVCxAKEtvRkG9nFosrzShZp6w/NrIPY
         0lUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528404; x=1718133204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZPLrNRezmocE4Rkfvj0VL4ygrCPYVD0bCTIaofhj+g=;
        b=YU2UADmjUso5JlTJPbcBjrAp61isqWBK8aRII8B1K/vnFPiR1MOhKCQYUqdXFZ/I59
         COmBEtDvbuwEBt3IRn+I6xYhh+uAuXnR51etCLfqaTVwvhZIYH5F/QF/E8SvIPP04d4i
         zWcayg7F3XgdKtFs3s4SRfuSvvF5NBiXC1S6O5SYhFpao4BmdPD7/84kI+EuNjaslgCt
         vFtWryWULU1VqX6GAG0c0Kx6uHtVoQkg4noL5HEEj/5yjHrqoc+99zn6Kt36vxaAV2sG
         9Qk84heh/dQHvDyQR/xRTWGKonUtSvnID4mXF8SEiw93SB/qodcjqbirL115L7sMIX1W
         VDmA==
X-Gm-Message-State: AOJu0YyjAOa0D5kGNmhmNGPgJhITP1N6V6QV9FrtWLnj03Ry9zzPu/dV
	rIgSI491vFltYc//5V7oa72uF+ubGLk833y2AQKf8IkGqlyDVgAVHcdS5rNO9iJUDclU3CTQsRi
	x
X-Google-Smtp-Source: AGHT+IFwL3I7rWCVxTojjk2RjESqa8lx6lJLJkZUpueWsgWbetCmU1bZcNmzD0sgnBiNdzdFONiIcA==
X-Received: by 2002:a17:90b:360b:b0:2c2:204d:6c2 with SMTP id 98e67ed59e1d1-2c27db681dcmr366493a91.2.1717528403405;
        Tue, 04 Jun 2024 12:13:23 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: move to using private ring references
Date: Tue,  4 Jun 2024 13:01:30 -0600
Message-ID: <20240604191314.454554-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240604191314.454554-1-axboe@kernel.dk>
References: <20240604191314.454554-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 io_uring/Makefile              |  2 +-
 io_uring/io_uring.c            | 39 ++++++++++-------------
 io_uring/refs.c                | 58 ++++++++++++++++++++++++++++++++++
 io_uring/refs.h                | 53 +++++++++++++++++++++++++++++++
 io_uring/register.c            |  3 +-
 io_uring/rw.c                  |  3 +-
 io_uring/sqpoll.c              |  3 +-
 8 files changed, 135 insertions(+), 28 deletions(-)
 create mode 100644 io_uring/refs.c

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a2227ab7fd16..fc1e0e65d474 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -238,7 +238,7 @@ struct io_ring_ctx {
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
-		struct percpu_ref	refs;
+		unsigned long		ref_ptr;
 
 		enum task_work_notify_mode	notify_method;
 		unsigned			sq_thread_idle;
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 61923e11c767..b167ab8930a9 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					tctx.o filetable.o rw.o net.o poll.o \
-					eventfd.o uring_cmd.o openclose.o \
+					eventfd.o refs.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					epoll.o statx.o timeout.o fdinfo.o \
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3ad915262a45..841a5dd6ba89 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -248,13 +248,6 @@ static __cold void io_kworker_tw_end(void)
 	current->flags |= PF_NO_TASKWORK;
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
@@ -265,13 +258,13 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	io_kworker_tw_start();
 
-	percpu_ref_get(&ctx->refs);
+	io_ring_ref_get(ctx);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 	io_kworker_tw_end();
 }
 
@@ -312,8 +305,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
 		goto err;
-	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    0, GFP_KERNEL))
+	if (io_ring_ref_init(ctx))
 		goto err;
 
 	ctx->flags = p->flags;
@@ -939,7 +931,7 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 		ret = 1;
 	}
 
-	percpu_ref_get_many(&ctx->refs, ret);
+	io_ring_ref_get_many(ctx, ret);
 	while (ret--) {
 		struct io_kiocb *req = reqs[ret];
 
@@ -994,7 +986,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 /*
@@ -1018,7 +1010,7 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 			ctx_flush_and_put(ctx, &ts);
 			ctx = req->ctx;
 			mutex_lock(&ctx->uring_lock);
-			percpu_ref_get(&ctx->refs);
+			io_ring_ref_get(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -1062,10 +1054,10 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
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
@@ -1074,7 +1066,7 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 
 	if (last_ctx) {
 		flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
+		io_ring_ref_put(last_ctx);
 	}
 }
 
@@ -2566,7 +2558,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		nr++;
 	}
 	if (nr)
-		percpu_ref_put_many(&ctx->refs, nr);
+		io_ring_ref_put_many(ctx, nr);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2610,7 +2602,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 	io_rings_free(ctx);
 
-	percpu_ref_exit(&ctx->refs);
+	io_ring_ref_free(ctx);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
@@ -2636,7 +2628,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 	 * might've been lost due to loose synchronisation.
 	 */
 	wake_up_all(&ctx->poll_wq);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
@@ -2654,9 +2646,9 @@ __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
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
@@ -2833,7 +2825,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	struct creds *creds;
 
 	mutex_lock(&ctx->uring_lock);
-	percpu_ref_kill(&ctx->refs);
+	io_ring_ref_kill(ctx);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
@@ -2848,6 +2840,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * over using system_wq.
 	 */
 	queue_work(iou_wq, &ctx->exit_work);
+	io_ring_ref_put(ctx);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)
diff --git a/io_uring/refs.c b/io_uring/refs.c
new file mode 100644
index 000000000000..af21f3937f09
--- /dev/null
+++ b/io_uring/refs.c
@@ -0,0 +1,58 @@
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
+				__alignof__(local_t));
+
+	ctx->ref_ptr = (unsigned long) __alloc_percpu(sizeof(local_t), align);
+	if (ctx->ref_ptr)
+		return 0;
+
+	return -ENOMEM;
+}
+
+void io_ring_ref_free(struct io_ring_ctx *ctx)
+{
+	local_t __percpu *refs = io_ring_ref(ctx);
+
+	free_percpu(refs);
+	ctx->ref_ptr = 0;
+}
+
+/*
+ * Checks if all references are gone, completes if so.
+ */
+void __cold io_ring_ref_maybe_done(struct io_ring_ctx *ctx)
+{
+	local_t __percpu *refs = io_ring_ref(ctx);
+	long sum = 0;
+	int cpu;
+
+	preempt_disable();
+	for_each_possible_cpu(cpu)
+		sum += local_read(per_cpu_ptr(refs, cpu));
+	preempt_enable();
+
+	if (!sum)
+		complete(&ctx->ref_comp);
+}
+
+/*
+ * Mark the reference killed. This grabs a reference which the caller must
+ * drop.
+ */
+void io_ring_ref_kill(struct io_ring_ctx *ctx)
+{
+	io_ring_ref_get(ctx);
+	set_bit(CTX_REF_DEAD_BIT, &ctx->ref_ptr);
+	io_ring_ref_maybe_done(ctx);
+}
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 63982ead9f7d..a4d4d46d6290 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -2,6 +2,7 @@
 #define IOU_REQ_REF_H
 
 #include <linux/atomic.h>
+#include <asm/local.h>
 #include <linux/io_uring_types.h>
 
 /*
@@ -52,4 +53,56 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
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
+static inline local_t __percpu *io_ring_ref(struct io_ring_ctx *ctx)
+{
+	return (local_t __percpu *) (ctx->ref_ptr & ~CTX_REF_DEAD_MASK);
+}
+
+static inline bool io_ring_ref_is_dying(struct io_ring_ctx *ctx)
+{
+	return test_bit(CTX_REF_DEAD_BIT, &ctx->ref_ptr);
+}
+
+static inline void io_ring_ref_get_many(struct io_ring_ctx *ctx, int nr)
+{
+	local_t __percpu *refs = io_ring_ref(ctx);
+
+	preempt_disable();
+	local_add(nr, this_cpu_ptr(refs));
+	preempt_enable();
+}
+
+static inline void io_ring_ref_get(struct io_ring_ctx *ctx)
+{
+	io_ring_ref_get_many(ctx, 1);
+}
+
+static inline void io_ring_ref_put_many(struct io_ring_ctx *ctx, int nr)
+{
+	local_t __percpu *refs = io_ring_ref(ctx);
+
+	preempt_disable();
+	local_sub(nr, this_cpu_ptr(refs));
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
diff --git a/io_uring/register.c b/io_uring/register.c
index f121e02f5e10..9c1984e5c2f2 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -28,6 +28,7 @@
 #include "kbuf.h"
 #include "napi.h"
 #include "eventfd.h"
+#include "refs.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -347,7 +348,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	 * We don't quiesce the refs for register anymore and so it can't be
 	 * dying as we're holding a file ref here.
 	 */
-	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
+	if (WARN_ON_ONCE(io_ring_ref_is_dying(ctx)))
 		return -ENXIO;
 
 	if (ctx->submitter_task && ctx->submitter_task != current)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a2128459cb4..1092a6d5cefc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -21,6 +21,7 @@
 #include "alloc_cache.h"
 #include "rsrc.h"
 #include "poll.h"
+#include "refs.h"
 #include "rw.h"
 
 struct io_rw {
@@ -419,7 +420,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
+	if (io_ring_ref_is_dying(ctx))
 		return false;
 	/*
 	 * Play it safe and assume not safe to re-import and reissue if we're
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index b3722e5275e7..de003b6b06ce 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -16,6 +16,7 @@
 
 #include "io_uring.h"
 #include "napi.h"
+#include "refs.h"
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -190,7 +191,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 * Don't submit if refs are dying, good for io_uring_register(),
 		 * but also it is relied upon by io_ring_exit_work()
 		 */
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		if (to_submit && likely(!io_ring_ref_is_dying(ctx)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.43.0


