Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C53E97A3
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhHKS3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhHKS3f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75198C0613D5
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f5so4315980wrm.13
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FG38pjRHEOabG18ycSq/GKF5RB+qgs7Jkjr3I/H0P34=;
        b=OLJwl6yxb2OQ5jUrI/EbYvNT9zS5yavXgDZBFJ8IHvaRbgb9r5/ZtCmnUOmmFp6LpX
         EO4N4Ya7Hb6eZ/Focwqv0Mlwc/5evJstJc9SigLzEGrEFu9H19C6s/wia/ag1SgwpXHq
         BtWOTLwvPE6otmdybenVkYbsNJY6CPIRn2mda0EcDywGZozHywM3lzOyqOqzQag1Uu7j
         Avqt+kgzVR55ed/WpfxcB4EVQKKAYOUHW8GSOrxiy8dI0gFz3fPECKb/Oyq2Ah2ov02X
         /pxmota3srSEj8kyi0dPUgCWM7J+YlhOZosHVu9M6mggMUORVrVcOUDSWHETe5NUg70d
         64bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FG38pjRHEOabG18ycSq/GKF5RB+qgs7Jkjr3I/H0P34=;
        b=ZWZDQazWC6p3UdMlS1n/hmgodi4HoaO5ogmtuFT8uAco6pVaJcfaw6n6gUk58BwIgX
         vEdDDKx08Jqo1vTDJjgJqXtxGU3b4sFYqwtwu0pzvHKjbyejwqTiXRS3RXXl43kyiF/8
         8QC1v682kDLc60F4Z/n3gfx/tWSlEpkGnViYl5QkyLxn1VmkdpOA+RcC7Cr6Rl++T2c/
         h+WnhLJcryCc2RHdjc4zlKR1GdBFPVnsz1m8s9UNtzrFWhgi+vV7AQETOm9SuUhidI7N
         0LgFHNGrrlZ25xi6W1HfENCMK7rrAbQm8tjtVZaCM+idYuKlvknn0CQVA5y7XFxBPK2d
         Ec3A==
X-Gm-Message-State: AOAM5317MUBJkJDxu5r0jBTW7VYJh7j5Ab0qf/jz+1JYv67yLTRYpMGd
        ywZq36F+Cw8HWbjnVTvEImM=
X-Google-Smtp-Source: ABdhPJwAvCZD6uYYTpD7XMFkNgShoEPkXy8Z89cKSR2lHc6s2d+DF/mEFm13/ICQo/IyaXFqWmV0EA==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr24547210wrw.412.1628706550149;
        Wed, 11 Aug 2021 11:29:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/5] io_uring: remove req_ref_sub_and_test()
Date:   Wed, 11 Aug 2021 19:28:28 +0100
Message-Id: <1868c7554108bff9194fb5757e77be23fadf7fc0.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
References: <cover.1628705069.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Soon, we won't need to put several references at once, remove
req_ref_sub_and_test() and @nr argument from io_put_req_deferred(),
and put the rest of the references by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a088c8c2b1ef..f2aa26ba34f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1041,7 +1041,7 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 				 long res, unsigned int cflags);
 static void io_put_req(struct io_kiocb *req);
-static void io_put_req_deferred(struct io_kiocb *req, int nr);
+static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -1090,12 +1090,6 @@ static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 	return atomic_inc_not_zero(&req->refs);
 }
 
-static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
-{
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_sub_and_test(refs, &req->refs);
-}
-
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
@@ -1374,7 +1368,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
 		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
-		io_put_req_deferred(req, 1);
+		io_put_req_deferred(req);
 	}
 }
 
@@ -1856,7 +1850,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			io_cqring_fill_event(link->ctx, link->user_data,
 					     -ECANCELED, 0);
-			io_put_req_deferred(link, 1);
+			io_put_req_deferred(link);
 			return true;
 		}
 	}
@@ -1875,7 +1869,9 @@ static void io_fail_links(struct io_kiocb *req)
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
-		io_put_req_deferred(link, 2);
+
+		io_put_req(link);
+		io_put_req_deferred(link);
 		link = nxt;
 	}
 }
@@ -2156,7 +2152,8 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = state->compl_reqs[i];
 
 		/* submission and completion refs */
-		if (req_ref_sub_and_test(req, 2))
+		io_put_req(req);
+		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -2185,9 +2182,9 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
+static inline void io_put_req_deferred(struct io_kiocb *req)
 {
-	if (req_ref_sub_and_test(req, refs)) {
+	if (req_ref_put_and_test(req)) {
 		req->io_task_work.func = io_free_req;
 		io_req_task_work_add(req);
 	}
@@ -5229,7 +5226,6 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
-	int refs;
 	bool do_complete;
 
 	io_poll_remove_double(req);
@@ -5241,8 +5237,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		req_set_fail(req);
 
 		/* non-poll requests have submit ref still */
-		refs = 1 + (req->opcode != IORING_OP_POLL_ADD);
-		io_put_req_deferred(req, refs);
+		if (req->opcode != IORING_OP_POLL_ADD)
+			io_put_req(req);
+		io_put_req_deferred(req);
 	}
 	return do_complete;
 }
@@ -5543,7 +5540,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	req_set_fail(req);
 	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
-	io_put_req_deferred(req, 1);
+	io_put_req_deferred(req);
 	return 0;
 }
 
-- 
2.32.0

