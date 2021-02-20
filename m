Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A864D3202AB
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 02:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBTBod (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 20:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBTBoc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 20:44:32 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DCEC061786
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 17:43:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id l12so11205558wry.2
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 17:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bpr7bcwv8IF7eBdQSjpooIpsgH7POu4TY/zR4rLnSNg=;
        b=aftkySGTa6EhCmZsBezmzVEcN8TgoKARQSPKf0GItUSSuTuCtRLNwUL3YeGCEAhY/i
         k4mkwwuuWO0ZEUIyjUQwEycmVgrhnv9nttroUezI5avKOqn1hs8yfcMiRzPGZfrJ+laU
         Vq/H9R0+303rFaCjlKif5hXcR0Els1pD3QNR6FbOLKZSllMWI5cPncbq9BL8S1yeppDL
         AGdiQHwsubiw9BVmaunB0UIRPGXRElBwC+/ZctQ2OE4o2NeMUXTBzImak6cTuHSYP5f7
         bkQPIDrBOA4oJMHXAS/Vfsrz0lclPbgRU10xfYwcXiMbD1VefkKjceib2ju2RubNI50H
         yxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bpr7bcwv8IF7eBdQSjpooIpsgH7POu4TY/zR4rLnSNg=;
        b=VteKP8kl3Dcb7ZAPbCDmm33+1tsPNhUwvaVzIlPxsgnv1GjZdKM0v7H5eGhLtmB1Mq
         naFTTkN0IeWC6Lb+UamS+SU1W5XCsTE6MjTYsvuWfaGqRp0MXnpKYzrG7jN9u9c4Pyzh
         4MIWFlpu/u31/ss2iSmh5R/+ZPEBw42cJgWT6JFf8JfqSk/c8KXIRpUx65VNuYYG7rpk
         ki89EdnS2Js1ksh+ThvkZDMsz15DSkP0WhIjCm487mX42J5o9oeU7LxKlAIiZNy+lU5c
         TaSkK4MJbb9IEAsYFPrlAy2PVS4EkigNHCPmCegVtXeR6vnq/jn+BcteufgcCH5PSHZc
         rDBQ==
X-Gm-Message-State: AOAM533G4uJIntULr4FSDd1wjGbRolLjV1WNye2Ni9PZxpNrAPaiz5ix
        p9aOQVanZ73g3aJ45/j6KgY=
X-Google-Smtp-Source: ABdhPJy/bfTCQods06HoF+I10ziCedly6ymAT169WEUFBX/S04x4a6LOCbKfZ7lOiAKlpGsZBBjQMg==
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr10538389wrf.424.1613785431333;
        Fri, 19 Feb 2021 17:43:51 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id f7sm16056595wrm.92.2021.02.19.17.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 17:43:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix leaving invalid req->flags
Date:   Sat, 20 Feb 2021 01:39:53 +0000
Message-Id: <67c634daf96050926d32cf9c692e53b9144e6f79.1613785076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613785076.git.asml.silence@gmail.com>
References: <cover.1613785076.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sqe->flags are subset of req flags, so incorrectly copied may span into
in-kernel flags and wreck havoc, e.g. by setting REQ_F_INFLIGHT.

Fixes: 5be9ad1e4287e ("io_uring: optimise io_init_req() flags setting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce5fccf00367..2bd10f89b837 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6687,8 +6687,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->result = 0;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
+		req->flags = 0;
 		return -EINVAL;
+	}
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
-- 
2.24.0

