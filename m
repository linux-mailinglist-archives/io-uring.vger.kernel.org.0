Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499C6209C07
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 11:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390360AbgFYJjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 05:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390350AbgFYJjx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 05:39:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1311FC061573;
        Thu, 25 Jun 2020 02:39:53 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so5226008wmo.1;
        Thu, 25 Jun 2020 02:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/68m/0qX3Mydm4zAirYJHeFbtGle4A8tT80zVLI5GE0=;
        b=W6Tu4K49fBDXt6lNb6gEA7Vxktia+sKAQ9RryHAMp6+7g4fmS8tHf625/rD8h7XbHC
         p5CNP74hc9fcVzuTou9/AOgKTwBWzB5unjjBNDw4p8LQNAzHbXHZAyruoZiW7lGkEz9t
         OYhfzy/PB4z/Cn/Sk4UDuwNYnLVa8UjI8q7bdZv3tSSGPUWn7p9CezyLn4J4vVZYtR2o
         fzCK/zAMFKN7eRjaI6WSoOyCh80BpsLpbLkqgp8Pb+DVDNTfS7T1cYPcUaOPs6/aWUCf
         v+EVx8hRfWgAq3QeQu2ZkF/NzIdmk3pXO8uCmE67/sVydndb1WvBJW7qGmMkh0Yy/uYt
         4K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/68m/0qX3Mydm4zAirYJHeFbtGle4A8tT80zVLI5GE0=;
        b=d4WiYBc1fEVQKVO9VoS6lKGz1ZZj5O5Z37fYjT+yAsSuZ0LmyiQ47jAgqeIL7fzRKQ
         Gxl8prFo70se9pnKR9l15fEPNnqqFr2B//Og9PFdrIUe0NVDB+d2YzBY/hZOWeBTOi8E
         H8/enpoM/mvNkFVp1VZxMRPcbhSdWZzTpYT78954CGWE29m1rZEapRQIBOi5eP63+PXu
         6cXdGWze/jZWMPkoLgWjWg/s4psIrWz/BM/rIF1g3x5rqqtlUIQLzjFo+eAtyv5W0Smj
         tEcE4t+mo18PRKGVSPFRwd4uDkuTxS5Qga2hj19V8wE0MqlQFSzOxyQP04TY/UNCjnlg
         dFBQ==
X-Gm-Message-State: AOAM533THS9l5Or0tafb6ZQVnMKGTL/jVGDxWAXCn3zMqxXlWpTniVCn
        2aQI63xCK08nY5PU5+4KsKGUa3Gx
X-Google-Smtp-Source: ABdhPJyr8FiAdJvetYzrq4xlC+YM/a+xqqTkr03TpYx80zetWAHOdfJ39yR/G3uNS9pjXAlNKqEYnQ==
X-Received: by 2002:a1c:790c:: with SMTP id l12mr2356499wme.50.1593077991751;
        Thu, 25 Jun 2020 02:39:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id g16sm26858895wrh.91.2020.06.25.02.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:39:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.9] io_uring: fix NULL-mm for linked reqs
Date:   Thu, 25 Jun 2020 12:38:13 +0300
Message-Id: <f7d8272bcf142fe2c11c85ecd86f7f75f6e48316.1593077850.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_sqe() tries to handle all request of a link,
so it's not enough to grab mm in io_sq_thread_acquire_mm()
based just on the head.

Don't check req->needs_mm and do it always.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21bc86670c56..e7b1e696fecd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2000,10 +2000,9 @@ static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
 	}
 }
 
-static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
+static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+	if (!current->mm) {
 		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
@@ -2012,6 +2011,14 @@ static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (!io_op_defs[req->opcode].needs_mm)
+		return 0;
+	return __io_sq_thread_acquire_mm(ctx);
+}
+
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req, int error)
 {
@@ -2788,7 +2795,7 @@ static void io_async_buf_retry(struct callback_head *cb)
 	ctx = req->ctx;
 
 	__set_current_state(TASK_RUNNING);
-	if (!io_sq_thread_acquire_mm(ctx, req)) {
+	if (!__io_sq_thread_acquire_mm(ctx)) {
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

