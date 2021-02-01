Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C41330B003
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhBATFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhBATEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:37 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC4C061786
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q7so17794674wre.13
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XteyHnZe8p7ca3vWiJx6T9if5QDkrrMcbIex424p+AE=;
        b=gPIbmvHNE4nAQBsa2BZBW1sF8gfD4y4ox0WouRiERRSMu/BkLRrEOuJppMa+ZrbQuY
         UxLKPHPnGrPn+DpNe4fwZqFlLOXIXbi5jOaq1HMbutQLIxDNCG8xi46xdziAjIimFwJA
         WzLBx4IcMbhhWT77DxgKRoZM9HTe39N+K6BLyIeFfXkk07vnVxw4orZ1PeUMLbcg5b6N
         YDX+zbVrh5mZ/U7sN3OZsZF+fJrPrmSecQ0gEwLVDkyIyw3/XVzDl3qcya5Qwx2e3fbM
         /hxf60LOFiFmVFgVuZmzYapkgsVxK37tjyV+2ml/I7rDL0IORJlWQJe3J8r4Z3y6zQ4j
         0Icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XteyHnZe8p7ca3vWiJx6T9if5QDkrrMcbIex424p+AE=;
        b=BV1N7kKXinltoWxc1ITSOw4bKFUpNm1XEkdo2wGx114ycFNu526xKxPYllKkoxp8MR
         S2EYv9eHAQDyqQ2qUxJEvQxFtzc1runnorpLGqx5wqBOSiGZYrnLugONSmg3JuOhEd5V
         WPrDyVfq8XnhRuqmZ1fL1FamqPQVfTn2hYUj0pp7hL1Jmh1b3z8NgaWYsXagB47FJith
         iLhLrbZYSEjflZNWYXcImc3obntiuH2lnDR0RyXfkD8rq2pEB0/iGX0EbikeAXKNdnTt
         MGDjQCiN4hj1VKdPw3EcD8/FyMzHWWdIsc6XwllfWkhRfvfMR14nrygtXjvBqYQTtM8s
         3AMw==
X-Gm-Message-State: AOAM533vGyrtHYaI2opnXH/fkEWtWp4Rf9JzteXPFl6Nos3lPbYvcl24
        KuQSxHblpJjv1NLTE1kyqdac9n7wPnA=
X-Google-Smtp-Source: ABdhPJzTNQ5PTAkkuiHZmrjOFZXk1AlfnGEex7y6B9vOqbMJow426/7g+UDfx8FybQiwcnf6/FXZ+w==
X-Received: by 2002:a5d:664c:: with SMTP id f12mr19639396wrw.61.1612206231820;
        Mon, 01 Feb 2021 11:03:51 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: deduplicate adding to REQ_F_INFLIGHT
Date:   Mon,  1 Feb 2021 18:59:55 +0000
Message-Id: <54e9901b6e17477f4615055b752ca85659661923.1612205713.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't know for how long REQ_F_INFLIGHT is going to stay, cleaner to
extract a helper for marking requests as so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7dc3d4260158..6834379c208b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1460,11 +1460,24 @@ static bool io_identity_cow(struct io_kiocb *req)
 	return true;
 }
 
+static void io_req_track_inflight(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		io_req_init_async(req);
+		req->flags |= REQ_F_INFLIGHT;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		spin_unlock_irq(&ctx->inflight_lock);
+	}
+}
+
 static bool io_grab_identity(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_identity *id = req->work.identity;
-	struct io_ring_ctx *ctx = req->ctx;
 
 	if (def->work_flags & IO_WQ_WORK_FSIZE) {
 		if (id->fsize != rlimit(RLIMIT_FSIZE))
@@ -1520,15 +1533,8 @@ static bool io_grab_identity(struct io_kiocb *req)
 			return false;
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
-
-		if (!(req->flags & REQ_F_INFLIGHT)) {
-			req->flags |= REQ_F_INFLIGHT;
-
-			spin_lock_irq(&ctx->inflight_lock);
-			list_add(&req->inflight_entry, &ctx->inflight_list);
-			spin_unlock_irq(&ctx->inflight_lock);
-		}
 		req->work.flags |= IO_WQ_WORK_FILES;
+		io_req_track_inflight(req);
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
 	    (def->work_flags & IO_WQ_WORK_MM)) {
@@ -6443,16 +6449,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
-	if (file && file->f_op == &io_uring_fops &&
-	    !(req->flags & REQ_F_INFLIGHT)) {
-		io_req_init_async(req);
-		req->flags |= REQ_F_INFLIGHT;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
-	}
-
+	if (file && unlikely(file->f_op == &io_uring_fops))
+		io_req_track_inflight(req);
 	return file;
 }
 
-- 
2.24.0

