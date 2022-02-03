Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770A44A88E8
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 17:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352409AbiBCQpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 11:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352207AbiBCQpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 11:45:11 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E444DC06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 08:45:10 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso2186107wms.2
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 08:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y6U7YdQVGA2YDGwsgkTnmQr3nQCNLxRAeMrGbxyU310=;
        b=0XuF/JGS5W8qkzma5i9WGPf31yOnDg4Ylqo4ISkoU/IijIll9Ymf3Td8QgD0+DmH0o
         sDoOH2il8HeN4WYLZlb1Plj59s9x6fvPOvbtozwkPU2aYwpEyhjezsrbj8kA0i3hoOGx
         tylG7ndZx1hzx6AXXef+3kj1EPL2RRxgL0sk4s6685tNFccloCAwQzWKjzw+1uBxhXsO
         Cwq7N1VZTwYZWHEKkRsSpCf+fWiZ5bNAWhC0FAaVXKztuVhg2l4izMROTTfQr5ZTl6JO
         C3PDQNGL2HWl3Gf+0mmccAwgzkf7N1T45DFS0awEToUo5CcWF2+SAghMZYLB+LUHJI1V
         aGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y6U7YdQVGA2YDGwsgkTnmQr3nQCNLxRAeMrGbxyU310=;
        b=nyh2vHixOl9uHs6CI4LhJpV1iMOcoxsyL7AOyvlDGwgVtVGXEx5Py3wHr5N8Z3S4eN
         iGmUquXR/xXRZPZvQ8bi5soS0za6faWAcrESMfx1aX8NErPWGnYdNeFRadIFHwhhp++P
         4qmXqA7tM3Ex7U0cozGXHPU95EuBxksP/Pku1LlO4EaBZnq8syeYgXMpx+dxrlia2cYh
         dwvKOAsUkCByrBYbaFebEdVDEntNiVjj317nDfVRo0CdKe9pYxtXnHnUm1jME9kTNCa/
         Di5cXMCyU9p2WWMpKelwoLYO2Js650s8t/9qPwUfOs4s+XINv/rrshlgYo6Nn9p6ZVDx
         UhQw==
X-Gm-Message-State: AOAM533DkFQfWyUhglzr0ptW2RLCQJXZS8ERyHUB+f3RDFtGDcPYijmE
        gp4ujtPyu/i9nSY0gQMoCI27uI2eoqsejQ==
X-Google-Smtp-Source: ABdhPJyhbFlaAl5r8+IIntVrV4V0/fEuqNg0yeotDlykZSJOMt2gxlgKbxy4VqszArLK1r8LlHt2Pw==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr10891990wml.34.1643906709375;
        Thu, 03 Feb 2022 08:45:09 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id n14sm21412831wri.80.2022.02.03.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:45:09 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v2 3/3] io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
Date:   Thu,  3 Feb 2022 16:45:03 +0000
Message-Id: <20220203164503.641574-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203164503.641574-1-usama.arif@bytedance.com>
References: <20220203164503.641574-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done using the RCU data structure (io_ev_fd). eventfd_async
is moved from io_ring_ctx to io_ev_fd which is RCU protected hence
avoiding ring quiesce which is much more expensive than an RCU lock.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b6ee3b8b9f2..05fd059b3f1e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -329,6 +329,7 @@ struct io_submit_state {
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	struct io_ring_ctx	*ctx;
+	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
 };
 
@@ -341,7 +342,6 @@ struct io_ring_ctx {
 		unsigned int		flags;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
-		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
@@ -1747,7 +1747,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		goto out;
 
-	if (!ctx->eventfd_async || io_wq_current_is_worker())
+	if (!ev_fd->eventfd_async || io_wq_current_is_worker())
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
 
 out:
@@ -9368,7 +9368,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned int eventfd_async)
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
@@ -9395,6 +9396,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 		goto out;
 	}
 	ev_fd->ctx = ctx;
+	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	ret = 0;
@@ -11010,6 +11012,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
@@ -11110,17 +11113,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

