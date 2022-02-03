Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FC74A9136
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356024AbiBCXer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356008AbiBCXer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:34:47 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916BC06173D
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 15:34:46 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u15so8073292wrt.3
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 15:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/qApFabyCqynxzYsW+8dYD6QrjWQhPeK69O6kd4Euc=;
        b=6s9JhcKBntjBkKFlGZfvX6NL1mxXzuU5vbBiVSaI9+eNj6JbcfL4wbiHwme+u88Yn6
         7b6goefqeUoqW917umdzcCP1sZUr2feWA36MqnrrLwtGbj76zU/P8WaB2wzY/hhrVXSC
         i5uFEyyvxFraNoC09AgegOVXhamcvWME8EgZQtfghNTgJOEKax+VzEaVds7OB1AWF1Yo
         tR3sNc++6aVtAArxqIU23GVYpS5wxWOzhZEJT9NkZMOhg/aXDSHuvAR2Zr7zIDMb7kCK
         grWgzRvkt4OmkLkKmMwZ5AErndsqfHQznFEzxf1QmJ5vs9KYDLJRMiWnmNV6vptd94EL
         WZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/qApFabyCqynxzYsW+8dYD6QrjWQhPeK69O6kd4Euc=;
        b=HFwtMjo0rwqGdWaVQibBCr5YBYefP1UE27XvrbQ2yW/TFIAlcVbxJE8lR9rJb6/wW5
         1M0ne6NT4OG6PkNuHIaKMMJiPMUOR6FF4hcl9xMgPsnYRuwTpfvUyRc4HRr0kK8qWmKC
         ej2bWyZOMQzMJvQSbgR1VS3rwhAPPes45lgiFdRm+gCCuDCfx2RcbS/ht5/1dX+ja5LQ
         JCMKaPlxMYp4lxORPrbOUESyv0UHHpX5gNY6hri/34pKMFbjxvud/ccSCoMzUswGYBPI
         icwDl5loKQl5AlEN7TBSxdbA9e5REWXpbudhNCrq44Ounq+4GF0Vysu4r/jdaHY8K17l
         S9cg==
X-Gm-Message-State: AOAM530Q3N0IDPHmS9VlLy1Ny6yiv/TbQWrREW0TqJyznELgrJx5q/hX
        Ek2Y4EKxWHQWmwLeLDDNP5rEVfOSbhzNoQ==
X-Google-Smtp-Source: ABdhPJx9B33DIul/jfnrSTzI4eCfy8T6j/MuusQGZtwW2rmZBbRbowZ88NOkXNJHe3FO4BqUYybjkg==
X-Received: by 2002:a5d:55c3:: with SMTP id i3mr220314wrw.250.1643931284877;
        Thu, 03 Feb 2022 15:34:44 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id j15sm148494wmq.19.2022.02.03.15.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:34:44 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v5 3/4] io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
Date:   Thu,  3 Feb 2022 23:34:38 +0000
Message-Id: <20220203233439.845408-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203233439.845408-1-usama.arif@bytedance.com>
References: <20220203233439.845408-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done using the RCU data structure (io_ev_fd). eventfd_async
is moved from io_ring_ctx to io_ev_fd which is RCU protected hence
avoiding ring quiesce which is much more expensive than an RCU lock.
io_should_trigger_evfd is already under rcu_read_lock so there is
no extra RCU read-side critical section needed.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51602bddb9a8..5ae51ea12f0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -329,6 +329,7 @@ struct io_submit_state {
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	struct io_ring_ctx	*ctx;
+	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
 	bool 			unregistering;
 };
@@ -342,7 +343,6 @@ struct io_ring_ctx {
 		unsigned int		flags;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
-		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
@@ -1756,7 +1756,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		goto out;
 
-	if (!ctx->eventfd_async || io_wq_current_is_worker())
+	if (!ev_fd->eventfd_async || io_wq_current_is_worker())
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
 
 out:
@@ -9377,7 +9377,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned int eventfd_async)
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
@@ -9416,6 +9417,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	ev_fd->ctx = ctx;
 	ev_fd->unregistering = false;
+	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	ret = 0;
@@ -11029,6 +11031,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
@@ -11129,17 +11132,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

