Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D729674075
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjASSCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 13:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjASSCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 13:02:41 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0536E8C
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:34 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id i70so1314521ioa.12
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff7H/3PeYDmHiRyUux/4lL6G6GX0g0GmP5JBfk3c0nE=;
        b=D1JDi4Bz0xr0JqrS/b8q5y5YGd/ekXo8pKyVp74cD2v5c6hPWA3ukFEAB9zCrpOzlw
         Ru9escdyn5K48Fu60svdG8oZtCzVyEwtaeUl0a1wnt7mXLYEvxgAG/bRcdclRhXeXnb+
         BweV+EEkFLfDbieVxoCNN37tk76628gPcR9Tai3OCLXa7AprxldowaAkswtnfFI0iyVe
         f2Kq1ngNVnCmI0dcQHtslKGYzeW1lCjGUldlo3M20RrEpbM3UI7N2f6Lqz1ET49VjnAy
         o6YYdUtN6ClIF8mt9p4412XfFB+zEMB3TYrftGLrSYxFCqR2XbtmV3ONMXZWSBKKnBpO
         gYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff7H/3PeYDmHiRyUux/4lL6G6GX0g0GmP5JBfk3c0nE=;
        b=OZXwkiVaBfP/N1k+AuX1Tttx0RVlljyuqoK7wW/92sNQCJDTHRABhOc6tXjjul2L42
         Q1r3ao8I5Sla95aQ7XAYLoIhkIQ/+ENrd/vF12Y8OdNp+tV78rcTsDP3uF3h47+RLp+e
         XBdGCJ2HgaBt0VXAY7YUvITRGY/m214hGLRw4dCNbS77/uVCSMPpCaXnMdBm3KW1LYsW
         mEs2GBXu5wLHNtEp/cZes87fVRyLZZEDCj9vfHyz8ddOyXt0kDdA0xRslfdnGuYu3+tm
         eJSqT3Yhu+HKSiaDt9jXy++p4IzbOdNTdGeSwcuJAnor47LiOseOCE57bctG+tKXhtRO
         snGQ==
X-Gm-Message-State: AFqh2kpt5MwSf5L4K9pUGGO8wvR1j4FSQC/lxbGaMaKZ8rcC+BevhMl1
        28aiFm6RuEIgWi49XWPd4s3yrSLXhufNzFsg
X-Google-Smtp-Source: AMrXdXtsZL3q27H5uwNKpbGMxlFZ3g0TYIpoBRvli4GoLFPmfUmCDJHm/NSblZbBNXSkSK9HEveU1w==
X-Received: by 2002:a5d:9e4d:0:b0:707:6808:45c0 with SMTP id i13-20020a5d9e4d000000b00707680845c0mr769304ioi.1.1674151348469;
        Thu, 19 Jan 2023 10:02:28 -0800 (PST)
Received: from m1max.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d3-20020a0566022be300b00704d1d8faecsm2354914ioy.48.2023.01.19.10.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:02:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/msg_ring: move double lock/unlock helpers higher up
Date:   Thu, 19 Jan 2023 11:02:24 -0700
Message-Id: <20230119180225.466835-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119180225.466835-1-axboe@kernel.dk>
References: <20230119180225.466835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for needing them somewhere else, move them and get rid of
the unused 'issue_flags' for the unlock side.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 47 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 2d3cd945a531..321f5eafef99 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -25,6 +25,28 @@ struct io_msg {
 	u32 flags;
 };
 
+static void io_double_unlock_ctx(struct io_ring_ctx *octx)
+{
+	mutex_unlock(&octx->uring_lock);
+}
+
+static int io_double_lock_ctx(struct io_ring_ctx *octx,
+			      unsigned int issue_flags)
+{
+	/*
+	 * To ensure proper ordering between the two ctxs, we can only
+	 * attempt a trylock on the target. If that fails and we already have
+	 * the source ctx lock, punt to io-wq.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		if (!mutex_trylock(&octx->uring_lock))
+			return -EAGAIN;
+		return 0;
+	}
+	mutex_lock(&octx->uring_lock);
+	return 0;
+}
+
 void io_msg_ring_cleanup(struct io_kiocb *req)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -77,29 +99,6 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	return -EOVERFLOW;
 }
 
-static void io_double_unlock_ctx(struct io_ring_ctx *octx,
-				 unsigned int issue_flags)
-{
-	mutex_unlock(&octx->uring_lock);
-}
-
-static int io_double_lock_ctx(struct io_ring_ctx *octx,
-			      unsigned int issue_flags)
-{
-	/*
-	 * To ensure proper ordering between the two ctxs, we can only
-	 * attempt a trylock on the target. If that fails and we already have
-	 * the source ctx lock, punt to io-wq.
-	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		if (!mutex_trylock(&octx->uring_lock))
-			return -EAGAIN;
-		return 0;
-	}
-	mutex_lock(&octx->uring_lock);
-	return 0;
-}
-
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -148,7 +147,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(target_ctx, issue_flags);
+	io_double_unlock_ctx(target_ctx);
 	return ret;
 }
 
-- 
2.39.0

