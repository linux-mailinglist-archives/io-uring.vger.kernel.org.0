Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8373D619518
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKDLDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiKDLCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7799F2C65C
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bj12so12221902ejb.13
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E10mPC6PQtfwv3JsRzakhMmHgVlpBD6yxwSuPka/SgY=;
        b=WCm2gVxjlK91l8Loecf7bj7l1NHvUAtiHfMxLeferarKSRGNwJ15jZfGzDlQykyzDh
         qZdQotRIvK7uEGuZIXWWrwV93rKqi9wHMlg3wGgPllc1dgeX/IuGFknLwpggLmSZuKTR
         XtSv4yVw6FPXH42w3+sWhAMXdaGCFq6EcJQslfNHGQQzKN3ixNxU5HB4WaGFWhnbbSDz
         u1VDe3QKJdEhzj4Lrm9RtBS6Td7UPghB+ItAZHd0CDsP+e1gvP6Y05x+M6W9YbUXXFOv
         bFksJzgARrFnsRMaX8yiYLXi3pPRNRmnFzj68PnUeXyRmS29hS7wpx5lrLpWUBZsTQjI
         G4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E10mPC6PQtfwv3JsRzakhMmHgVlpBD6yxwSuPka/SgY=;
        b=ZvmRmfoi1uoXEqWtrSDicy57V4mQgYmihdBFLur9wAslSAqC1SG8/wmzVM2WxvFYq/
         LfSzmZfx8y6ONqm0tZOJvvFHSkCNEtjabKS54EA0TvzWKUOHM+uoN3/f7UsJQUCKmz8l
         bR7sdjtjea5xcuYjZb2vyTZPbWij7+4VGLkRYQdAZxpf0YfC1Wdcv3025fMq6tLTm28y
         7U68dznrS756hQfVVInA3cF4s7FCGpvrCeGw57ZfU//JmPG9938gUXuC0cHWuoM50DPp
         qelICTXgXWyFchc/GQ2yi1CG8FYfHJm7tkpobj3BN4POmQk2xOjJlWsfFGoIKwWOO9Iz
         Nebw==
X-Gm-Message-State: ACrzQf0QMYAt1lbMwREBgoW/pjFdiLyYXwTl/j8bj0aqOtgUbz3X4iK2
        QN3Jvm89tqBQnrlSmrlD7DUt9w+KQNo=
X-Google-Smtp-Source: AMsMyM4l2Sl2+vbkKweXRHbCSO+umHaBn2k1f0TcmdB+ntissPP4U0t6twimvquVryfKpoEKpDStbQ==
X-Received: by 2002:a17:907:7f92:b0:78d:ed9c:d86f with SMTP id qk18-20020a1709077f9200b0078ded9cd86fmr33254367ejc.251.1667559753684;
        Fri, 04 Nov 2022 04:02:33 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/7] io_uring: move zc reporting from the hot path
Date:   Fri,  4 Nov 2022 10:59:45 +0000
Message-Id: <40de4a6409042478e1f35adc4912e23226cb1b5c.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add custom tw and notif callbacks on top of usual bits also handling zc
reporting. That moves it from the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 22 ++++++++++++++--------
 io_uring/notif.c | 31 +++++++++++++++++++++++++++----
 io_uring/notif.h |  1 +
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0a8cdc5ae7af..556a48bcdbe4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -925,6 +925,9 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 	}
 }
 
+#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
+#define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
+
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -937,11 +940,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_CQE_SKIP)
 		return -EINVAL;
 
-	zc->flags = READ_ONCE(sqe->ioprio);
-	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF |
-			  IORING_SEND_ZC_REPORT_USAGE))
-		return -EINVAL;
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
 		return -ENOMEM;
@@ -949,6 +947,17 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	notif->cqe.res = 0;
 	notif->cqe.flags = IORING_CQE_F_NOTIF;
 	req->flags |= REQ_F_NEED_CLEANUP;
+
+	zc->flags = READ_ONCE(sqe->ioprio);
+	if (unlikely(zc->flags & ~IO_ZC_FLAGS_COMMON)) {
+		if (zc->flags & ~IO_ZC_FLAGS_VALID)
+			return -EINVAL;
+		if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
+			io_notif_set_extended(notif);
+			io_notif_to_data(notif)->zc_report = true;
+		}
+	}
+
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
 
@@ -958,9 +967,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
 		io_req_set_rsrc_node(notif, ctx, 0);
 	}
-	if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
-		io_notif_to_data(notif)->zc_report = true;
-	}
 
 	if (req->opcode == IORING_OP_SEND_ZC) {
 		if (READ_ONCE(sqe->__pad3[0]))
diff --git a/io_uring/notif.c b/io_uring/notif.c
index c287adf24e66..9864bde3e2ef 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,11 +18,17 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 		__io_unaccount_mem(ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
+	io_req_task_complete(notif, locked);
+}
+
+static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
-	io_req_task_complete(notif, locked);
+	__io_notif_complete_tw(notif, locked);
 }
 
 static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
@@ -31,15 +37,33 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
+	if (refcount_dec_and_test(&uarg->refcnt))
+		io_req_task_work_add(notif);
+}
+
+static void io_tx_ubuf_callback_ext(struct sk_buff *skb, struct ubuf_info *uarg,
+			     bool success)
+{
+	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
+
 	if (nd->zc_report) {
 		if (success && !nd->zc_used && skb)
 			WRITE_ONCE(nd->zc_used, true);
 		else if (!success && !nd->zc_copied)
 			WRITE_ONCE(nd->zc_copied, true);
 	}
+	io_tx_ubuf_callback(skb, uarg, success);
+}
 
-	if (refcount_dec_and_test(&uarg->refcnt))
-		io_req_task_work_add(notif);
+void io_notif_set_extended(struct io_kiocb *notif)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
+
+	nd->zc_report = false;
+	nd->zc_used = false;
+	nd->zc_copied = false;
+	notif->io_task_work.func = io_notif_complete_tw_ext;
+	io_notif_to_data(notif)->uarg.callback = io_tx_ubuf_callback_ext;
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -63,7 +87,6 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_tx_ubuf_callback;
-	nd->zc_report = nd->zc_used = nd->zc_copied = false;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 7f00176020d3..c88c800cd89d 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -19,6 +19,7 @@ struct io_notif_data {
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
+void io_notif_set_extended(struct io_kiocb *notif);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
-- 
2.38.0

