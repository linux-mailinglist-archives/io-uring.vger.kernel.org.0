Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDC86D97EA
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbjDFNVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238263AbjDFNU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68493EA;
        Thu,  6 Apr 2023 06:20:26 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-4fa3ca4090fso1302502a12.3;
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xie9XCgTu7FI1l5nk9+NmrYSBfE45KwR9N84Pl/XEno=;
        b=pFyiffwvrKrL+a8mRQ0WHHlDdErDsDHxBH2WvrPhqvMx4xeIDEy54bMPIGaNhTh5sl
         9HcBDYDAR7zFEIf1JVYoPBKsshPGnGDKFPe4zo6sLUV87yOuYvs0H22N05EZAxZBcHaY
         lkfpTaKYz6RIG0YbDSWq8f9gDlm78HPT9gyj6D/mhy20A17rqbF/YSHhVI1x4u1bHdce
         RoaPBPMVo7Z+IGtZaqXrwhJhubtmSIYbFDSCLIUmNL+bL/szHyjdbw3GRGlKxE3sqH1H
         5OEF9g6pONaI6J2C5rKCQRWdJphEazXBrXzmFtTWLA6Ac6+NGHWZ8YA8cU2tXmiyxn6L
         C+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xie9XCgTu7FI1l5nk9+NmrYSBfE45KwR9N84Pl/XEno=;
        b=13dh6d/CKxHeTXbSyf6M0eezAc31HoK0tF8e27sGM3JidOQJlOqScYCGtflZSZcuqy
         c4vt6YS8BgEUjWm4g0pXrY1atX6MGM4mUPkRpf/QAlbjdTOCCDHgw4LUVwsWHTpNzbFJ
         sTrz2fYBF4zqRDDi7XtSjIQhuzbu2jNSEpnwc/Pcaxo+cPCDlJPgr6bTQ4m0jOajdOFn
         +PxKTEovKahlTNhqm3tI3vnmX1DsXOuAqj1KKXhTNeHbnj83Q6NuYazznUPgM03+ix50
         5jd+U2hpQTLHArvcOCK90GXiIrHCQwmrh8q8WNDCAyP3Yti5nDvovU0kO8OhJpK2Aj8+
         EDpg==
X-Gm-Message-State: AAQBX9foQpqnd4MTBiMXljOnUPTjOIo7vy7LMFtVb30nRLV3fCNK7Cr2
        mWgUSCaercFg5nPKgOl9StYSNzAlqwc=
X-Google-Smtp-Source: AKy350Z5bkIsq104YEcLm+j7qXTvqy1TDkoQzweZbfy3Qy8NrmTDp8LKjx5PGJ53BxqjJN1vsqpmPQ==
X-Received: by 2002:aa7:d152:0:b0:502:2265:8417 with SMTP id r18-20020aa7d152000000b0050222658417mr5065901edo.17.1680787225176;
        Thu, 06 Apr 2023 06:20:25 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] io_uring: add tw add flags
Date:   Thu,  6 Apr 2023 14:20:10 +0100
Message-Id: <4c0f01e7ef4e6feebfb199093cc995af7a19befa.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass 'allow_local' into io_req_task_work_add() but will need more
flags. Replace it with a flags bit field and name this allow_local
flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 ++++---
 io_uring/io_uring.h | 9 +++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d4ac62de2113..6f175fe682e4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1324,12 +1324,13 @@ static void io_req_local_work_add(struct io_kiocb *req)
 		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+	if (!(flags & IOU_F_TWQ_FORCE_NORMAL) &&
+	    (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
 		rcu_read_lock();
 		io_req_local_work_add(req);
 		rcu_read_unlock();
@@ -1359,7 +1360,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 						    io_task_work.node);
 
 		node = node->next;
-		__io_req_task_work_add(req, false);
+		__io_req_task_work_add(req, IOU_F_TWQ_FORCE_NORMAL);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 24d8196bbca3..cb4309a2acdc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,6 +15,11 @@
 #include <trace/events/io_uring.h>
 #endif
 
+enum {
+	/* don't use deferred task_work */
+	IOU_F_TWQ_FORCE_NORMAL			= 1,
+};
+
 enum {
 	IOU_OK			= 0,
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
@@ -48,7 +53,7 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
+void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
@@ -93,7 +98,7 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
-	__io_req_task_work_add(req, true);
+	__io_req_task_work_add(req, 0);
 }
 
 #define io_for_each_link(pos, head) \
-- 
2.40.0

