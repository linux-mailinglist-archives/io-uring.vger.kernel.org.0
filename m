Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC79840C412
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 13:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhIOLFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 07:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhIOLFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 07:05:40 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F5BC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 04:04:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 140so1869815wma.0
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 04:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aGkOfyWSKRvhHFK7GxyU4tAUlG5lTmCWFHqwycyODGw=;
        b=oZAm9KTSEm59kzn0hZHWaw8WwLf3nh4NoiW79fIBixGnz7VwivxTuvARwjviBIGAR8
         yZq4ceENzu6iNLG+J5gYTcOdFWNeflBlf1wswrhEvT3w6GZQg4Ky1H4t+ma2u8bFdRQy
         dSe7hAQEYaoleKll0O6doNAqZiP6ck9MxA0xRC8Oj8Q8r9Cq6yGR3XfeFsYYJrAlsxg7
         OaVvh5Hf096JBbXeHOwsMuL5zsJkKyVy7T/urN+fYhwl7J2ZIF8H10XTne1bTQOljuKj
         0nOl4ZzthEqrs1LpF55Coz9sl1IoeN6fDqPy/7gY0lhcVvqWvFfWpQrlmmlEDzZ6q8cu
         CVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aGkOfyWSKRvhHFK7GxyU4tAUlG5lTmCWFHqwycyODGw=;
        b=5MlUGlADnjX2F6GH5jYId1bmp/nzahUvcnNLwvMh8TDHJ16y0CnLdG2zeaNNMqTpqp
         x5lc6P+ieFi1NckTyzwtG7edcgRikTLIn9djzKq7kHCodTuaOo3nJAXxs+ngw19079ps
         9hGdmf0kPdDT3LiYDm7cTBfItGZBXVN6zPqAR13dHNy0GqkAJPgaYybqjsDPdRfd5GYr
         pjVTNW0+cbLUBFvplZ5m8wxKS+Y9LG1Kaj9YS5Z9qWcpmE3hIwiez0PRb6rEuva4Nxg9
         2VNHJ9vyEz5HnBBcRlTyVdz5ypzp3xqCmcvxRsFxDg+y9EvpW5AhQl7EPXjxH63Cuafr
         664w==
X-Gm-Message-State: AOAM532hqGV+HitdivlT6/8o2bDBpWt6f8KqOy/5rjC7CiIZXmYriNZI
        WjEfWIaKUoqa07W+S5jZQgYr51I8Lgs=
X-Google-Smtp-Source: ABdhPJy2LueiH4bMPt1YV3ee9sEzTGp8olh1HphxF1aH/+yjZIl9ZH89h7gBeLyUvsu9e4rdkw/Gcg==
X-Received: by 2002:a1c:1b4f:: with SMTP id b76mr3664832wmb.161.1631703859741;
        Wed, 15 Sep 2021 04:04:19 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id g9sm4098986wmg.21.2021.09.15.04.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 04:04:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: optimise io_req_init() sqe flags checks
Date:   Wed, 15 Sep 2021 12:03:38 +0100
Message-Id: <dccfb9ab2ab0969a2d8dc59af88fa0ce44eeb1d5.1631703764.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOSQE_IO_DRAIN is quite marginal and we don't care too much about
IOSQE_BUFFER_SELECT. Save to ifs and hide both of them under
SQE_VALID_FLAGS check. Now we first check whether it uses a "safe"
subset, i.e. without DRAIN and BUFFER_SELECT, and only if it's not
true we test the rest of the flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f4dcdda9d4ae..511fb8052ae9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -103,9 +103,11 @@
 
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+#define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
+			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+
+#define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS|IOSQE_BUFFER_SELECT|IOSQE_IO_DRAIN)
+
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
 
@@ -7044,20 +7046,21 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->fixed_rsrc_refs = NULL;
 	req->task = current;
 
-	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
+	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
+		/* enforce forwards compatibility on users */
+		if (sqe_flags & ~SQE_VALID_FLAGS)
+			return -EINVAL;
+		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
+		    !io_op_defs[req->opcode].buffer_select)
+			return -EOPNOTSUPP;
+		if (sqe_flags & IOSQE_IO_DRAIN)
+			ctx->drain_active = true;
+	}
 	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
-	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select)
-		return -EOPNOTSUPP;
-	if (unlikely(sqe_flags & IOSQE_IO_DRAIN))
-		ctx->drain_active = true;
-
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
 		req->creds = xa_load(&ctx->personalities, personality);
@@ -10917,6 +10920,8 @@ static int __init io_uring_init(void)
 
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
+	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
+	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
-- 
2.33.0

