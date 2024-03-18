Return-Path: <io-uring+bounces-1075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A1787E160
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA6191F2219D
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEE6224F0;
	Mon, 18 Mar 2024 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XZP7rEbg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0392209D;
	Mon, 18 Mar 2024 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722636; cv=none; b=CXxiGCP4tdbk1O+GAb0StcTDKRYMy6yDqDMuLUswCyx8kWJvbixweCQcsz5pIXRrJm88YQYKmK+Bo6I/PMLqOde0djiBb/tN4nCDEPUotRTSeNHkbwt6WZNwMQ9Dbg6UI0JkKDc1/dEZihjk+1DghLuDBvCABQOVpYcyS1Xb+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722636; c=relaxed/simple;
	bh=tspyoNcqRcJMnQG7roFhmaTi2ZGh3rmyISZ/OP7BKQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzsdfbJo6Ku53/ATBFnZgmBo/U2XW9/tkCSL9M7viKpDPWg10lClXSUr05eXb8dTN8sGIWdhQo91NzsWCgBlWWjFuf8JgOhdhkpYaqxIT6iB40DCdzzHfoPSWY35HVtXoU7BCubwaB1NRM0y7VxajqScOkj8RHjugn6ojMZ8fOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XZP7rEbg; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d21cdbc85bso53744641fa.2;
        Sun, 17 Mar 2024 17:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722633; x=1711327433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8EA2C18hEB59l01Sz2plpqRO9/27NRPOgErU8VDH/I=;
        b=XZP7rEbgpJR4QiVm0p5IM2EloosHCAMl8fl6QUrtJEdsnWUPb9Gk5Ie+KUqXI5197l
         C79qfeKaIAkJTiOoNeun34f+VkGBIugaAYlL0yJQqI+ZO/4+ra2LoaIfeDt44rNjk9Be
         YUL8Gkd7nIPxwieJ4uEaQtvXlVS+Zwjngpq61ktlGr20FJxYXKhOHQw01c1DFfDwE7gA
         R72i5kGOfb7VkU85eIccdf6utixrsXTUMy0L+SlUCyzdc0xHty8pXq17Td1Vcd8/CGeY
         6C4m5JAR5QVW2jXcdBpZXgqEMvzGT13RxEp6vUOyERXT0+MPUcMMvCO+DIEeCEG0tu7n
         lTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722633; x=1711327433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8EA2C18hEB59l01Sz2plpqRO9/27NRPOgErU8VDH/I=;
        b=Ta56gSlnd1jVnO8IVLxgMzV2asaDSsHomXd5el6daTFNUfgIuEFUt93br5kwKpSP6M
         f3l8F+Fbs/BvoxNAD7vLXXCvuFhHbUpI0cQOz5BTdXZpm2lv7yQivO2pWVHus1ysXX4T
         aAVoBwtkcumBOJ4NFZq2TwY9xtzkE2PoOhX6LRXfjE6S77DybDVs9MAZjllWSW+UvZ6r
         olHWYtsFM3+FJVJSzcQ1rSYAsXxz6h99MutuIql445z39H96xCDG8xyFwCUwxRwHcixG
         bJpvMwNKGmPXo6+EOeukVHga6a+jR1EyrSCMv6/tK0/55VKxCvZOtSR6OatgjQe//Pun
         3Erw==
X-Gm-Message-State: AOJu0Yw+3wmSKUMQJLeRurvOovbPLBXD10/jvRhDQheMpC7gd5x/ZyM0
	vZZAlodRBc3raTHLiMIArP7FOKOmLnVgHWUDlmjtN3a18I6Kh3Sz15M8bZWf
X-Google-Smtp-Source: AGHT+IFBPp+zzvTY1fqaWU4tJrYl2jx4TD5WAnIVfE6WyWEShOnJG10VdmeG7HEY09Q+uOcZ0RqnIQ==
X-Received: by 2002:a2e:981a:0:b0:2d4:5850:28e8 with SMTP id a26-20020a2e981a000000b002d4585028e8mr5759509ljj.26.1710722633344;
        Sun, 17 Mar 2024 17:43:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 13/14] io_uring: refactor io_req_complete_post()
Date: Mon, 18 Mar 2024 00:41:58 +0000
Message-ID: <5ac955f317b2e57bec3d3ced95e59a1b08cd953d.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make io_req_complete_post() to push all IORING_SETUP_IOPOLL requests
to task_work, it's much cleaner and should normally happen. We couldn't
do it before because there was a possibility of looping in

complete_post() -> tw -> complete_post() -> ...

Also, unexport the function and inline __io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f0d46b81e799e36d85d4daf12e2696c022bf88fb.1710538932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 29 +++++++++++------------------
 io_uring/io_uring.h |  1 -
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0b89fab65bdc..68c69b553b17 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -926,11 +926,21 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
-static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
+static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *rsrc_node = NULL;
 
+	/*
+	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
+	 * the submitter task context, IOPOLL protects with uring_lock.
+	 */
+	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
+		return;
+	}
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP)) {
 		if (!io_fill_cqe_req(ctx, req))
@@ -974,23 +984,6 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	}
 }
 
-void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (ctx->task_complete) {
-		req->io_task_work.func = io_req_task_complete;
-		io_req_task_work_add(req);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-		   !(ctx->flags & IORING_SETUP_IOPOLL)) {
-		__io_req_complete_post(req, issue_flags);
-	} else {
-		mutex_lock(&ctx->uring_lock);
-		__io_req_complete_post(req, issue_flags & ~IO_URING_F_UNLOCKED);
-		mutex_unlock(&ctx->uring_lock);
-	}
-}
-
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4bc96470e591..db6cab40bbbf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -65,7 +65,6 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
-- 
2.44.0


