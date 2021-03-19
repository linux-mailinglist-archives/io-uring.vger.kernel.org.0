Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB20342349
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhCSR1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhCSR04 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2291DC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:56 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v4so9875468wrp.13
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yDW/gJ4l5sNYAIb9GbMKu7xexyu2VALvbva6k3a6opc=;
        b=SJRijktZFGCaXJPgIVI+oydGf+QLqhpsZ9QJ1XrFftBWYg5UmhItODrZZ+osZuxvcr
         2gR4i8fiwEk+K2L1D+4jQ5iQsz27PIhItcpS1SfE9WijL3V1aY0loAvg3PFCYTm6/5ib
         Hlw/EAgBFT6JiPJe/L9iamkGk87eRi1F29HO432dtioj8Xp/dynW2rm7J2ZzWykIvSwS
         PTwCJlRJglNyL0mMSHQdRxnXY79gyAcn9VhAyr56anyhqO2YbQHUB5Bn7WHNl9pj0f0D
         S4NTKNW1Ny6eyx0CuIkBBYnwO6GdooJoqa7tc9V4EPYyXXqdibg81M1IcWx16unjaN4F
         gbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDW/gJ4l5sNYAIb9GbMKu7xexyu2VALvbva6k3a6opc=;
        b=Fh5ZqC6wkD7FIThdcrY7ELSh7pmkakPdjKdH06DKY6DnFg0uDNTwxE71ZzAaL9+sOK
         Hdg5Jx0ZlgiDV6htAepk2y/3DqyGpYkxAP7CQoIcDU6709uVH+dPWiXWOBIfBwRDVwgk
         2YAVYjejUMO1P0+M+fKqNEB37bHIajSGC1ngqgAMvVfMbm6u9Fn8eiq3X/xNmMW4B51v
         0wrED7vFi/LgdkbY3IUS3PtoeGYukGKkIRtUfG3gDUDSZubHVvS0G14bxNN/FPMIMenM
         gOf49YFievCT0/MN1uf4V+qz53K6KAq4TJrFnSaDSqh5AE78mYZGOcGmCVfsFAb8Tlma
         8YQg==
X-Gm-Message-State: AOAM530kAaMey8NDK7b9q4j5EScgsIXclSN+joLsPWN65SqrPuBBJXq+
        e35qMv47P+oVr46VgHkcw80=
X-Google-Smtp-Source: ABdhPJwMzteSdsG7mIE3H14Ap2gF27d+7VkhNqM0uuiUobzASRun3acnQQfHRHiF2tfO+EzogvtGfg==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr5684526wru.264.1616174814931;
        Fri, 19 Mar 2021 10:26:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/16] io_uring: inline __io_queue_linked_timeout()
Date:   Fri, 19 Mar 2021 17:22:33 +0000
Message-Id: <8f8f56418756c6e8d022ab98a2ce7be76e53e5bc.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline __io_queue_linked_timeout(), we don't need it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8be345c81ff..a5e5c8da1081 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1026,7 +1026,6 @@ static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static void io_queue_next(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
-static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
@@ -6272,8 +6271,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void __io_queue_linked_timeout(struct io_kiocb *req)
+static void io_queue_linked_timeout(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
 	/*
 	 * If the back reference is NULL, then our linked request finished
 	 * before we got a chance to setup the timer
@@ -6285,16 +6287,7 @@ static void __io_queue_linked_timeout(struct io_kiocb *req)
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
 				data->mode);
 	}
-}
-
-static void io_queue_linked_timeout(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	__io_queue_linked_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
-
 	/* drop submission reference */
 	io_put_req(req);
 }
-- 
2.24.0

