Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD351235AA
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 20:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfLQT1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 14:27:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41606 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfLQT1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 14:27:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so1774367wrw.8;
        Tue, 17 Dec 2019 11:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aa0MHm0jNgCV5u+eqHQup6OeLeHMHuyq3NzfGZGNmqQ=;
        b=r+QweQzSVJad5MVP388wMUb6Lk0P3DYnEmXnIv6nyG+FrlU6JjPextTIEvgAOZRg9v
         WMwdZAmQwXP95gMHa/byaoJxaAmR4dxAR+Vmxk+EfF5WR5ub1KMSkWfX13HSVxAcdVRZ
         7i0vs7WVoqAgG+aNLX1FamDkqjDXkFxvQ4fOZX6IcBy6QXYz3nrSYGAIyChHs7ZE+2Rb
         KxLldzurACj6bYbwFZjv8zwNEXrvDN74TK93xqxoINMWl08eY4aP7Zg2dxRsDvFSA/Oq
         SdeFFQuomHFkXRrDOSVZhddpxwMeNfkvJ4hc7TGPJuH9E+L8vde19RFE+hp4Hb6b4eLz
         y0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aa0MHm0jNgCV5u+eqHQup6OeLeHMHuyq3NzfGZGNmqQ=;
        b=gAHLnpGlXradwUydUubDUoeHojX1qT7KjwsNNNmbS56H6WfrXHyO8ThdPa/EG8Jdgs
         ptueGenO++qBnkHgZbm+cdIW0Ghajpgy7+A9ugMD+xXeBEPrv4jUEMiNIv9iRiY57Lel
         H46rZWwNDSyD4xuiZQVfVCSJo3mo0T2B/BKhe15MnClBkNrI1rOyot1WrLv+25UuIoXE
         PHmD4Y93YIFc6bWQvmvuiW5hakXFnOD9FVq6/po10Mjt20hi8kCDs4bNb8a0Fcg/rUfG
         zB95+28ZgEnRZDZdTBCpThYYTBBc+lTqoV66UqYB+cobGwzNg6VoFH5s8bC+g7CrVRBE
         ysCA==
X-Gm-Message-State: APjAAAW+5rRgrq21JdGrbbulUH40H+Lenf4f9hldMfCGUwLbGaQJTcOZ
        51rC8klMF8P9PImZ0YtronjjVPt8
X-Google-Smtp-Source: APXvYqwIR7NYj6uIuNHWrVx4rFzvV0MJRX+/w8zvZBeFZE1fzik4xowTHKEQHUocHmIPWFEwBedliw==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr36383336wrm.24.1576610856093;
        Tue, 17 Dec 2019 11:27:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id w13sm26711822wru.38.2019.12.17.11.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 11:27:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] io_uring: move *queue_link_head() from common path
Date:   Tue, 17 Dec 2019 22:26:58 +0300
Message-Id: <c58a248e87cc4b471e79572136f2d3d2efaf5932.1576610536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576610536.git.asml.silence@gmail.com>
References: <cover.1576610536.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_queue_link_head() to links handling code in io_submit_sqe(),
so it wouldn't need extra checks and would have better data locality.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee461bcd3121..8ab96ca0ad28 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			  struct io_kiocb **link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned int sqe_flags;
 	int ret;
 
+	sqe_flags = READ_ONCE(req->sqe->flags);
 	req->user_data = READ_ONCE(req->sqe->user_data);
 	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
 		ret = -EINVAL;
 		goto err_req;
 	}
@@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	if (*link) {
 		struct io_kiocb *head = *link;
 
-		if (req->sqe->flags & IOSQE_IO_DRAIN)
+		if (sqe_flags & IOSQE_IO_DRAIN)
 			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
-		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+		if (sqe_flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
 
 		if (io_alloc_async_ctx(req)) {
@@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		}
 		trace_io_uring_link(ctx, req, head);
 		list_add_tail(&req->link_list, &head->link_list);
-	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
+
+		/* last request of a link, enqueue the link */
+		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
+			io_queue_link_head(head);
+			*link = NULL;
+		}
+	} else if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 		req->flags |= REQ_F_LINK;
-		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+		if (sqe_flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
 
 		INIT_LIST_HEAD(&req->link_list);
@@ -3540,10 +3548,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
 
 	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req;
-		unsigned int sqe_flags;
+		struct io_kiocb *req = io_get_req(ctx, statep);
 
-		req = io_get_req(ctx, statep);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -3563,8 +3569,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		}
 
 		submitted++;
-		sqe_flags = req->sqe->flags;
-
 		req->ring_file = ring_file;
 		req->ring_fd = ring_fd;
 		req->has_user = *mm != NULL;
@@ -3572,14 +3576,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		if (!io_submit_sqe(req, statep, &link))
 			break;
-		/*
-		 * If previous wasn't linked and we have a linked command,
-		 * that's the end of the chain. Submit the previous link.
-		 */
-		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
-			io_queue_link_head(link);
-			link = NULL;
-		}
 	}
 
 	if (link)
-- 
2.24.0

