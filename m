Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BA227F2D7
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgI3UAs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1A4C061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:47 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k18so731231wmj.5
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sq/DCv0+JvFbh0+CC5kDZjCagdvXbM38EK5unb4ImN8=;
        b=QkTHGYGsb47TBHVXps6DrFnesNxY8c6n6EqC1LyRUlhaN6+puflbTCRc757a0qjz1u
         L5H6b6AbcA7hoyj7/ME/QZL7B1etQQ1ITo92p0B3CcrRh/Crxs3VLUgO8rnmSH9xolK2
         SwVZCSt6whQe05xk2fSJr0MzjXA94YXFyplP4db1xTDXnwvfxSUzGOqVklW2hyY6GGx9
         ZeKxDuggenMFDOB7fnmas6MxSx9wLoU/SSon0fXKreyeSHgTwWhWJ/qRBg1jQ7qYDVI0
         q71yzLvnqBjTwY4WR5JoaFMu0lIoFp0HpDnzCi6XQrE3u0xruQ8aTgfo4fnBq/kdpD2B
         g0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sq/DCv0+JvFbh0+CC5kDZjCagdvXbM38EK5unb4ImN8=;
        b=pnDFXH0PBuzfU7IABzgSuXFzFnAd1wtrzC8U9DxwdG/5AotL4ESjHaqab22PYDERir
         LNHrJSu/h1Vt1/sCqRSxImUTWTwECW/WSWaujMSnXZMAhUDpFHKULC9wrr+m/Dyw2fuo
         s/z1mjAVzwgY46WnGhS8QP05i4ggQiOpYJe/ckTE4LR9VcinvstCQ0DLLwZXxeZKC1gn
         dmWiv91IGNfw4Z+kuesTR0iDscAjsfU2XXzf4BVXikn7sj3iBPIQh2Q3whDjwHszNJ5W
         pWlzoh89/H8Pdtzd8IOJumU8wH+cSuQgRvgLG+IKcY5w1INXXyOfWSTa6fsX3i+7ldJ3
         lW8w==
X-Gm-Message-State: AOAM532KXnr7Nn7Zlp7dluO7CYKd5VJQQ4upjNM6fouvBBC35Xk9IKLd
        8BsA0dAgTEnF/6h/PKi5N0Gk6q+UFxk=
X-Google-Smtp-Source: ABdhPJxvzvCNamv9EG360zBvSZWXz8rb/f2QMzqYHjnc6Aux+qtRF5Iq6+ifnJsP57rJyHLQFSTdNQ==
X-Received: by 2002:a7b:cf26:: with SMTP id m6mr4666037wmg.71.1601496046055;
        Wed, 30 Sep 2020 13:00:46 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id x17sm5127176wrg.57.2020.09.30.13.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: move req preps out of io_issue_sqe()
Date:   Wed, 30 Sep 2020 22:57:56 +0300
Message-Id: <9bdc5dc96295e02df430bd6e1c6c515f1733c31c.1601495335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601495335.git.asml.silence@gmail.com>
References: <cover.1601495335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All request preparations are done only during submission, reflect it in
the code by moving io_req_prep() much earlier into io_queue_sqe().

That's much cleaner, because it doen't expose bits to async code which
it won't ever use. Also it makes the interface harder to misuse, and
there are potential places for bugs.

For instance, __io_queue() doesn't clear @sqe before proceeding to a
next linked request, that could have been disastrous, but hopefully
there are linked requests IFF sqe==NULL, so not actually a bug.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ce0ebee4808..cb22225bee6c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -954,9 +954,7 @@ static int io_prep_work_files(struct io_kiocb *req);
 static void __io_clean_op(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
-static void __io_queue_sqe(struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe,
-			   struct io_comp_state *cs);
+static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
 static void io_file_put_work(struct work_struct *work);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
@@ -1852,7 +1850,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 
 	if (!__io_sq_thread_acquire_mm(ctx)) {
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL, NULL);
+		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		__io_req_task_cancel(req, -EFAULT);
@@ -5725,18 +5723,12 @@ static void __io_clean_op(struct io_kiocb *req)
 	}
 }
 
-static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			bool force_nonblock, struct io_comp_state *cs)
+static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
+			struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	if (sqe) {
-		ret = io_req_prep(req, sqe);
-		if (unlikely(ret < 0))
-			return ret;
-	}
-
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, cs);
@@ -5877,7 +5869,7 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, false, NULL);
+			ret = io_issue_sqe(req, false, NULL);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -6061,8 +6053,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return nxt;
 }
 
-static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   struct io_comp_state *cs)
+static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
@@ -6082,7 +6073,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, true, cs);
+	ret = io_issue_sqe(req, true, cs);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -6161,7 +6152,12 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
-		__io_queue_sqe(req, sqe, cs);
+		if (sqe) {
+			ret = io_req_prep(req, sqe);
+			if (unlikely(ret))
+				goto fail_req;
+		}
+		__io_queue_sqe(req, cs);
 	}
 }
 
-- 
2.24.0

