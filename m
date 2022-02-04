Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C48A4A9B78
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359479AbiBDOv1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 09:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359476AbiBDOv0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 09:51:26 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78C7C061741
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 06:51:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r17so2750484wrr.6
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 06:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5zc8mYGQQbklzCfEPq5ixDqvUH1Mr0RGq4NsmzowtCU=;
        b=q7cQX7sIPSRmOALm6TBpWQ/mo+y2c7GlrThj3wILGB7n2WzpXU+8SZremYwVxzsGij
         G4wbfSz+fec2keuXRmpWplZXoU2vxrq6jPyHhQLVAKWuAerYySuGY+3DyvIwOas7Xxue
         bJt0BgDjxeDxViSaqlitN225zUj03fM9SAae8IDkFXjvPYwTDeqRr08cjukhfdroSDZy
         MIh8Ofdt5LlhPny7r6Yji8K9glZwtL4zPbnuq/CRld5WZCybRx60kBazZ5temZpPbccT
         MSr3bITJgpVF3sBCebcZE9muZSJvPqrswt/BPmf/n+NEwCoaCnzY+UXCiCudufpnOyC2
         49tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5zc8mYGQQbklzCfEPq5ixDqvUH1Mr0RGq4NsmzowtCU=;
        b=uurmXEv0uu22eLQSJ0dLwVgJoPmIilu5WOtgaHvBtGG/Y4VTILQfML5mhONfIWAu0l
         NxfhBOD/MQa9NMPqb80SrkWHZrgqq4CQ0hlifyAUiWHbm22JTqD8/qxTDR8P3rzQ9oOQ
         j+56xYof8XtSPud10gZfS0zNSq3r1JtBSgD4B5xvWvKw5KNLj/0fQRgnp4qZHha4qNzf
         Vw6tSXL6DUGzpTN1qY+9jpQd3PJLA4dGIptRefgMePZaMrI4tqoX5QCKTtTpmF2T1h5d
         X1OM4+7/GoNLEpfnHHqTx+pZPr87ZFxwBB4L34Ki5G0pxlXDz0NwAE7eeWOtTKfCk2Ur
         kDaw==
X-Gm-Message-State: AOAM5309r0UEPHZRwPDRl3sQA9G2yRacoxkl4rgHN2lUo+RExz5gQOQc
        Kl1XEj7PILvRh0mSCJTD4eLDbGfFkZB+EA==
X-Google-Smtp-Source: ABdhPJz3r/hgUNyu1JFddlat0A+D16hlkSO3MwsYWonb403K1rS4BB2N+fCYnF6gfCI/1pQ27pBarA==
X-Received: by 2002:a5d:4cc7:: with SMTP id c7mr2656075wrt.233.1643986284356;
        Fri, 04 Feb 2022 06:51:24 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:e94c:d0f2:1084:a0d3])
        by smtp.gmail.com with ESMTPSA id c11sm2552898wri.43.2022.02.04.06.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:51:24 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 3/5] io_uring: avoid ring quiesce while registering async eventfd
Date:   Fri,  4 Feb 2022 14:51:15 +0000
Message-Id: <20220204145117.1186568-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done using the RCU data structure (io_ev_fd). eventfd_async
is moved from io_ring_ctx to io_ev_fd which is RCU protected hence
avoiding ring quiesce which is much more expensive than an RCU lock.
The place where eventfd_async is read is already under rcu_read_lock
so there is no extra RCU read-side critical section needed.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad6361aeaca7..671c57f9c1fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -328,6 +328,7 @@ struct io_submit_state {
 
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
+	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
 };
 
@@ -340,7 +341,6 @@ struct io_ring_ctx {
 		unsigned int		flags;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
-		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
@@ -1752,7 +1752,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		goto out;
 
-	if (!ctx->eventfd_async || io_wq_current_is_worker())
+	if (!ev_fd->eventfd_async || io_wq_current_is_worker())
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
 
 out:
@@ -9373,7 +9373,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned int eventfd_async)
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
@@ -9396,6 +9397,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 		kfree(ev_fd);
 		return ret;
 	}
+	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	return ret;
@@ -11000,6 +11002,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
@@ -11100,17 +11103,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_register_files_update(ctx, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
-	case IORING_REGISTER_EVENTFD_ASYNC:
 		ret = -EINVAL;
 		if (nr_args != 1)
 			break;
-		ret = io_eventfd_register(ctx, arg);
-		if (ret)
+		ret = io_eventfd_register(ctx, arg, 0);
+		break;
+	case IORING_REGISTER_EVENTFD_ASYNC:
+		ret = -EINVAL;
+		if (nr_args != 1)
 			break;
-		if (opcode == IORING_REGISTER_EVENTFD_ASYNC)
-			ctx->eventfd_async = 1;
-		else
-			ctx->eventfd_async = 0;
+		ret = io_eventfd_register(ctx, arg, 1);
 		break;
 	case IORING_UNREGISTER_EVENTFD:
 		ret = -EINVAL;
-- 
2.25.1

