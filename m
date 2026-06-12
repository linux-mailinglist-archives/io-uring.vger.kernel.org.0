Return-Path: <io-uring+bounces-13690-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ofLILT50K2qj9wMAu9opvQ
	(envelope-from <io-uring+bounces-13690-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5960A676556
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:42 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=ePXgmE6Z;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13690-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13690-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CCCCB300D37D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053A2374E57;
	Fri, 12 Jun 2026 02:51:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD46D2F12AD
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:37 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232699; cv=none; b=HGOKOA5biihy9ARKsGsfN19epVmBRVALFTtBhBHqbU6fn/qAPdV/QzNrrjUVWzQlu7efozuVI6rGoSPGDQvH6C566HRdjhEWHWCDWpfaC6W5Np0cHEK+mjOxD2yJG1gW4WtxyCSBS5X7i3KZYhXOd4EUNFEyDaMnAXFLuvs5YNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232699; c=relaxed/simple;
	bh=C/O/dzSLQ2bH2XmEm2q7oJIt4VZsdk0UEy5AB9xWFfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4v7xvr5QYx8/kera859QmL4dVfuQzloP1JMtVnsjrRcfAjnxNI0HYZi1jp4HLH7jEGHP3Xpk2wbhJAO6kPBvNSkjQlm4F4uIODR2ZQ4h/o9J0pB7N5SNW0vryqvqi9ceG28wxtsxUoX5PEkXTC7Do8YdXtUvzJFTze87XkJOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ePXgmE6Z; arc=none smtp.client-ip=209.85.210.48
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6b5c374e5so522576a34.0
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232697; x=1781837497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYJWwYLoV0c77hU1FQXCUimZ6vSEMbDSifWweBW8/jw=;
        b=ePXgmE6ZWBKXI4YcEygyuv+F024i8q9bf+MpgQ7wA4l+mzttsNa0hauUyYd56ar3yC
         5dD6amaK9mKBoc0YJUIENMmgLVnIP+IAZCu51KvlYrK+W56d9aAj3fiWidU0SdGQGVnT
         S9pBtMCrkKMIC+GcwXApa/6T5h6I6ac34gdc3RxtGa8ZJ4IrSXKvTopy90g+rqY/lJVF
         wrVfx43/6lzxnvbK2lBy1I9xL8j0Z/er4r0MytQIsNXMjwFuYPDayYc1ezH3dzBwGxfi
         fropZ4XszaVqnhvzU9cHiLLAupZ6xH1qVhJqeMBndxEkT+4q0SUinYZ7KoZK5ls1pgKW
         B3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232697; x=1781837497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UYJWwYLoV0c77hU1FQXCUimZ6vSEMbDSifWweBW8/jw=;
        b=TR+YkWZyn8iCH/G5dVlQVc6l9kU9tvrH3S826spnriAzLNOGUfv73JlhJmjxQWiYYi
         lZZQtGgW9eRkVwVj1nf/KxzMKOWnmr1DUqR0mRO2JuGL+O9w/XOzdjgPwbVnwfaFrl3b
         +fqI+E+7J3Bu7QHd9HHumGTWoS12G9LUPyzfdoDO0eCQtKAY2b2GS8+G5VPV1zLXGgZX
         ZsIPz7KzbIDWjFecO0zLEIWQCat6uUmsXJ9Gx/lKPcfQ5/fpXernwQzwClqAYpjzlQmy
         tcZUnWk1dIzWtP4QjOgOnIGlBKkxD5m1eLoce1lxf1saNBg2dtTozD4nFHmRRNpUqH5t
         pFZA==
X-Gm-Message-State: AOJu0Yz3cpZRgMb1f6hKqgxKYI8zkXyM3bXMmmVFXFgXMCF5NRkowboF
	gOe3xm9onHixlGVM8oU51hNICMhOMmjU0xLwTWBH/ogB/waRZCc+sLZ8bgGdmq3QpXyE9rpOFFG
	+ekSM6uw=
X-Gm-Gg: Acq92OGILt8BTtm0vOJIVYFBbNLoTq2vHrgWGL87WonpnOsT2kPmJC/mFn28iY5K1jg
	kNJZ84DPKEqr22S/EBw8ReFgPXpGNCY9jpa2abAyFSfZ1s7FrM/sChfmnybngUkkVbePqUnEON5
	0pmexaOWv+PA5AXdD1lR3AhhZuUmgAUpulcDaW4SBzgURfR+AqOPYWEhqEo6XMlJY+44SeLnHIk
	ooSiu9qBjG7wiltpMgWDgpEtyZG6GDATrib7EZSURZ4wX9cITJpk+41pqAPnWFw1wI3efC7dbDT
	lXv5bcSnJW8Dt16+lh2Z+53fDTYQrBhlkpb82dXZr8ah3YTqktFeXfVeViOLJtOuqMgb6OlI8Kp
	V7rX/ApqVSKsUbA7ZLOgRjSlDjgqLU2Bc0QEMwPCneA5PoR5EoB4rUB4jfy7p1EVAhVhv7UUoCC
	joZW8mufRdYCHNtce6jnZsXBTUOXERg30i6zJDGm7AGJreVxVRRCQcO5e8MXE3P2LS339Q
X-Received: by 2002:a9d:641a:0:b0:7d7:45b7:ed8a with SMTP id 46e09a7af769-7e7826596eamr542589a34.5.1781232696788;
        Thu, 11 Jun 2026 19:51:36 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: remove the per-ctx fallback task_work machinery
Date: Thu, 11 Jun 2026 20:48:32 -0600
Message-ID: <20260612025125.1690253-7-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13690-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,fallback_work.work:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5960A676556

With the tctx fallback running its entries directly, the per-ctx
fallback work has a single user left: moving local (DEFER_TASKRUN)
task_work entries out of a ring that is going away. Both of its call
sites are process context and don't hold ->uring_lock, the same
conditions the deferred fallback work itself ran under - so run the
entries in cancel mode right there instead, and rename the helper to
io_cancel_local_task_work() to match what it now does.

With that, ->fallback_llist, ->fallback_work, io_fallback_req_func()
and __io_fallback_tw() can all go away, along with the fallback work
flushing in the ring exit and cancel paths. Requests that get
orphaned by an exiting task now run via the tctx fallback work, which
the ring exit side implicitly waits on through the ctx refs those
requests hold.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 -
 io_uring/cancel.c              |  2 -
 io_uring/io_uring.c            |  7 +---
 io_uring/tw.c                  | 67 +++++++---------------------------
 io_uring/tw.h                  |  3 +-
 5 files changed, 16 insertions(+), 65 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 33de451127f9..a0de8dafd990 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -498,8 +498,6 @@ struct io_ring_ctx {
 	struct mutex			tctx_lock;
 
 	/* ctx exit and cancelation */
-	struct llist_head		fallback_llist;
-	struct delayed_work		fallback_work;
 	struct work_struct		exit_work;
 	struct completion		ref_comp;
 
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 4aa3103ba9c3..8c6fa6f367e4 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -565,8 +565,6 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	mutex_unlock(&ctx->uring_lock);
 	if (tctx)
 		ret |= io_run_task_work() > 0;
-	else
-		ret |= flush_delayed_work(&ctx->fallback_work);
 	return ret;
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16acd99ff083..33b4340d32a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -289,7 +289,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
 #endif
-	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
@@ -1204,7 +1203,7 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		io_move_task_work_from_local(ctx);
+		io_cancel_local_task_work(ctx);
 }
 
 static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
@@ -2350,7 +2349,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		/* The SQPOLL thread never reaches this path */
 		do {
 			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-				io_move_task_work_from_local(ctx);
+				io_cancel_local_task_work(ctx);
 			cond_resched();
 		} while (io_uring_try_cancel_requests(ctx, NULL, true, false));
 
@@ -2436,8 +2435,6 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
-	flush_delayed_work(&ctx->fallback_work);
-
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_dfl_wq to avoid spawning tons of event kworkers
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 0fa685aa3926..31f9feb42353 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -16,24 +16,6 @@
 #include "wait.h"
 #include "mpscq.h"
 
-void io_fallback_req_func(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
-	struct io_tw_state ts = {};
-
-	percpu_ref_get(&ctx->refs);
-	mutex_lock(&ctx->uring_lock);
-	ts.cancel = io_should_terminate_tw(ctx);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func((struct io_tw_req){req}, ts);
-	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
-}
-
 static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 {
 	if (!ctx)
@@ -46,34 +28,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 	percpu_ref_put(&ctx->refs);
 }
 
-static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
-{
-	struct io_ring_ctx *last_ctx = NULL;
-	struct io_kiocb *req;
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		if (last_ctx != req->ctx) {
-			if (last_ctx) {
-				if (sync)
-					flush_delayed_work(&last_ctx->fallback_work);
-				percpu_ref_put(&last_ctx->refs);
-			}
-			last_ctx = req->ctx;
-			percpu_ref_get(&last_ctx->refs);
-		}
-		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
-			schedule_delayed_work(&last_ctx->fallback_work, 1);
-	}
-
-	if (last_ctx) {
-		if (sync)
-			flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
-	}
-}
-
 void io_tctx_fallback_work(struct work_struct *work)
 {
 	struct io_uring_task *tctx = container_of(work, struct io_uring_task,
@@ -278,29 +232,34 @@ void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
 	__io_req_task_work_add(req, flags);
 }
 
-void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
+void __cold io_cancel_local_task_work(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node, *first = NULL, **tail = &first;
+	struct io_tw_state ts = { .cancel = true };
+	struct llist_node *node;
 
 	/*
 	 * The work list consumer side is serialized by ->uring_lock, see
 	 * __io_run_local_work(). Grab it to guard against racing with normal
-	 * task_work running, as the task may be exiting.
+	 * task_work running, as the task may be exiting. The ring is going
+	 * away, run the entries in cancel mode right here - the callers
+	 * provide the same process context the per-ctx fallback work that
+	 * they were previously punted to ran in.
 	 */
 	guard(mutex)(&ctx->uring_lock);
 
 	while (!mpscq_empty(&ctx->work_list)) {
+		struct io_kiocb *req;
+
 		node = mpscq_pop(&ctx->work_list, &ctx->work_head);
 		if (!node) {
 			/* a producer is mid-push, wait for it to link */
-			cpu_relax();
+			cond_resched();
 			continue;
 		}
-		*tail = node;
-		tail = &node->next;
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		req->io_task_work.func((struct io_tw_req){req}, ts);
 	}
-	*tail = NULL;
-	__io_fallback_tw(first, false);
+	io_submit_flush_completions(ctx);
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
diff --git a/io_uring/tw.h b/io_uring/tw.h
index 387e52004da8..3ade5ad577fd 100644
--- a/io_uring/tw.h
+++ b/io_uring/tw.h
@@ -30,8 +30,7 @@ void io_tctx_fallback_work(struct work_struct *work);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 
-__cold void io_fallback_req_func(struct work_struct *work);
-__cold void io_move_task_work_from_local(struct io_ring_ctx *ctx);
+__cold void io_cancel_local_task_work(struct io_ring_ctx *ctx);
 int io_run_local_work_locked(struct io_ring_ctx *ctx, int min_events);
 
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags);
-- 
2.53.0


