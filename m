Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EB14F477
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgAaWQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38500 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgAaWQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so10517552wmj.3;
        Fri, 31 Jan 2020 14:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7wdBkgzfqrw3xwjaGUYTIWJD4C1FRsvzjImuzApBwhE=;
        b=fhK5lsmHoZTARU0AtIXR40+duvR3HttOsmxuahiUIYZ06LMpDJw9/c5cH7P7tRNl4z
         HDCdlHdm1yhD5DFOcGIv3rA6SAHDFySuylnga+Bt+7lKtMuzOouj9ptdVLDH8aUU1cCj
         Yoap7PK8pkHyqI5g3Bec6Xpo2t2R82PLur5jBcU98ARqNeH1MRBssFaOgV9/2OB/DXr/
         mame+ITreddPQilTVqnuchQGyC/AAmEOnZPpAKQsJry8AS1CKR8xO4lGKdzv7p6PUVsB
         B1g/zA5vCA3/bYP+qrLF9aJPOoEIeR23ATdifoosnlkKg8UTXT/cFwNkGOiSafNwotJP
         dZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wdBkgzfqrw3xwjaGUYTIWJD4C1FRsvzjImuzApBwhE=;
        b=aUuDL7lfT+QpH0fM42AbIyd4rx3PBVc60igVSieVJZbU3pe5K+RUXdXo0yv0GQtOzm
         MLt5SSs6u9gN8u3+HkvbYrPj+ch98GVriKt6zxryWCoBJ2ht6cDCUagi/S8ZHqQZHZ2x
         WiC6lBgbySpU7iqyfocHi4FRHVnw+9zfkqNtMyJr0BtmWsooRr8Ky1Df1+eszApSGHu6
         h2oTsdh3g0Rsjv6Uh6O/IxQ+ZVj8KK7Ql+wOhuUEX2DDXACqjADHtswTYkqfE2UXvx6b
         p4IvFrJf7ZQu0FZFqD0WCB85/ugDIwf09cpsQnWZVqtJVxPi0S3K9vP1OFvO7rvUNaZQ
         vgMg==
X-Gm-Message-State: APjAAAUvluEQ/bYOQJU5MF0Lx3YDma6vJR6ZiWLBCgCp2ZOKQCxQz2zQ
        UqvKrObJjVksHPdOWgbcpvs=
X-Google-Smtp-Source: APXvYqzeFMLsAKoA6oc96JgRrhzajf+CVrico6XvPOMI0sbd/JUF4GwzrQRHzuc/7zRVfld8J9ciCw==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr14507267wmg.144.1580509009552;
        Fri, 31 Jan 2020 14:16:49 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] io_uring: move *link into io_submit_state
Date:   Sat,  1 Feb 2020 01:15:53 +0300
Message-Id: <f86d95660c3e69d8161bae9c9bde45a90a1ae10d.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's more convenient to have it in the submission state, than passing as
a pointer, so move it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 725e852e22c5..cbe639caa096 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -219,6 +219,8 @@ struct io_submit_state {
 
 	struct file		*ring_file;
 	int			ring_fd;
+
+	struct io_kiocb		*link;
 };
 
 struct io_ring_ctx {
@@ -4721,11 +4723,11 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
-static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_kiocb **link)
+static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 	unsigned int sqe_flags;
 	int ret, id;
 
@@ -4770,8 +4772,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (*link) {
-		struct io_kiocb *head = *link;
+	if (state->link) {
+		struct io_kiocb *head = state->link;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
@@ -4801,7 +4803,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		/* last request of a link, enqueue the link */
 		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
 			io_queue_link_head(head);
-			*link = NULL;
+			state->link = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
@@ -4814,7 +4816,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
-			*link = req;
+			state->link = req;
 		} else {
 			io_queue_sqe(req, sqe);
 		}
@@ -4836,6 +4838,8 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
 					&state->reqs[state->cur_req]);
+	if (state->link)
+		io_queue_link_head(state->link);
 }
 
 /*
@@ -4852,6 +4856,7 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 
 	state->ring_file = ring_file;
 	state->ring_fd = ring_fd;
+	state->link = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -4915,7 +4920,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct mm_struct **mm, bool async)
 {
 	struct blk_plug plug;
-	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
 
@@ -4973,7 +4977,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, &link))
+		if (!io_submit_sqe(req, sqe))
 			break;
 	}
 
@@ -4982,8 +4986,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		percpu_ref_put_many(&ctx->refs, nr - ref_used);
 	}
-	if (link)
-		io_queue_link_head(link);
 
 	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
-- 
2.24.0

