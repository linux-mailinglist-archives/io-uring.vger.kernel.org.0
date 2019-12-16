Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E93121EE6
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 00:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLPXWx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 18:22:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51072 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfLPXWx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 18:22:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so1085164wmb.0;
        Mon, 16 Dec 2019 15:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x8nU01l1+vWsHvZad2awAYIoskbBmhJuMKxGT9lmKus=;
        b=VW+e/v6vX+6B8/Pmp0PJZzBLJQndN7RxiavN+X9VhNNjRU5fsJg+M4TSZ5Fg/BJaTK
         +BkZin1FesJeE4jSQDvYXwuBNYQa0H99hYzJmlrxTjuHDTIoqlSJTaJSXHRhrpTgBmnP
         ZdaCpimd5rCc0VsepxFodFEcPxIzU+TNSfCzhOUPVPwYrtceDjXj/iXjXRJeSXa+M3o4
         OWYsQln5mnO8zVQ3VtHTac19MyUjhCWP3/c0oB0I843wH1X8PGUxNyb/pjYiQ00Hexe0
         gh9pvdnNraaKu6soCciQo01fbSfD+l9Y/POBBEUSckQX2F31yuObHKHumZSiRUhOaj9u
         Mp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8nU01l1+vWsHvZad2awAYIoskbBmhJuMKxGT9lmKus=;
        b=rAoOJraPgNsZC97KLTEC1uP3me7Mw+md0p+dcx/SjxCP06hJS6M+DSKZaJP8+2ZNh9
         2MjUKgpuQ3+wYH9BhH62uzLkErJhrEtQPp3LtH1v9W0CX7xJ2hRhAZOK5qcgHDnE4Nhy
         g0G48AiaBZ061WaOK7Xz5vNB500jOYHD03N2jb6W0aYVRqfwFyEldHa5zLPCZGuve1CA
         vcpfVFGFdNuEMyNXqzudd22p0iosULPOO5Bs2i674mhX4NB62LeGC/+ncziXIrtrtQWl
         eIqMhpYvSmQOZmDezNALHMK8HUGwCLgSfjtVlNSug617x8iWlvf2y5zY2yw3aPnKu31o
         Wa3w==
X-Gm-Message-State: APjAAAWz1ScxMmJ3U3kbf7G/HfQhDgE5hxQmB4QTVUAGo8whN7slMlAQ
        0ufVjvavfDvGeSR6Mr8bCq5/PtLC
X-Google-Smtp-Source: APXvYqxgY03Xxw1GZGJH8PoC8CI9mvVQc1f3Ei8QFUw76SlaHbm8DnKJ7jB7B7bbuWvOMvjSIuqAfg==
X-Received: by 2002:a1c:964f:: with SMTP id y76mr1665956wmd.62.1576538571113;
        Mon, 16 Dec 2019 15:22:51 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id 5sm23526167wrh.5.2019.12.16.15.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:22:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: move *queue_link_head() from common path
Date:   Tue, 17 Dec 2019 02:22:09 +0300
Message-Id: <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576538176.git.asml.silence@gmail.com>
References: <cover.1576538176.git.asml.silence@gmail.com>
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
index bac9e711e38d..a880ed1409cb 100644
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
+		if (!(sqe_flags & IOSQE_IO_LINK)) {
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
-		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
-			io_queue_link_head(link);
-			link = NULL;
-		}
 	}
 
 	if (link)
-- 
2.24.0

