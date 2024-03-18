Return-Path: <io-uring+bounces-1126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D6E87F2E0
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF14128114F
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CE85B20E;
	Mon, 18 Mar 2024 22:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaHDtb9r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5946A5B1EC;
	Mon, 18 Mar 2024 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799348; cv=none; b=jNMEIzxbLK03ZPBH3I6vheVr85R05Rzyt85kfe01lqys+55nVtJWg2RStfQ6PdHuf/+/UEhuhSB9vVhHewQWEZ9fWLjXSNJsTJ6yyCaCGluL2cRdG7RMUgji7/qb0+kOYiIlmPy7AhOfn6ZAqwezgursnDkMflzm4nyVPCgIT1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799348; c=relaxed/simple;
	bh=lR20SPFN7AEYF4hlpLAqRs9SBH6pj/xZec3GIigfjiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rt9QnSnB+4SE+a5hm2+9L5N9SL4tcAiB/LNBeazJ81nzuhg8ELRfs7AJyehwx4codoMBKwU9f96fyS/mXv/NlNFp2L9KxNlV1mseBpMC5jHTMLIq/BuKv8GIlRYlcofGvCtfo+am5SDC78l15k23gnQIjnDbOOxj8Xla4rMnkG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YaHDtb9r; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33ed5b6bf59so1985719f8f.0;
        Mon, 18 Mar 2024 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799345; x=1711404145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2smzkL0ccPd6EW+XOKsfNYEGXriaM8JzkEqntm67yY=;
        b=YaHDtb9r0iAg0/QGRtFi8wPztOhvk+uXcCkWv5I43CdhyDGOusUeLvi2EH2/qP/b2f
         Duq98pz6wbwYHNZY7oaDDTX1Rht7lX98n8cvQVrKrJPvu4Vae8Fk+Iq2eMYdhmendKKq
         yVVIYKwFjrwg0SrKz8b+z9O0YyX5iHBIq2zGBGjb9sB73smrlPvMiOqW4+3PbdorVVm/
         bxt1+lGPV6mbslUNv8cton0FBjPHXoIVEwsnk1ZOBsZ/8PTZVOhnHhuCeb00xdIBIumR
         1K0o7+fnpEgqVg+Cw6aPPqUolNk3QEbU98hBb4KMWbQeWAD/A6Yeb0Q/tKSizgLdrwoT
         p4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799345; x=1711404145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2smzkL0ccPd6EW+XOKsfNYEGXriaM8JzkEqntm67yY=;
        b=ptWlkhurhNlyMew2MnWOeja0/L8bXTJjrJnUxoVgdIVS+UooZK2FX4r/dfHTjAJBxh
         kRlec8fz/zJbTIfBogxZygLNqAdsxvMhaDA0l6FP45ZjhKEX2TbBkr0igBVLUkhTO8vR
         eXr7sqNY+MqoBMDO80e0FiqrgiUtDq5fn03q5oTH2oNdnsx9Q9WG3+qdsBRv1vLIWc/A
         850OK2yaFZ9KOePU/YBPvM9jbq4hxoO13Pb4oLkHTspFNtRXz2A6RvNbafAdKYn7w3+/
         2YZuNWGBjuzUnRbhxc7MCet5n2S7jWobMfr/Gg6u8tjJOTq1uLSPTmJGUgHPRMLt2fdC
         hvYA==
X-Gm-Message-State: AOJu0YyfO0c6GD/v4LLeXBmQnXRUYOYproLUV4s/HMR98lgkEKJKsHoY
	6ikF7GBvqlsI905HFhKGBeVnLr3+4/XtrC77rdvJuu9zJSxLw+MryZ2bb0Of
X-Google-Smtp-Source: AGHT+IHt1DQjEAjH4adUYqb6vaerxNfUMIA3bCl+8k9bzEYXFHUTDdCMfvko51IsAZ6QywtQSovnPw==
X-Received: by 2002:adf:f3d2:0:b0:33d:b376:8a07 with SMTP id g18-20020adff3d2000000b0033db3768a07mr7879097wrp.8.1710799345172;
        Mon, 18 Mar 2024 15:02:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 12/13] io_uring: refactor io_req_complete_post()
Date: Mon, 18 Mar 2024 22:00:34 +0000
Message-ID: <ea19c032ace3e0dd96ac4d991a063b0188037014.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
---
 io_uring/io_uring.c | 29 +++++++++++------------------
 io_uring/io_uring.h |  1 -
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 077c65757281..b07ab65591bf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -920,11 +920,21 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
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
@@ -968,23 +978,6 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
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
index 5119265a11c2..f694e7e6fb25 100644
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


