Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7AB1538BC
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBETIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 14:08:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37676 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgBETIe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 14:08:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so4168563wmf.2;
        Wed, 05 Feb 2020 11:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q2bqoWdVJyhJvlC3Kkgf7HQYqdThAvtE5829R5JqczM=;
        b=kEuN1OK0njQ0YTDfam5UV+wTyR5JN91xw8THv5iNiDQRKH5zKxDfyW0eGHHb5xHoUR
         czS/mXsHYWH1Dpktik2K4GLY9sJgpCYwxNArdmdwTn5tULJ/PRRLgpefyemHieTwxNZq
         qyh5UPvUOjVxnAevLlhcw7jSwkhU9PvJU/1wm14c/Q+3O5q7JalNUdabT3Lt8PG7nR5M
         Fyi9MTwQYu3tiAKC1//26Xu7HIT6CKyAEvg8TzdifU1qvMiTae/CPiOAwAhvIE+/d4zw
         LViACAaf4WNryeUjyKRVwsFfj+JElHvmJUaqD/pN4YBvG4A4TU/4ppfOuwBD1buhh/5t
         4ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2bqoWdVJyhJvlC3Kkgf7HQYqdThAvtE5829R5JqczM=;
        b=MKd9GUDUXjYqs1oqk7yab6Jrt25+pZ6qbGyfUZEZBQ7cJ9KiFaHV4G3J5mz7i/1/d6
         IL2KBuCnD3b+sBWAvTm0Rmv6M5d2z3VnUZksy3LOYQLi8AE4AqTvd8QR5ekbk7KOGTUV
         FVFlreDqvKhEr2HShGhwbM50BxJ5f7W7G9wQQ0abY0Mwk6CHWEYa4LyaazXzpKSllOGx
         T8UTFz9xfljcl89hALcO+YlPvL5V8EE9f0tkTNu52DYWHFi3eV/mzq3v55F/r1kAHYSZ
         bQmimiXOTa5tgZMQQjpofZfALExqY/NQFdHsLqQ3b4ORHzCS5j/RQlmTqw78YywkaJEZ
         NF2Q==
X-Gm-Message-State: APjAAAWe6CH2/QrhGxIfWGuQDfVMMcEVl1rEKfvAcN3IFfXwBWDIPbfx
        ES3mXAkdy+CSFXDuk44s56iOXLCW
X-Google-Smtp-Source: APXvYqw7DSpyHB8FWRhzpMpK6pGuHhQnJbNSm4GO344oKzg4exj8JlxNKXLiL357oEKSKyFJtiyUAQ==
X-Received: by 2002:a1c:4857:: with SMTP id v84mr7168695wma.8.1580929711807;
        Wed, 05 Feb 2020 11:08:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id b10sm915568wrw.61.2020.02.05.11.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 11:08:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: pass submission ref to async
Date:   Wed,  5 Feb 2020 22:07:33 +0300
Message-Id: <59d04643a5406674ea98ba2f62346992e94feaa5.1580928112.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580928112.git.asml.silence@gmail.com>
References: <cover.1580928112.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Whenever going into async, __io_queue_sqe() won't put submission ref,
so it's done either by io_wq_submit_work() in a generic way (1) or
compensated in an opcode handler (2). By removing (2) in favor of (1),
requests in async are always pinned by this submission ref, so extra
referencing in io_{get,put}_work() can be removed.

The patch makes the flow as follows: if going async, pass submission
ref into it. When async handling is done, put it in io_put_work().
The benefit is killing 1 extra pair of get/put and further though
yet blurry optimisation prospects.

- remove referencing from io_{get,put}_work()
- remove (2) from opcodes specialising custom @work->func
- refcount_inc() in io_poll_add() to restore submission ref
- put a ref in io_uring_cancel_files() as io_put_work() won't be called on
cancel.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b24d3b975344..00a682ec2efe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2466,7 +2466,6 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
@@ -2513,7 +2512,6 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fallocate_finish;
 		return -EAGAIN;
 	}
@@ -2894,6 +2892,13 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 
 eagain:
 	req->work.func = io_close_finish;
+
+	/*
+	 * As return 0, submission ref will be put, but we need it for
+	 * async context. Grab one.
+	 */
+	refcount_inc(&req->refs);
+
 	/*
 	 * Do manual async queue here to avoid grabbing files - we don't
 	 * need the files, and it'll cause io_close_finish() to close
@@ -2947,7 +2952,6 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_sync_file_range_finish;
 		return -EAGAIN;
 	}
@@ -3322,7 +3326,6 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	ret = __io_accept(req, nxt, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
-		io_put_req(req);
 		return -EAGAIN;
 	}
 	return 0;
@@ -3409,6 +3412,8 @@ static void io_poll_remove_one(struct io_kiocb *req)
 	WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
 		list_del_init(&poll->wait.entry);
+		/* compensate submission ref */
+		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	}
 	spin_unlock(&poll->head->lock);
@@ -3634,8 +3639,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 				req->work.func = io_poll_flush;
 		}
 	}
-	if (req)
+	if (req) {
+		/* compensate submission ref */
+		refcount_inc(&req->refs);
 		io_queue_async_work(req);
+	}
 
 	return 1;
 }
@@ -4461,9 +4469,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		} while (1);
 	}
 
-	/* drop submission reference */
-	io_put_req(req);
-
 	if (ret) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, ret);
@@ -5826,15 +5831,12 @@ static void io_put_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
+	/* drop submission ref */
 	io_put_req(req);
 }
 
 static void io_get_work(struct io_wq_work *work)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	refcount_inc(&req->refs);
-}
+{}
 
 static int io_init_wq_offload(struct io_ring_ctx *ctx,
 			      struct io_uring_params *p)
@@ -6358,6 +6360,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL;
+		enum io_wq_cancel ret;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -6378,7 +6381,10 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!cancel_req)
 			break;
 
-		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+		ret = io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+		/* put submission ref instead of never-called io_put_work() */
+		if (ret != IO_WQ_CANCEL_RUNNING)
+			io_put_req(cancel_req);
 		io_put_req(cancel_req);
 		schedule();
 	}
-- 
2.24.0

