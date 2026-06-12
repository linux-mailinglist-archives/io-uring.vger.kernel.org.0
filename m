Return-Path: <io-uring+bounces-13688-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id kR9VKjt0K2qi9wMAu9opvQ
	(envelope-from <io-uring+bounces-13688-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 815B5676551
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:39 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=BMOM434N;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13688-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13688-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6D9F03028AE4
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1303737FF41;
	Fri, 12 Jun 2026 02:51:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428EE2F12AD
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232697; cv=none; b=AGQz+2FABNl1xPpw+cGnMeBsMnjXh8XGCz83g8RS7OU0pk4rnx2iwFJqj9Ia1sCsAwv+v35CbnoWzGUGESksGZOKT1KR+fQ2ic2Vvm3foQEUqPNEc8bMCPC61+J5+iXMTeRbRFvaNKi02Atrs8gtSqblhL1CWnwzgLk2beGnxro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232697; c=relaxed/simple;
	bh=zcVppFxeHVg+uhvome74pcIMDDLufidH0PzEtL54FkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUsuwLP2kd6FO/l64yb2PtIsK475xQmPmVhBSk6/pP9OZ1l3kZH7hiH541q3dSytMzDU4w5krvfi/6ZTpDSaGEfiHgQdKROGl21NeZ2GJ1cr+YaerP6Lq1U9dO4DU9UpXIZ6j46he/Op5EVFAOO/iqXPF7wtVKaIZHjiWwTTkIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=BMOM434N; arc=none smtp.client-ip=209.85.210.53
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6f586a0d5so291248a34.0
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232694; x=1781837494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFfXYKGam7qUD6FfDdyFXOCRafZUmkmYqNH8ErbqfrQ=;
        b=BMOM434NT+HogLB0kYGkOMhdQ11XPUYM+1Fo9q5Dflyq8ltlu2JX+b7+IgzwdnX8uX
         IurQzMwjLEFJ5P9NGb1AP0MreIcND3UsAWRLzdFLTfR0g3cv8pD9DE+BPUW+Pjky/b5G
         MvCZNxfWCj9sUb5yN+NPNBsSP1aal62jA0qz3Mvh3Fq7duJYsjatD8Sl3hrHwDLphRdt
         Sym/+sr+LFkMfeDouxSAN/S2QgZZQ7LurFeUTp/LveyCOz6XwQ9JBLaLGnkeDE2ciRgr
         wBPB7xXdeI/MLI60jg7HQRY4WIvwk0Uy4MUM8ZhN4zUevTCtgWpFPO/uCiNiKzAdensm
         kFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232694; x=1781837494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZFfXYKGam7qUD6FfDdyFXOCRafZUmkmYqNH8ErbqfrQ=;
        b=j7VqXK4DapXgrxpXoVGQInzSmkWEtSJpI+6jscBZDxcknDEPrcKNGSphWdzTcoAMfs
         MXvq/Oi32UaE6ayAymqmrjePCVHpkjtjhuX4pgS7PkE7/UF3l9mOWHAMOTCwUT4uNAKs
         5Lo31PSrmOlSMeMlHKO98Fi3Gy6IigqcneyxvPJ7FqZBBA+rTl/onHInhNSoUMi/PJV7
         w1uGUGB6L3aczT9pQR/TFrGFkjA32R0Mb6JMKgszGhmFr2q3AWjD45ks3OJ7zf3cbEVr
         vz05eY9ydWOzJTJreFWo3fqHmsSV/P0OXI/GNtbgHQ7fr6IeHJfzpv+/kPLb5mQYWPhU
         xFxg==
X-Gm-Message-State: AOJu0YxSyuexJ4fEelwJXRYtaWNlz+iRLT7rVxnr5y5zUT2UBdzF24XX
	mn9e2lFtYOHlM944Z4tH9PkPUc1g0k1EAMGQDC1c3IHPxhucILbTxRX5BxvzZDL7GX17KncG96E
	K5F2M608=
X-Gm-Gg: Acq92OF0YIRDJ90yHPILPysy6esW0tY/6CNrwDRtXZWl1+wECuekML0YgzGX4kVpCjp
	Ax9DbPaKfHr02cuzxMqOBnJeobVnuItmlwHkXSQ1geQo+qAvw9xrwcXCPq0w2o5s17XLrzEHN+4
	aguTfFC8GE3FApTbDSzNjq/4ZTBqXIpm6rcbzL89x0SH7dbOnvdS7UuQwfkWB/kRgu1o7Dcuj67
	13OIOowaA+oqBmn15E5aNBCX4F7NTGUEaleslgVlpE7m6HSMtr5eGJsLuprAcmaMtQrAftjcj2F
	aZMjyejJfPciKxjxP89cJlm7nKIAArtMHe/i9FtvmYgHnMKNBtEibmcuYcDvpHclUiAc/3uPXGh
	FlAoRfdZ9yG01+VQBnEHsjnjVmD0b9lU0728VbtpiMgG17Zsj0nhm6l4Jy+dXG7z9cvYsbDX9Er
	Ztxo7ki54p5wPcPzsP920IN3Abbr4YBZ3LMWNWXnn8NpzQ5j8GdwISRM947AUsVw8rjSo9
X-Received: by 2002:a05:6830:4115:b0:7e6:ff83:4b36 with SMTP id 46e09a7af769-7e7846526e0mr555733a34.8.1781232694149;
        Thu, 11 Jun 2026 19:51:34 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
Date: Thu, 11 Jun 2026 20:48:30 -0600
Message-ID: <20260612025125.1690253-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612025125.1690253-1-axboe@kernel.dk>
References: <20260612025125.1690253-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13688-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 815B5676551

Like the local task_work list, the normal (tctx) task_work list is an
llist, and hence needs the O(n) llist_reverse_order() pass before
running entries in queue order. On top of that, capped runs - sqpoll
processing IORING_TW_CAP_ENTRIES_VALUE entries at a time - need the
claimed-but-unprocessed leftovers carried in a separate retry_list,
as they can't be pushed back to the shared list.

Switch tctx->task_list to a mpscq, like what was done for the
DEFER_TASKRUN paths as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  12 ++-
 io_uring/sqpoll.c              |  30 +++----
 io_uring/tctx.c                |   3 +-
 io_uring/tw.c                  | 146 ++++++++++++++++++++-------------
 io_uring/tw.h                  |   4 +-
 5 files changed, 113 insertions(+), 82 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9df5584ec3b1..33de451127f9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -131,6 +131,11 @@ struct io_uring_task {
 	const struct io_ring_ctx 	*last;
 	struct task_struct		*task;
 	struct io_wq			*io_wq;
+	/*
+	 * Consumer cursor for ->task_list. Only popped by the task itself,
+	 * or by ->fallback_work once the task can no longer run task_work.
+	 */
+	struct llist_node		*task_head;
 	struct file			*registered_rings[IO_RINGFD_REG_MAX];
 
 	struct xarray			xa;
@@ -139,8 +144,13 @@ struct io_uring_task {
 	atomic_t			inflight_tracked;
 	struct percpu_counter		inflight;
 
+	/* drains ->task_list once the task can no longer run task_work */
+	struct work_struct		fallback_work;
+
 	struct { /* task_work */
-		struct llist_head	task_list;
+		struct mpscq		task_list;
+		/* BIT(0) guards adding tw only once */
+		unsigned long		tw_pending;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 46c12afec73e..2460bd605266 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -260,39 +260,29 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 }
 
 /*
- * Run task_work, processing the retry_list first. The retry_list holds
- * entries that we passed on in the previous run, if we had more task_work
- * than we were asked to process. Newly queued task_work isn't run until the
- * retry list has been fully processed.
+ * Run task_work, processing no more than max_entries at a time. If more
+ * than that is pending, it simply stays on the queue for the next run.
  */
-static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
+static unsigned int io_sq_tw(int max_entries)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	unsigned int count = 0;
 
-	if (*retry_list) {
-		*retry_list = io_handle_tw_list(*retry_list, &count, max_entries);
-		if (count >= max_entries)
-			goto out;
-		max_entries -= count;
-	}
-	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
-out:
+	tctx_task_work_run(tctx, max_entries, &count);
 	if (task_work_pending(current))
 		task_work_run();
 	return count;
 }
 
-static bool io_sq_tw_pending(struct llist_node *retry_list)
+static bool io_sq_tw_pending(void)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
-	return retry_list || !llist_empty(&tctx->task_list);
+	return !mpscq_empty(&tctx->task_list);
 }
 
 static int io_sq_thread(void *data)
 {
-	struct llist_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
@@ -347,7 +337,7 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
-		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
+		if (io_sq_tw(IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -372,7 +362,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending(retry_list)) {
+		if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending()) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -411,8 +401,8 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	if (retry_list)
-		io_sq_tw(&retry_list, UINT_MAX);
+	if (io_sq_tw_pending())
+		io_sq_tw(UINT_MAX);
 
 	io_uring_cancel_generic(true, sqd);
 	rcu_assign_pointer(sqd->thread, NULL);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 42b219b34aa8..cc3bf2b3bdbc 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -103,7 +103,8 @@ __cold struct io_uring_task *io_uring_alloc_task_context(struct task_struct *tas
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
-	init_llist_head(&tctx->task_list);
+	mpscq_init(&tctx->task_list, &tctx->task_head);
+	INIT_WORK(&tctx->fallback_work, io_tctx_fallback_work);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return tctx;
 }
diff --git a/io_uring/tw.c b/io_uring/tw.c
index b8d6027aaeff..ca29bb0b9768 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -46,46 +46,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 	percpu_ref_put(&ctx->refs);
 }
 
-/*
- * Run queued task_work, returning the number of entries processed in *count.
- * If more entries than max_entries are available, stop processing once this
- * is reached and return the rest of the list.
- */
-struct llist_node *io_handle_tw_list(struct llist_node *node,
-				     unsigned int *count,
-				     unsigned int max_entries)
-{
-	struct io_ring_ctx *ctx = NULL;
-	struct io_tw_state ts = { };
-
-	do {
-		struct llist_node *next = node->next;
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx, ts);
-			ctx = req->ctx;
-			mutex_lock(&ctx->uring_lock);
-			percpu_ref_get(&ctx->refs);
-			ts.cancel = io_should_terminate_tw(ctx);
-		}
-		INDIRECT_CALL_2(req->io_task_work.func,
-				io_poll_task_func, io_req_rw_complete,
-				(struct io_tw_req){req}, ts);
-		node = next;
-		(*count)++;
-		if (unlikely(need_resched())) {
-			ctx_flush_and_put(ctx, ts);
-			ctx = NULL;
-			cond_resched();
-		}
-	} while (node && *count < max_entries);
-
-	ctx_flush_and_put(ctx, ts);
-	return node;
-}
-
 static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 {
 	struct io_ring_ctx *last_ctx = NULL;
@@ -114,43 +74,109 @@ static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 	}
 }
 
