Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7942EC90B
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 04:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbhAGDUC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 22:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAGDUC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 22:20:02 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE51C0612F1
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 19:19:21 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w5so4182387wrm.11
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 19:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EEo4pck8Yp85gtwTba33DaKZDVD/yHw+QRKF+ooNqyU=;
        b=C1KaTJG5t+BwH0j3FQ12/DDfL342w+VcOdTfMvC5SLTxKbanj2Jqghg6fb0ct831wZ
         WG6W2HmSESx7fadzEUUgN5Dqc77pUrvnCc3h/Ry+QLGn6oVOKiJbLFMAWj5s13HskJPC
         zTBEv1T35pfW7HHpMGJPAEhEDn1fDTDHJR5x8b9YOm136Fluq6ahGmmGYWBRlkygiqv8
         qXHUI+lnpdqCG0UJ9s576g0T8sGRXTfsd0YKlPHGNr6Tr+xNXx7wJEKMMco1tqAyhrc5
         P4u8A3BWkqxOmzmuKhw3WTyjPLxadCaR/npIy+sQGbMdVKsQmo+xgJB2+MqDVpCJc24j
         KMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EEo4pck8Yp85gtwTba33DaKZDVD/yHw+QRKF+ooNqyU=;
        b=HAwH8BYJ06OjyiaWYDoyaHhCn5x8AaFLEFSruNbR67VXPLEAlR6MgRo7VXQYqN5ZcG
         mQAIGBUgPPn2E37LdGc42ffWW9OU3R0Zf0HlXRXdgrnRMycw/xVd44yJSRqQ/Mh/oGt+
         sDnEAxZSeslTTrsjW6PPFfjoiXrqJa5T9uFfGuTeUTqTdxTc/ojnITogArjRcQjqkkXj
         leTeoaxCagmo27FkfJlo90c5020d+sohsZEPj6Da1V4FW0HMMX+3YB3vfJjpG+UPo/mQ
         tnuDnKNCkWwOCSYrFuD9wz3ljGVAXq7x97uJpB5EobRPUS53OGDgAlkNHv8tzOue83JT
         ZUjQ==
X-Gm-Message-State: AOAM530w3NAyHOcYRf3arYgt8Exbq8fh+LmBK6zufA38156iVnmlU22t
        Qx+dcjM9cjKp7+3ejYNRMyI=
X-Google-Smtp-Source: ABdhPJzNtNYpnJ1R1P2cBHWYNsmRfjhOj7fcwRUXr7pg0EU3WIaZBpijEa1EIm2/85JAVcZofI3u7g==
X-Received: by 2002:adf:fc48:: with SMTP id e8mr6709823wrs.11.1609989560672;
        Wed, 06 Jan 2021 19:19:20 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id t1sm6181430wro.27.2021.01.06.19.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 19:19:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: trigger eventfd for IOPOLL
Date:   Thu,  7 Jan 2021 03:15:41 +0000
Message-Id: <d54b038ec7e65d175edbd7621d8ca6d3b279ae7e.1609988832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609988832.git.asml.silence@gmail.com>
References: <cover.1609988832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure io_iopoll_complete() tries to wake up eventfd, which currently
is skipped together with io_cqring_ev_posted() for non-SQPOLL IOPOLL.

Add an iopoll version of io_cqring_ev_posted(), duplicates a bit of
code, but they actually use different sets of wait queues may be for
better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 27a8c226abf8..91e517ad1421 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1713,6 +1713,16 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		if (waitqueue_active(&ctx->wait))
+			wake_up(&ctx->wait);
+	}
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, 1);
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				       struct task_struct *tsk,
@@ -2428,8 +2438,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	io_commit_cqring(ctx);
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted_iopoll(ctx);
 	io_req_free_batch_finish(ctx, &rb);
 
 	if (!list_empty(&again))
-- 
2.24.0

