Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100C4159A25
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbgBKUCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42318 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgBKUCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:53 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so14034495wrd.9;
        Tue, 11 Feb 2020 12:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JoJVONI9ynzOQnCp/Q3VBaIx3fqD2PLhYmRbsdZ0IMM=;
        b=rdaUQf+wDobwiG7cRBhwJRYvsUOxx0oNOJwo0P03pFApmIjdSKxEu0f9fNxn0IdTxL
         sMtLew8pF6MKkWpS/tpeMNpC2BsP5csjcLqZntO1sEkktQ6aeM8OLr8lw9plB1n96lmD
         C2cQtPpq8wlFOxa5SCwd6uFS2Cw6oWS9aHV3Fh74UMGj7AW6PpKvG2omcZweE8fjRD4x
         LgtMSyqYENBhqdtaL5bCJBJM3HBYnJlYQRphndrCrX7Ce1OT3nOXQVRygDw8WrnnQPf9
         WLZirWiyyqWP3sRFuWXxNfXfreA6SgK2XaKxqUaFhLD0MknInA7IAkvhnLEcyPtP/Jzu
         XgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JoJVONI9ynzOQnCp/Q3VBaIx3fqD2PLhYmRbsdZ0IMM=;
        b=r/HEcomw4BQv8x+G1QwJahb+SxwNztvnjKo6llegbJkGdIzTDV97KYyKWB66GK4POK
         QIbx7LdewJp6bDWcj1xaBBwbk0pEcDA2a/T/LaNKdY2uiSXSZEe8dXaaPFlffpFxg9wy
         BKoTUNI7JMfTL5tmbuxG4DMBoUpHZdFdVGJT6vix5hjT+2tAq0WSp6Os8Ek04QJgpfVc
         OT175eWXfFiGYQA0xJNINInPBENa6Jk/z+U2ZjPgzf2hmACaVJMMaLxNEgvjtE0I2Ix7
         tgu47Sf/waKoxXj17xX0DHBL0KQk1S11y8OUA17LjYLvsOK5ttFlKdQTQqSv4X1xizNU
         xJXw==
X-Gm-Message-State: APjAAAUeR2e04hyTErL7L8uU/b/oYWkvjTQRrdaSLvBuGUmDG7y2q+zI
        HtscZqk3Adg6BiIv3fm+EB1g+uDc
X-Google-Smtp-Source: APXvYqyEm/aUq2S5+C5q3JwTuvzsUeaUELJnuGSq8hsA4hWF0bgU4oljaG6AsyckNEdkZNYT2CeLxw==
X-Received: by 2002:a5d:61cf:: with SMTP id q15mr10050833wrv.74.1581451370644;
        Tue, 11 Feb 2020 12:02:50 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring: don't call work.func from sync ctx
Date:   Tue, 11 Feb 2020 23:01:55 +0300
Message-Id: <ef53fa1d05e92d333f20d75a682570565945348f.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581450491.git.asml.silence@gmail.com>
References: <cover.1581450491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Many operations define custom work.func before getting into an io-wq.
There are several points against:
- it calls io_wq_assign_next() from outside io-wq, that may be confusing
- sync context would go unnecessary through io_req_cancelled()
- prototypes are quite different, so work!=old_work looks strange
- makes async/sync responsibilities fuzzy
- adds extra overhead

Don't call generic path and io-wq handlers from each other, but use
helpers instead

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 76 +++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98da478ae56c..04680d2c205c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2462,23 +2462,28 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	}
 }
 
-static void io_fsync_finish(struct io_wq_work **workptr)
+static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	loff_t end = req->sync.off + req->sync.len;
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+static void io_fsync_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	if (io_req_cancelled(req))
+		return;
+	__io_fsync(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2486,26 +2491,18 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
-
-	work = old_work = &req->work;
-	io_fsync_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
+	__io_fsync(req, nxt);
 	return 0;
 }
 
-static void io_fallocate_finish(struct io_wq_work **workptr)
+static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
@@ -2513,7 +2510,15 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+static void io_fallocate_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	__io_fallocate(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2533,8 +2538,6 @@ static int io_fallocate_prep(struct io_kiocb *req,
 static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 			bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2542,11 +2545,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	work = old_work = &req->work;
-	io_fallocate_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
-
+	__io_fallocate(req, nxt);
 	return 0;
 }
 
@@ -2949,21 +2948,27 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
+static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, &nxt);
+	io_put_req_find_next(req, nxt);
+}
+
+
+static void io_sync_file_range_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	if (io_req_cancelled(req))
+		return;
+	__io_sync_file_range(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2971,8 +2976,6 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
-	struct io_wq_work *work, *old_work;
-
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
 		io_put_req(req);
@@ -2980,10 +2983,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	work = old_work = &req->work;
-	io_sync_file_range_finish(&work);
-	if (work && work != old_work)
-		*nxt = container_of(work, struct io_kiocb, work);
+	__io_sync_file_range(req, nxt);
 	return 0;
 }
 
-- 
2.24.0

