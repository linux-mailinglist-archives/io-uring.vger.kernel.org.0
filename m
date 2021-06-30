Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B66B3B89EE
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhF3U5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhF3U5B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:57:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16003C0617A8
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m18so5307797wrv.2
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p1nBbmZ67dyntplqHtIae7f9jZTnieexc/JG3zWZfL8=;
        b=j9RO0eaPBSUiN7rmYpgLwSi7x6YFr7571CE3PJYiQX1Rk1008QQEUgSO/bJgvUTLuP
         5LGraR/j7LW+vE1mc/GhuN+uusfa6jXDzj4pBNmvQHHhanEof+wtMBTb3RMWAnZrsnp3
         JBx4UUePrHoDfH3977pnjsAfuuvZjxcqU/rb6X8QrlZwdLpnOoPdVt768M4qWeNJy8I1
         SkxUCc1Ka2w/55E5SCE6E4+OxscTIrZxM1/iG9ZxZU7dF6bEMLADXfnkAshciTjT11Qu
         a1QEuI9dh/zcyyaG1Mi3DOwJIg/ujj41MJ2zBnJtC66UeJJlV+d2ZxylwOIRu9QPkyFw
         3OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1nBbmZ67dyntplqHtIae7f9jZTnieexc/JG3zWZfL8=;
        b=txVcMPs0bP91WDB//uL353NyUdxdcF+Xjd4m58GJN2x3aOy45a77X8G9UsZANoTNRx
         PfkhtwAegfoRxHsgqJzdJ9cZIF/YIXfxU8GeeE+vxcjeN8oCojyDdZHWXk5HPOG6DOAB
         4Fo/WJvKZyK/yq/VyqeyiM/sfwAZqQ5r+vvBCSh8Ln9CXsq0hw5NexPuknS/7u6mdzdz
         Wxj1sfrKf0l6pDWNh7AC3GF7wK8qatNg2I/xyHBT+ba6LpGLPKJmxatbTHWbR5oZYfJ9
         mcf2qzhaJtob6qF+sZFaAyS9qAzo+rm0SLwEODl6E9Qp6zfbnxZoB95rcsBS0JdRgsiR
         5soQ==
X-Gm-Message-State: AOAM533HtIjrew/4a0dMWZUFR8x8EAXW7eSRRugyvTJGpVZYLrD2HTbk
        7fM06xWhthTpt6y3R5J098mvlIzWC4k8LKks
X-Google-Smtp-Source: ABdhPJydl502I9+yZ+R/9jXN/wIIbuQriXu/1lBmo4v/lzhNP2+rSoIHfJUC0wCYb/1X1uS3cfFavQ==
X-Received: by 2002:a5d:4ac6:: with SMTP id y6mr1527108wrs.347.1625086469778;
        Wed, 30 Jun 2021 13:54:29 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.26])
        by smtp.gmail.com with ESMTPSA id p2sm22099087wro.16.2021.06.30.13.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 13:54:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: tweak io_req_task_work_add
Date:   Wed, 30 Jun 2021 21:54:05 +0100
Message-Id: <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625086418.git.asml.silence@gmail.com>
References: <cover.1625086418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Whenever possible we don't want to fallback a request. task_work_add()
will be fine if the task is exiting, so don't check for PF_EXITING,
there is anyway only a relatively small gap between setting the flag
and doing the final task_work_run().

Also add likely for the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5fab427305e3..1893a4229dbb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1990,9 +1990,6 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	unsigned long flags;
 	int ret = 0;
 
-	if (unlikely(tsk->flags & PF_EXITING))
-		return -ESRCH;
-
 	WARN_ON_ONCE(!tctx);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
@@ -2000,7 +1997,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	/* task_work already pending, we're done */
-	if (test_bit(0, &tctx->task_state) ||
+	if (likely(test_bit(0, &tctx->task_state)) ||
 	    test_and_set_bit(0, &tctx->task_state))
 		return 0;
 
@@ -2011,8 +2008,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	 * will do the job.
 	 */
 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-
-	if (!task_work_add(tsk, &tctx->task_work, notify)) {
+	if (likely(!task_work_add(tsk, &tctx->task_work, notify))) {
 		wake_up_process(tsk);
 		return 0;
 	}
-- 
2.32.0

