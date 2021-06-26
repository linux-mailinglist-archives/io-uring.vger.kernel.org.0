Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ADD3B501D
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFZUnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhFZUnl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:41 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4102CC061574
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u20so3325002wmq.4
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IrankBGgA+mLMv9lEiDtSHWFXPxzrem4PXNRtSiWvpI=;
        b=ZVk3EsUBZL1kDNuT61zJb4Y3wSi0NLDdJwLCDCQEs74mmSXa9VuBwTX+iYwSIG37mN
         3j0RzTw3AwaZt2R0Gzc3rgJ49bK5Xbuz22nPZD2HRJf9QASQzZYRJV/6W53SZ4ZMVoLy
         AOBzSKwq6GorKcEu716IiZt5hh69gXgPUhAPJW/2p/mGMIjfze/dECrLpGaOGF9xfhx9
         S+1Eo0X9u7vidr0viPN7KZcxGxpxBrr603n7YgbSU/rFRa3RvyEArE7T2Pgs7S+DhAHp
         NH5OohCJWLEAzV6u4UlBoQ15gji9PJkO3OfMBIajBgEIrJvYmflBWCIVjRoK+y8vCp2K
         qg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IrankBGgA+mLMv9lEiDtSHWFXPxzrem4PXNRtSiWvpI=;
        b=sXzdBF/gPMza+FSVf7InyU7VGlrtCW8LqsQj6Gw0XVVgccG5d05ZbPuvYStj9PDlAN
         /FiWHbYeahjr77gJycp2F79Y1P1tzTcJkGnIIpmZRaf+5otbLJIzERpQ397EZ74PZVx2
         0HqRjvFXB2vVUm8xMgJl05z01L6n2Io3fOm7u6X+Gtk4N7rIOAEabOkcZ5KmBBUdM6Bn
         OtdK5cRcRgjxdtS0uJMj3kacr4Pvc6W3hmLZ5xMtLiTMqolR7DSu6rBzDMNRxgjiHTpy
         Ed0iE3cjU4w2W7nLVcWzb+8bAyRi6+DMtahJDBLz6PudbWQ6k1yLI4YO5twrKtx/tB+K
         MjqQ==
X-Gm-Message-State: AOAM5304r5KFftTs04UTN+b2eYNNGAWfHoodAqfw6xUMVGiZ+kEq4zCd
        SEqcTFztVWMn2xE9bAVVzmo=
X-Google-Smtp-Source: ABdhPJy+ToNcPB6xWyCidmSkgl+FsZyJYmy9ZSS7cpRF/+/GZfWcImpiG/Z6u2YG0zn8Y/SzVsE12A==
X-Received: by 2002:a1c:1dd1:: with SMTP id d200mr1961691wmd.82.1624740074890;
        Sat, 26 Jun 2021 13:41:14 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: optimise hot path restricted checks
Date:   Sat, 26 Jun 2021 21:40:47 +0100
Message-Id: <22bf70d0a543dfc935d7276bdc73081784e30698.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move likely/unlikely from io_check_restriction() to specifically
ctx->restricted check, because doesn't do what it supposed to and make
the common path take an extra jump.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 953bdc41d018..4dd2213f5454 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6702,7 +6702,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
-	if (!ctx->restricted)
+	if (likely(!ctx->restricted))
 		return true;
 
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
@@ -6745,7 +6745,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
-	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
+	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-- 
2.32.0

