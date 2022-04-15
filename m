Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F550312F
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbiDOVLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245670AbiDOVLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCA6AD103
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s25so10624489edi.13
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eKjJ8fQrqV2IPByYLHFgnKn4p3KcHjXDSyza97rq/aw=;
        b=VRE0R7cA1K0Z5zl/UiGGQ+DWbPB1nIzQO0Kftqt+XnzF2fJTt+08oIVEOennX4d2Uj
         DNLX/xmsyIj/gwT0vnGBARu6cKl+Rz+mV064FpoRENabQ0yfXlAb8zDTxLkbZkymH52F
         IkVljCBJmTZVvWr044ef00VoKfbPL0H9ymhuMrcLI2gV5j11mRd+ObMCi3SZU0ChSu+I
         ciRjEnLZdMhVt6VnKhoK7vkgevl+pLUTuG3qHqL8Dxh6H9tUaC3j3/FfEKB7zUhFcVfj
         gLYJFPmyvWwThxEAcZMtnbFN7V7e+DvM93zOE527mv5henVgVHYjGJdB0b+9p2RMhJbG
         qkHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eKjJ8fQrqV2IPByYLHFgnKn4p3KcHjXDSyza97rq/aw=;
        b=PNszXqcIK2suCF7RNHXacrGvOLIdjsZrD0spNHFmHG6DOpKlFZeIqO4B+JRsIUeaHw
         mPqdRHvJwqE+E9koefd8+EbC4FhZ0faqTKpom4D8wjbWm9QomgKYyXLZPSu0C4MZUtt1
         84cny0aHl5y/bxa9QOOQyU6oM6G+rLnv1C7k2AjctmfB1MPCDWDolN8OG84DN5DM5pQO
         q0efhUXBr02+VD/+PZyO59gpPnapLO8uvoNoOwS8yaIa+6yL2rHvlbZ3EuV6YXiq0YYq
         JT4T+yv+0DoRorKXOHGvdH1bVfilcvPLoTrIeVZb0FM1BAe8mxOux8MQvp/JBR+Ie6q3
         39JA==
X-Gm-Message-State: AOAM5331YI+SNeqN5lrPW1Fm/kK/Yh5zR/is1owCsz5EjFXMbQNYVdtx
        Zb6pg0/Sqig8Uz3fEEMClTTlgn2qzr0=
X-Google-Smtp-Source: ABdhPJyZrF5OR9aM+kX+1r8g+7bXKSBpALnmA3jj9P8+tZmyEWzpyYFzUywZnjdDSBXy47lHSn/k+A==
X-Received: by 2002:a05:6402:183:b0:410:fde:887a with SMTP id r3-20020a056402018300b004100fde887amr955701edv.243.1650056952360;
        Fri, 15 Apr 2022 14:09:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 02/14] io_uring: add a hepler for putting rsrc nodes
Date:   Fri, 15 Apr 2022 22:08:21 +0100
Message-Id: <865313e8a7eac34b6c01c047a4af6900eb6337ee.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

Add a simple helper to encapsulating dropping rsrc nodes references,
it's cleaner and will help if we'd change rsrc refcounting or play with
percpu_ref_put() [no]inlining.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bc3b20b7f85..b24d65480c08 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1327,6 +1327,11 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 
 #define IO_RSRC_REF_BATCH	100
 
+static void io_rsrc_put_node(struct io_rsrc_node *node, int nr)
+{
+	percpu_ref_put_many(&node->refs, nr);
+}
+
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
@@ -1337,21 +1342,21 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 		if (node == ctx->rsrc_node)
 			ctx->rsrc_cached_refs++;
 		else
-			percpu_ref_put(&node->refs);
+			io_rsrc_put_node(node, 1);
 	}
 }
 
 static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	if (req->rsrc_node)
-		percpu_ref_put(&req->rsrc_node->refs);
+		io_rsrc_put_node(req->rsrc_node, 1);
 }
 
 static __cold void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	if (ctx->rsrc_cached_refs) {
-		percpu_ref_put_many(&ctx->rsrc_node->refs, ctx->rsrc_cached_refs);
+		io_rsrc_put_node(ctx->rsrc_node, ctx->rsrc_cached_refs);
 		ctx->rsrc_cached_refs = 0;
 	}
 }
-- 
2.35.2

