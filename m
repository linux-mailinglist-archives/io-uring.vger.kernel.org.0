Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A7362539
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhDPQKv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhDPQKv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 12:10:51 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D64C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:25 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l19so19650231ilk.13
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUgvBqmzJHyygWcp0YuQV59j+VpE+d2wu22XtmQv7VM=;
        b=o2gkQ7LHwmd8WB8mIhqQMq/kT1jiteOr3Rg+1INNyLsZn6kjmW+y8CxRkCHfEBXsy4
         TVLnnHkhaEsDyUofTjXuZ4ZDGfZwI1FABEadKBPHBYfj1oqUU65UXop986jksFl0eBZQ
         0XY5AAh1U2djO+mk+OS7o2l0t6Ik3V+9xHd6jS8GtqrWXCse3HFSSsa9vcr2ta56fjr2
         ET3hKMoI3/t1yMnyIUaowFrsKcZ0DQ/bD4NTnx9RtRYOxVrg96638FvECpQX4c3K8t2j
         AHmdDhxudve7lmB3tHCZX0BcbsA6c0TDJL3jXKjJ9cmEHK4R2yx/1c+Owe3mvInuz1b3
         5pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUgvBqmzJHyygWcp0YuQV59j+VpE+d2wu22XtmQv7VM=;
        b=oTlRx7kGdD7neDx4MjQJtorsECtjMxGeNkrvn+El4oI/hVBAmDvkzx26zqN64m/EGG
         KU9X8k243HzE1YSgJ7xf8auFeg/fp/rN8ZB0NJxqzXGcBCBIo6WA035kyf5JQ6XCATDH
         b/MQYnqrMHwp9ZskTq7cH0eWXNHQydgaKAjQvrK4B/5lUSTqfirCGZwW8/wd8610zVPL
         iJaRnqIrLuWfDSFODirdP6l5rc4QD1AaC7Dn0MlzvgZn9YbbaEdVJR+odVvchucJqjqg
         9iOIINIZhDOy0AMcaTeVyBom28p3zhVS6836YHZGF5/BYY4LwVq2/NdT16YnJ1DsDvmZ
         E0gQ==
X-Gm-Message-State: AOAM531Z7+EroYKRKOdsTke0NDpcVKdajWQAH9UdzPJneqp5z6WP3xp0
        v/xnGvzCWAv3B+cWEJr7b6fOTO1nm1iQFA==
X-Google-Smtp-Source: ABdhPJyOrBkQevKtC+bDDvn07vtmVGPV+MUVZTzoflwvLQ84214/M4DrpYFYTMbLm6cKewBfxvfbmQ==
X-Received: by 2002:a05:6e02:16cf:: with SMTP id 15mr6951803ilx.199.1618589423653;
        Fri, 16 Apr 2021 09:10:23 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f13sm3024641ila.62.2021.04.16.09.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 09:10:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: tie req->apoll to request lifetime
Date:   Fri, 16 Apr 2021 10:10:18 -0600
Message-Id: <20210416161018.879915-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416161018.879915-1-axboe@kernel.dk>
References: <20210416161018.879915-1-axboe@kernel.dk>
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
index 8e6dcb69f3e9..10b2367138be 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1600,7 +1600,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 
 static inline bool io_req_needs_clean(struct io_kiocb *req)
 {
-	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP);
+	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP |
+				REQ_F_POLLED);
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -5038,9 +5039,6 @@ static void io_async_task_func(struct callback_head *cb)
 		__io_req_task_submit(req);
 	else
 		io_req_complete_failed(req, -ECANCELED);
-
-	kfree(apoll->double_poll);
-	kfree(apoll);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -5156,8 +5154,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret || ipt.error) {
 		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		kfree(apoll->double_poll);
-		kfree(apoll);
 		return false;
 	}
 	spin_unlock_irq(&ctx->completion_lock);
@@ -5195,12 +5191,8 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req)
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
@@ -6054,6 +6046,11 @@ static void io_clean_op(struct io_kiocb *req)
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

