Return-Path: <io-uring+bounces-9867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68874B956C0
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 12:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230BA482E86
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 10:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633B3319601;
	Tue, 23 Sep 2025 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="moMXBcvJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA49130FC11
	for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758623271; cv=none; b=FmzIYeOEn0fc1aBvpXdtqihRUHAxYFs7Udsf/uzULjWh/Re2oPtvDxkLOw5xRhahoOf9MwpKeeBTNXngss/Whxd+JhaXatQSvcAuMst+YdRtwvBILnLJZdFaEgx82QXoC+twfoarME0kLOD8ouF+cr47w62TEHDr+0Kh80QADTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758623271; c=relaxed/simple;
	bh=qER0MNr0oESJfWQRrTncEobMeaMvhk9Llk3SEk8ycDo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=hOF6SCpuU6Q4XaAwkJlxXB4y63GxCEVGWa1rr/z0fu4ujfJ2Hds4dydv8znmnNOW5kfRL8VUrrUEwKx+W6Dpmdw+PSK1j9DFteiii35v7Vo2J81BQKpkv8ozMRbsYqGmOB7JcYQb5s3xK8uTbkPm9H86tNfIV0sxfA9++1FvvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=moMXBcvJ; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63604582e53so534194d50.3
        for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 03:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758623266; x=1759228066; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYxDRwNqfEvB+h5fbZxIPpCZ6jrVK2cFQwwppqgJ4Z8=;
        b=moMXBcvJn067m83vyqV0D32notQ+mUu71yO9uJL5wfptBvrgfMgjG/hmD7StPtC9mT
         vlvIUAVxf7xVlaA/wq2APtM26fJ7ZzPOiaMtqqw3r7MueNkIjti/wAxYLxN1YmsADx4l
         AtEe6Vf3TzQ4e6Ipv+c18LyQG+Yi9S1Wjwwf7vy45mQVADmlparU5CeB6j/g9uYbiRWO
         3X4IV4aFKRXqfWDKD/H63zbElt3iejdAvKGUKvdLV0j8395dSmBz8vxtbHgNG4livUwt
         G7lWRa1PqqoBk0VkVD/f0I6h/9Xohfr5IDtdRSt4KWgcYTTeAQwzOanXNWtHhGWhVEWT
         Xtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758623266; x=1759228066;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dYxDRwNqfEvB+h5fbZxIPpCZ6jrVK2cFQwwppqgJ4Z8=;
        b=tiIA+TAIyPjsRzua/dzykm92VTp6CsqgqN294sdmYBebX+D7r6tf6IibXKTQ1ANNZU
         iFVIKNEugBRWEm9aTiVZo0g5AwAhpDU5P5j8vUqJRtOfTzHEGEyvmSC6xgbTb1YtFlDG
         e7y9pPEUHqQW5+7R7VIScxvhOzJPLABto4xgAF1agFOjgLNgFe3AAKXPbBPrLsTSV8XE
         +R5ux0ucA0AjCknmkUvADkAQ58wKxwpT4GlK/y5GLErcugUSfJUJ+pglvp4RAglgx3X6
         a1l6H4dUH18slGENl4SA144gwB6pX/zJp1hXNqvxWNcC0A/iQAaCex8L76aLbOnR08Rs
         kpaw==
X-Gm-Message-State: AOJu0YwsXjKV9Z2Z403E/g4joDhWwb5cCzB41IVNc12L1jwkGR6n+U6A
	R+thQzJJzJZAL7vaYUfmhS+AQ9x2/POsIBFix2W/Thhe3Wh7orBmfC7Y/IgTiOtDvXYQM1WEHrN
	kGJUtAUo=
X-Gm-Gg: ASbGncvk3jcubRRSDQslRQRpFZ6jLnyCFY10JUHur+8GnPjUPHxzXv1MwGjk+i6ld5F
	r1oJrKkx1gJWz+PjvOeNM6+/qkVPLniMaWn/hPRSPiQsa5+GlnKHLKSS3sgXgPqil2xkNlkAmdM
	zjP1pPmtURugkVMDoA2aAx38CuVyqHzMFYgWPsffZw89VbBS488yqvxjQDbEZIVyFVFqPuNbmkf
	n4Dg0q59HLY3CLrYD5kz5buZuZ+clVQX56X4Qi+4t2dA+ZNDUVVhWAHmZvIho8OTqu67EBoQjMR
	+zbR6UgHEDGqBYfPtwFVRR4aX44T/TCkBtKSK5n2Y2B938Q2Eo2Khh9hpECrHlLrDZaLXcR0G0u
	41LNfD4xuU87uojl6DbhFznoPLRYisN8Hx757sNpZisX5c6gmfWsVgMeVoAxIlPk=
