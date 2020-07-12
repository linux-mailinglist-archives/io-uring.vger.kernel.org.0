Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD20521C853
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGLJnO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD676C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so10894086ejj.5
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dcXrcuxbJK3MCbL02vjQxa4zV2KZ/CqQISwOVB0wdTQ=;
        b=uevwJrl+19W8Il4FTfUs920djEhBCRL4I0Tk37O7UgLVxx0K4tiqmVArYnyDaavbH0
         g6jV51sUiuDvA1lQu59ZwIDJbrtwG/jtio6k8DIkCCTg+MtoKOe1YIYTUPq/2ifTpj5/
         jhI/qxj0MCRRY9KCo7aBY8CNC+XYEI1Uo4yZNmiqYuB1ebmFMIUC2K8SgtaEHVtpm0qm
         CDYAoU9DXtq8Hzfq39P4TjYemHU2qDUutJsIk2O5DF8RNMmaAFSgnQMdZTrUOjTxqI2v
         iBfK/avc5gViMioXhJqhgtYF9/RR9lf9BhSYkH9VnPeDAewJNmyOUHX0wCUATvqqsoYu
         vY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcXrcuxbJK3MCbL02vjQxa4zV2KZ/CqQISwOVB0wdTQ=;
        b=NvWrM6n41sFaj6hCeMWU4fZ4Of3/tFnbuSR+BVp8i2rpykeBM0kSK6xAWPPyMmWjQc
         uFC8ir6OQd0S0fCYenNYcgmkjJMk1jaA+YeXuX/unVK7srHxY9EgFzN9pfkhdK/WCNUX
         nvLtfhjzg+SpwKePXE/Wm3vubAApQk+4OgfRUtSZAAUMY6qS77evIoKZM80OVtSNH14e
         xfL9LsaNCMfcScJk75HITyVP3W3GXNK/u98Qg3udI5BpsMpY6dgIie6+VVochHfXRb6s
         ptLwiaHKZ6osjgWlLOsj/HjczT6NIcmVdVYF+ETFwY01joEo/d2mr1grtg56xfAA9PUz
         3fQg==
X-Gm-Message-State: AOAM533yKeeKeepNW/YWXFFUZTA3GQ/CczIPAqMzKzSkpIZLZBMPrwwM
        m3XXfZGCNuIo39SL7H/opSWcCmry
X-Google-Smtp-Source: ABdhPJzL7xg8mj0YTCVHwP/8LBNt8vie7SM99JCh8AqjFGyccWDLhAquX9O7bU3nUgNv1YaRIwKJ7A==
X-Received: by 2002:a17:906:5246:: with SMTP id y6mr22647353ejm.316.1594546992526;
        Sun, 12 Jul 2020 02:43:12 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/9] io_uring: use competion list for CQ overflow
Date:   Sun, 12 Jul 2020 12:41:10 +0300
Message-Id: <7afe44908236ed556ebdc600e22a1f71255287d1.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As with the completion path, use compl.list for overflowed requests. If
cleaned up properly, nobody needs per-op data there anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb92cc736afe..88c3092399e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1335,8 +1335,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 			break;
 
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
-						list);
-		list_move(&req->list, &list);
+						compl.list);
+		list_move(&req->compl.list, &list);
 		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
@@ -1357,8 +1357,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	io_cqring_ev_posted(ctx);
 
 	while (!list_empty(&list)) {
-		req = list_first_entry(&list, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(&list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
 		io_put_req(req);
 	}
 
@@ -1386,6 +1386,9 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 	} else {
+		if (req->flags & REQ_F_NEED_CLEANUP)
+			io_cleanup_req(req);
+
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
@@ -1394,7 +1397,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		refcount_inc(&req->refs);
 		req->result = res;
 		req->cflags = cflags;
-		list_add_tail(&req->list, &ctx->cq_overflow_list);
+		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
 }
 
@@ -7822,7 +7825,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		if (cancel_req->flags & REQ_F_OVERFLOW) {
 			spin_lock_irq(&ctx->completion_lock);
-			list_del(&cancel_req->list);
+			list_del(&cancel_req->compl.list);
 			cancel_req->flags &= ~REQ_F_OVERFLOW;
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
-- 
2.24.0

