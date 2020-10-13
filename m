Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BCE28CA79
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403973AbgJMIrB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIrB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:47:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613EFC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e18so22964611wrw.9
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zew41vaYTwL/7B5LU+cCXpiGd8Vrqha7YbHtbwQVmYA=;
        b=J6Pi+t/skgL2Rc6PK5tXGMGQ6SgSsR/30jZz8bTXVsiGIAn2g17xdYJt78sZ6mdYue
         qSm1SjVdj0DaGn/539531b+JIr3UdBthK9Medc0EH0WRaLY/Yx0JjJqWylXxdoUJJUr5
         16ZIMu2GLiOxpzmhygT/8AG6DNuz5Bv/D7cM+EAVblvcFsjVEyQYiss1Q5t2Oh2VgqWb
         5OESlINPxdSyBRYvCWZgQo2CVln8kXEnh3R0uFUlznusAi6Wbc8lu+M/NK9LdHvghupF
         fCtzqH3QqMNH0bM7XiuqU18L7Tz8dii4SQ28z01yWabdzFRae/mWVO97AVGO+daXnx3F
         Ue6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zew41vaYTwL/7B5LU+cCXpiGd8Vrqha7YbHtbwQVmYA=;
        b=awg2w/8uAMwQwKw4a8dch1Db5cqm52tlHra3En5vQdXY92+RvJxQd3kpmxHG/gepK/
         0/NO/mknNvRjDSRYqY4ORchJbnpT0o4OIFcycNecYl9bX9bFZCJWa/byvgpgdtKkJwiE
         2ndIyfZSlrIj8JEJXWS+g8zpZQtXcFEdhaFT2iGIQqyhoQi1uxLKAqrHOZ1szW4Skq9O
         6IAFDRckoUwSsOVWlGrYWOdKdUowZDI4yf/S3SgCId+zJRN0nMyRyG5CR1ZYK8Ul4IGC
         4q0fxBf83dieLn1E7q1hIHQqiXpdwyCiwjhfZ5bZ90UI4FLJ1A0jRxvgRepWG9AAuMUL
         SR2w==
X-Gm-Message-State: AOAM530ZKFER50yv7ul0Iz7KUfEnXA8ysQ7XHbGiG43MYSNp16zK6biW
        qZ1ICJ/4gsUwFvEXlF/UyQ+aprKBhGs=
X-Google-Smtp-Source: ABdhPJzEqw9FFKCqfxkCGgAj1YJWTbI8USb3K/GtQK7FrdAW5Bxs94u5BQ4tRjwVE0p0AiwNo0B9YA==
X-Received: by 2002:adf:e292:: with SMTP id v18mr33935343wri.256.1602578820157;
        Tue, 13 Oct 2020 01:47:00 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:46:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: dig out COMP_LOCK from deep call chain
Date:   Tue, 13 Oct 2020 09:43:59 +0100
Message-Id: <95722fbc3e6d9c02043a1c162ec5db90deeaa27f.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
References: <cover.1602577875.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_clean_work() checks REQ_F_COMP_LOCK to pass this two layers up.
Move the check up into __io_free_req(), so at least it doesn't looks so
ugly and would facilitate further changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca1cff579873..d5baa5bba895 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1190,14 +1190,10 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-/*
- * Returns true if we need to defer file table putting. This can only happen
- * from the error path with REQ_F_COMP_LOCKED set.
- */
-static bool io_req_clean_work(struct io_kiocb *req)
+static void io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
-		return false;
+		return;
 
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
@@ -1216,9 +1212,6 @@ static bool io_req_clean_work(struct io_kiocb *req)
 	if (req->work.fs) {
 		struct fs_struct *fs = req->work.fs;
 
-		if (req->flags & REQ_F_COMP_LOCKED)
-			return true;
-
 		spin_lock(&req->work.fs->lock);
 		if (--fs->users)
 			fs = NULL;
@@ -1227,8 +1220,6 @@ static bool io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.fs = NULL;
 	}
-
-	return false;
 }
 
 static void io_prep_async_work(struct io_kiocb *req)
@@ -1708,7 +1699,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 		fput(file);
 }
 
-static bool io_dismantle_req(struct io_kiocb *req)
+static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
@@ -1717,7 +1708,7 @@ static bool io_dismantle_req(struct io_kiocb *req)
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
-	return io_req_clean_work(req);
+	io_req_clean_work(req);
 }
 
 static void __io_free_req_finish(struct io_kiocb *req)
@@ -1740,21 +1731,15 @@ static void __io_free_req_finish(struct io_kiocb *req)
 static void io_req_task_file_table_put(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct fs_struct *fs = req->work.fs;
-
-	spin_lock(&req->work.fs->lock);
-	if (--fs->users)
-		fs = NULL;
-	spin_unlock(&req->work.fs->lock);
-	if (fs)
-		free_fs_struct(fs);
-	req->work.fs = NULL;
+
+	io_dismantle_req(req);
 	__io_free_req_finish(req);
 }
 
 static void __io_free_req(struct io_kiocb *req)
 {
-	if (!io_dismantle_req(req)) {
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		io_dismantle_req(req);
 		__io_free_req_finish(req);
 	} else {
 		int ret;
@@ -2066,7 +2051,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	}
 	rb->task_refs++;
 
-	WARN_ON_ONCE(io_dismantle_req(req));
+	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
 		__io_req_free_batch_flush(req->ctx, rb);
-- 
2.24.0