-static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+void io_tctx_fallback_work(struct work_struct *work)
 {
-	struct llist_node *node = llist_del_all(&tctx->task_list);
+	struct io_uring_task *tctx = container_of(work, struct io_uring_task,
+						  fallback_work);
+	struct llist_node *node, *first = NULL, **tail = &first;
+
+	/* see tctx_task_work() - a set bit must always have a run coming */
+	clear_bit(0, &tctx->tw_pending);
+	smp_mb__after_atomic();
+
+	while (!mpscq_empty(&tctx->task_list)) {
+		node = mpscq_pop(&tctx->task_list, &tctx->task_head);
+		if (!node) {
+			/* a producer is mid-push, wait for it to link */
+			cond_resched();
+			continue;
+		}
+		*tail = node;
+		tail = &node->next;
+	}
+	*tail = NULL;
+	__io_fallback_tw(first, false);
+	put_task_struct(tctx->task);
+}
 
-	__io_fallback_tw(node, sync);
+static void io_fallback_tw(struct io_uring_task *tctx)
+{
+	/*
+	 * The task ref both keeps ->task valid and, as __io_uring_free() is
+	 * only called when the task itself is freed, ensures the tctx (and
+	 * the queued work) stay around until the drain has run.
+	 */
+	get_task_struct(tctx->task);
+	if (!queue_work(system_unbound_wq, &tctx->fallback_work))
+		put_task_struct(tctx->task);
 }
 
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
-				      unsigned int max_entries,
-				      unsigned int *count)
+/*
+ * Run queued task_work, processing no more than max_entries, with the number
+ * of entries processed added to *count. If more entries than max_entries are
+ * available, the remainder simply stay on the queue for the next run.
+ */
+void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries,
+			unsigned int *count)
 {
-	struct llist_node *node;
+	struct io_ring_ctx *ctx = NULL;
+	struct io_tw_state ts = { };
 
-	node = llist_del_all(&tctx->task_list);
-	if (node) {
-		node = llist_reverse_order(node);
-		node = io_handle_tw_list(node, count, max_entries);
+	while (*count < max_entries) {
+		struct llist_node *node = mpscq_pop(&tctx->task_list,
+						    &tctx->task_head);
+		struct io_kiocb *req;
+
+		if (!node) {
+			if (mpscq_empty(&tctx->task_list))
+				break;
+			/*
+			 * A producer has published a node but hasn't
+			 * linked it into the queue yet (see mpscq_pop()).
+			 * Give it a chance to finish rather than spinning,
+			 * and don't sit on the ctx lock while doing so.
+			 */
+			ctx_flush_and_put(ctx, ts);
+			ctx = NULL;
+			cond_resched();
+			continue;
+		}
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		if (req->ctx != ctx) {
+			ctx_flush_and_put(ctx, ts);
+			ctx = req->ctx;
+			mutex_lock(&ctx->uring_lock);
+			percpu_ref_get(&ctx->refs);
+			ts.cancel = io_should_terminate_tw(ctx);
+		}
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				(struct io_tw_req){req}, ts);
+		(*count)++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(ctx, ts);
+			ctx = NULL;
+			cond_resched();
+		}
 	}
