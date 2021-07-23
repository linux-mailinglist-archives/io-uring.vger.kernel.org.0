Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883723D4016
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbhGWRTS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhGWRTS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 13:19:18 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43BAC06175F
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:51 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id n19so3670132ioz.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+iwnoZ+oTW1+Szx+i+nKaEeZuhvYhl0UCpXBK+1EDUQ=;
        b=nua2ovt37jOB2WL1Qoaq9gzc2wu4s/Xa78oBlCtDGvhZQzC4nuydzeSCVy9wEtBjYq
         x8Nzb017RZ4mm4vFdX89l+P6gICnMCbOz9PNVZIbAu07PhuS8TlXkQB3OJRvDOGD00TX
         ZEJYlkEf4vP81rQszfKMD6GrsrNjOxaoSPpMnGgcj8QmTTM9uJLZ/m7ICzR9qm/eflw1
         zP1KpI9WrT4CE/Nz1OnjZJApDkRe/3niTafyK4yhdze/W3F557m8LhcqC+8B8TLHDlgD
         YBIQwcx+O11WSfTkIKmjH2oaZexzClJfQe+nXooXi/IJu0TDNinQxf+KKhUYNhnKYftg
         9tAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+iwnoZ+oTW1+Szx+i+nKaEeZuhvYhl0UCpXBK+1EDUQ=;
        b=af8k/8JtQhcEVPcthXr/4kLeZILHg+cZ0VCDdKwukxr5zU0nCPtN5WyGPvVzixmHVn
         VYi71b83A303R4J5BBXnlUtguPg7ENdjkxtJ/F+9SZLWq2F9e3SR72abSfUKJ/RHWA1P
         /qXFZazEvnrT+TH426SajwYKmjtVEwo72sKWCZSrjOf6JXYRqu6Y3wXJXjY8TmW/3aKu
         C0aNdsGkUAiMrbFkVo3jcSQviuAN3nNdK/euaS1OzMtVfOZh2zRHhFqssUD4wiLruivg
         UeY1/GcAkwza8kWpDIOojccIgExEmSytMbJQG3L714ZdUWALl8gOCFbZiLQqXOURNobr
         UiGw==
X-Gm-Message-State: AOAM531Oj6UQhFHzjfCGJYXCGJ3mu7dC/0gxWe8HLC6Rhv0Jxp9bVR5M
        jcH14F8RznWMMPnVdiLeOyi0F4W/tL964yZ7
X-Google-Smtp-Source: ABdhPJwNrvWhH8IEq/6B+4Orsw8gV+gFBkXKgI2lt9kmcN/W88AtupF1MzlwhbN85lcJcTTj56t39g==
X-Received: by 2002:a02:90d0:: with SMTP id c16mr5090114jag.106.1627063190917;
        Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u13sm17696533iot.29.2021.07.23.10.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: explicitly catch any illegal async queue attempt
Date:   Fri, 23 Jul 2021 11:59:45 -0600
Message-Id: <20210723175945.354481-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210723175945.354481-1-axboe@kernel.dk>
References: <20210723175945.354481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Catch an illegal case to queue async from an unrelated task that got
the ring fd passed to it. This should not be possible to hit, but
better be proactive and catch it explicitly. io-wq is extended to
check for early IO_WQ_WORK_CANCEL being set on a work item as well,
so it can run the request through the normal cancelation path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  7 ++++++-
 fs/io_uring.c | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 843d4a7bcd6e..cf086b01c6c6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -731,7 +731,12 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	int work_flags;
 	unsigned long flags;
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
+	/*
+	 * If io-wq is exiting for this task, or if the request has explicitly
+	 * been marked as one that should not get executed, cancel it here.
+	 */
+	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
+	    (work->flags & IO_WQ_WORK_CANCEL)) {
 		io_run_cancel(work, wqe);
 		return;
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 117dc32eb8a8..4238dc02946d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1294,6 +1294,17 @@ static void io_queue_async_work(struct io_kiocb *req)
 
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
+
+	/*
+	 * Not expected to happen, but if we do have a bug where this _can_
+	 * happen, catch it here and ensure the request is marked as
+	 * canceled. That will make io-wq go through the usual work cancel
+	 * procedure rather than attempt to run this request (or create a new
+	 * worker for it).
+	 */
+	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+		req->work.flags | IO_WQ_WORK_CANCEL;
+
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
 	io_wq_enqueue(tctx->io_wq, &req->work);
-- 
2.32.0

