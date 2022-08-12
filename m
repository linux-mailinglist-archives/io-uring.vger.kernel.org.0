Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B306590D73
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiHLIfj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2E214088
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=9vLR9I/s/Gt9S7/C2keS2sfOrL5iuoZP7IGqkr6U+V4=; b=J4oDItYSNCuRyPCkOlimzoX3sn
        0TdJWOCPD5DmtH9IMKwkE4Rhemx2LEQUkEFJnfO7pDwHvPBrpuPd+HSsCqgpXixjuRIb9h8n48yM6
        G3eu/luBKeFTqPC5Krnr3k4UQpgNZSxO9OrmBzV/Oc9k4/yUQCaO/A6jjNXpsKS/QFEnqsJE3eerD
        yLBrzAYNXDI5EAeLm61LmyRCg4aC5h7k7+jlbpaVAQtYCNrJF5Js+Uv1djDAeRUTDsJQxp0289g8x
        E6RNulzzMa919Xlu07JrNmk94rWZ/vSJcyshnqPACJ+wRzC6X4t3L+W7t4ZW/SyqvnGHM8NnEnv07
        zrYM5kuvtNcDS8nEY8HWOrS/TpFySIy2ZH/RPS/ETR0Ht0er514B4qB284uDLKNR/h1dGQItdQcRs
        lkw4Q+eGpAHmCGyNrRaB9D5NZ9ulGiBv42+8XPPviltVcub0f6cJeCv41sif9D2KbVQxv0hkbRpbY
        VSRHb2hRnkDH3kBwcpi5yuoK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8g-009Jc1-1h; Fri, 12 Aug 2022 08:35:30 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 7/8] io_uring: introduce struct io_uring_sqe_rw for all io_prep_rw() using opcodes
Date:   Fri, 12 Aug 2022 10:34:31 +0200
Message-Id: <03b3026be552fe5ddb36c281d75881c3b887c89b.1660291547.git.metze@samba.org>
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

This is the start to use opcode specific struct io_uring_sqe layouts.
It hopefully make it much easier to maintain the struct io_uring_sqe.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 16 ++++++++++++++++
 io_uring/io_uring.c           |  9 +++++++++
 io_uring/rw.c                 | 26 +++++++++++++++++++-------
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4dcad4929bc7..690b13229227 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -116,6 +116,22 @@ struct io_uring_sqe {
 			__u64	u64_ofs48;
 			__u64	u64_ofs56;
 		};
+
+		/* IORING_OP_{READV,WRITEV,READ_FIXED,WRITE_FIXED,READ,WRITE} */
+		struct io_uring_sqe_rw {
+			struct io_uring_sqe_hdr hdr;
+
+			__u64	offset;
+			__u64	buffer_addr;
+			__u32	length;
+			__u32	flags;
+
+			struct io_uring_sqe_common common;
+
+			__u32	u32_ofs44;
+			__u64	u64_ofs48;
+			__u64	u64_ofs56;
+		} rw;
 	};
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8e1a8800b252..e3336621e667 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4003,6 +4003,15 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_LEGACY_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_LEGACY(56, __u64,  __pad2);
 
+	BUILD_BUG_SQE_HDR_COMMON(struct io_uring_sqe_rw, rw);
+	BUILD_BUG_SQE_LEGACY_ALIAS(8,	__u64, rw.offset,	off);
+	BUILD_BUG_SQE_LEGACY_ALIAS(16,	__u64, rw.buffer_addr,	addr);
+	BUILD_BUG_SQE_LEGACY_ALIAS(24,	__u32, rw.length,	len);
+	BUILD_BUG_SQE_LEGACY_ALIAS(28,	__u32, rw.flags,	rw_flags);
+	BUILD_BUG_SQE_ALIAS(44,		__u32, rw.u32_ofs44,	u32_ofs44);
+	BUILD_BUG_SQE_ALIAS(48,		__u64, rw.u64_ofs48,	u64_ofs48);
+	BUILD_BUG_SQE_ALIAS(56,		__u64, rw.u64_ofs56,	u64_ofs56);
+
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
 	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3d732b19b760..5612b03af997 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define IO_URING_SQE_HIDE_LEGACY 1
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -33,15 +34,16 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
 
-int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *_sqe)
 {
+	const struct io_uring_sqe_rw *sqe = &_sqe->rw;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
 	int ret;
 
-	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
+	rw->kiocb.ki_pos = READ_ONCE(sqe->offset);
 	/* used for fixed read/write too - just read unconditionally */
-	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->buf_index = READ_ONCE(sqe->common.buf_info);
 
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED) {
@@ -55,7 +57,7 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
 
-	ioprio = READ_ONCE(sqe->ioprio);
+	ioprio = READ_ONCE(sqe->hdr.ioprio);
 	if (ioprio) {
 		ret = ioprio_check_cap(ioprio);
 		if (ret)
@@ -66,9 +68,19 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 
-	rw->addr = READ_ONCE(sqe->addr);
-	rw->len = READ_ONCE(sqe->len);
-	rw->flags = READ_ONCE(sqe->rw_flags);
+	rw->addr = READ_ONCE(sqe->buffer_addr);
+	rw->len = READ_ONCE(sqe->length);
+	rw->flags = READ_ONCE(sqe->flags);
+
+	/*
+	 * Note for compat reasons we don't check the following
+	 * to be zero:
+	 *
+	 * sqe->u32_ofs44
+	 * sqe->u64_ofs48
+	 * sqe->u64_ofs56
+	 */
+
 	return 0;
 }
 
-- 
2.34.1

