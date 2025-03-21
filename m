Return-Path: <io-uring+bounces-7175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1B3A6C35C
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A34DE4814ED
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4720F22C35D;
	Fri, 21 Mar 2025 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Sa752X2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB477225A20
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585506; cv=none; b=J3fJgCK7EDA9g97DJfiH5CKSCqCi9EeSbfcWRAwiad2K0iuGvbcYACjC5f8HMcLqSZrQ+6jOnAbvdqGYgnQK013+ihJvN2NlSX02ppTmIizohUCCw7LNJAW6bGLJ30q6RyVjRFi9JDER78XkQsprjdHOh+lK4C9rNdT7tzMjH44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585506; c=relaxed/simple;
	bh=TWHf8sidIKTXj3vh9lpN8ep+HAEsBdmybz1YeWb2ICk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qnhn8R30D6syBb/rX30WhAnFDQYTCiYUsjYtezqsIlMjzkWMH7FIIlmIW85et6HKw4wpMri3QMucHvoRWWJQOrFa+6Weahl0GKTYgTra8xRpYggcMbBqpOMGvzIJwH1mZSyOcvxTlI1nGIq0k7Y8R6PbhQznp44IMy3JmjaDmgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Sa752X2G; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85b3f92c8dfso77926139f.2
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742585502; x=1743190302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7ct+aok0+e88ngkQ9ijTRO+pVsgJ58u38oJY4wLvbk=;
        b=Sa752X2G2rnVOzVbozn+OZJBJ/0aSI75br0WaBL+JfzRNgiFyMdTQinRSK9XyQ750p
         UE3T0F0AwLDWd8ha+L37W2SSqjrMmRB1tYbK9uAd6Nbi4JBI6QumNYR4yzfiZFAbA0LI
         v/+j0FflOCrNAE9S7hHHPB2eXMrC8Xm8I4pfrlZ3TNGMLqbaac+/jHIxHjLxccyhl7R+
         yfC16BvkGX+D7/Qmuod8jXBtr8GiP1sEwlrZc3SC80fZgfB1xwXGBexaX4JNMvAjIWFw
         VvGFNbfGDAvhZIATPHVSHEWpvw+Y2q9d2VL/vQFteO/++CXPeVkcmSDp1jBbb0bxzyzK
         XEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585502; x=1743190302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7ct+aok0+e88ngkQ9ijTRO+pVsgJ58u38oJY4wLvbk=;
        b=Yk0hDQxuEaP8J4qSJa5yEPaFKY6DjqmTb7acloqHp42pqXhH5EE7u+ZmiESWtyL6Fm
         w35m0J0jYuPuS8gbRl4L1XvnGMoEK/qR4bhHKT8m++oRQmdIQ0XktvKMOuj6AupSBIYd
         PZIRQW2EjnyyDWhN1txL3WSzB/vmSp4flVcwqIlw01v99rb0nUPhef0QLbT/wnlvs8S6
         6AHiAvix68BVs8Q72rLsxsIhND9uUxHqf5l4LB5nP9R4abfU5ZP9czgZad6gC/x+/qe0
         EQbIgw36l4p3O74SEecYDYDyxbE0wZ709Or9YAcIqnDSsNFDTlENqVTjbiQBRag+sstr
         8KJA==
X-Gm-Message-State: AOJu0YwnKPFCQfPFj5o9yTpy5iNQZbc1kiUpW06gPwWD4qeD6+MP9nHM
	eU/JWK2V5Mgob3iQJxSHTEfd7xRJ/vrZUTKjU9SQBSpEGQLKyrTRqZiqtTx/ie8oh+mbq0q7eE6
	j
X-Gm-Gg: ASbGncscRw3aTFUdV2qJa3LOu2S3GVVAd6+eFIZa8yF8jzdbihURRLylp2405MapI3L
	umyvyAn+XNc7ltF439uhG3GlBsqegg05We2+EaVmVH6lVOSsORoznSoYIu3qJlsLRaIuyzSQffo
	ngo8GG+lCySi1nTu4Cde4yXREkZx89F7cmTzRtLZwvEorK1gHo96dh32zb1op8dyUHh8qrg4mJM
	ZlKQMEIvxv7cNOsWNpUJMPlt1aCp8xhoKICp8otgaUdbhoQJ1YjkVtnhQPKL30T9XFq+bXadxpX
	Su1sfjbx7QxaQCirK2z7Sw5Mg2olI/p32UdmFoKflNhSs5JObA==
X-Google-Smtp-Source: AGHT+IGNRnt4rzZJAHoD3dEpG69YDtr4uytrMiOPn8OYlhL2VyHmNMiPkUwqJjwR9eZumSUgTZkY/A==
X-Received: by 2002:a05:6602:a10d:b0:85b:46b5:6fb5 with SMTP id ca18e2360f4ac-85e2cb4605cmr333349939f.11.1742585502149;
        Fri, 21 Mar 2025 12:31:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdeac82sm571268173.71.2025.03.21.12.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:31:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: mark exit side kworkers as task_work capable
Date: Fri, 21 Mar 2025 13:24:56 -0600
Message-ID: <20250321193134.738973-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250321193134.738973-1-axboe@kernel.dk>
References: <20250321193134.738973-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two types of work here:

1) Fallback work, if the task is exiting
2) The exit side cancelations

and both of them may do the final fput() of a file. When this happens,
fput() will schedule delayed work. This slows down exits when io_uring
needs to wait for that work to finish. It is possible to flush this via
flush_delayed_fput(), but that's a big hammer as other unrelated files
could be involved, and from other tasks as well.

Add two io_uring helpers to temporarily clear PF_NO_TASKWORK for the
worker threads, and run any queued task_work before setting the flag
again. Then we can ensure we only flush related items that received
their final fput as part of work cancelation and flushing.

For now these are io_uring private, but could obviously be made
generically available, should there be a need to do so.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5f625be52e52..2b9dae588f04 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -238,6 +238,20 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 }
 
+static __cold void io_kworker_tw_start(void)
+{
+	if (WARN_ON_ONCE(!(current->flags & PF_NO_TASKWORK)))
+		return;
+	current->flags &= ~PF_NO_TASKWORK;
+}
+
+static __cold void io_kworker_tw_end(void)
+{
+	while (task_work_pending(current))
+		task_work_run();
+	current->flags |= PF_NO_TASKWORK;
+}
+
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -253,6 +267,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	struct io_kiocb *req, *tmp;
 	struct io_tw_state ts = {};
 
+	io_kworker_tw_start();
+
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
@@ -260,6 +276,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
+	io_kworker_tw_end();
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
@@ -2879,6 +2896,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
+	io_kworker_tw_start();
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
@@ -2935,6 +2954,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		 */
 	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
+	io_kworker_tw_end();
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
-- 
2.49.0


