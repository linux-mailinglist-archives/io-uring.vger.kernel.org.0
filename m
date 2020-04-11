Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EFE1A5A37
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgDKXGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:06:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35597 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgDKXGX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:06:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id r26so6347525wmh.0;
        Sat, 11 Apr 2020 16:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xLzReQ4qtzK/vCjG6se09q2ZYDgTQY84tl1gCdIUsXU=;
        b=p1NHNL6ZR+WjxJCPWq8CcZkMCFeDb+c1zjszVRYt7BBzV3sieqwQztWgsZGI0xMn1Y
         eNpYplMPHXrsV7CjIuewOKykrcFidr0dgGtvSH33zuLT42Hfh1nCB5JdiEKVe9ewgEfL
         coyF7ZMfnGBcR4DpvMxj8n1ydwnEHxgwmo9hlwgY645mzJnJ2ZzdrkQVCrKc3nfYSMpk
         2E6I6U+gBigd7MzLVW7gd8KwJvhfyCCzYgX4mcvpu2O1yULrDxBBTEsWFO0acefnqx5W
         V37ek3GnI7oOuM0IkJm8BttuQhDF5KDJthq1PXl2NWjWGCgeIgMd7FVjToGWB7jMDyjb
         A0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xLzReQ4qtzK/vCjG6se09q2ZYDgTQY84tl1gCdIUsXU=;
        b=ntNVQ7rtCkWTJw7zHJIW5PzxU1yfYJhT/ZwXk6bUnDcR6kx6wasPAXWYgQBbBa46MN
         JSClX+RMFRqepffzlWEPGaUtlaPMY8t3iO0GvWv2TKEYr8/yUrpOZIpCz6FVpYvOJhwv
         +wVo0g105YXR78BDDo1CYCZC/C73McVwjlGMulj4yljUE7N+Hfef8cFaLrRHeygt8IGP
         PZASjpHzF9CjjxTEQqFXKJvpe6QaUNekURuqCvJqAD/FU1xrTGT4qm3lwwlILGw7rmQ5
         3QJVZ7uRk6TE4ICYdUIp43LM5YYwbpiDyRruUttG/zcaLHEmKkpq1DOFQwj4hXTJrdVB
         ydIA==
X-Gm-Message-State: AGi0PuZ1Q3T90IW32JBWJCTAZC4+0I0IvCULPdq6J0dE+rFzIqEO8zZt
        iUFYHYkcNZNBk1la8RsFspkJb68R
X-Google-Smtp-Source: APiQypIGy1TZc93f08zhg/UpDISGmD0VnGokqQoBRbzu2w/IR+XHMZgCvQxY8fgcmduT4PCTV/JCHQ==
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr12570390wml.189.1586646381344;
        Sat, 11 Apr 2020 16:06:21 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id k133sm8992741wma.0.2020.04.11.16.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:06:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] io_uring: keep all sqe->flags in req->flags
Date:   Sun, 12 Apr 2020 02:05:04 +0300
Message-Id: <92cf6b32f856ea65c99948ff1670874987f20241.1586645520.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586645520.git.asml.silence@gmail.com>
References: <cover.1586645520.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's a good idea to not read sqe->flags twice, as it's prone to security
bugs. Instead of passing it around, embeed them in req->flags. It's
already so except for IOSQE_IO_LINK.
1. rename former REQ_F_LINK -> REQ_F_LINK_HEAD
2. introduce and copy REQ_F_LINK, which mimics IO_IOSQE_LINK

And leave req_set_fail_links() using new REQ_F_LINK, because it's more
sensible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 90b806e4022a..9118a0210e0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -506,6 +506,7 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
+	REQ_F_LINK_HEAD_BIT,
 	REQ_F_LINK_NEXT_BIT,
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
@@ -541,6 +542,8 @@ enum {
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
+	/* head of a link */
+	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
 	/* already grabbed next link */
 	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
 	/* fail rest of links */
@@ -1435,7 +1438,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 	if (ret != -1) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
-		req->flags &= ~REQ_F_LINK;
+		req->flags &= ~REQ_F_LINK_HEAD;
 		io_put_req(req);
 		return true;
 	}
@@ -1471,7 +1474,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 
 		list_del_init(&req->link_list);
 		if (!list_empty(&nxt->link_list))
-			nxt->flags |= REQ_F_LINK;
+			nxt->flags |= REQ_F_LINK_HEAD;
 		*nxtptr = nxt;
 		break;
 	}
@@ -1482,7 +1485,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 }
 
 /*
- * Called if REQ_F_LINK is set, and we fail the head request
+ * Called if REQ_F_LINK_HEAD is set, and we fail the head request
  */
 static void io_fail_links(struct io_kiocb *req)
 {
@@ -1515,7 +1518,7 @@ static void io_fail_links(struct io_kiocb *req)
 
 static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	if (likely(!(req->flags & REQ_F_LINK)))
+	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
 		return;
 
 	/*
@@ -1667,7 +1670,7 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 {
-	if ((req->flags & REQ_F_LINK) || io_is_fallback_req(req))
+	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
 		return false;
 
 	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
@@ -2560,7 +2563,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 
 	req->result = 0;
 	io_size = ret;
-	if (req->flags & REQ_F_LINK)
+	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
 
 	/*
@@ -2651,7 +2654,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 
 	req->result = 0;
 	io_size = ret;
-	if (req->flags & REQ_F_LINK)
+	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
 
 	/*
@@ -5474,7 +5477,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
 
-	if (!(req->flags & REQ_F_LINK))
+	if (!(req->flags & REQ_F_LINK_HEAD))
 		return NULL;
 	/* for polled retry, if flag is set, we already went through here */
 	if (req->flags & REQ_F_POLLED)
@@ -5634,7 +5637,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
 					IOSQE_ASYNC | IOSQE_FIXED_FILE |
-					IOSQE_BUFFER_SELECT);
+					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
 
 	fd = READ_ONCE(sqe->fd);
 	ret = io_req_set_file(state, req, fd, sqe_flags);
@@ -5685,7 +5688,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->ctx->drain_next = 0;
 		}
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
-			req->flags |= REQ_F_LINK;
+			req->flags |= REQ_F_LINK_HEAD;
 			INIT_LIST_HEAD(&req->link_list);
 
 			if (io_alloc_async_ctx(req))
-- 
2.24.0

