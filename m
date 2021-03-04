Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4466E32D9C3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCDS5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhCDS5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEA4C061756
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:27 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f12so25033650wrx.8
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vZfT3zD8StUYAuWA/a/eMUpWThYuq7am0eVnPH9rP2Y=;
        b=B9ugmlsS7r5hMJRTGi0FddPfSl2cf4AJWnPJ3Ws9xyPkBQLdbUOTjrYTDCvNolOCf7
         Xq7ciETKClr+QnBoSdaZ1qcATLVvudcgeZ5lkwjVuCkimkID5v1ADmqTgg1Dy7zsuFWl
         oULgTaN3hNES9KbRNa0Zd7/hpLqeMGlUahCnZkH3jOGKnJJPTLO8fg3AKi8T/tCwni5p
         iTprBSkBVhV8FUal8XcnW+2vVxdNYeN1OTz5kU00wnGruERxJYKsQjNhrh0Q6yAHFtV9
         HW79b6BlqKffIRvSkC4SAYFWIpREHB1kuUhoeXipSP0ETBKI+bepPQ9HrPahASzPOQCm
         ZVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZfT3zD8StUYAuWA/a/eMUpWThYuq7am0eVnPH9rP2Y=;
        b=Ks45lvwfkkcb5JZtzoRBK1kYDmHEauC8k8+pEV2391FWxg1CZVE7MJxJB5A81kkQo/
         CUJn0PxIRmdrBCi0qzjLJwBP1Y23/GpkwHbxPuvEtA3/LKzyh2uwomR0soNIlqIYEc1Z
         2Kh9iNm+uQO4d9OVaA1DQO6p0nVaQdRub4H/AFV27xLfMe6H6QxU+DQUnnN8iMKe8mV3
         pPdMXgwmMZzY2GLPmlSQFWfe8kyQfNmHgymM0P5+LYwhFLI8u1cDsiQv41bP2fLstvJE
         PgE4JcfFdvOoDhe4gFed9pLEuj9AsOsgHR+FRfMVOm3ZUloNCZjLinfGDppnAEAnJD78
         ifZg==
X-Gm-Message-State: AOAM5309n6Ozqa40qzhxIXVwnHfkNLHQ7ulSUz3KstpyLWmn2Q6eIeN9
        1MKWaedapcj5XtbjbFDY47w=
X-Google-Smtp-Source: ABdhPJwV4eah2kbUvfyKStAdaus6Nv6SQki09ZoTflgV/YYTnLv93hfJCtPUvnqjdWaqV6R/OEJg8w==
X-Received: by 2002:a5d:698d:: with SMTP id g13mr5764462wru.2.1614884186633;
        Thu, 04 Mar 2021 10:56:26 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/11] io_uring: don't take ctx refs in task_work handler
Date:   Thu,  4 Mar 2021 18:52:15 +0000
Message-Id: <22cf580b18bfc5481f7ac8f17b2f4a1e7c08e8aa.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__tctx_task_work() guarantees that ctx won't be killed while running
task_works, so we can remove now unnecessary ctx pinning for internally
armed polling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3cfc50320923..36d0bc506be4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4780,7 +4780,6 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	req->result = mask;
 	req->task_work.func = func;
-	percpu_ref_get(&req->ctx->refs);
 
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
@@ -4877,8 +4876,6 @@ static void io_poll_task_func(struct callback_head *cb)
 		if (nxt)
 			__io_req_task_submit(nxt);
 	}
-
-	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4985,7 +4982,6 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
-		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -5001,7 +4997,6 @@ static void io_async_task_func(struct callback_head *cb)
 	else
 		__io_req_task_cancel(req, -ECANCELED);
 
-	percpu_ref_put(&ctx->refs);
 	kfree(apoll->double_poll);
 	kfree(apoll);
 }
-- 
2.24.0

