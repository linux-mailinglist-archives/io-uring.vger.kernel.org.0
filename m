Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE97621C857
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgGLJnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:22 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF625C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so8167439edr.5
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s+l20BzTPq+glHmb73AlJC0mzVDeeZwmqHJKFji0+MU=;
        b=Ke4U/SiUZteIeqsM8XQohWSIhbO1L5rbyhHLvjM51+jlO6GfBBn9ULNbm2D3zZIgwR
         E9ExACOKibubjIV4B+n+/1C+zCqesg7hj9HBaonJz7YbWl/ZFUMkt8pA/OMgUcrPUPKq
         jwyRViNocKXqT8AZandmebmRpYZ99iSg3sEzpvToZphKqyLI6zXWmd/POFYeA325Qpn6
         o6RCj/mr3s8FILdu2kgwJ9p/90OqFSrcV7bpN6/Pd7PnTpzRioQTPQGDrQ/U6RngKU0Z
         06ztn1OTJBYNDNQvFOgnftd6fDy+iQz8zKa2gkTiReHv9oZaSgJ8/SDVxFxhVwhRdEYi
         jCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s+l20BzTPq+glHmb73AlJC0mzVDeeZwmqHJKFji0+MU=;
        b=dEvp1E0ZoyFHZbROs6XNJwnDj1IOnNy5sgv+EwXuoKQCtKWue12++lzuml7G6emmK+
         VcABNbADDWS2sbrFeM6pOh2lIQUbfBzB2/T0t9k5pBZx+cFYu/qKq8YQHJt6TmPmwN7W
         OMibJ8SMvfJTTN3eypzgji0ZnqRNatmR7rf5BbJkwj19lPuXYIXfSlGX+B9gOmvRoAXt
         SuDmc/ARzXrr2jiZCHHcpMXYFFOmPHPpeMGsim6nuOqnuPR4U4gmSfNNtVbVSD9tA+Ux
         GmEdpww3dEp51qWvza71BRgWwUXqrdwF4A62QaF8T4UKQTthsVJYofQiSFoDBbcOOGgX
         AEUQ==
X-Gm-Message-State: AOAM5326sYkBqVSTpD4J7Ce/ZrKiquZsAKHbzGVGXwFWXIUN2IdVAsFz
        F8AM4cQVTIBFIAfvUH3sgtZnt2CL
X-Google-Smtp-Source: ABdhPJzVzUoFxPfiRgdbfLhMh14xqxofm4nwGVlkSlteDxGp9e3YXYUFLQPZuu89/+++viB6aje4+g==
X-Received: by 2002:aa7:d4c1:: with SMTP id t1mr77801402edr.253.1594547000652;
        Sun, 12 Jul 2020 02:43:20 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/9] io_uring: remove sequence from io_kiocb
Date:   Sun, 12 Jul 2020 12:41:14 +0300
Message-Id: <73b43fa23ea60e58ab020b43a52593df3a43b480.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->sequence is used only for deferred (i.e. DRAIN) requests, but is
a burden of every request even if isn't used. Remove req->sequence from
io_kiocb together with its initialisation in io_init_req(). In place of
that keep the field in io_defer_entry, and calculate it in
io_req_defer()'s slow path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93e8192983e1..db7f86b6da09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -639,6 +639,7 @@ struct io_kiocb {
 	u8				iopoll_completed;
 
 	u16				buf_index;
+	u32				result;
 
 	struct io_ring_ctx	*ctx;
 	unsigned int		flags;
@@ -646,8 +647,6 @@ struct io_kiocb {
 	struct task_struct	*task;
 	unsigned long		fsize;
 	u64			user_data;
-	u32			result;
-	u32			sequence;
 
 	struct list_head	link_list;
 
@@ -681,6 +680,7 @@ struct io_kiocb {
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
+	u32			seq;
 };
 
 #define IO_IOPOLL_BATCH			8
@@ -1088,13 +1088,13 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
-static inline bool req_need_defer(struct io_kiocb *req)
+static bool req_need_defer(struct io_kiocb *req, u32 seq)
 {
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return req->sequence != ctx->cached_cq_tail
-					+ atomic_read(&ctx->cached_cq_overflow);
+		return seq != ctx->cached_cq_tail
+				+ atomic_read(&ctx->cached_cq_overflow);
 	}
 
 	return false;
@@ -1237,7 +1237,7 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
-		if (req_need_defer(de->req))
+		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
 		/* punt-init is done before queueing for defer */
@@ -5400,14 +5400,30 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	return ret;
 }
 
+static int io_get_sequence(struct io_kiocb *req)
+{
+	struct io_kiocb *pos;
+	struct io_ring_ctx *ctx = req->ctx;
+	u32 nr_reqs = 1;
+
+	if (req->flags & REQ_F_LINK_HEAD)
+		list_for_each_entry(pos, &req->link_list, link_list)
+			nr_reqs++;
+
+	return ctx->cached_sq_head - ctx->cached_sq_dropped - nr_reqs;
+}
+
+
 static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
 	int ret;
+	u32 seq;
 
 	/* Still need defer if there is pending req in defer list. */
-	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
+	if (likely(list_empty_careful(&ctx->defer_list) &&
+		!(req->flags & REQ_F_IO_DRAIN)))
 		return 0;
 
 	if (!req->io) {
@@ -5422,8 +5438,9 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!de)
 		return -ENOMEM;
 
+	seq = io_get_sequence(req);
 	spin_lock_irq(&ctx->completion_lock);
-	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
+	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(de);
 		return 0;
@@ -5431,6 +5448,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	trace_io_uring_defer(ctx, req, req->user_data);
 	de->req = req;
+	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
 	spin_unlock_irq(&ctx->completion_lock);
 	return -EIOCBQUEUED;
@@ -6207,12 +6225,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	unsigned int sqe_flags;
 	int id;
 
-	/*
-	 * All io need record the previous position, if LINK vs DARIN,
-	 * it can be used to mark the position of the first IO in the
-	 * link list.
-	 */
-	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
-- 
2.24.0

