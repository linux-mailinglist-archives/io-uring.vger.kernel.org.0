Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7428A54DE13
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiFPJWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiFPJWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50C611167
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:46 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id s1so1035718wra.9
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ZsaHpJ+wHbQ542pIhquFY7dETyZEEfQcuRQQLy5A28=;
        b=Ne2qDU/PEqXHQeBk7GF3dMp6i/rEBKurv9RqgtWdBWqfRoiC/OSAq4/DPVbYHtoOsA
         svLLQy66KYqVoDd4l9oEBkuBmKnETzAZkM8V+VhZPRCC3lrNpRm68TQIMmLqw/xIJIuZ
         j6cXC12H6mI/j4/p3wlRiHYIHPHlQnvI5ZkB62tiHZROmU7wnt6vdGaNwFgDiQSGGTIP
         lfAR3yfGnv9bUVMLIAQ24AE4FLvgqlb1r4f8SmyqRbFv3H3RMaWwrGvSq63G1a/3q+5Q
         vOOmfsIZYZH6rbwHtwmUQYxZ2MSYuth/CYmiwzlwKlStom4mqHPI9XM78pa6njQk9Oz2
         +N0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZsaHpJ+wHbQ542pIhquFY7dETyZEEfQcuRQQLy5A28=;
        b=U0EJENDcJjKuSBBBraiVg+OYodBCgNgGrLPLlJeBsf7ht0ZBtabJrFVFLXaVKCRBZ3
         Upwtni1APjchpeldzJ5FaVMrI5I/o8dmN2Qu7hHLj533s/WUjA9vMzZ8h9raPTNO0SOj
         2V4Po7Vnj0DZxxPwgqlGUFzh7mjuaASiDDhDx642XV68+4OUZuEYv5ScJBMSOmxHjhTI
         /11XQ463BQR4e8QN6OaN5mePkrZaAbxOds2X/6x0xyZEgSuT7ozXElYjU490hASXR2hQ
         qPtQXezGuCxqLsDazfZJs4UtRieYUJkwxo7ksLdNFoJAAzFBgeecNVEJ0P96yplrAY1D
         yL5A==
X-Gm-Message-State: AJIora/E+IRZ994uy7J+ZuKPnKUXZxa+ZNzvzT666CfqGJk9TIOfV954
        amIQdbe2cXCEJ1O3FO3x/XDIhVcQnuSVMg==
X-Google-Smtp-Source: AGRyM1tXNEK//2jWAerbkkagqbLN2PkzYsLgGHE2n+NOw1sjZhpnW12wEYHkxQ9AkdzOzrlBS9xFaw==
X-Received: by 2002:a05:6000:186e:b0:218:5f5d:9c55 with SMTP id d14-20020a056000186e00b002185f5d9c55mr3562733wri.128.1655371365004;
        Thu, 16 Jun 2022 02:22:45 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 02/16] io_uring: kill REQ_F_COMPLETE_INLINE
Date:   Thu, 16 Jun 2022 10:21:58 +0100
Message-Id: <600ba20a9338b8a39b249b23d3d177803613dde4.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_COMPLETE_INLINE is only needed to delay queueing into the
completion list to io_queue_sqe() as __io_req_complete() is inlined and
we don't want to bloat the kernel.

As now we complete in a more centralised fashion in io_issue_sqe() we
can get rid of the flag and queue to the list directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c       | 18 +++++++-----------
 io_uring/io_uring.h       |  5 -----
 io_uring/io_uring_types.h |  3 ---
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f1ecfdd0166e..02a70e7eb774 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -742,10 +742,7 @@ void io_req_complete_post(struct io_kiocb *req)
 
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-		req->flags |= REQ_F_COMPLETE_INLINE;
-	else
-		io_req_complete_post(req);
+	io_req_complete_post(req);
 }
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
@@ -1581,9 +1578,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (creds)
 		revert_creds(creds);
 
-	if (ret == IOU_OK)
-		__io_req_complete(req, issue_flags);
-	else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+	if (ret == IOU_OK) {
+		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+			io_req_add_compl_list(req);
+		else
+			io_req_complete_post(req);
+	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
@@ -1748,10 +1748,6 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
-	if (req->flags & REQ_F_COMPLETE_INLINE) {
-		io_req_add_compl_list(req);
-		return;
-	}
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e30e639c2822..3f6cad3d356c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -217,11 +217,6 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_COMPLETE_INLINE;
-}
-
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index ef1cf86e8932..4576ea8cad2e 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -301,7 +301,6 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_BUFFER_RING_BIT,
-	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
@@ -356,8 +355,6 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* buffer selected from ring, needs commit */
 	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
-	/* completion is deferred through io_comp_state */
-	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
 	/* supports async reads/writes */
-- 
2.36.1

