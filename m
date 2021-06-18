Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A313AD4DD
	for <lists+io-uring@lfdr.de>; Sat, 19 Jun 2021 00:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhFRWMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbhFRWMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 18:12:53 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092DCC061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 15:10:44 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f3-20020a0568301c23b029044ce5da4794so4553447ote.11
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 15:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AZb8uKvkEgm8dhG2qepKF8wvoUFP0ljSN2L0f1SY2m8=;
        b=1t4Ok03E4oXkhnKLA2PZNFYEZNWzxa4AMZNf9dLGIVhYKAiBza0WUzew/W6n73Jbq8
         0voRybQBArILqgUwH0HtMHvcJTaQ7/6xptT/jrK/4AaAFBOF/QoQYuS1LmeD+H+trxPg
         /zhRz9DjqHd8SVQ54U+0Pm1r8BHbzkETaPMO67LuX2yaAsN+cJziN/24CdKFt2aQ/+Yv
         JO5oXNJIAlhqZkzX7UspmJKLJqqqNxS2hvEqymrqpKumXnnyoOwpwFnyQG3FM+8a2bhX
         xdrXvSouttvG/zSue5Zzl7r8sFTxzL2LAODK/ChX4IrZmJ01AIOpyNKQrEI/sIE1rQ6Q
         Az2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZb8uKvkEgm8dhG2qepKF8wvoUFP0ljSN2L0f1SY2m8=;
        b=ptNRvQmgWn0TdHr2tE5XWSqLqOzTQ4nKe6dIkfARgiWfz2Z/X/xLAe5kJJWJ8sp5j3
         T3DzAYFegEMv1WO7tamak2OWqQB1sr4PXcZlU772al/2LM8KDpO77Up5g7n+dIAj5ADl
         eQYRMCwJzC+wBhMzXN9a3yD3rbITPSE8gxuy8s95/xWqfrn3g+RfiwWyEbFg3a7nkggd
         GRCf0ikCnWLsa078pHoswKa4DbArJk0DtzWHg4MAkSdWNMsBAOUxFJAJfnEjbzSe3b+a
         WJtupSRffSNtQQz3kaiVAn4DXvOtaHgB+rT6Hs0MPryglLlx0PTRyJl5CkZlFuCTlGyd
         W3dQ==
X-Gm-Message-State: AOAM530IGHZh7+HF3ZiHeeraJMwxcDULdHnFL0+yub8w9Rif2jEmkQ42
        zFAk/nsgeW0J27m3JIZJRCNwCUrOcEC1gA==
X-Google-Smtp-Source: ABdhPJzy5k5YOIve1TP8aGeDQct4gS+mTsL2z/o0o9nGpgyIQMi29yY1daNs1kieD+k0sKuskkkDPQ==
X-Received: by 2002:a9d:2f61:: with SMTP id h88mr9379405otb.190.1624054243202;
        Fri, 18 Jun 2021 15:10:43 -0700 (PDT)
Received: from p1.localdomain ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id w2sm654921oon.18.2021.06.18.15.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:10:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     samuel@codeotaku.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add IORING_SETUP_IGNORE_ONONBLOCK flag
Date:   Fri, 18 Jun 2021 16:10:40 -0600
Message-Id: <20210618221040.91075-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618221040.91075-1-axboe@kernel.dk>
References: <20210618221040.91075-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a file has O_NONBLOCK set, then io_uring will not arm poll and wait
for data/space if none is available. Instead, -EAGAIN is returned if
an IO attempt is made on the file descriptor.

For library use cases, the library may not be in full control of the
file descriptor, and hence cannot modify file flags through fcntl(2).
Or even if it can, it'd be inefficient and require 3 system calls to
check, set, and re-set.

If a ring is setup with IORING_SETUP_IGNORE_ONONBLOCK, that tells io_uring
to ignore O_NONBLOCK and arm poll to wait for data/space instead, just
like we would have if O_NONBLOCK wasn't set on the file descriptor.

Suggested-by: Samuel Williams <samuel@codeotaku.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 8 +++++---
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8637f591a6..214b8cd297cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2686,7 +2686,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 
 	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !(ctx->flags & IORING_SETUP_IGNORE_ONONBLOCK)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -4709,7 +4710,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
-	if (req->file->f_flags & O_NONBLOCK)
+	if ((req->file->f_flags & O_NONBLOCK) &&
+	    !(req->ctx->flags & IORING_SETUP_IGNORE_ONONBLOCK))
 		req->flags |= REQ_F_NOWAIT;
 
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
@@ -9755,7 +9757,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_IGNORE_ONONBLOCK))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1f9ac114b51..972fa742119b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_IGNORE_ONONBLOCK	(1U << 7)	/* ignore O_NONBLOCK */
 
 enum {
 	IORING_OP_NOP,
-- 
2.32.0

