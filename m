Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402CC44C4A2
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 16:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhKJPwe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 10:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhKJPwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 10:52:34 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0270CC061767
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:45 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so2283755wmb.5
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wFwDI5TKV1uc/mnFIqy1ChqtJUGMY9/4l5J3GYvZrP4=;
        b=LGCOHMGx+t6nKdLAfAJg51KDXnCSWMMR8xZMdL1XND1ELqeVtShJF/9a3KhmMh6WUo
         G1dWe+OYaNroEisiErWQ6wo7oibaMjrbnSkjXpKI5BbcjVcjMEMFzNgEa57aUk4+HicL
         FO/O67C5Ba6u0pP57aWTOY8yKZl/gRdR7cZsbjyteo9ny4eJT1rmbp9WiY78qkxVGDaP
         koskI7dPlWzk1aoeohlcQ+sZKizAQEGazTOtAwjoa23tCEC1VJLvb9uLxtPDOH/FKZ1W
         FBInWtxhY1YP5Z1kIZ6JM/rZ7eswkEdIq3VTLyrnpKgQc60b4ywQt1Clm1FO4LDgnqKR
         c/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFwDI5TKV1uc/mnFIqy1ChqtJUGMY9/4l5J3GYvZrP4=;
        b=pgxeebgr5j+VPWP+589jDCW7YUi0BNS6XBH7udG57LB8iZtA5ZNPHc1LN5sx3qfvCc
         zm9qMLrfR9ZdTFRRPKwjyHBXSzYp/MDmILb/a5gsBdlLhJVSoO1fvQ97zZ+F/GxyJGxt
         DyjkHZrBZoTGI/2nwfg94MA9NFvDNwWXrdOmeUQ3dYnFquWejPJ5ATTjVbRTnKCT6jG0
         3XIL/75SaWUcjPYnnEz/fEjQ10tIX8U+E036X5Qi3tZYrnTkNSAI6CDJ9TLbA8zV08FV
         F1OUs6iYBdIoPKHWy9A4vBGidTR/hst36hM3eT6hMw4pyo71W3MjvNhMXzrBlHYmJBZz
         6C4w==
X-Gm-Message-State: AOAM531uhDs2O8M4Ejvv3Jzilv6nM1c9ENzS9WOhSbD2XD/fBOp04CT6
        FKIrXZ0ZAn+wIyKnLs2MKhq5u8IHN3A=
X-Google-Smtp-Source: ABdhPJxDhpxCv+VEoKiJZmywZbYGEtK8xcWvxFYRqarJ0HtBXRiaYPodzBmtF2vUZOFZEMkWD4PNCg==
X-Received: by 2002:a05:600c:4e94:: with SMTP id f20mr17388202wmq.119.1636559383785;
        Wed, 10 Nov 2021 07:49:43 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id l15sm108820wme.47.2021.11.10.07.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:49:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 4/4] io_uring: disable drain with cqe skip
Date:   Wed, 10 Nov 2021 15:49:34 +0000
Message-Id: <bcf7164f8bf3eb54b7bb7b4fd119907fa4d4d43b.1636559119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
References: <cover.1636559119.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Current IOSQE_IO_DRAIN implementation doesn't work well with CQE
skipping and it's not allowed, otherwise some requests might be not
executed until the ring is destroyed and the userspace would hang.

Let's fail all drain requests after seeing IOSQE_CQE_SKIP_SUCCESS at
least once. All drained requests prior to that will get run normally,
so there should be no stalls. However, even though such mixing wouldn't
lead to issues at the moment, it's still not allowed as the behaviour
may change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c0ea3bbb50a..f2c64f0f68d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -106,10 +106,10 @@
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
-			  IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-			  IOSQE_CQE_SKIP_SUCCESS)
+			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
-#define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS|IOSQE_BUFFER_SELECT|IOSQE_IO_DRAIN)
+#define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
@@ -339,6 +339,7 @@ struct io_ring_ctx {
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
+		unsigned int		drain_disabled: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -7123,8 +7124,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 		    !io_op_defs[opcode].buffer_select)
 			return -EOPNOTSUPP;
-		if (sqe_flags & IOSQE_IO_DRAIN)
+		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
+			ctx->drain_disabled = true;
+		if (sqe_flags & IOSQE_IO_DRAIN) {
+			if (ctx->drain_disabled)
+				return -EOPNOTSUPP;
 			io_init_req_drain(req);
+		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
-- 
2.33.1

