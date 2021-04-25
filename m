Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F39436A78D
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhDYNd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDYNd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB700C061756
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:42 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p10-20020a1c544a0000b02901387e17700fso3631012wmi.2
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GwkFN2g8DmcJNTfhLZk+elQbf9tzR3YlitRDOo789uY=;
        b=tY5PoCd9sQRprBAb/1x6LGM0xWzCU2bZbbPVRfrvlP3XMEjugoe2vPnu3EzmaHrZ4N
         9msMTJyjHWbuHRraZQwtRDI2hkuz+cmJWcvX6d2AFskm2f+95tMUP/XQTUg2J9hxsun4
         Ahr5+EbqqE2GubpCC/+k9PUq7+CprVvTfqRQqGOXkDHoCjGNxrUZIicwoqw/lpjEK/nN
         lTCwXPGZvwHQPV8bo4KWXihIaXaeUl5ZxZ9kPPZfsi+L96FzPryPAJfdcSiUJAXHnTab
         Hv82FEv9UKBT7PaUUX5L0E6ueuDsB8rBuz8FXPhwYIF1FBe9juO8ieQP9G5yaiDqQCHx
         3J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwkFN2g8DmcJNTfhLZk+elQbf9tzR3YlitRDOo789uY=;
        b=E/y2MeGCxlLyBzErMSS/k8h6+3xh5uGAfua4YjvhDaEz8msLLh0cHYZIhxSzK25e/L
         IGbGT4Igief2iZwqu+aq+uE6t5pViYdzmdaof1vXg1/0K6HjCQ1ORFcJDPCfTzPAGeYu
         X/H+XeE+DPl/gApZGGBWfQjE4nOHDAGQMTSUihh2cBgu+H0MODtsmMml197L83mYuiR7
         UWKNa54/hC38VBC/rd8PaqK4i4vy6+FlBIxJyENrDYoPzT0cWtZqfkhK1At3dvJq2APC
         mbmTvepbSZbuecIQ5oQhal7ePAjLli96JsUmlhqoEXP9nP4dJPYal/mis3Mj4nGW+vWK
         RrEw==
X-Gm-Message-State: AOAM530r2+PODeK8KwDSlc8L5pq/oyKYj4Qi1LL4hZWa8u2QjnhZa4Qn
        PQmv9XLvZ8vnsM46oaedM/U=
X-Google-Smtp-Source: ABdhPJxO1hyR6fcumWLY4T25bYD5RFvPLeQiGHbH2y3e8W9tVkKutqE1J2ca7auwB14LAp90Mlp3kg==
X-Received: by 2002:a05:600c:35cc:: with SMTP id r12mr15965282wmq.147.1619357561573;
        Sun, 25 Apr 2021 06:32:41 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 06/12] io_uring: enumerate dynamic resources
Date:   Sun, 25 Apr 2021 14:32:20 +0100
Message-Id: <f0be63e9310212d5601d36277c2946ff7a040485.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As resources are getting more support and common parts, it'll be more
convenient to index resources and use it for indexing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 16 ++++++++--------
 include/uapi/linux/io_uring.h |  4 ++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f79bb0362cd..cfd5164952e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1035,7 +1035,7 @@ static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update *up,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
@@ -5818,7 +5818,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_register_rsrc_update(ctx, IORING_REGISTER_FILES_UPDATE,
+	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
@@ -9666,7 +9666,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update *up,
 				     unsigned nr_args)
 {
@@ -9679,14 +9679,14 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
 	if (err)
 		return err;
 
-	switch (opcode) {
-	case IORING_REGISTER_FILES_UPDATE:
+	switch (type) {
+	case IORING_RSRC_FILE:
 		return __io_sqe_files_update(ctx, up, nr_args);
 	}
 	return -EINVAL;
 }
 
-static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				   void __user *arg, unsigned nr_args)
 {
 	struct io_uring_rsrc_update up;
@@ -9697,7 +9697,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
 		return -EFAULT;
 	if (up.resv)
 		return -EINVAL;
-	return __io_register_rsrc_update(ctx, opcode, &up, nr_args);
+	return __io_register_rsrc_update(ctx, type, &up, nr_args);
 }
 
 static bool io_register_op_must_quiesce(int op)
@@ -9790,7 +9790,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_register_rsrc_update(ctx, opcode, arg, nr_args);
+		ret = io_register_rsrc_update(ctx, IORING_RSRC_FILE, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
 	case IORING_REGISTER_EVENTFD_ASYNC:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5beaa6bbc6db..d363e0c4fd21 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -316,6 +316,10 @@ struct io_uring_rsrc_update {
 	__aligned_u64 data;
 };
 
+enum {
+	IORING_RSRC_FILE		= 0,
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.31.1

