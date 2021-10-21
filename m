Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4E436183
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 14:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhJUMWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 08:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhJUMWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 08:22:54 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55313C06161C
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 05:20:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v17so747519wrv.9
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 05:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QZ8fn7KJ3p5wKNqZyikr39JUFic1IVA3jWZquM4XzY=;
        b=KSQrbzmtFXdg6gwS+khPFQzs3YV7Iqrqk5THlL5CvGW0zfAnlCpSWeY/0iFDdCPKOV
         bDDsK8tP5UUVOBk/vek5S1IbhxTCeWJlWnDmpklF7ULKeyG2zBO3F4rtro5WBeP2FRQc
         fTPIMZsgPDgDUNxvI7yzvkxUiyrr1GPg2+hcDmhqt0v/gnyfasPtjxmujnnXFg58HilG
         ATfDxqtJ9ifQsk4L/HWn3x3Cqf+WIt8fe31vIU1QHLAruZBn0DdSBifvfu36HvAjh2qP
         JgsB48RSYe/kVJDfeVQoS0mNjeI9rBgV2WgHlbxTkqdz5gvVM6VbQtw2E242kT/oTxYt
         kuzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QZ8fn7KJ3p5wKNqZyikr39JUFic1IVA3jWZquM4XzY=;
        b=LZ+9k6gyvYtt62T+jUgMjHhEyZ5HpbZlKiupXIuFBUUA1fiujnW/+qajLNK56t58qe
         h3DWyv5lOVMltxsu3cSpgnT1BCgLkWUS7hdlrd+vKWZFH6JYJr+UiL+C9sO8FypHOkwo
         DDUbxUcF7BSKD4z4HdMeNe8VxqN+C++WWcaLtBfUw8MMk8s7ViXGsqrv+EBgtkBJpoAq
         H28DSOOj/Q3Dc0qA7yPujz3wALsdQ85TRaJuKE2fWRZD6/hS9LSDoflAzUKS4kSdvttc
         bsmpuoGxUqxbn7xajdSnHvC4KzNTc368cehYTAH+9myQyuefAJ+WbsRRglH/eG8x80AF
         xywQ==
X-Gm-Message-State: AOAM530f7NktxEZxWWoOM0qFJe04s4oqAb0uvLBPjuws/cxEfNCpHcJm
        I1SBKFE5hMfFJWpg+daplKTlcx7TDeEA4A==
X-Google-Smtp-Source: ABdhPJw5NJkUe5cmaK1yu4LWzFDQfH/t5N+8OdOwFDjvcb+WL363KrmmRjJNrICQMMZbx9tALgbKkg==
X-Received: by 2002:a5d:528b:: with SMTP id c11mr6882838wrv.35.1634818836776;
        Thu, 21 Oct 2021 05:20:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.206])
        by smtp.gmail.com with ESMTPSA id l2sm4757627wrw.42.2021.10.21.05.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 05:20:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15] io_uring: apply worker limits to previous users
Date:   Thu, 21 Oct 2021 13:20:29 +0100
Message-Id: <d6e09ecc3545e4dc56e43c906ee3d71b7ae21bed.1634818641.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Another change to the API io-wq worker limitation API added in 5.15,
apply the limit to all prior users that already registered a tctx. It
may be confusing as it's now, in particular the change covers the
following 2 cases:

TASK1                   | TASK2
_________________________________________________
ring = create()         |
                        | limit_iowq_workers()
*not limited*           |

TASK1                   | TASK2
_________________________________________________
ring = create()         |
                        | issue_requests()
limit_iowq_workers()    |
                        | *not limited*

A note on locking, it's safe to traverse ->tctx_list as we hold
->uring_lock, but do that after dropping sqd->lock to avoid possible
problems. It's also safe to access tctx->io_wq there because tasks
kill it only after removing themselves from tctx_list, see
io_uring_cancel_generic() -> io_uring_clean_tctx()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5cc103224f1..bc18af5e0a93 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10649,7 +10649,9 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 
 static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 					void __user *arg)
+	__must_hold(&ctx->uring_lock)
 {
+	struct io_tctx_node *node;
 	struct io_uring_task *tctx = NULL;
 	struct io_sq_data *sqd = NULL;
 	__u32 new_count[2];
@@ -10702,6 +10704,22 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
 		return -EFAULT;
 
+	/* that's it for SQPOLL, only the SQPOLL task creates requests */
+	if (sqd)
+		return 0;
+
+	/* now propagate the restriction to all registered users */
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		if (WARN_ON_ONCE(!tctx->io_wq))
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(new_count); i++)
+			new_count[i] = ctx->iowq_limits[i];
+		/* ignore errors, it always returns zero anyway */
+		(void)io_wq_max_workers(tctx->io_wq, new_count);
+	}
 	return 0;
 err:
 	if (sqd) {
-- 
2.33.1

