Return-Path: <io-uring+bounces-1411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7463F89A1CB
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 17:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF47C1F2254A
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878F416F27B;
	Fri,  5 Apr 2024 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNvmUNl9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B804116F85A
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332216; cv=none; b=AOMGziDFz/OxAojNA9R1hEZVTpVM/RzBdKxKEX+/W/U5svFVFsTJGeM0/eQB36lki1gIucof9a7im866T6pFbD4SRCLl285h8oGyIsC0/U/hSV+E6fUJR76dfa9zpQjCVzmNhaUaYOZwwPGYz9Fs1JNloRqydj42635aPhbtVTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332216; c=relaxed/simple;
	bh=ivG4baHe8jvZDHz51NYdk34fk/ji3JHYkVbRpuIa3H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4bKGZn6whTNeZZT3LipJeDFSfiLjxUo3meVAh5qwMn78Bx2Yr6paLjNWeMe+WAtNm8RmsxbBTsoCO/XOQsSQwOBEBMnNGs9HYkrSyaTAlaeWHAnGjhyVKeZgmUDp4lF3jU8dCLi71nxGgUwEUt46jvtdDvwz51W5gxC0UNwyzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bNvmUNl9; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a468226e135so330984466b.0
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 08:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712332212; x=1712937012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKMEblkDI7QPYIeMCqCL6ua5DWNpr+kCM+xZPnX6/xc=;
        b=bNvmUNl9q9qFtiGk3iIL1cJ5XepvqW42NnPrwvJhGRMq66KIGFlwijj/Yry/CoxmGo
         MoAHFR1FVrVI07S/PaTTUQC300zL/KS97mb//QGne1+mHF8sJACAAw69ILqhzDSSZVrc
         Njz4GZRnqauedEmJlufTZcyoMSZpBDWL2L7+rXi/n69U1+wQvqOTmNCuJyyXJFzEXozf
         uEPTU7Fl19rNIluDKL2uH7/iCNtlNAf1QZ6qX69PTPXCXMvv/Gojj4GU7FyGquTcUckt
         QXlXBqKPSkf7fRldCruz116oGZlkVVXcuDhMy011z1732M3uBreO0WxS3Ec3o12X5yCk
         rL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712332212; x=1712937012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FKMEblkDI7QPYIeMCqCL6ua5DWNpr+kCM+xZPnX6/xc=;
        b=qvNqYtP8XUex0jWgJ53zZ50Q4GzqWmA92djRnVjJyU1iwhJQodpKIhaPdlW3ey3war
         zPzPVGao4+zu+4cFS2Mc8sdfKmzC6N+S1jn0ABun6Zwn0ydAhMNYHMq67is1C2hzON2d
         nMoACnA6WLnRWH5WHJ+i+FETFvNUrrksCcGfg9qw2PL6LceANGsYw5DczMPftpRO052e
         O2i42Gqq5jMllxDW7pXVB2XNrcdERGTBmVyiYqF1t/I1XXaNes2R5AwUPfA4cM/OMS8z
         IaQeTway7m+U0xMPw0NuhfOb0jKOzBKBOR4du8/+WgqRcNTnmjV/Prp7FnCB1jDvNlAR
         1cWw==
X-Gm-Message-State: AOJu0Yylr3q42x7pI9qTuy9hvWsuR3KTG1vWGpCXAB7AQd2gFFn0oZSH
	96wGFgy7HYMoV0KMRbdJPnN/17mY6+ZkPWcfpwjUTITYHE2a9JFPkhCvF2Xj
X-Google-Smtp-Source: AGHT+IG7XmzxUYgDaSUyPNK+5KDrKWIP7xWbpjExkbPKLsA3iB4G9Y3paPQIGmrtOHzywspKybOLVA==
X-Received: by 2002:a17:907:985b:b0:a4e:109f:7b4b with SMTP id jj27-20020a170907985b00b00a4e109f7b4bmr1513990ejc.41.1712332212337;
        Fri, 05 Apr 2024 08:50:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a46c8dbd5e4sm966105ejb.7.2024.04.05.08.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:50:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-next 1/4] io_uring: kill dead code in io_req_complete_post
Date: Fri,  5 Apr 2024 16:50:02 +0100
Message-ID: <1d8297e2046553153e763a52574f0e0f4d512f86.1712331455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712331455.git.asml.silence@gmail.com>
References: <cover.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

Since commit 8f6c829491fe ("io_uring: remove struct io_tw_state::locked"),
io_req_complete_post() is only called from io-wq submit work, where the
request reference is guaranteed to be grabbed and won't drop to zero
in io_req_complete_post().

Kill the dead code, meantime add req_ref_put() to put the reference.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 37 ++-----------------------------------
 io_uring/refs.h     |  7 +++++++
 2 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8a9584c5c8ce..b7f742fe9d41 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -930,7 +930,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_rsrc_node *rsrc_node = NULL;
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
@@ -947,42 +946,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		if (!io_fill_cqe_req(ctx, req))
 			io_req_cqe_overflow(req);
 	}
-
-	/*
-	 * If we're the last reference to this request, add to our locked
-	 * free_list cache.
-	 */
-	if (req_ref_put_and_test(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS) {
-			if (req->flags & IO_DISARM_MASK)
-				io_disarm_next(req);
-			if (req->link) {
-				io_req_task_queue(req->link);
-				req->link = NULL;
-			}
-		}
-		io_put_kbuf_comp(req);
-		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
-			io_clean_op(req);
-		io_put_file(req);
-
-		rsrc_node = req->rsrc_node;
-		/*
-		 * Selected buffer deallocation in io_clean_op() assumes that
-		 * we don't hold ->completion_lock. Clean them here to avoid
-		 * deadlocks.
-		 */
-		io_put_task_remote(req->task);
-		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
-		ctx->locked_free_nr++;
-	}
 	io_cq_unlock_post(ctx);
 
-	if (rsrc_node) {
-		io_ring_submit_lock(ctx, issue_flags);
-		io_put_rsrc_node(ctx, rsrc_node);
-		io_ring_submit_unlock(ctx, issue_flags);
-	}
+	/* called from io-wq submit work only, the ref won't drop to zero */
+	req_ref_put(req);
 }
 
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 1336de3f2a30..63982ead9f7d 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -33,6 +33,13 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+static inline void req_ref_put(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	atomic_dec(&req->refs);
+}
+
 static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
 {
 	if (!(req->flags & REQ_F_REFCOUNT)) {
-- 
2.44.0


