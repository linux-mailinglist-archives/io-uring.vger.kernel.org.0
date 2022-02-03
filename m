Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5B74A8B92
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353483AbiBCSYu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 13:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353468AbiBCSYt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 13:24:49 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AF0C061744
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 10:24:48 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso2351109wms.2
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 10:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nbb/JonlYt2gwQTccH2YTHZ8fFvVyRbc8c63+KA/SXs=;
        b=tIGn+9IvEdbkXn5xnNLy09gK3SY2EFeBj/BT39em5zIXMjreIH0iirlTjng4muT1re
         iqgntSWn1lpNoVerckRjRAvdhLtLuHRymFX88dZi47LvqLyQFnGVfmf1H0AyReqDmx/n
         BVQvPiqTc63TJTO75Y/SmZrRXGCWz1QEGbVZA/VP7r91FFphT1FX9pS2MWkuZR5viui8
         fpvguOV37Xq9Zlxlqm6EsKxFrhCtXzdLEUtPO6EUUEkETmysOeQiRlj1Aaslysc0afL3
         tJgWWVpfWQEF+juElhCDyExWrDjLzjJ9YwYnXInIhchz30cDe92A1MC2PQWwdAuM+NOI
         aR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nbb/JonlYt2gwQTccH2YTHZ8fFvVyRbc8c63+KA/SXs=;
        b=sT/Kbnkw7wNMeVwQzojULUwK9TWhUK7iEz7mxZ6LLQq3vnP0DG9cSWnwm6s+BOQrbZ
         u/cvI6zBB7KlwB/xCCJNeH3HRsWvk631JAl4ORi0nV5QAV1iju3xLXurNYm6HuDTRykR
         2Y18Jc75R7HH1IlZW1/lmWpMJEa3jismozv1X2tC3KT8/0zek5tKQqYklOXVvaQ213eR
         5nFakBd4Q7b2pE7MVAhefDaHNDuGSECkU0k6cnAINF+nmhyWP/Wsl4h8OugzICqy3Fwk
         LncmoX/8kGLlIuD5VRqxfKsvgojDie9jrGIIlam+saM2G+Qq948CDp/lesU7CwbFYCiS
         f7xQ==
X-Gm-Message-State: AOAM533UC2PmWgMFtmcImqLW3E3KQ1qyXTrU++/jEZv8188U0KLWTfTj
        ZeBfE25vLzDURxG76x+9ak9Q+icHK8Wmrw==
X-Google-Smtp-Source: ABdhPJy8kFjgZA7GepNZjH7o49H9W94lbEP8JvFAcXl7hMwg0rlZPQMT0bcsqkgE3yBPSknYYP+iTA==
X-Received: by 2002:a7b:c0c8:: with SMTP id s8mr11511762wmh.3.1643912687002;
        Thu, 03 Feb 2022 10:24:47 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id h18sm3540056wro.9.2022.02.03.10.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:24:46 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v4 3/3] io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
Date:   Thu,  3 Feb 2022 18:24:41 +0000
Message-Id: <20220203182441.692354-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203182441.692354-1-usama.arif@bytedance.com>
References: <20220203182441.692354-1-usama.arif@bytedance.com>
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
index 7a8f4ac7a785..e287fc61879f 100644
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
@@ -9398,6 +9399,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 		goto out;
 	}
 	ev_fd->ctx = ctx;
+	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	ret = 0;
@@ -11013,6 +11015,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
@@ -11113,17 +11116,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

