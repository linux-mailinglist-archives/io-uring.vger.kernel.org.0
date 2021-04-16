Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05AD36172D
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 03:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhDPBZ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 21:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbhDPBZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 21:25:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C11DC061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so5600724pjb.1
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZDMw16QNL69eqcpSAp1ywF+mAru9er6dptRWksQ9rg=;
        b=apRkugxS7gqL3sjS5nBcK43bsI4SU8BpeMs9q735mUgsTJfbtvkxW+wibHgih8QTya
         t3fXSHEScHF6oGS58YnEkhfvHmgm2Uy1dASW/EqIvaPvxnYgKW+SANT5Nxl4cxK5eHMa
         hNYH5LNUxnDeRm2FQXJJVqNUIUJltOgv1V3IgE962zppLHtZzpEz0EDX9MFSuuYspTCz
         /yaaL6FnZZbTVO/Oy7spC/amI0W9YuXc/KxJ3xImr2QU9KBAX+MQ8c3KXvk0xEjYHyM9
         b5spZ2adtdZWLJUA3b75uWjNVniCkmu+RCiOCCZlvdf2UTVXYvc1XSjxYHZbT2WeOfUS
         rPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZDMw16QNL69eqcpSAp1ywF+mAru9er6dptRWksQ9rg=;
        b=IMBHQxdDhafDlyXNHjALysOws3/CuFpH+83H+yK/hU1Tk91s2kBkG7NJMH9Sfdh9ZI
         DsJmNfOBTs2TJHeh2PXMvBsCVcyOUUC/HuDGGRI4XzHRoLYfLOkJ+GXj4dwCmpMrsB6K
         w7jBMCMYF65rIBF/VfSvQiVpLu0ZxyBCYUxJNqQxEOzpksDJ/nOsLs+j7D3K0PWLGH6Z
         zW6740OgPx3k7i3xuJluKTyMlls3pU8S4afjlMj5W41RmbZcBhNAFhIAjIgMLuOke0zp
         z/fcniJQDEmIcG/DPe1whoxTGgFQ+FLJRzC2Up1WG7aFo+xsgsTnX66b7s3pWuznqW+w
         y3gA==
X-Gm-Message-State: AOAM533F/UigWxuxY4MwyBeEzwJb6u9U5tbUY7GftqYCjkbfaSWXQjFc
        1kfDnzUXRzbB2No/bGpjaKAOep8PQwNGMA==
X-Google-Smtp-Source: ABdhPJxpM3qOFYT7j61pBeKygfemmUnv0IDwmTqCXa+VL+iFLs09Ta7Oqsu2R/LVWvuFwLI7/b5j9Q==
X-Received: by 2002:a17:90b:4a4c:: with SMTP id lb12mr6954748pjb.133.1618536330466;
        Thu, 15 Apr 2021 18:25:30 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm3502039pji.40.2021.04.15.18.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 18:25:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: tie req->apoll to request lifetime
Date:   Thu, 15 Apr 2021 19:25:23 -0600
Message-Id: <20210416012523.724073-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416012523.724073-1-axboe@kernel.dk>
References: <20210416012523.724073-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We manage these separately right now, just tie it to the request lifetime
and make it be part of the usual REQ_F_NEED_CLEANUP logic.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a668d6a3319c..2ea909ed2f49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5029,9 +5029,6 @@ static void io_async_task_func(struct callback_head *cb)
 		__io_req_task_submit(req);
 	else
 		io_req_complete_failed(req, -ECANCELED);
-
-	kfree(apoll->double_poll);
-	kfree(apoll);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -5147,8 +5144,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret || ipt.error) {
 		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		kfree(apoll->double_poll);
-		kfree(apoll);
 		return false;
 	}
 	spin_unlock_irq(&ctx->completion_lock);
@@ -5186,12 +5181,8 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req)
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
 	if (req->opcode != IORING_OP_POLL_ADD && do_complete) {
-		struct async_poll *apoll = req->apoll;
-
 		/* non-poll requests have submit ref still */
 		req_ref_put(req);
-		kfree(apoll->double_poll);
-		kfree(apoll);
 	}
 	return do_complete;
 }
@@ -5990,7 +5981,8 @@ static int io_req_defer(struct io_kiocb *req)
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP |
+			    REQ_F_POLLED)))
 		return;
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		switch (req->opcode) {
@@ -6047,6 +6039,11 @@ static void io_clean_op(struct io_kiocb *req)
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
+	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+		kfree(req->apoll->double_poll);
+		kfree(req->apoll);
+		req->apoll = NULL;
+	}
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.31.1

