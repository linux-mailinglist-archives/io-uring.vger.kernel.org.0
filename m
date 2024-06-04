Return-Path: <io-uring+bounces-2098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 179F98FBC5C
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 397741C25006
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCEF14A629;
	Tue,  4 Jun 2024 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B0af9lpX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A614AD2D
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528404; cv=none; b=MRJ8V5AHOI3BA1epGeg6QQuIIQr+DWC0w68istjthcjojoFJoj4aKJEERTs/Uk8fuzjpZ/7m+GQC4VBT2TxXiSSN4aO/s3DazUntBn2BcYgX0tZ+SNqdWSVEfXDzJNuFg8UFhJvAAnSEdZFPlOQD3Z1JWqq3qex/w1nfWAf0KNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528404; c=relaxed/simple;
	bh=D+m/wSgQAbMA+02aZWRWA1Gwz4JUhMB+0I6b8qbq06k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwmVJ11WCivIOxFtYoTsGg+ziPDRy5RNrnv+knKrWdl66Gca8U/faJJvyYBhjYAHcmB+Kr/xFwxVF4rn3+n52Fd9en93vljf1v+5LQ0PsRbQbkrz1do9ugjhhcRdnHGMeJ5vopprSYx6hNTy9tUa7x/KgKz9/0K59dNuGE8zNWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B0af9lpX; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6c53be088b1so546668a12.1
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528402; x=1718133202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XuP3zpjuZ3vDa/VOrDbCkjCQYw9n0YiMJHOj6m2/Xo=;
        b=B0af9lpX69FPay5SrX2xAXATqxdF1Fk5E1cziCm20g11l+j7w1hGtGtcXqjTue0nYv
         ZwkiL1eBMg16GyZ4iiuXha7Qg4haX6q7BrXF6EmKJ15RkcVt5C8BM6ODm34MisULJ7L/
         9KIefxGrP/31lA1qyVw4TWdrWVNZ37WVuQRn4G8cE7MxTDHqsyp48PN1gT8B9tuj87Gv
         5y+ZX7G4G0i5Cq1wvl/X8Z+76z4d/9inx9Ey0fEoHTuTZjImVOeK+MABVb0tfqiiH78K
         63VzuZhyxTpbiuMRwoGVxbLlzVHkiBYwXTfNfCVikBVRyOSb+IyxIn8Y9eQEtCg3zYSm
         V5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528402; x=1718133202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XuP3zpjuZ3vDa/VOrDbCkjCQYw9n0YiMJHOj6m2/Xo=;
        b=HQgh9G08GnaSe1981Qi3si7tFpcFaG0jrTwn1W+UAFPtokk6txeuvFN3Xn7geX2k2e
         gMtNZxwMjHEJMxIt17BXOSo+CS/nxdvXpD0GpDJMy/j9M5TFPxG2yjBmCBSudHFyr4Qp
         HYGN4DEjZ7hb4xIpBYzVzxY76aqgmVjC+5ViYQxEqMpAGp31i19mYWNBjBEuFuS0mZmH
         eYHOXCHHKx3emSbk5XVp6TFRBOZ0sOK5vBn+RfyumUG60mHewee0zBsI60gPnVkegcg4
         IYl1nK6kybj+D4O+YBxYLGkxAOy9s49GDsYKEZhSFZjVG87TmkoEBP5bWcy0KYhhiXiZ
         oeRA==
X-Gm-Message-State: AOJu0YzwTrRuTgsZa55jwjcjDdXeI76h4KAq3Y2ZStvhyxesQWNnFg3W
	CpltwWoAaLZNCaquVX1Ns8EOKZCKORwl6M8Dx0MQeafwRbdgIL21KAvXeBBTJIhk5GmE9gc7cw8
	5
X-Google-Smtp-Source: AGHT+IGAoKhdXRhDtpufvSIrfJ3zzy3QPSAlVZkvRFki22lnwhTE3h85Z2pdhXNeQ9C20rcgbriLzQ==
X-Received: by 2002:a05:6a20:3caa:b0:1aa:68c4:3271 with SMTP id adf61e73a8af0-1b2b70ebef8mr634772637.3.1717528401830;
        Tue, 04 Jun 2024 12:13:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: mark exit side kworkers as task_work capable
Date: Tue,  4 Jun 2024 13:01:29 -0600
Message-ID: <20240604191314.454554-3-axboe@kernel.dk>
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
index 96f6da0bf5cd..3ad915262a45 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -234,6 +234,20 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
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
@@ -249,6 +263,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	struct io_kiocb *req, *tmp;
 	struct io_tw_state ts = {};
 
+	io_kworker_tw_start();
+
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
@@ -256,6 +272,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
+	io_kworker_tw_end();
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
@@ -2720,6 +2737,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
+	io_kworker_tw_start();
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
@@ -2770,6 +2789,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		 */
 	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
+	io_kworker_tw_end();
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
-- 
2.43.0


