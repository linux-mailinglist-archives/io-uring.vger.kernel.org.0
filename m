Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3322A969D
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgKFNDp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbgKFNDo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:44 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B1BC0613D3
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:44 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id s13so1265391wmh.4
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p13foSmAu1Vz3FXw2gUXpZ8K266ZAxOO9CNLJpunk/4=;
        b=TW55VVIDXkq6fNIg8wMtcC8OFOgak3o2jyzZlFMKfD5VjaaHBjouDkVhkOAW0N2MCV
         j3mI1T2TZdzud4G9+jER/xrGS2h1I9xgybhl+0O+jqO4H9Y2sIDa0RO3X7BFxAipY88/
         1rC8ttKi6MHmw8XJyi80Z3x8iZ8GgzJdaUTXSDd+qeSHV+8o3Js6CEJjaURQeZABPHEy
         biMRrO8ceRCtu8F4A2CA3YnXOcG61CduBT+aLZc2bLLq3uY0OSPbU8G6T3d3RL/azkA/
         S/hb6D8OTfQeTPGLze6Rwai321kdbXBmneQXCU/rtJxQycrRkiM7hQdk7OeXkoIrYJR0
         n72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p13foSmAu1Vz3FXw2gUXpZ8K266ZAxOO9CNLJpunk/4=;
        b=RE7cs+bPgdMdFWZ5ef5DpMlYHQw2PcffJTUzZ9lV9VCdvg9zN64krZxG/Zcg0QI8GQ
         4DVwOKXFadNm3Ui0bG0Yu3B+UwxoPtATxXbBsPWYyRCHZ5R9VGtLRphbL/THIx3qVfRk
         1XxIjI07tGZZy5QsM0HZlb1gLbaRhpoiuEVP5lpmnyWuVVM8dh8e9Na/aBLhs+JivDs5
         pmEmaChkEnKiLyBqMmwjvhJY47XA2cK13dE+CLfHTIP6uNZY7xKGsRFw7n4R9iXy/bf6
         fcLxie8P124w7X/DX9+D9PowOT+3CgnW/lIO70mpcGIvQOfi48bBZpj1Fpy5CBmi5RJC
         jpog==
X-Gm-Message-State: AOAM5332JUyFhaQhI3M1xP1B+ItUxtncozCoWh0f0k8BPHVco/KsWd1n
        YOaD5MZVohtZJLYSZLabtkIuoXvofLQ=
X-Google-Smtp-Source: ABdhPJyTiZS6Pk2HTHz94bj1EPW080Ws5UQhXKCldHK4R4A5C3YLiXgQOALQ5bs32gBenE2PYLVmSQ==
X-Received: by 2002:a1c:b746:: with SMTP id h67mr2334443wmf.43.1604667822873;
        Fri, 06 Nov 2020 05:03:42 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: cancel only requests of current task
Date:   Fri,  6 Nov 2020 13:00:23 +0000
Message-Id: <810b7400938d6b24eae3c94d1d75eafb71536461.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cancel_files() cancels all request that match files regardless
of task. There is no real need in that, cancel only requests of the
specified task. That also handles SQPOLL case as it already changes task
to it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14e671c909ed..8716a864b8b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8654,14 +8654,6 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static bool io_wq_files_match(struct io_wq_work *work, void *data)
-{
-	struct files_struct *files = data;
-
-	return !files || ((work->flags & IO_WQ_WORK_FILES) &&
-				work->identity->files == files);
-}
-
 /*
  * Returns true if 'preq' is the link parent of 'req'
  */
@@ -8794,21 +8786,20 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
  * Returns true if we found and killed one or more files pinning requests
  */
 static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
 		return false;
 
-	/* cancel all at once, should be faster than doing it one by one*/
-	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (files && (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task == task &&
+			    (req->work.flags & IO_WQ_WORK_FILES) &&
 			    req->work.identity->files != files)
 				continue;
 			/* req is being completed, ignore */
@@ -8851,7 +8842,7 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 {
 	bool ret;
 
-	ret = io_uring_cancel_files(ctx, files);
+	ret = io_uring_cancel_files(ctx, task, files);
 	if (!files) {
 		enum io_wq_cancel cret;
 
@@ -8890,11 +8881,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
-	if (files)
-		io_cancel_defer_files(ctx, NULL, files);
-	else
-		io_cancel_defer_files(ctx, task, NULL);
-
+	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-- 
2.24.0

