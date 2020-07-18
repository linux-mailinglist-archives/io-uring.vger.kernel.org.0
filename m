Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA53D2249DE
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 10:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgGRIe4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 04:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbgGRIev (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 04:34:51 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C62C0619D3;
        Sat, 18 Jul 2020 01:34:50 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q7so15309077ljm.1;
        Sat, 18 Jul 2020 01:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QYsmohHX4ln1V0gQOEGp8gE+5TZzMMGOeU8S/vpgEPo=;
        b=M2s4NCYDfJimKFQMOmTfY4Xvpulv2i8U+qQt4ANGT+CErJXdML4ivd78j/XVD9R77I
         W4ajBPu2Ltwo45UJmlIgGXukRnpsrNcGdev+JoCiW/kSfIeS6AFCcYbsBOWs9+1Rlj0n
         ig2imsD1/aLyTR5qqIiFIlNNwU0DOwCjqxfE3op/xPhoPFHDZfRmjvF/nPO0kJmfyhSJ
         YYg2O/8NQFbmp//EeDUhMrY1iySIE2R0pJ54UdToBiXWd90aREXDDa65QxVcuK0ZH+fn
         dScO79Xhmlp4LaRN9Yxpy/Ng9fiScLZIogznwO37C+4YwjFamjep0PluMJvYsnJUrNGP
         Oh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYsmohHX4ln1V0gQOEGp8gE+5TZzMMGOeU8S/vpgEPo=;
        b=N8AibMJ2cZSnUTfOjbaNhCGHJH1lK0/2RVW3UBAUYjBSpEqdo7y269RnSarLiyDjs3
         XLOhZWYwbqudzSYx3+RGfuU7ToG+iMQo9YN+lPV863JzqY0U0AUZ1hR4/pUKw9puvf93
         qMGUS/A2Ybsu2kb4SnmzMafZ1ZZ8zWKwGsEjD65I5SUDkTmZc6y13tXlbCyMbsbmb3kR
         kmDIJ/pAQTj46nuPFDQ6c5hMfe4YaacN8TArlV5j5FCPR192fz6Xs5R6vKkRIn54/lPr
         SnsU71KdZ0iHSn9Mprql1yvdfQ/69jUHl47itJx+rRgyGzpAFsYyYqiKfRs4d9TDnAUQ
         51jw==
X-Gm-Message-State: AOAM533y4T0qQ3VKG7B4Z6kduRVO+Qo55TtWqfjBQrs/ZXtIfgbIz0Nm
        V8O6We36ucAGQ+s/jWVusTA/Qqyb
X-Google-Smtp-Source: ABdhPJyQ5aDJMIiAzOmkliORJIVZKK6iYVcEk3DBcZzY7O/fEaLm3XtksjIeGlZuOczK5ku4yNiZ9A==
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr6279795lji.450.1595061289390;
        Sat, 18 Jul 2020 01:34:49 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id u26sm2789226lfq.72.2020.07.18.01.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 01:34:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: batch put_task_struct()
Date:   Sat, 18 Jul 2020 11:32:52 +0300
Message-Id: <8a0e399414ec362ee0c587f4bdca968d4fa04be7.1595021626.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595021626.git.asml.silence@gmail.com>
References: <cover.1595021626.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As every iopoll request have a task ref, it becomes expensive to put
them one by one, instead we can put several at once integrating that
into io_req_free_batch().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 57e1f26b6a6b..b52aa0d8b09d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1543,7 +1543,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	__io_put_req_task(req);
 	io_req_clean_work(req);
 
 	if (req->flags & REQ_F_INFLIGHT) {
@@ -1563,6 +1562,7 @@ static void __io_free_req(struct io_kiocb *req)
 	struct io_ring_ctx *ctx;
 
 	io_dismantle_req(req);
+	__io_put_req_task(req);
 	ctx = req->ctx;
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
@@ -1806,8 +1806,18 @@ static void io_free_req(struct io_kiocb *req)
 struct req_batch {
 	void *reqs[IO_IOPOLL_BATCH];
 	int to_free;
+
+	struct task_struct	*task;
+	int			task_refs;
 };
 
+static inline void io_init_req_batch(struct req_batch *rb)
+{
+	rb->to_free = 0;
+	rb->task_refs = 0;
+	rb->task = NULL;
+}
+
 static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
 				      struct req_batch *rb)
 {
@@ -1821,6 +1831,10 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 {
 	if (rb->to_free)
 		__io_req_free_batch_flush(ctx, rb);
+	if (rb->task) {
+		put_task_struct_many(rb->task, rb->task_refs);
+		rb->task = NULL;
+	}
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
@@ -1832,6 +1846,16 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_HEAD)
 		io_queue_next(req);
 
+	if (req->flags & REQ_F_TASK_PINNED) {
+		if (req->task != rb->task && rb->task) {
+			put_task_struct_many(rb->task, rb->task_refs);
+			rb->task = req->task;
+			rb->task_refs = 0;
+		}
+		rb->task_refs++;
+		req->flags &= ~REQ_F_TASK_PINNED;
+	}
+
 	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
@@ -1977,7 +2001,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	/* order with ->result store in io_complete_rw_iopoll() */
 	smp_rmb();
 
-	rb.to_free = 0;
+	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-- 
2.24.0

