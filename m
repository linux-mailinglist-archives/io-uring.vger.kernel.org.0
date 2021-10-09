Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5844F427DD4
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 00:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJIWR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 18:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhJIWR0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 18:17:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C85DC061570
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 15:15:29 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r7so41660486wrc.10
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 15:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q6Zo/Oj/sX/6A5Z55bKm4IDFdHV8gCHt0EQy/lVMilk=;
        b=YUsomu59IrWa0dCFPwZpqx+TuKN6o4cazOgfs9IrZaUpsv1633x9aONOHCaQpPtCuI
         fWoT78CWPND9MmUolaId7cfuqF8VID4kjFa4LUxrwD5ExQlOl8O0C821B99lD84Nmemn
         1zgDInOYxy0T7aN1vUqGHhcqDz5YDkLz0fWbe8B9qj09TgJFK4JNfatc3M2PtCLllTfX
         k7lGmYPuCjlU19UJLsDa7PAbcCNGLFA6Z+PPwY1/ukJvS6CUd0xJNm2/auZ6ICgijTyV
         XDqMe9JTyMnfzn+A7TD9HBmYX759ShyMLt5UB8LIwRuLwAycd4rfNXktJ5KvEcNcapri
         opHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q6Zo/Oj/sX/6A5Z55bKm4IDFdHV8gCHt0EQy/lVMilk=;
        b=PhXZG8aforTcMrVwElzwR4pBKZvR4drWURpZlhPyoeX2sNTCGB0JenpxyzkXlQ1BnY
         vNox2BwNdNo2qIss22oR6hFbbWpswvaGm1ZEJsD+EwgX034kGMan7/gBKplymsUSs1uU
         X/E9fnd25KAGVAXkUbAWdRtGj/qYlvz7IK/BNPZmVvEo4gD6asJxgP9iNP7qJmZ3aEtL
         A+xXAFQFuODWeXvdCPXl+nfzoHrRA+EaAXbo/AWc3ThAliBF3vxQoSXGwBfG9QhamCZ7
         vIVg2GfL80kBfpQff55e9Q4vtv/NqF0i5GtzFJU5rWdN1jzJGUsA4l5IuN8b07bMWnCX
         Dulg==
X-Gm-Message-State: AOAM532b1OzkhT7vW23lPOqEwJ3STdTZ38OndI9ciIPY4nP+3DYt26+J
        YTv8t99xFD/ZsGyS9UdiS/HgEEggJds=
X-Google-Smtp-Source: ABdhPJzpmCXAMtEUN9YYobQNbe4xDIvuO8eAVjDFDQHWQL8yK33IqZLjqw7+rMsnJmK2ll6c6n68vQ==
X-Received: by 2002:a05:600c:3b82:: with SMTP id n2mr6749021wms.46.1633817727828;
        Sat, 09 Oct 2021 15:15:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id g70sm3261147wme.29.2021.10.09.15.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:15:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: optimise io_req_set_rsrc_node()
Date:   Sat,  9 Oct 2021 23:14:40 +0100
Message-Id: <67a25557b8a51e90bfd578447a6f1671911b05ae.1633817310.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633817310.git.asml.silence@gmail.com>
References: <cover.1633817310.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_set_rsrc_node() reloads loads req->ctx, however it's already in
registers in all use cases, so better to pass it as a parameter.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff732397264..24984b3f4a49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1175,10 +1175,9 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 	__io_req_set_refcount(req, 1);
 }
 
-static inline void io_req_set_rsrc_node(struct io_kiocb *req)
+static inline void io_req_set_rsrc_node(struct io_kiocb *req,
+					struct io_ring_ctx *ctx)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (!req->fixed_rsrc_refs) {
 		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
@@ -2843,7 +2842,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED) {
 		req->imu = NULL;
-		io_req_set_rsrc_node(req);
+		io_req_set_rsrc_node(req, ctx);
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
@@ -6772,7 +6771,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
-	io_req_set_rsrc_node(req);
+	io_req_set_rsrc_node(req, ctx);
 	return file;
 }
 
-- 
2.33.0

