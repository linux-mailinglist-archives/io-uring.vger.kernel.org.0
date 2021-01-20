Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DB82FC8A8
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbhATDVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732091AbhATCg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:36:58 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15921C0613CF
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id y17so21616635wrr.10
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gFv5SzEKELQP7zLKT3+YpOZpTwxUmvYl0uWhQtmURps=;
        b=oN98o4Htz00+gBI8kpViFX24jWJjDvMfPbBnXPDCRC8jigdsgzVX5ZDKdkSq2u+6sT
         7DJMDJc5fMTovq5+CdRPIp4Pf0P1H2gCD71H46LoH5/mUQE87MSxA10xuPaBBFn4oz9Q
         r3H7h5hqDPB4FzFvC4ogDh2lANQbvKRpYWsDnPqYk2exWP+gq1GXIBs8E23y72gcHtDU
         Oqu/RzmcZFylc8B2Y2NQrEteumoShXaXy+vN2mZny+IvW0StHx9IA25mj+Ia4t6EZbIJ
         cdIT3YBPYLOVkwOe3N5AG5uRLAkVLw90W6iaf55+8ENc+d5od44Kent1LIsHfq+L8ZJY
         sylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gFv5SzEKELQP7zLKT3+YpOZpTwxUmvYl0uWhQtmURps=;
        b=Ut8L0B9QEG6I3VdTsKo8bg8d6R9SPqPQiOEp7GGn8QCpsgwNtlY5I0gJFnJrQN0qdJ
         2Rg6DGkYrEOdJBxrb5j1xnUeU8bwM48973EmUsChFos9CvSLzYeZNynjJgUUejkcXfzH
         3rJi3Ic727w4JZrmQHjfYlBHIMQS0gSALq6CasAhrUsaL4IR09DvnCD5caJKr4kccFLU
         D9gnB38k1gpiFimgFa8rISqmRLBCLcOBZx6fst6SODfQJOLDOamG8FlS3x6oSSQ+d+wG
         DIp6tPozhonHmyMcEwLvIs8qxQu5gJ3Cw4ymtrx370SIO/rEmCNP9HUNWdxhHgdlUWvJ
         nIPA==
X-Gm-Message-State: AOAM531yNrXd8hMZMaTKJYWyV5U6K5arP+2m3Gba5N78bPkuUR5QE2Zs
        v+242i4Hi1D4NxZWn0p4i6BC/P4QLdoWlA==
X-Google-Smtp-Source: ABdhPJzsJtlLoPfKWhigYX8Br0eFJx9G/04IxgbLhmneLsObKGUdjy1mxys1U4RtInLs75uN8XnSrg==
X-Received: by 2002:adf:fb52:: with SMTP id c18mr6839947wrs.186.1611110170873;
        Tue, 19 Jan 2021 18:36:10 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id v20sm1082767wra.19.2021.01.19.18.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:36:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: cleanup iowq cancellation files matching
Date:   Wed, 20 Jan 2021 02:32:24 +0000
Message-Id: <40dbd3122a332596887a0b1390e85a4c128e497d.1611109718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611109718.git.asml.silence@gmail.com>
References: <cover.1611109718.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clean up io_cancel_task_cb() and related io-wq cancellation after
renouncing from files cancellations. No need to drag files anymore, just
pass task directly.

io_match_task() guarantees to not walk through linked request when
files==NULL, so we can also get rid of ugly conditional synchronisation
there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c886ef49920..8d181ef44398 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8850,29 +8850,12 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-struct io_task_cancel {
-	struct task_struct *task;
-	struct files_struct *files;
-};
-
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_task_cancel *cancel = data;
-	bool ret;
-
-	if (cancel->files && (req->flags & REQ_F_LINK_TIMEOUT)) {
-		unsigned long flags;
-		struct io_ring_ctx *ctx = req->ctx;
+	struct task_struct *tsk = data;
 
-		/* protect against races with linked timeouts */
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ret = io_match_task(req, cancel->task, cancel->files);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else {
-		ret = io_match_task(req, cancel->task, cancel->files);
-	}
-	return ret;
+	return io_match_task(req, tsk, NULL);
 }
 
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
@@ -8905,13 +8888,12 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 					    struct task_struct *task)
 {
 	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
 		enum io_wq_cancel cret;
 		bool ret = false;
 
 		if (ctx->io_wq) {
 			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
+					       task, true);
 			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 		}
 
-- 
2.24.0

