Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D93334BD4
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhCJWon (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhCJWoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14611C061762
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so8061557pjc.2
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6/72Omk7XNlOINOMaKerKQpk/LQfvlQHjvqr0dn8rQo=;
        b=U9ivY1dSIqONeF9FWenjoK2tP2JMGDp4D0gbfAuzvWq99tfqtDrwcABRtR1EyXHCUR
         OPnZJr97d4QjEBDkTRlwqRbK49LmG1ZvFkVOIkCmcPZy3/YTmTtH2IX4A8DAawqf9Z3t
         epX48VZDpIq99hgYPlB5dC8ztg2wbWVRgtc1x1UKdD5ytlNIvGe/IcRPhvnWJZpOhWd4
         UnvtjpuRQuRpC3JrfUmyi3d8qhLGF6IqwLph0ut2HW0eSEIy+JjCS8PMqHHiyu9lm6xp
         XKH1f6ywTPjqAGj+Bay+PyEK7g1nSIK6LSLfBBqwdeGAfsio7uYM8OcUsOi7mlAIgVdE
         SeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6/72Omk7XNlOINOMaKerKQpk/LQfvlQHjvqr0dn8rQo=;
        b=TvO6UeqV3LBnX/pfWJHkhKPBxJlU/JoXGQiLCrtngEqFXae4QBGUdh9R2qmTC4cKNC
         O6M8RKUAhisKI7KFyQ5O3kLQtQ+jtdgL0fPrp1oFdE/8iZJGGkrkLAIG9FIhcU6VTe5t
         g/FvY4ucqUdwMuvkBIcf5/ax9thb5XeH+QJekegzcag+njOpfLkNwK82UYUyyar1lEAs
         2X/4egR5uwtCSqZyzvRTOqoJAWrMQYZPTfGNRNfxuUr1g6Ffy7SNTkpBKp+3b+FZefza
         bxBMsWxfeCqSug2hqtTyOT6mikXq4a5Isw/u/gCTTpsnbSXW5VWa3O4mw7hwYGKpWRKl
         +Gdw==
X-Gm-Message-State: AOAM532vAXB1bR656Gt69AyntH2/usMzepZ4/mUf+v2AaDyycPZHWcTE
        EZIWibFzpIIVt6Np2WMy1sIXHVhadbZqtg==
X-Google-Smtp-Source: ABdhPJxF69rCt/Ql+RHtDgKUW3QHKylpBXDi9sr8oO2DtX6E/C4cOtWae6GWaBaWdaWWSVhfyfXNxg==
X-Received: by 2002:a17:90a:67cf:: with SMTP id g15mr5734007pjm.208.1615416263367;
        Wed, 10 Mar 2021 14:44:23 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 19/27] io_uring: add io_disarm_next() helper
Date:   Wed, 10 Mar 2021 15:43:50 -0700
Message-Id: <20210310224358.1494503-20-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

A preparation patch placing all preparations before extracting a next
request into a separate helper io_disarm_next().

Also, don't spuriously do ev_posted in a rare case where REQ_F_FAIL_LINK
is set but there are no requests linked (i.e. after cancelling a linked
timeout or setting IOSQE_IO_LINK on a last request of a submission
batch).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/44ecff68d6b47e1c4e6b891bdde1ddc08cfc3590.1615250156.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 68 ++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3299807894ec..cc9a2cc95608 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1705,15 +1705,11 @@ static inline void io_remove_next_linked(struct io_kiocb *req)
 	nxt->link = NULL;
 }
 
-static void io_kill_linked_timeout(struct io_kiocb *req)
+static bool io_kill_linked_timeout(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *link;
+	struct io_kiocb *link = req->link;
 	bool cancelled = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = req->link;
 
 	/*
 	 * Can happen if a linked timeout fired and link had been like
@@ -1728,50 +1724,48 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
 			io_cqring_fill_event(link, -ECANCELED);
-			io_commit_cqring(ctx);
+			io_put_req_deferred(link, 1);
 			cancelled = true;
 		}
 	}
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
-	if (cancelled) {
-		io_cqring_ev_posted(ctx);
-		io_put_req(link);
-	}
+	return cancelled;
 }
 
-
 static void io_fail_links(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
-	struct io_kiocb *link, *nxt;
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
+	struct io_kiocb *nxt, *link = req->link;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = req->link;
 	req->link = NULL;
-
 	while (link) {
 		nxt = link->link;
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link, -ECANCELED);
-
 		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
-	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+}
 
-	io_cqring_ev_posted(ctx);
+static bool io_disarm_next(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	bool posted = false;
+
+	if (likely(req->flags & REQ_F_LINK_TIMEOUT))
+		posted = io_kill_linked_timeout(req);
+	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
+		posted |= (req->link != NULL);
+		io_fail_links(req);
+	}
+	return posted;
 }
 
 static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_LINK_TIMEOUT)
-		io_kill_linked_timeout(req);
+	struct io_kiocb *nxt;
 
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
@@ -1779,14 +1773,22 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (likely(!(req->flags & REQ_F_FAIL_LINK))) {
-		struct io_kiocb *nxt = req->link;
+	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK)) {
+		struct io_ring_ctx *ctx = req->ctx;
+		unsigned long flags;
+		bool posted;
 
-		req->link = NULL;
-		return nxt;
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		posted = io_disarm_next(req);
+		if (posted)
+			io_commit_cqring(req->ctx);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		if (posted)
+			io_cqring_ev_posted(ctx);
 	}
-	io_fail_links(req);
-	return NULL;
+	nxt = req->link;
+	req->link = NULL;
+	return nxt;
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
-- 
2.30.2

