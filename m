Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C304A8756
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351686AbiBCPML (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351673AbiBCPMK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:12:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B4C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 07:12:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m26so2326890wms.0
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 07:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rvWCTnK7RIGRGIa+VtDlo4Iv+yq/+Lu9evG31SQz/yM=;
        b=aW2ldL8OrNHngGrqChyY1ky0oKQbCrh9+FJ5S95lS+kjaw7Ym5fHIhG1ooDDMy2EG3
         aVlN2KW7PlYjaf6Mjypd7qOZi6lqyqn1m12PkW5BNNCNRGPo1tZJIky1EuBeeb178tgN
         ApGjkm0vMph1dYj0p0SEWiy3DW+6pof1wBe9Mn+8PB66yFy7QDEpXwfjoF4vHpCn2bOz
         HaCygIYmbIQSTrQ84JGvaxCagkwh5EfXLYVO8JPvM+NH/VKVvrK/mRtFch87ogTwkrNm
         2aodA6WlZqikQpgmboDZosh5pJ3d4w46nIH6iZ0zFLFV6zfqNeSNt/3xYN7r6uXQb0GT
         +4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rvWCTnK7RIGRGIa+VtDlo4Iv+yq/+Lu9evG31SQz/yM=;
        b=7exMXFseZWtPWQ8VHUfuqbp8DDH9V+zDF40l7v04BPHZYj6jXzLoEOkzgSMWKRkx7M
         h4Xdi01AOsCATiApFG4jkgAjj6dObi6+tvcRVUQNPn4sUl4LuTYuFiJFA9bknbT3yuS6
         t2ZfhYdGOIWq/DYzCOLCkGhoZEsV3h3I7FwfXPr5eJ5CKbfMFw3zFi7yNoMfLOk16a/Z
         IsNDZcSPgYtIgKVuEpezkijPbeqIqwP8DcMfIXxL6HuYSDmzwTTtMmGsYxtw1X50thlz
         gSV1PwGEcTs/XgrzLcLfjGSmCq0/bFlI2Dg5CprmLGBdwH9qqmUtU5eeSOhK9y5JIo5K
         NcWQ==
X-Gm-Message-State: AOAM533x1D87NG0gVvr5jT+gK40BInxZj4dEP6rzLdvgEQYNrDh4YDmC
        49e7v4lzPhHZM2jgb5G9erS/HZ2WzzPHkA==
X-Google-Smtp-Source: ABdhPJwGqRQozSjn+lIsgMN0YR+bp/BBm28F1i1av7MLxP9PAKwUk51QlDUZ++M1LdLsc3DB92sdOw==
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr10799974wmq.44.1643901128011;
        Thu, 03 Feb 2022 07:12:08 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id m14sm25793665wrp.4.2022.02.03.07.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:12:07 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 2/2] io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
Date:   Thu,  3 Feb 2022 15:11:53 +0000
Message-Id: <20220203151153.574032-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203151153.574032-1-usama.arif@bytedance.com>
References: <20220203151153.574032-1-usama.arif@bytedance.com>
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
index f07cfbb387a6..30ac08ad6810 100644
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
@@ -1740,7 +1740,7 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx, struct io_ev_
 		return false;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		return false;
-	return !ctx->eventfd_async || io_wq_current_is_worker();
+	return !ev_fd->eventfd_async || io_wq_current_is_worker();
 }
 
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
@@ -9372,7 +9372,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned int eventfd_async)
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
@@ -9399,6 +9400,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 		goto out;
 	}
 	ev_fd->ctx = ctx;
+	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	ret = 0;
@@ -11014,6 +11016,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
@@ -11114,17 +11117,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

