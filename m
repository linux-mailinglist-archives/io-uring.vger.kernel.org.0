Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8F54F38A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381220AbiFQIts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381265AbiFQIts (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFDE694B0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ej4so1329207edb.7
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYKWq+KGlgwf5IPJ3VD5XpYLXdGaLVBpMxjUxYcqacQ=;
        b=QNX/vrMaKXZyYicIu1UG0Fsixi5bJAhNAnmMHWQq66JOrndZk6rhDRtBCXsM9dUKGq
         VU0zsvFikxIGohmR4u80/TQYYGWe+XKiDzZbzgLJzzGa+hs5BIeaPa9RMbmaVXi3rdA0
         nP6nSDZWnEBCCW7VghoFCvQ9SkU3kSKc22mne2VRyj5JtwiXGoui0zBFdPX07WHj830r
         5yQqfSoTXLImt1tQxLUb16FvsrWFiAswFoBd5WSKWU/0a1Z6P1zLFvV9Kf12XE6600ri
         V2wsSG+CKVvKvIJJ+HgPTd07KN3jEPiTOvWyyBhn/+676mm6iXjgIwAcWA3njJYB4P8A
         YVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYKWq+KGlgwf5IPJ3VD5XpYLXdGaLVBpMxjUxYcqacQ=;
        b=THCvCMnnqLja8Ge5X+GvbSPavoWRb2WGghBkakpGM2UPnnNHPmNTs7ndlEjjeIPRTw
         ZvmgMT5Mx+qIyMI55NLQpwD389epDOSAt5xkroVUH6RrJIAxJ0r2su3jJTKy8VXuThxr
         ERXTXW13PpVH+y8vRBStmN6fsDDllADp26VpUpNYjwZ9MlNB91btWyzvVdZDzFlY89D9
         ALgfoaSIFa1yJoL811Q8I5bMDkKral+wUT9i4J7zSCLF8Jr84yZ/yA8wW+vzYLxIQ2wi
         QWxpdRMf29x5SOQ9NdkxN+AG19J6bLy5kFcDxD2wDL+RF8Fjoe3lPTdjmcjeFEsXS3Qx
         xBmg==
X-Gm-Message-State: AJIora9jF/K1g79JSlQrGy0LHwlycBjavlNCL1+8fFtGP1cyIBrixx6l
        SE20YbTUOWIW6Yzh4dlVbqKCmUOQ61A2qg==
X-Google-Smtp-Source: AGRyM1s7ebSN2DT5vzTzdr2wuFMl36x0sq8MRiaDUVUGyLv87MNPOWVqvCSHghmg28I0HNA4RKS4OQ==
X-Received: by 2002:a05:6402:3514:b0:431:7164:f1d9 with SMTP id b20-20020a056402351400b004317164f1d9mr10870604edd.99.1655455784981;
        Fri, 17 Jun 2022 01:49:44 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/6] io_uring: change ->cqe_cached invariant for CQE32
Date:   Fri, 17 Jun 2022 09:48:05 +0100
Message-Id: <1ee1838cba16bed96381a006950b36ba640d998c.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
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

With IORING_SETUP_CQE32 ->cqe_cached doesn't store a real address but
rather an implicit offset into cqes. Store the real cqe pointer and
increment it accordingly if CQE32.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 15 ++++++++++-----
 io_uring/io_uring.h |  8 ++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263d7e4f1b41..11b4b5040020 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -698,11 +698,8 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
-	unsigned int shift = 0;
 	unsigned int free, queued, len;
 
-	if (ctx->flags & IORING_SETUP_CQE32)
-		shift = 1;
 
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
@@ -712,11 +709,19 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
 	if (!len)
 		return NULL;
 
-	ctx->cached_cq_tail++;
+	if (ctx->flags & IORING_SETUP_CQE32) {
+		off <<= 1;
+		len <<= 1;
+	}
+
 	ctx->cqe_cached = &rings->cqes[off];
 	ctx->cqe_sentinel = ctx->cqe_cached + len;
+
+	ctx->cached_cq_tail++;
 	ctx->cqe_cached++;
-	return &rings->cqes[off << shift];
+	if (ctx->flags & IORING_SETUP_CQE32)
+		ctx->cqe_cached++;
+	return &rings->cqes[off];
 }
 
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd29d91c2175..f1b3e765495b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -24,14 +24,10 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
 		struct io_uring_cqe *cqe = ctx->cqe_cached;
 
-		if (ctx->flags & IORING_SETUP_CQE32) {
-			unsigned int off = ctx->cqe_cached - ctx->rings->cqes;
-
-			cqe += off;
-		}
-
 		ctx->cached_cq_tail++;
 		ctx->cqe_cached++;
+		if (ctx->flags & IORING_SETUP_CQE32)
+			ctx->cqe_cached++;
 		return cqe;
 	}
 
-- 
2.36.1

