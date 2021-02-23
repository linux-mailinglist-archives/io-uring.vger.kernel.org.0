Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82D83223F5
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhBWCA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhBWCA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:00:29 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F51C061786
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:48 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l30so5313720wrb.12
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pv348uAgIpvvKbVWx1cw05eQ7LA36e4h3OGTLN61zdM=;
        b=riyxhxBy82WacyrgMVi2CUXldnddeUR0+bOksG2bfgZ1PbfQWlPwOGZ7zGHloey3kG
         MBITzPz5fROMEGgAPJzgvP14B0vLn7ET97O3azEvc+sIvgShxKU61WzyIkOxwcwY1eZW
         8TiwimFs5OVmAPyGribvbD2kRt5LJgbKJewAKniwGWVAulO739rk+suBhv5NseTnuCXw
         0pySmfqh3PPl0ee6+oe4UZe8sWl1u+1A1jgba5LYgwkrFVYZgmJ5ARkSa9i6bEhZ8jXn
         MtAjg4JEgJVBiS9JGZ2Fp+kmrUTPVUxoNE0WxSZC2mVmYRAolBmRPtt1Ec1eRXpMiuGp
         AWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pv348uAgIpvvKbVWx1cw05eQ7LA36e4h3OGTLN61zdM=;
        b=m7I1pe8haF5dLStLn3eHVSN1qDaaMWuIyINMpIzEvyJZvjo0uO6HQ5z+GPAYr1JPoY
         x907Og5yJVGrn47Y5HYrFV+zNS+loB95tGecCI+pW81PMiKapWiCgSnt9b30cW+NtA/X
         VbRgiwv9EIEEP3UCLGBe3RGlCSnA7xuoClufng9ZSAejZkk4++edtZ01aDhqqPQ7uaJy
         Qaft3vtP59+KziZruxl/yqt76T7Ak2wocgIksidRfZT440YeROh+AgBo4nBRT/+17izW
         6nmgQrHR1ClxiOPjXXgT0DdjTVXCXAe0EBLxd5sIDutQGQh7g+y43IPhR1Ljgnixmwyt
         NYXg==
X-Gm-Message-State: AOAM530gly+437KLzoU3Qrfbo02FcZRxvlZikXmUXJ0WloKtG7Z1GFdO
        HktApAcIr5Frh3hEeisYDoGadxUusZg=
X-Google-Smtp-Source: ABdhPJwIoTkt7k94azjoDaT92pf+t+ro53++IqvzjPJF/pgbo7sWi51dIHSmibU6IHdwN97BZbkrYw==
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr4297303wru.277.1614045587792;
        Mon, 22 Feb 2021 17:59:47 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/13] io_uring: avoid taking ctx refs for task-cancel
Date:   Tue, 23 Feb 2021 01:55:37 +0000
Message-Id: <bba359aab588d4df3433331c71c0801713323fe5.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't bother to take a ctx->refs for io_req_task_cancel() because it
take uring_lock before putting a request, and the context is promised to
stay alive until unlock happens.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e781c064e74..2d66d0afc6c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2010,10 +2010,10 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* ctx is guaranteed to stay alive while we hold uring_lock */
 	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, req->result);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
 }
 
 static void __io_req_task_submit(struct io_kiocb *req)
@@ -2044,14 +2044,12 @@ static void io_req_task_queue(struct io_kiocb *req)
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
 		req->result = -ECANCELED;
-		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	}
 }
 
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	percpu_ref_get(&req->ctx->refs);
 	req->result = ret;
 	req->task_work.func = io_req_task_cancel;
 
-- 
2.24.0

