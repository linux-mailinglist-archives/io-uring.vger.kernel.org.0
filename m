Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50B14979D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAYTyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:45 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52550 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgAYTyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so2763196wmc.2;
        Sat, 25 Jan 2020 11:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=O+YdBeRfrUCBNvQVHd+6eaVsRVjTnSvqp1R98uHsKZI=;
        b=qvgooRKB17Ogzy/oUaGMJ3BuVZsfBvJpniSXUZjfrzP/2Eu+LsiqLiP7XKbTUm1K9/
         CQhA+wyPb2Y4f6t6bXAHinscYilrFtfFb5AshdhuG3AFOmf+jhWipVTOonrpPFPshA5G
         +n65T/3v7auI5VkGc5n45KiVSsoFb+4Wzv3vIP3WlOQtkoVHkNJjkbvcBUrXqgDegheg
         gvXUbcdO2PfX4vVRvl98kty+MHZ1Rt4mNHlwcTAImD9w3kLGBmAXPYNTnkigmK7ZYNiJ
         OEKQH5IjoHToXFLBGtJxO48bje1OZ3gW9WTb8g4+b36UdfkEnnmJ3oGZGNLKFPcfdfjW
         9hQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+YdBeRfrUCBNvQVHd+6eaVsRVjTnSvqp1R98uHsKZI=;
        b=i31hFjyEgk/hWHUkUwd42eO2IOthtfMBRfiNIiNFkjeSF92Sg5SW+9g+ICGP7c+mqm
         n6mAHXyLdxzDYQAyECAfthfX0Eoo5jHMiOzY1TPt+YbDUPdJUXGl3yQ21/y9uXT4y2/f
         e34KzUeMvNP0ebFzOOCtWPQ7fC5lbgHbAmrHQIe4B2b29zthKnf8JlHSyFcvzGhUNSop
         kTzaf+O9eg7bLnBmLgr3upOSVLL30pG1rmLx6ADF2vFcYkj+n/jE5lJz6b85WLvdUlKN
         oboqYN5jdSjspdMnA5SMBiHymfIreNUhIyJd3IKBB/5vyQHTC4/W7ZHhSMTM5av/SlKk
         JXlw==
X-Gm-Message-State: APjAAAXvOmO9hwlAlu2xu1OL1v3aPxaTn3wI/ClkEEm8417lzwyvyUvA
        aTaZsspkBvg58amrAAkan3q067OT
X-Google-Smtp-Source: APXvYqwCE6VUWg5YgqOItq2H0KBcIccaY7A7b46n3idp1UlUn8IUbRvn8Ui3zw7nzRdydo6DieLsWQ==
X-Received: by 2002:a1c:7717:: with SMTP id t23mr5631185wmi.17.1579982083072;
        Sat, 25 Jan 2020 11:54:43 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] io_uring: move *link into io_submit_state
Date:   Sat, 25 Jan 2020 22:53:43 +0300
Message-Id: <d9615d9c553187cb0272488dd41e367166b3eb2d.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 880c0e9bbe9e..5022eb4cb9a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -221,6 +221,7 @@ struct io_submit_state {
 	int			ring_fd;
 
 	struct mm_struct	*mm;
+	struct io_kiocb		*link;
 };
 
 struct io_ring_ctx {
@@ -4664,10 +4665,10 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
-static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_kiocb **link)
+static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 	unsigned int sqe_flags;
 	int ret;
 
@@ -4697,8 +4698,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (*link) {
-		struct io_kiocb *head = *link;
+	if (state->link) {
+		struct io_kiocb *head = state->link;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
@@ -4728,7 +4729,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		/* last request of a link, enqueue the link */
 		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
 			io_queue_link_head(head);
-			*link = NULL;
+			state->link = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
@@ -4741,7 +4742,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
-			*link = req;
+			state->link = req;
 		} else {
 			io_queue_sqe(req, sqe);
 		}
@@ -4761,6 +4762,8 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
 					&state->reqs[state->cur_req]);
+	if (state->link)
+		io_queue_link_head(state->link);
 }
 
 /*
@@ -4777,6 +4780,7 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 
 	state->ring_file = ring_file;
 	state->ring_fd = ring_fd;
+	state->link = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -4839,7 +4843,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd, bool async)
 {
 	struct blk_plug plug;
-	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
 
@@ -4897,7 +4900,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, &link))
+		if (!io_submit_sqe(req, sqe))
 			break;
 	}
 
@@ -4906,8 +4909,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		percpu_ref_put_many(&ctx->refs, nr - ref_used);
 	}
-	if (link)
-		io_queue_link_head(link);
 
 	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
-- 
2.24.0

