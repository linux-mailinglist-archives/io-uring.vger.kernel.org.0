Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF27C590D71
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiHLIfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIfV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AC711813
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=TsgtwajptdxMGTmu5bVJE1WEzLCihCl0Umpf54+PXIg=; b=TzEq9S4d3xGLQKIyJ28b4qUyx4
        qbR1xGIpmpBhnXZAkaF/FoaOj8aK939JOaFJhgP8TlTQp+NFLEvCDipla4mqeHPDYCPcj8svuP2RY
        ItlkJ9gi1YdRoPOZerFrnq/mNBSLFMa86m+Po+u8P8iqWRsA8wcKKEfOGCdhtblOs29iAy4JGbNk7
        S5xjlUfO8nAcWYnb48jhpPSi7TXElU4KZBaNcHzvgKY93MC7/kPfdZ60tDlfiDpNWJP9RFj340/mT
        mZo45ev6QMi4sl7BmjUmbNB9TtZjcrIhy9wJDgDw+Szd7nygo+93ZY/zY4hdv+I9QSDWWL5mrii82
        Cnr1+AUhVMjM6PWs8tk2LR+90uxnWYZHNfrp1z1o8r3RC+roTx7V/u0eGwNT76Oithkz4mKWHSD+5
        nndLkISi1PpPSqTnjlJI1avR/TlqbJhdyuvRXhaZnGTORoT1mwtL6xGJbZRyKXgOHoOnkkwwt4AtN
        /n5zk5xHXuYvx5wRpGwUt4Xt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8R-009Jbl-Je; Fri, 12 Aug 2022 08:35:16 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 5/8] io_uring: only access generic struct io_uring_sqe elements in io_uring.c
Date:   Fri, 12 Aug 2022 10:34:29 +0200
Message-Id: <cc6807c4bdd438218cc6e2240b970799dd15a834.1660291547.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660291547.git.metze@samba.org>
References: <cover.1660291547.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 60426265ee9f..f82173bde393 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -39,6 +39,7 @@
  * Copyright (C) 2018-2019 Jens Axboe
  * Copyright (c) 2018-2019 Christoph Hellwig
  */
+#define IO_URING_SQE_HIDE_LEGACY 1
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -1837,10 +1838,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	u8 opcode;
 
 	/* req is partially pre-initialised, see io_preinit_req() */
-	req->opcode = opcode = READ_ONCE(sqe->opcode);
+	req->opcode = opcode = READ_ONCE(sqe->hdr.opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-	req->cqe.user_data = READ_ONCE(sqe->user_data);
+	req->flags = sqe_flags = READ_ONCE(sqe->hdr.flags);
+	req->cqe.user_data = READ_ONCE(sqe->common.user_data);
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
@@ -1857,7 +1858,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
 			if (!def->buffer_select)
 				return -EOPNOTSUPP;
-			req->buf_index = READ_ONCE(sqe->buf_group);
+			req->buf_index = READ_ONCE(sqe->common.buf_info);
 		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
@@ -1881,7 +1882,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	if (!def->ioprio && sqe->ioprio)
+	if (!def->ioprio && sqe->hdr.ioprio)
 		return -EINVAL;
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -1889,7 +1890,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (def->needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
-		req->cqe.fd = READ_ONCE(sqe->fd);
+		req->cqe.fd = READ_ONCE(sqe->hdr.fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
@@ -1902,7 +1903,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	personality = READ_ONCE(sqe->personality);
+	personality = READ_ONCE(sqe->common.personality);
 	if (personality) {
 		int ret;
 
@@ -3909,11 +3910,11 @@ static int __init io_uring_init(void)
 	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, aname)
 
 #define BUILD_BUG_SQE_LEGACY(eoffset, etype, lname) \
-	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, sizeof(etype), lname)
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, sizeof(etype), legacy.lname)
 #define BUILD_BUG_SQE_LEGACY_SIZE(eoffset, esize, lname) \
-	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, esize, lname)
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, esize, legacy.lname)
 #define BUILD_BUG_SQE_LEGACY_ALIAS(eoffset, etype, ename, lname) \
-	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, lname)
+	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, legacy.lname)
 
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe_hdr) != 8);
 	BUILD_BUG_SQE_HDR_ELEM(0,  __u8,   opcode);
-- 
2.34.1

