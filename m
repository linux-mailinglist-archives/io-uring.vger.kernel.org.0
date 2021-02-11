Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB93D31925E
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 19:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBKSfR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 13:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhBKSdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 13:33:05 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185EC06178A
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:19 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w4so6420194wmi.4
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mvJVHvc4Rf/OGlrj0a0cLFD4kicIcMgleLXrm7242gg=;
        b=uOQjsdyqEYO2f3GCQyge8lA3oLKKBmHd46+3KbqsIc4uZQgi3gkVT+tRqcbRTCinN1
         cn4wqDTC7WvCKnXz7uPV/4EAmMmAQ+lV0SATyEn1M6m0fPzi3u9YZyzEMRu5jX4NvnLJ
         mXXL8iG0W1384dWseV2PbZVWF1GRAJnkExgtYHCPjlaXrPjF3ab4KWsXYUG/6jD6wrfZ
         /ERGzmXv/L6zpVSbgMIqZXj5ENN5z6xURmA35Qj/swZaWRLbYpq6Rqrs/KhexjT7ax3J
         fvgCkbODw54lusUKBlkv0l907FbFuVXBzPJcqUzacuAc9gOl7TvBMNyvpAMmROAdKVpB
         BiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mvJVHvc4Rf/OGlrj0a0cLFD4kicIcMgleLXrm7242gg=;
        b=tXUwWt0klLx5cYFZs9CAuF7u5r/4W92QYqgYlmU4J++xzlQN3j/YrSA7F/DbKoo2zY
         DaXvTrjrZCLZsgocnbGBciMh2oDXTEvtby0t5c0ItG2ntgfN5iyqq3b05sWcNGzRQHEU
         itvEDoC+Vx9MquUdNFlEr0bAfS6GQzmdu+B1FyhWW0AH5/UFKdOq+Wy9M/1JQWba10Oe
         41EM44PCzET94YOAIxqSlSk9bl5duoMKVrqAA2663PJK10AwsS9uOYDyc8ic3twqvxfc
         pEVqc53sZTC+2SpBf1yxPvASHtT80UggArUj9pQZSMhah2FgnZOHr8kamJiOicBPwtFq
         RDxA==
X-Gm-Message-State: AOAM533ilSF6fczCOudtFMI56yh70bJjRxd7MUIoSULn44XWWfCnnAA0
        hXASogP717uZ97tbSC7/qPLNSZTZA0cD/A==
X-Google-Smtp-Source: ABdhPJzFQ1CPtD3n7zdu1ZtcbDMV/JpJERVYbmAQokSjrRotlUtrekyeoO2ZuFAOs03aDGsYLDVN8A==
X-Received: by 2002:a1c:20cf:: with SMTP id g198mr6154129wmg.173.1613068337962;
        Thu, 11 Feb 2021 10:32:17 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id a17sm6501595wrx.63.2021.02.11.10.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 10:32:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: move res check out of io_rw_reissue()
Date:   Thu, 11 Feb 2021 18:28:22 +0000
Message-Id: <790e018b34e448fa8fc6201c853becbc2cf8bf8a.1613067783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613067782.git.asml.silence@gmail.com>
References: <cover.1613067782.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass return code into io_rw_reissue() for it to check for -EAGAIN.
It's not the cleaniest approach and may prevent inlining of the
non-EAGAIN fast path, so do it at call sites.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3df27ce5938c..81f674f7a97a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1026,7 +1026,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
 				     struct fixed_rsrc_ref_node *ref_node);
 
-static bool io_rw_reissue(struct io_kiocb *req, long res);
+static bool io_rw_reissue(struct io_kiocb *req);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
@@ -2575,7 +2575,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		if (READ_ONCE(req->result) == -EAGAIN) {
 			req->iopoll_completed = 0;
-			if (io_rw_reissue(req, -EAGAIN))
+			if (io_rw_reissue(req))
 				continue;
 		}
 
@@ -2809,15 +2809,12 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 }
 #endif
 
-static bool io_rw_reissue(struct io_kiocb *req, long res)
+static bool io_rw_reissue(struct io_kiocb *req)
 {
 #ifdef CONFIG_BLOCK
-	umode_t mode;
+	umode_t mode = file_inode(req->file)->i_mode;
 	int ret;
 
-	if (res != -EAGAIN && res != -EOPNOTSUPP)
-		return false;
-	mode = file_inode(req->file)->i_mode;
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
 		return false;
 	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
@@ -2840,8 +2837,10 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     unsigned int issue_flags)
 {
-	if (!io_rw_reissue(req, res))
-		io_complete_rw_common(&req->rw.kiocb, res, issue_flags);
+	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
+		return;
+
+	io_complete_rw_common(&req->rw.kiocb, res, issue_flags);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
-- 
2.24.0

