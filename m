Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B21F0C70
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFGPeU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgFGPeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0649C08C5C3;
        Sun,  7 Jun 2020 08:34:10 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j198so12548290wmj.0;
        Sun, 07 Jun 2020 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2VFniMBWr4YYnHsQG7lbIfuNGaVb+0VDuaYkys35pC4=;
        b=p16z8a/73K+KH7R8jDZH9EOVt7QT5/mLZ9EUfcEUA3muZ/OkIWTk6yXkxyYRREf4Sr
         ldhB6+phOLMQcPiIz0MCUep4ZmGXph8ntI5a8ELypCPTvIx1ZwsGZ2uAhlC0ukSxC9rI
         DhB9E2ySrJjhL0gxBLRJuNxZfRNN0zrT1pe7w77JrXgfMK27uE2OckrLFIFSPza/aVoz
         cULIViBtKkS0tvjvt8Fx9lOITleGKq1uaV/FNkQ+pD2jUP8EuzVT46s4dPoQE8B2nqZx
         eEOvIp9RFqF9kALqCJjcczi0iIkhD3WyVntJvLlIrUg6mnvsBRSH2L2eHPBiruGy7hUh
         81ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2VFniMBWr4YYnHsQG7lbIfuNGaVb+0VDuaYkys35pC4=;
        b=UoSx41JE0o2KW2bU1AifBUk5/9wqJzKKJq5pCBhe7FW6QxDm43fMcJVrDUArW2g841
         2P6DpuXpUsbM+nf4Ps+ls6AAZT4eDx1e1T8qLmqo5HeXmnx+SqodL+uk94I4UE0X/YV4
         4O1KK3mgrkMsmVRTN3W7Ps5VOmVAz3+BSSHUdb/CjL9uyIWzlCWkJGRPeihMJ/DV0jCo
         710VSkqY9i57kguvO/PZo3eBIwkowPyKr1rF7aRvFEHDGk4NoN6sPcuPWztMoR/KVtjs
         qLjL+Gq2fF+mo5gKqznYGCP5mHoSqPezypibxff7klZNWXi7ocabh4usX0/nQoCeumnO
         QxCw==
X-Gm-Message-State: AOAM5302QVM+8bG6nYIdhF+Hh68BmXW/GaIGlr+7PBqYMpoKuRC5eC6l
        uJidCdQosoDx7wJWLjk3J0Rhpb8G
X-Google-Smtp-Source: ABdhPJyHx2JXo85wKiGMezezztt3d9srlpTrbiXeWl/LWJoFBYBHfMkQ0kY4BxC3sULGFxvnUxZi/Q==
X-Received: by 2002:a1c:7515:: with SMTP id o21mr12025038wmc.52.1591544049430;
        Sun, 07 Jun 2020 08:34:09 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: cancel all task's requests on exit
Date:   Sun,  7 Jun 2020 18:32:24 +0300
Message-Id: <13b130e031aaf5eea418bc4be55e1eb03bdaa100.1591541128.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
References: <cover.1591541128.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a process is going away, io_uring_flush() will cancel only 1
request with a matching pid. Cancel all of them

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 14 --------------
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 14 ++++++++++++--
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6d2e8ccc229e..2bfa9117bc28 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1022,20 +1022,6 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
 }
 
-static bool io_wq_pid_match(struct io_wq_work *work, void *data)
-{
-	pid_t pid = (pid_t) (unsigned long) data;
-
-	return work->task_pid == pid;
-}
-
-enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
-{
-	void *data = (void *) (unsigned long) pid;
-
-	return io_wq_cancel_cb(wq, io_wq_pid_match, data, false);
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 8902903831f2..df8a4cd3236d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -129,7 +129,6 @@ static inline bool io_wq_is_hashed(struct io_wq_work *work)
 
 void io_wq_cancel_all(struct io_wq *wq);
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
-enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b0c9a5bcec1..bcfb3b14b888 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7577,6 +7577,13 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static bool io_cancel_pid_cb(struct io_wq_work *work, void *data)
+{
+	pid_t pid = (pid_t) (unsigned long) data;
+
+	return work->task_pid == pid;
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -7586,8 +7593,11 @@ static int io_uring_flush(struct file *file, void *data)
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
+		void *data = (void *) (unsigned long)task_pid_vnr(current);
+
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_pid_cb, data, true);
+	}
 
 	return 0;
 }
-- 
2.24.0

