Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B2C32F99C
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhCFLHF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhCFLG2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:28 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075F3C061763
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:28 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so859940wml.2
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Uty1uVF8m/Pv3K99djMwSfZF+8WP1EMcRu6igoo4my8=;
        b=U8Ypn6vBE7I206lnJu+1N0gScnZT8lGD9KM4zebonka0gkChWjsFiEYbA+Id/4zPcn
         TChGGy7m//Ry0NtBhorEJIWK4+XALgtpH7wPKYs2cN8j9QE/5omGDHkj7YMoszJRbLdh
         rBknShVo03MKHyR9RaImRFnvjGVmsNJdf0FAKu/DxXG2o10Zz64RfMIjY32EDbqZovIJ
         YrzP3MFg3q0sJaC6+dcn6P4wop+te93fSX4QMzfwfEIm2TyiFyLTZeX4v5rjdCb5YLiw
         ezIGrTfTbzCSzxpUXpW8moa5ev17QbdZbCZDtwp6yzNd9VRttBZ+3rIpgKaOCPmk2SoR
         C9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uty1uVF8m/Pv3K99djMwSfZF+8WP1EMcRu6igoo4my8=;
        b=Gs6qb3Fscsh4pRkIJiEQpGwUqGG5CIZzGqJmHyw9vT3mGnpjHkGd2VO0927qyzIdYf
         cFqw/2oyKwPfsLcbzUjdtg5Axim4IdKeyxk57gHkpYO90UuMwtyj5LhbyVtZxrN2T6Dy
         6lTQo7XX9LkNEABkOiqEscoPBBIjI1hY1cOBa+knOuRptLXFYD0z1FeHwSBikIPDPIxx
         ZCWY28la3ppR0uoQzM8tpnG/KNaEY1nUCL3ZbGOfIqJsmIGNnDCyDxHvfVsTp0mQ/QiW
         2wquwUV12eIgNSYKNgRZtzedbSgJZNeez9RqlzT8n8Ytn1TVPPYhV9A3rly9JxRtEXv7
         /OTA==
X-Gm-Message-State: AOAM531CeZOm4CPfoJB9Wt8VEqJcgyCbHoRB1UMpJ0YLP+ny1EZqHdik
        BG67/5B77XUKy69lWFZmrqc=
X-Google-Smtp-Source: ABdhPJy3n2Ks8w35K4Jd6vgrhgpnbIUmF5dIAd7KeyvuLUo6C1v8zJCCZUZbAlqtmkVYxLIJBJ9F+A==
X-Received: by 2002:a7b:cb99:: with SMTP id m25mr13373788wmi.64.1615028786852;
        Sat, 06 Mar 2021 03:06:26 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 7/8] io_uring: cancel reqs of all iowq's on ring exit
Date:   Sat,  6 Mar 2021 11:02:17 +0000
Message-Id: <a868a2882cbdaef807b209a9b458c915623218ce.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_ring_exit_work() have to cancel all requests, including those staying
in io-wq, however it tries only cancellation of current tctx, which is
NULL. If we've got task==NULL, use the ctx-to-tctx map to go over all
tctx/io-wq and try cancellations on them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4c771df6364..a367e65a2191 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8683,19 +8683,55 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
+static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
+{
+	struct io_tctx_node *node;
+	enum io_wq_cancel cret;
+	bool ret = false;
+
+	mutex_lock(&ctx->uring_lock);
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		/*
+		 * io_wq will stay alive while we hold uring_lock, because it's
+		 * killed after ctx nodes, which requires to take the lock.
+		 */
+		if (!tctx || !tctx->io_wq)
+			continue;
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files)
 {
 	struct io_task_cancel cancel = { .task = task, .files = files, };
-	struct task_struct *tctx_task = task ?: current;
-	struct io_uring_task *tctx = tctx_task->io_uring;
+	struct io_uring_task *tctx = task ? task->io_uring : NULL;
 
 	while (1) {
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		if (tctx && tctx->io_wq) {
+		if (!task) {
+			ret |= io_uring_try_cancel_iowq(ctx);
+		} else if (tctx && tctx->io_wq) {
+			/*
+			 * Cancels requests of all rings, not only @ctx, but
+			 * it's fine as the task is in exit/exec.
+			 */
 			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
 					       &cancel, true);
 			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-- 
2.24.0

