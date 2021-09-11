Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C4940786F
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhIKNyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 09:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbhIKNx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 09:53:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E976C061756
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t8so1920919wrq.4
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ei0fXqqBPlvMCr3bEgq0dF6nO+W7uc59QEWd4xZ/MKo=;
        b=T23d95Nf4QzRd5ZmfQLUehY0BkGBHHFOSYkx2naYDpkyeqXafq4oACHhheDJWgR8P4
         YTcyar9wVcADN88KKHfjgZ7mu3VW+y2MOT8Dkgw+w+WZGjAgAh2+lUcYZh+MUGQtKYdj
         OJ7XRIFkiusIXKQdbL4DqaqNTG34eI4My/Scn6sappEkS6m0jYQhJVeuN2Wl+vf4MDH3
         JFb7evj1fMhEV3OdCaO/LJ8HEZvMGpCMxJlSRrBeo4h/tROkhdwgoULEm8HPpclHy8p3
         R8mu7StSJd2RVruxzRnZmI2JsGEDdWoQL8M5nrCLwpEWsY5E4aiaaDz9zW0n22Jcvlcq
         MaVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ei0fXqqBPlvMCr3bEgq0dF6nO+W7uc59QEWd4xZ/MKo=;
        b=1cg/itcdoBdudP5aXUJBFCe7YfpoEi0A0QLNE+/k7dtAf838KXnB59maEj2thljXnb
         FHiNbv7/5vnbJWFzfYlFPs3a5kAhvonSWnQHleg+BTQrW3U8Na0XkSXXMztud0B34w2w
         6Khs3j1j52IGr6e2t/ZkTMfkt6ZF2zr4Z5gl3RDhjKbuMgTuPnWPPzajqC63PEp0HRzv
         gBoxi4zFhCIbkScaMjn0+4XgmG9RuceaRhgmEQtuMiiP06oQLUKrshcYfOI5uKXOnj6f
         vW2s9/PXKl3TNXtCfOSIx7kYVT0npmk6K3P3jUMNcy2u/pDS55PAVWIUcv529SnYWxN9
         XvVA==
X-Gm-Message-State: AOAM531ItgUjzMvCxH1vyildTUUFiqjtRrO0YPz1p7f3LbyyRf2YhCvy
        5Bo4bXYOF3kbZGuGrmKkLjHx+TwWFOg=
X-Google-Smtp-Source: ABdhPJzA6kdQv256E7rNR6ALUFhl5/l0jvhoHwfDuGf5urwHwtejQvzUTZ/gYusNYKjAKYkig36C8A==
X-Received: by 2002:a5d:470b:: with SMTP id y11mr3290079wrq.213.1631368364843;
        Sat, 11 Sep 2021 06:52:44 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id n10sm1774928wrt.78.2021.09.11.06.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 06:52:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: add option to skip CQE posting
Date:   Sat, 11 Sep 2021 14:52:01 +0100
Message-Id: <23ced42a12192a00660c9fed177c200dbaa05230.1631367587.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631367587.git.asml.silence@gmail.com>
References: <cover.1631367587.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Emitting a CQE is expensive from the kernel perspective. Often, it's
also not convenient for the userspace, spends some cycles on processing
and just complicates the logic. A similar problems goes for linked
requests, where we post an CQE for each request in the link.

Introduce a new flags, IOSQE_CQE_SKIP_SUCCESS, trying to help with it.
When set and a request completed successfully, it won't generate a CQE.
When fails, it produces an CQE, but all following linked requests will
be CQE-less, regardless whether they have IOSQE_CQE_SKIP_SUCCESS or not.
The notion of "fail" is the same as for link failing-cancellation, where
it's opcode dependent, and _usually_ result >= 0 is a success, but not
always.

Linked timeouts are a bit special. When the requests it's linked to was
not attempted to be executed, e.g. failing linked requests, it follows
the description above. Otherwise, whether a linked timeout will post a
completion or not solely depends on IOSQE_CQE_SKIP_SUCCESS of that
linked timeout request. Linked timeout never "fail" during execution, so
for them it's unconditional. It's expected for users to not really care
about the result of it but rely solely on the result of the master
request. Another reason for such a treatment is that it's racy, and the
timeout callback may be running awhile the master request posts its
completion.

use case 1:
If one doesn't care about results of some requests, e.g. normal
timeouts, just set IOSQE_CQE_SKIP_SUCCESS. Error result will still be
posted and need to be handled.

use case 2:
Set IOSQE_CQE_SKIP_SUCCESS for all requests of a link but the last,
and it'll post a completion only for the last one if everything goes
right, otherwise there will be one only one CQE for the first failed
request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 41 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  3 +++
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1703130ae8df..172c857e8b3f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,8 +104,9 @@
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+			IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+			IOSQE_BUFFER_SELECT | IOSQE_CQE_SKIP_SUCCESS)
+
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
 
@@ -722,6 +723,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -738,6 +740,7 @@ enum {
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
+	REQ_F_SKIP_LINK_CQES_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -760,6 +763,8 @@ enum {
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	/* IOSQE_CQE_SKIP_SUCCESS */
+	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
@@ -795,6 +800,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* don't post CQEs while failing linked requests */
+	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
 };
 
 struct async_poll {
@@ -1225,6 +1232,10 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
+	if (req->flags & REQ_F_CQE_SKIP) {
+		req->flags &= ~REQ_F_CQE_SKIP;
+		req->flags |= REQ_F_SKIP_LINK_CQES;
+	}
 }
 
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
@@ -1785,7 +1796,8 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 static noinline void io_fill_cqe_req(struct io_kiocb *req, long res,
 				     unsigned int cflags)
 {
-	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe(req->ctx, req->user_data, res, cflags);
 }
 
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
@@ -1801,7 +1813,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_fill_cqe(ctx, req->user_data, res, cflags);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2027,6 +2040,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
+			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
 			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
@@ -2039,6 +2053,7 @@ static void io_fail_links(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_kiocb *nxt, *link = req->link;
+	bool ignore_cqes = req->flags & REQ_F_SKIP_LINK_CQES;
 
 	req->link = NULL;
 	while (link) {
@@ -2051,7 +2066,10 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_fill_cqe_req(link, res, 0);
+		if (!ignore_cqes) {
+			link->flags &= ~REQ_F_CQE_SKIP;
+			io_fill_cqe_req(link, res, 0);
+		}
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2068,6 +2086,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
+			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
 			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
@@ -2339,8 +2358,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		__io_fill_cqe(ctx, req->user_data, req->result,
-			      req->compl.cflags);
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			__io_fill_cqe(ctx, req->user_data, req->result,
+				      req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2458,8 +2478,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			continue;
 		}
 
-		__io_fill_cqe(ctx, req->user_data, req->result,
-			      io_put_rw_kbuf(req));
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			__io_fill_cqe(ctx, req->user_data, req->result,
+				      io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -5775,6 +5796,8 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
+	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
+		return -EINVAL;
 
 	io_req_set_refcount(req);
 	poll->events = io_poll_parse_events(sqe, flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 59ef35154e3d..e521d4661db0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_CQE_SKIP_SUCCESS_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* don't post CQE if request succeeded */
+#define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
 
 /*
  * io_uring_setup() flags
-- 
2.33.0

