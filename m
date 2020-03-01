Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFBA174E54
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCAQTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:41 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55063 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgCAQTk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so8522143wmi.4;
        Sun, 01 Mar 2020 08:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LiVaYMYbUqVkP59cyO56jsLqHdgbJcbPk8cCf+c5iQk=;
        b=c8EU9cL2zkaocTwACu+KThuLqAbHSFH8R0RXIWC9tnZCkg6toNrJt+w//8L9tIrytB
         aXWPasuGdU03mGAJ3QmbP1jwsfQe80Z5Mn5dj2Xexx4xbTowP4rgsPNCnccwHz3D7Zgy
         18rclpuEXkI5NBY5+zNMpVDlwOKeaKOX7IMZd5nnUjBiFzjEt44uU2BvuCmvFryOLELO
         wTN2+tXgVbAm+HsLK0YHWlyFY6BMsXd2IweP5qjvCutf9MeyZ4cXuoSsUHK9AupsCnuh
         H2BgFcuZN3X7yVO+HhvKozkLOCLG3iSWtcp502OOam9eZiN8BsxDZu6PtVLJBKu2zs4V
         fq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LiVaYMYbUqVkP59cyO56jsLqHdgbJcbPk8cCf+c5iQk=;
        b=OvxkFRMRVUitv9JaqIJkJN0YRytOrgqGCMUkLYAn7Il/t5TpLpO1mhFH8w1eUunPhl
         2IOjW1K7/Igz4n5GD8J+wweh0QIsnrld4Bn6D+ZtsK1vRGdOHfOIigE5c+LIXDExtreS
         l6vSehfsepmSmMUoShnxx+jnWIf/oal0hh4Cwemzy9xuFTw22aKzAyYuMpJsWeLBTOWE
         Im53EDErTqE7dp8/QrWwvkDa9Kf08ypRL9rul0vstQmLjr+tZKkSFdQnyxCBKBKuGv40
         Irb3U0/UoTWnXy3xjNHUAwYTe3BNBtRb0l9bkQd9hC2K57y1XxQX09XAR2P0l7ObiQLO
         hlvg==
X-Gm-Message-State: APjAAAV1Jz84PAlhK+TgLdEsStxeHUAWpyd54/hL2xU+C/P4BbqvvLE6
        etPrg/BuXQ5zvgCWT2LI20U=
X-Google-Smtp-Source: APXvYqyFvGzGB/e5gukIL015HTa43jM1e7yFbohtROBBG7p9FnaT+JB+hET3OcSLQOIOyLnU0gAD4A==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr14056231wmd.76.1583079576002;
        Sun, 01 Mar 2020 08:19:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] io_uring: make submission ref putting consistent
Date:   Sun,  1 Mar 2020 19:18:20 +0300
Message-Id: <2245d427a1de9423369a9b2482b0c2149428b2ca.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The rule is simple, any async handler gets a submission ref and should
put it at the end. Make them all follow it, and so more consistent.

This is a preparation patch, and as io_wq_assign_next() currently won't
ever work, this doesn't care to use io_put_req_find_next() instead of
io_put_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff6cc05b86c7..ad8046a9bc0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2550,7 +2550,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	if (req->work.flags & IO_WQ_WORK_CANCEL) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, -ECANCELED);
-		io_put_req(req);
+		io_double_put_req(req);
 		return true;
 	}
 
@@ -2600,6 +2600,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2609,7 +2610,6 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
@@ -2621,9 +2621,6 @@ static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
 	if (ret < 0)
@@ -2637,7 +2634,10 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	if (io_req_cancelled(req))
+		return;
 	__io_fallocate(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2659,7 +2659,6 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fallocate_finish;
 		return -EAGAIN;
 	}
@@ -3015,6 +3014,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -3038,6 +3038,8 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 		 * the file again and cause a double CQE entry for this request
 		 */
 		io_queue_async_work(req);
+		/* submission ref will be dropped, take it for async */
+		refcount_inc_not_zero(&req->refs);
 		return 0;
 	}
 
@@ -3088,6 +3090,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req, &nxt);
+	io_put_req(req); /* put submission ref */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -3097,7 +3100,6 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_sync_file_range_finish;
 		return -EAGAIN;
 	}
@@ -3464,11 +3466,10 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	io_put_req(req);
-
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, &nxt, false);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -4733,17 +4734,14 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		} while (1);
 	}
 
-	/* drop submission reference */
-	io_put_req(req);
-
 	if (ret) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
 
-	/* if a dependent link is ready, pass it back */
-	if (!ret && nxt)
+	io_put_req(req); /* drop submission reference */
+	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
 
-- 
2.24.0