X-Google-Smtp-Source: AGHT+IGbHzDqCkH2qVeVQ0w7tvGd2MesojECx3MEZk+CQCtZe3gn25gytDFNWywyxliXfu6WYF46dQ==
X-Received: by 2002:a05:690e:1b57:b0:62c:8e48:4340 with SMTP id 956f58d0204a3-63604752d6dmr1276596d50.26.1758623265939;
        Tue, 23 Sep 2025 03:27:45 -0700 (PDT)
Received: from ?IPV6:2600:380:525f:ef4:7d81:5c88:186d:41e2? ([2600:380:525f:ef4:7d81:5c88:186d:41e2])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5ce728fadsm4874477276.12.2025.09.23.03.27.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 03:27:45 -0700 (PDT)
Message-ID: <41351b1a-6177-4840-8639-aedb01b2b842@kernel.dk>
Date: Tue, 23 Sep 2025 04:27:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: unify task_work cancelation checks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rather than do per-tw checking, which needs to dip into the task_struct
for checking flags, do it upfront before running task_work. This places
a 'cancel' member in io_tw_token_t, which is assigned before running
task_work for that given ctx.

This is both more efficient in doing it upfront rather than for every
task_work, and it means that io_should_terminate_tw() can be made
private in io_uring.c rather than need to be called by various
callbacks of task_work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c2ea6280901d..25ee982eb435 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -474,6 +474,7 @@ struct io_ring_ctx {
  * ONLY core io_uring.c should instantiate this struct.
  */
 struct io_tw_state {
+	bool cancel;
 };
 /* Alias to use in code that doesn't instantiate struct io_tw_state */
 typedef struct io_tw_state io_tw_token_t;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 49ebdeb5b2d9..a4e85bb08e59 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -265,6 +265,20 @@ static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 	complete(&ctx->ref_comp);
 }
 
+/*
+ * Terminate the request if either of these conditions are true:
+ *
+ * 1) It's being executed by the original task, but that task is marked
+ *    with PF_EXITING as it's exiting.
+ * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
+ *    our fallback task_work.
+ * 3) The ring has been closed and is going away.
+ */
+static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
+{
+	return (current->flags & (PF_EXITING | PF_KTHREAD)) || percpu_ref_is_dying(&ctx->refs);
+}
+
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -275,8 +289,10 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.node) {
+		ts.cancel = io_should_terminate_tw(req->ctx);
 		req->io_task_work.func(req, ts);
+	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -1147,6 +1163,7 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 			ctx = req->ctx;
 			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
+			ts.cancel = io_should_terminate_tw(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -1205,11 +1222,6 @@ struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
 {
 	struct llist_node *node;
 
-	if (unlikely(current->flags & PF_EXITING)) {
-		io_fallback_tw(tctx, true);
-		return NULL;
-	}
-
 	node = llist_del_all(&tctx->task_list);
 	if (node) {
 		node = llist_reverse_order(node);
@@ -1399,6 +1411,7 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
+	tw.cancel = io_should_terminate_tw(ctx);
 	min_events -= ret;
 	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
 	if (ctx->retry_llist.first)
@@ -1458,7 +1471,7 @@ void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
-	if (unlikely(io_should_terminate_tw(ctx)))
+	if (unlikely(tw.cancel))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..78777bf1ea4b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -558,19 +558,6 @@ static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 		      ctx->submitter_task == current);
 }
 
-/*
- * Terminate the request if either of these conditions are true:
- *
- * 1) It's being executed by the original task, but that task is marked
- *    with PF_EXITING as it's exiting.
- * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
- *    our fallback task_work.
- */
-static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
-{
-	return (current->flags & (PF_KTHREAD | PF_EXITING)) || percpu_ref_is_dying(&ctx->refs);
-}
-
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 {
 	io_req_set_res(req, res, 0);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index b9681d0f9f13..c403e751841a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -224,7 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int v;
 
-	if (unlikely(io_should_terminate_tw(req->ctx)))
+	if (unlikely(tw.cancel))
 		return -ECANCELED;
 
 	do {
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 17e3aab0af36..444142ba9d04 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -324,7 +324,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
 	int ret;
 
 	if (prev) {
-		if (!io_should_terminate_tw(req->ctx)) {
+		if (!tw.cancel) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d1e3ba62ee8e..1225f8124e4b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -118,7 +118,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
-	if (io_should_terminate_tw(req->ctx))
+	if (unlikely(tw.cancel))
 		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */

-- 
Jens Axboe


