Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9382C338183
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhCKXeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 18:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCKXdn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 18:33:43 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB65C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:42 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id w11so3768497wrr.10
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=03/BhKPKd2WMgdHLg79p/+l8A8CgJ4LF7Z0M8IhAC9Q=;
        b=eL9k72nJsMUSPah7U+/vVFyDqRN+XaODkG9ZIFfEulW5q2eOP1xDo5ZUQfkP1YTNd3
         ri8v5CG3nb/6fCmCp5G0S84aw/RfBc0RM60kCc/wVBIphEMt5WiwGSHlJEur4etE8eLx
         MsFypKN5K1JPHEIihOrD20yUEMi+ux6GwXsNWknV+sjIpbcu1xiDDAixnaxskz5rwOlM
         jaSuUrfIGq6DU+cW0nTU9IfitGi4uD7H0ipTLbM/9nAp9Jr4Pcj1q7Fubq93nXcyub6M
         itQXVWEmHC2gffErwBCjV4Tr7odVGnhiILrL7isJWu2DJPn3t+6blfzjAJZTxCPQBMmM
         6bOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03/BhKPKd2WMgdHLg79p/+l8A8CgJ4LF7Z0M8IhAC9Q=;
        b=BNcugPt7Ter1aSQdYcsONwWXUJenWml992JBUlYcrLUxLZ2KjWvDtduJAV8DS2nuDY
         gAh35UYpJQjz7aIQR71qmNJglG5+vHmPKslVmbJIrIs7kcDaYpMaGSckeJ8wpvU295El
         qpk+Xcavug7cHzI49tUo+vB3P3ActwSzxaOovrRI8Tn6mccHYZtWoGYVwp1+qeubH+20
         Bo4JjVIjz7G74LPMOV/NMqKW1DxpKhftG0pMfT5UC/Q3KWceWWl6E4acPHtVelAP2sFi
         gSYvEndI87jn8zGJuSkoj0whGaV7KfWqVBLCYmVp075+j4J+OfUL0HyBKZ2b0JvqWm8F
         XsJw==
X-Gm-Message-State: AOAM531D/Y/SDrV9dCiw2wR1tsiQK4C81+CScj28htr0lA2VQLQNL033
        Y5eioVH+rtO5xdu4OFIrHsMr1Gtl/ynICA==
X-Google-Smtp-Source: ABdhPJzAkfyPNvIEVv89AAOHjGj0P1cFjngVe+bDPBPLh4fX5ALkNQlel2/E33v3vrgscEgRdCbBNw==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr11090848wrz.407.1615505621285;
        Thu, 11 Mar 2021 15:33:41 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id m11sm5828062wrz.40.2021.03.11.15.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: cancel deferred requests in try_cancel
Date:   Thu, 11 Mar 2021 23:29:35 +0000
Message-Id: <eec6865904ef898d16bcb2f44e060c9e0e8e321f.1615504663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615504663.git.asml.silence@gmail.com>
References: <cover.1615504663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As io_uring_cancel_files() and others let SQO to run between
io_uring_try_cancel_requests(), SQO may generate new deferred requests,
so it's safer to try to cancel them in it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 49f85f49e1c3..56f3d8f408c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8577,11 +8577,11 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return ret;
 }
 
-static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
-	struct io_defer_entry *de = NULL;
+	struct io_defer_entry *de;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->completion_lock);
@@ -8592,6 +8592,8 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	if (list_empty(&list))
+		return false;
 
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
@@ -8601,6 +8603,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		io_req_complete(de->req, -ECANCELED);
 		kfree(de);
 	}
+	return true;
 }
 
 static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
@@ -8666,6 +8669,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
+		ret |= io_cancel_defer_files(ctx, task, files);
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
@@ -8734,8 +8738,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 			atomic_inc(&task->io_uring->in_idle);
 	}
 
-	io_cancel_defer_files(ctx, task, files);
-
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		io_uring_try_cancel_requests(ctx, task, NULL);
-- 
2.24.0