+	ctx_flush_and_put(ctx, ts);
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
 	trace_io_uring_task_work_run(tctx, *count);
-	return node;
 }
 
 void tctx_task_work(struct callback_head *cb)
 {
 	struct io_uring_task *tctx;
-	struct llist_node *ret;
 	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
-	ret = tctx_task_work_run(tctx, UINT_MAX, &count);
-	/* can't happen */
-	WARN_ON_ONCE(ret);
+	clear_bit(0, &tctx->tw_pending);
+	smp_mb__after_atomic();
+	tctx_task_work_run(tctx, UINT_MAX, &count);
 }
 
 /*
@@ -220,7 +246,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
+	if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
 		return;
 
 	/*
@@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
+	/* task_work must only be added once */
+	if (test_and_set_bit(0, &tctx->tw_pending))
+		return;
+
 	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
-	io_fallback_tw(tctx, false);
+	io_fallback_tw(tctx);
 }
 
 void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
diff --git a/io_uring/tw.h b/io_uring/tw.h
index f42db5fdbded..387e52004da8 100644
--- a/io_uring/tw.h
+++ b/io_uring/tw.h
@@ -25,8 +25,8 @@ static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
 }
 
 void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
-struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 void tctx_task_work(struct callback_head *cb);
+void io_tctx_fallback_work(struct work_struct *work);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 
@@ -36,7 +36,7 @@ int io_run_local_work_locked(struct io_ring_ctx *ctx, int min_events);
 
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_normal_work_add(struct io_kiocb *req);
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
+void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 
 static inline void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
-- 
2.53.0


