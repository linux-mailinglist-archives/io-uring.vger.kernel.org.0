Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223BE3223FE
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhBWCBO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhBWCBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:12 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC2C0617AB
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:00:00 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h98so16185781wrh.11
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+mJcsavnSmdsYaM5SEkNfFvnWebgPAUYa5/l0YqpUrI=;
        b=PlMiZRZ35xRCQH7QfreK06yIgEMSBNTzT6xuz4+xf50/SVJushauKocHArrxfCHTlA
         gmUNRBNGwHmod+T0XKQhoWP7pkLMzqO2GRWP3S5XsXzhLyAW8um0mPHX8Mz36gDriUq1
         iIvyCWocFB5FDhrQdOK3sv+kcqdzV5bM0U3sL6DOjj+Nzry3q/Mm/gidtRicPDcr5EFn
         TpZJvNrxNu9XaWm3/7BNbrn/Q8LbpW2LVGoS+avz1c/GfIdl0d7KmwPJzdaiV2QaGs/9
         mj7OyMU2KF6cgh3iNhuiUFoXAYig+xTY5b4L+DVwovkRWgaq3uy6hPDa00cW4yIyZw8S
         0+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+mJcsavnSmdsYaM5SEkNfFvnWebgPAUYa5/l0YqpUrI=;
        b=UObZqHITS+ftQmVgPdwdMGLfv85Mj53Hof43sHumfOu2pBYOXhr1AmThKRuuKmdi0B
         FnXfU5Qq8w0uf11jsLokK8OW0+8g1Sv55G4LHicGMs4zRgn3W3JqswWWXSBiYfRV/cqc
         3xwY5JXDp6YpWChjoB22U6WW8hti9jts4o9/JRU9xkb3J82eaYL48CPxw20qJb1eWlQf
         ra40VUqt98rk/rtnVxPVLp9/JqvJEuf4Y63oDAAqZVq2XPwfW4kXWtJgefvd/IpHpDie
         tBKdv86nlga9MejwcVTi+bSknak2w4nMJ9XuEhPx5edwp7kDyU24jcSii/piV38Qc1kD
         RhrA==
X-Gm-Message-State: AOAM533cD8/IrmnJoWCLb1SK+I01g/KREKVgqvYO2Hjw12wgHLcmH0tB
        V7Le+J6OaXLEiu8rkv5DNc0R0jABK5E=
X-Google-Smtp-Source: ABdhPJxP2Zd0ifHr3Q8nUbxEheNhipAjYaJsxuRzeZMRxWK7GrPeD0bIozLBSPpo6qYYqDGEWvQSNg==
X-Received: by 2002:a5d:524a:: with SMTP id k10mr17469104wrc.43.1614045598857;
        Mon, 22 Feb 2021 17:59:58 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/13] io_uring: merge defer_prep() and prep_async()
Date:   Tue, 23 Feb 2021 01:55:47 +0000
Message-Id: <584389eceea429c9dfba34051371b2dc087c8c1e.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge two function and do renaming in favour of the second one, it
relays the meaning better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5647bc73969b..34cd1b9545c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5778,6 +5778,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_req_prep_async(struct io_kiocb *req)
 {
+	if (!io_op_defs[req->opcode].needs_async_setup)
+		return 0;
+	if (WARN_ON_ONCE(req->async_data))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
+		return -EAGAIN;
+
 	switch (req->opcode) {
 	case IORING_OP_READV:
 		return io_rw_prep_async(req, READ);
@@ -5790,18 +5797,9 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
 	}
-	return 0;
-}
-
-static int io_req_defer_prep(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_async_setup)
-		return 0;
-	if (WARN_ON_ONCE(req->async_data))
-		return -EFAULT;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-	return io_req_prep_async(req);
+	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
+		    req->opcode);
+	return -EFAULT;
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
@@ -5834,7 +5832,7 @@ static int io_req_defer(struct io_kiocb *req)
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	ret = io_req_defer_prep(req);
+	ret = io_req_prep_async(req);
 	if (ret)
 		return ret;
 	io_prep_async_link(req);
@@ -6251,7 +6249,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 			io_req_complete_failed(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_defer_prep(req);
+		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			goto fail_req;
 		io_queue_async_work(req);
@@ -6403,7 +6401,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-		ret = io_req_defer_prep(req);
+		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			goto fail_req;
 		trace_io_uring_link(ctx, req, head);
-- 
2.24.0

