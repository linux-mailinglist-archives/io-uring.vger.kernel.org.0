Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710DC3024B0
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 13:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbhAYMME (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 07:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB5AC0611BC
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:21 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g10so12058661wrx.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jDk96/cb1BKygJ8fG3IrH5uzwae6v8GlmEl+pGJrmjM=;
        b=npNh2erCMhmdYeYEUMCn1tOoxOoQtTpTds7fW39IondVHPVPGEHyup0Ndce+BFMRyq
         7ly7gzCYoSp4zw8Iwu+L805zuGGkPCkCA2x1R550kJfVd0djVhj69tpEHFqyhaHpwu97
         vIf2vnInzObtIAemm/LeRsFxrL8arinp/BS5f5W+e2RMArN+tyVxLPO+bKsLbUv2nqtq
         5IBxkh8+4XiIbtP6821GIgseuLdkNNTy2HY7ULOSkMez6o0IsAiHs6AfEULpEoXqfmY2
         A1vVWIuH462YJZ4lYb0Rs1ABB7/756+qwYN8MpHlP8pHSqw6HQ05IzGcWVat8ZhpKfZT
         DMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDk96/cb1BKygJ8fG3IrH5uzwae6v8GlmEl+pGJrmjM=;
        b=kQSH9uZx4HXTcfsQQHvvShkWerF3qrydI5f3Gn31BgAN0tYbSKn8koo57XVQrblQzP
         7Tvd4eZ9bA9InLbyD5O8idQn+55aF6b4SjChG3U5j5BQ5smJVxl58Z3Ho77tyUzx66Ls
         8z0WMPDX2lB0qWazgDJtwyMV/os4UPrAvOduKU9niAzKjbI7FhdIOu2Hf/F6sPkfylSI
         iLbJciDbIuI0SNL/SNBQnfVumCqvTW4w/IohBB3cWd967NWULunQrdzhywTSiTf64Z8u
         St+2oqflugbIcTlox/iujx0oWW2DJ7eYtNPYodIrKNzlDCZ6uriWNtWViigrZPjj3kQa
         dosg==
X-Gm-Message-State: AOAM532pj6/nGfLZNfI2eCaVotcS0qgTVvmV04sYi2F2IzlVAdcwEZth
        9LzFR+9ZDPerUCTDAsdTnnc=
X-Google-Smtp-Source: ABdhPJxVarYXYFgIe6lUPPlFcoyqxWfV+pySqk/3HsZFc/WQnhjPc+2ckTnp4kbFa9S46/HPYjqs/A==
X-Received: by 2002:a5d:5411:: with SMTP id g17mr522350wrv.54.1611575180349;
        Mon, 25 Jan 2021 03:46:20 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: submit-completion free batching
Date:   Mon, 25 Jan 2021 11:42:26 +0000
Message-Id: <5137090db5cbd8a3808cffe3879bc8cd0ff24a12.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() does completion batching, but may also use
free batching as iopoll does. The main beneficiaries should be buffered
reads/writes and send/recv.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fcd8df43b6bf..7a720995e24f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1898,26 +1898,6 @@ static void io_req_complete_nostate(struct io_kiocb *req, long res,
 	io_put_req(req);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx)
-{
-	int i, nr = cs->nr;
-
-	spin_lock_irq(&ctx->completion_lock);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = cs->reqs[i];
-
-		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-	}
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	for (i = 0; i < nr; i++)
-		io_double_put_req(cs->reqs[i]);
-	cs->nr = 0;
-}
-
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags, struct io_comp_state *cs)
 {
@@ -2303,6 +2283,35 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		__io_req_free_batch_flush(req->ctx, rb);
 }
 
+static void io_submit_flush_completions(struct io_comp_state *cs,
+					struct io_ring_ctx *ctx)
+{
+	int i, nr = cs->nr;
+	struct io_kiocb *req;
+	struct req_batch rb;
+
+	io_init_req_batch(&rb);
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < nr; i++) {
+		req = cs->reqs[i];
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	for (i = 0; i < nr; i++) {
+		req = cs->reqs[i];
+
+		/* submission and completion refs */
+		if (refcount_sub_and_test(2, &req->refs))
+			io_req_free_batch(&rb, req);
+	}
+
+	io_req_free_batch_finish(ctx, &rb);
+	cs->nr = 0;
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
-- 
2.24.0

