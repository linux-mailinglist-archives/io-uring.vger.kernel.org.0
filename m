Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4FB24B125
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 10:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgHTIfz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 04:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgHTIfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 04:35:52 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FA0C061757
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:35:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w2so651909edv.7
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PVwJFLYDdy0vKYD0F2soaIjAFd8e8dRatVhmhyjmu20=;
        b=Z/GHvF7YH3rYV+ZvnhIHN+tA+oJbLLo80DMR1Y3mBr4ZAWod+g46IyfeXJf+/t/s3d
         0qzjGRUfQ6W9EOqYu9cuHnq6zB79AIMD4YTaEnl7nwhBJcg6q6OXLYyVDRtRZpM0yo2e
         3Xa5911WKajQFQhbZG5z8IVfNUzsgAugPUPKd0+O0NFdIJTwuH7qfZ6bAybmuyYWzODX
         E/+UgDV/ogV0V0h2xSMb9XxNH0PvzSKd+OdxtkfNGouFgxpWL8FBh9hxVTfgloWjQswl
         Nlfjpn2tsqCm/pvIUgazf+HUx+WukV0jVahLIeLXIkxUGCa3GpeItEhTicrxmbIU57jJ
         UBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PVwJFLYDdy0vKYD0F2soaIjAFd8e8dRatVhmhyjmu20=;
        b=f6Au/BGpAVSzdgRwU+JVVmheRZexg+SRNQh01H1f+I6whF3cyrG1VyqGyJI+RpyQat
         CSPvYCpBiJJYxICLdyopNedoiepNX2wlBmjo9bu+34rwPeqsg+9tnS1ejkqkn4ns3ocK
         XtYy+6SxbmqgolkOO8JBZCC2kxS2mpClKsN7M3XGbNz2wESNTRTst/j+yVSCAAPUWDmu
         b4lK5NwcVtBf/ORJLXwMO3PKXyMwA/bjbjAnlobnoB5HZiOD2nlJBsJMqAUycGY35Tii
         pbtN5prEGSfjMJ0zy1XfU5+a+biRXlny0GTV0QyBH0EneeXY5lc2WXlV4JfBxZhGeTX4
         xI1A==
X-Gm-Message-State: AOAM531rKrG0cD/UQuyc+Z2OiAiCQ+MLivpfuaYi9U+vJZOIYPhPz0Go
        1TLlSaTcZOJSyvAl1clh+1g=
X-Google-Smtp-Source: ABdhPJyU4dsX8L3+dW1+Px4CADE5OApQjcLvx/2vDItFVAGqNO+paZKUisKSmVdYZtFkWgMZRAhAfA==
X-Received: by 2002:a05:6402:b32:: with SMTP id bo18mr1847710edb.201.1597912551096;
        Thu, 20 Aug 2020 01:35:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.225])
        by smtp.gmail.com with ESMTPSA id g5sm989696ejk.52.2020.08.20.01.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 01:35:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.9] io_uring: fix racy req->flags modification
Date:   Thu, 20 Aug 2020 11:33:35 +0300
Message-Id: <396ddf7deab36b73b6f24ae28b1e2fd1a2f468fb.1597912300.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Setting and clearing REQ_F_OVERFLOW in io_uring_cancel_files() and
io_cqring_overflow_flush() are racy, because they might be called
asynchronously.

REQ_F_OVERFLOW flag in only needed for files cancellation, so if it can
be guaranteed that requests _currently_ marked inflight can't be
overflown, the problem will be solved with removing the flag
altogether.

That's how the patch works, it removes inflight status of a request
in io_cqring_fill_event() whenever it should be thrown into CQ-overflow
list. That's Ok to do, because no opcode specific handling can be done
after io_cqring_fill_event(), the same assumption as with "struct
io_completion" patches.
And it already have a good place for such cleanups, which is
io_clean_op(). A nice side effect of this is removing this inflight
check from the hot path.

note on synchronisation: now __io_cqring_fill_event() may be taking two
spinlocks simultaneously, completion_lock and inflight_lock. It's fine,
because we never do that in reverse order, and CQ-overflow of inflight
requests shouldn't happen often.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 ++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4b102d9ad846..938112826dd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -540,7 +540,6 @@ enum {
 	REQ_F_ISREG_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
-	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
@@ -583,8 +582,6 @@ enum {
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
-	/* in overflow list */
-	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
@@ -946,7 +943,8 @@ static void io_get_req_task(struct io_kiocb *req)
 
 static inline void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
+			  REQ_F_INFLIGHT))
 		__io_clean_op(req);
 }
 
@@ -1366,7 +1364,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
 						compl.list);
 		list_move(&req->compl.list, &list);
-		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
@@ -1419,7 +1416,6 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
 		io_clean_op(req);
-		req->flags |= REQ_F_OVERFLOW;
 		req->result = res;
 		req->compl.cflags = cflags;
 		refcount_inc(&req->refs);
@@ -1563,17 +1559,6 @@ static bool io_dismantle_req(struct io_kiocb *req)
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		if (waitqueue_active(&ctx->inflight_wait))
-			wake_up(&ctx->inflight_wait);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-	}
-
 	return io_req_clean_work(req);
 }
 
@@ -5634,6 +5619,18 @@ static void __io_clean_op(struct io_kiocb *req)
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
+
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_ring_ctx *ctx = req->ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		list_del(&req->inflight_entry);
+		if (waitqueue_active(&ctx->inflight_wait))
+			wake_up(&ctx->inflight_wait);
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+		req->flags &= ~REQ_F_INFLIGHT;
+	}
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -8102,33 +8099,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		/* We need to keep going until we don't find a matching req */
 		if (!cancel_req)
 			break;
-
-		if (cancel_req->flags & REQ_F_OVERFLOW) {
-			spin_lock_irq(&ctx->completion_lock);
-			list_del(&cancel_req->compl.list);
-			cancel_req->flags &= ~REQ_F_OVERFLOW;
-
-			io_cqring_mark_overflow(ctx);
-			WRITE_ONCE(ctx->rings->cq_overflow,
-				atomic_inc_return(&ctx->cached_cq_overflow));
-			io_commit_cqring(ctx);
-			spin_unlock_irq(&ctx->completion_lock);
-
-			/*
-			 * Put inflight ref and overflow ref. If that's
-			 * all we had, then we're done with this request.
-			 */
-			if (refcount_sub_and_test(2, &cancel_req->refs)) {
-				io_free_req(cancel_req);
-				finish_wait(&ctx->inflight_wait, &wait);
-				continue;
-			}
-		} else {
-			/* cancel this request, or head link requests */
-			io_attempt_cancel(ctx, cancel_req);
-			io_put_req(cancel_req);
-		}
-
+		/* cancel this request, or head link requests */
+		io_attempt_cancel(ctx, cancel_req);
+		io_put_req(cancel_req);
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.24.0

