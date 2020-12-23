Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE322E17BE
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 04:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgLWD14 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 22:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLWD1z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 22:27:55 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C340C0613D3;
        Tue, 22 Dec 2020 19:27:15 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w5so9744980pgj.3;
        Tue, 22 Dec 2020 19:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H8go/+X2Vcs98+iki2Z8ohftpJpMUDcNkNw9l89t5vU=;
        b=IPSlb0CJNRuU2Z0oTyjF3f8ujTtTF2TnQQJv5kNitqjETttqxOuxfFZRmja9kR0Eu1
         AcoKkHM9+On8cwyy9gk6cvFGM1mFgVmBiIcPsGIoZgZ9n77by/weeVCQpltp3KWBYNeS
         jtADoDxkM+TgrqZ7Zx3vhvHHfie35QrA5n9rq3wMbQdaGSGa2rGqnSB3WU+dTmn2xjrK
         g3H+ZGdLOo4HXXA7kirE2wlVf0JLBInAUOzXnrZlaDuU13MtlDD5lryhLRS4u9NsV4Fx
         EpnrJMjfkjWaJl5EStz5hoaaKXQWwl6a71DUAjsYNHtotjka9wfehAsNTzk0fEFjgS+4
         mYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H8go/+X2Vcs98+iki2Z8ohftpJpMUDcNkNw9l89t5vU=;
        b=bAWdtHYmqgp9UWQ7SSdozVP3dZHxIboFDJ78tBWaUlRNEPSttkFol2a1rLevviPzLN
         fr/e0LwRlMchlykV0Ae2ZXE4c6jWMuz4I1yYp0YqfsdAAIQd/nGcuekdeD5lGR5cBRYB
         A9TrGhKy4G+ppwr87NrlJO/E+sbNR5eZSZQ+FuKMwUOLeYWV4UmG3QkMTmF/oop4cZAX
         r03d4YlyPqtGrtdKW+lr/JnD7gVXMk4lhX6H0h5jFQTTjtOANeVsq89w7MYOFsGqgQCD
         BnsV47b+rrcsvYY3s9GUxNkbkpzbbEK/9bX5OEzxwWgltGms8E07BMPDPLnQMcoi83fy
         XKPA==
X-Gm-Message-State: AOAM530HFtz4VhxbHwmSs0MNcSlbme1ROjknC+fo672pt9Dug9km3ryY
        1pW73ZMX3GD4GNO0Wi8By28=
X-Google-Smtp-Source: ABdhPJyYhZUATDbhC2Yt6IPIF6lHyrgNCyQ47E/gPAVgdoDwMC0xnj/TuVVJUJLeWKJZI5K8xDFA6g==
X-Received: by 2002:a63:66c3:: with SMTP id a186mr22826436pgc.198.1608694035129;
        Tue, 22 Dec 2020 19:27:15 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id b6sm20535189pfd.43.2020.12.22.19.27.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 19:27:14 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, yejune.deng@gmail.com
Subject: [PATCH] io_uring: remove io_remove_personalities()
Date:   Wed, 23 Dec 2020 11:27:05 +0800
Message-Id: <1608694025-121050-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The function io_remove_personalities() is very similar to
io_unregister_personality(),but the latter has a more reasonable
return value.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 fs/io_uring.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b749578..000ea9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8608,7 +8608,7 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
+static int io_unregister_personality(int id, void *p, void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	struct io_identity *iod;
@@ -8618,8 +8618,10 @@ static int io_remove_personalities(int id, void *p, void *data)
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
 			kfree(iod);
+		return 0;
 	}
-	return 0;
+
+	return -EINVAL;
 }
 
 static void io_ring_exit_work(struct work_struct *work)
@@ -8657,7 +8659,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	idr_for_each(&ctx->personality_idr, io_unregister_personality, ctx);
 
 	/*
 	 * Do this upfront, so we won't have a grace period where the ring
@@ -9679,21 +9681,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	struct io_identity *iod;
-
-	iod = idr_remove(&ctx->personality_idr, id);
-	if (iod) {
-		put_cred(iod->creds);
-		if (refcount_dec_and_test(&iod->count))
-			kfree(iod);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 				    unsigned int nr_args)
 {
@@ -9906,7 +9893,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (arg)
 			break;
-		ret = io_unregister_personality(ctx, nr_args);
+		ret = io_unregister_personality(nr_args, NULL, ctx);
 		break;
 	case IORING_REGISTER_ENABLE_RINGS:
 		ret = -EINVAL;
-- 
1.9.1

