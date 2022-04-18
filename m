Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288F3505EC2
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347793AbiDRT4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347790AbiDRT4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:23 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A682C66E
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k23so28742873ejd.3
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUTLGWFpT5QuNlBwe7w5l2Bg5o0bl5KxgiV3skdmM8c=;
        b=HCUHHNtpO+8KNBS9ymAyEEouMM5rZVjhXC8JRlSuWXKxpF411ZZvuHXLNZvE41/qU3
         EJWE4TfXHcBEdJ76C2FIbobRDl8bOdEpNq2YlqeF7pSUeQPkttLh5K/NdEVcA7oYig2C
         NDUk7L5wn5mgUxDaOW6TxIEDCuf55XUVSLqS7joMarAfM1iH1hVw6QX0bshoNrajcK+b
         1X4JfKhxxTIwqNP8P9lfp0fm5EK798O1VNpY4jLa0TP35aXpu9lYdjgxHszbJTH+YtQ9
         0yp9oHzvPo+rPNqm0e9BKZZX7j3dLbijm43Z4/k+aq+ALEC8E/7rTSk5uygdophh0WQ4
         rvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUTLGWFpT5QuNlBwe7w5l2Bg5o0bl5KxgiV3skdmM8c=;
        b=QFgu3A+A5wQOqJjHOuCQnNlIMbpYzMbaibTqXqw+wHiPVZywyQVplLQRv0MN+AveUr
         rnX/zYvrnF+QPkVNd3aZ+ObLyXTaZWgBIfLeoyKGJzaFst17nhp/LiUlZFWK+eR4/ynI
         mFIIKAVywZHuwpwtqCaFflKgB8C+sKAUXLI3Xf4NyJjhRngvp2oPcdErH7MQUExTY/01
         A0lYecElHWMOmwwfZOxaXq9KsjzrB5g22rzPLwZYE9L6NQrnsQfmC/FUC/JGHvYu0Bxc
         nsKFKEKiPkQ67SpvtBZgvqRnHXDTi+fTwv1vHf3lIy2xieMgY6TEyce6xbkhRjCMzfnc
         WbmA==
X-Gm-Message-State: AOAM5323VCkS15WduQ0kGWWM9xvVdTO7yUz2EcX6hnjk6g7oud3FgO8r
        lAk6pYJlc9fnwzGW2/nu9drVOAcj0M0=
X-Google-Smtp-Source: ABdhPJzJKPZrjSMKu7jHtUl42uB+v1JDFBfsoy66VTmLDNe58h2SqkWAxkwbmooV1zzK6B/S+UilkA==
X-Received: by 2002:a17:907:6095:b0:6e7:cc3f:c33d with SMTP id ht21-20020a170907609500b006e7cc3fc33dmr10706966ejc.570.1650311621699;
        Mon, 18 Apr 2022 12:53:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring: add a helper for putting rsrc nodes
Date:   Mon, 18 Apr 2022 20:51:14 +0100
Message-Id: <63fdd953ac75898734cd50e8f69e95e6664f46fe.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
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
index c26de427b05d..c67748eabbd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1325,6 +1325,11 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 
 #define IO_RSRC_REF_BATCH	100
 
+static void io_rsrc_put_node(struct io_rsrc_node *node, int nr)
+{
+	percpu_ref_put_many(&node->refs, nr);
+}
+
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
@@ -1335,21 +1340,21 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
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

