Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD04AC60D
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiBGQhq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 11:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbiBGQYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 11:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C5C0401D2;
        Mon,  7 Feb 2022 08:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8DD60915;
        Mon,  7 Feb 2022 16:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576DDC004E1;
        Mon,  7 Feb 2022 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644251082;
        bh=wizEBetaRGWa2xd5IXRmfnLE9oVDJtn3/BtteleiDC4=;
        h=From:To:Cc:Subject:Date:From;
        b=PrD+e3xkXH15yxqW3MWnSPrWcDpaDckn1bQQf3urWGrunHqlZq4miFYHCoW2lJF5M
         wnwqUSZ5pjlTXm3nIDgY8AhFC3dQK4Fq92rIWuMq9mzlXnGsWalP3qTSMrF+XvZAV9
         sFEVLpgEeftZxEoczh4UhCpZ+1yRo4HRn5fQRUw2hxTrrzTzp41ZxKrNpxvtUp53du
         zSZ2pOgFJLqT/vEgjrGNt1o/d3MVv4X3obbGu+yG8CAtCjX+ldxOg67atZ9AfIU5kM
         QZJhPnGjL4VInsqw+GToch6hUanMSRBv2TlltnCIoCdJQb8r20a1qVrdKpkr1mBGnZ
         y73rN3je0sxJA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] io_uring: Fix use of uninitialized ret in io_eventfd_register()
Date:   Mon,  7 Feb 2022 09:24:11 -0700
Message-Id: <20220207162410.1013466-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clang warns:

  fs/io_uring.c:9396:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
          return ret;
                 ^~~
  fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence this warning
          int fd, ret;
                     ^
                      = 0
  1 warning generated.

Just return 0 directly and reduce the scope of ret to the if statement,
as that is the only place that it is used, which is how the function was
before the fixes commit.

Fixes: 1a75fac9a0f9 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
Link: https://github.com/ClangBuiltLinux/linux/issues/1579
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5479f0607430..7ef04bb66da1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9370,7 +9370,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
-	int fd, ret;
+	int fd;
 
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
 					lockdep_is_held(&ctx->uring_lock));
@@ -9386,14 +9386,14 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
 	if (IS_ERR(ev_fd->cq_ev_fd)) {
-		ret = PTR_ERR(ev_fd->cq_ev_fd);
+		int ret = PTR_ERR(ev_fd->cq_ev_fd);
 		kfree(ev_fd);
 		return ret;
 	}
 	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
-	return ret;
+	return 0;
 }
 
 static void io_eventfd_put(struct rcu_head *rcu)

base-commit: 88a0394bc27de2dd8a8715970f289c5627052532
-- 
2.35.1

