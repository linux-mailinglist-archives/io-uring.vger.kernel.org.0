Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CE590D74
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiHLIfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIfk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:40 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F356E1BE9D
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=sC6oBsYEFjtJzAxkKyLzp3l6tw1ZIHBKxL/2QAcAcGg=; b=IvgiPfj+aQIPwMW/a7gGciDFLe
        UqFGfth7QhTtH0bBNDs9yDC5OR0b16S0qfmjMdP5t/vYwmwTadfhDIkdt++ZVO0fVbzXACcPxceAz
        xyu4pvhSCiQNQ0StE+bU8thV8LaNC8gSNt671cRVN9XBOJLH0lQYB9s2lWizkVHXnqujtbiKml3wR
        F2XyxD66wkCE4Z1LqW7E+9nARe5dAoF4b4qVQzlZmOu05bg9Bq6xa4kOMg/Q5Ofko/Jr5gCBY0lYi
        vWulews/0bo2Rq0xb8JmKYPKWwnsOnZCqg1miuEZke3XlUo61dcBd5NyKUf50Au9l3FmGwn9NiT66
        +pId+lqdPzcawbRaJmI+IVQINRZd/MnP6H0f2MrbPlOt+mvmU98hOtlvijvTiksOXB9N95+DiN5dE
        1nmiTv+9+djYdAUNfdvy3aD5b5pueZg3scPS9KxEFDtpFc8tsKIDi3po7lc6zcVcYDZnCYN/2ByIB
        87UDATaRNKqPFe82GgOLRmIB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8m-009Jc9-MW; Fri, 12 Aug 2022 08:35:36 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 8/8] io_uring: introduce struct io_uring_sqe_{fsync,sfr,fallocate}
Date:   Fri, 12 Aug 2022 10:34:32 +0200
Message-Id: <07ade3e4e9182f0857e6206e6613063639f95dce.1660291547.git.metze@samba.org>
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

This allows us to use IO_URING_SQE_HIDE_LEGACY in io_uring/sync.c

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 48 +++++++++++++++++++++++++++++
 io_uring/io_uring.c           | 33 ++++++++++++++++++++
 io_uring/sync.c               | 58 ++++++++++++++++++++++++++---------
 3 files changed, 124 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 690b13229227..6428d97e14fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -132,6 +132,54 @@ struct io_uring_sqe {
 			__u64	u64_ofs48;
 			__u64	u64_ofs56;
 		} rw;
+
+		/* IORING_OP_FSYNC */
+		struct io_uring_sqe_fsync {
+			struct io_uring_sqe_hdr hdr;
+
+			__u64	offset;
+			__u64	u64_ofs16;
+			__u32	length;
+			__u32	flags;
+
+			struct io_uring_sqe_common common;
+
+			__u32	u32_ofs44;
+			__u64	u64_ofs48;
+			__u64	u64_ofs56;
+		} fsync;
+
+		/* IORING_OP_SYNC_FILE_RANGE */
+		struct io_uring_sqe_sfr {
+			struct io_uring_sqe_hdr hdr;
+
+			__u64	offset;
+			__u64	u64_ofs16;
+			__u32	length;
+			__u32	flags;
+
+			struct io_uring_sqe_common common;
+
+			__u32	u32_ofs44;
+			__u64	u64_ofs48;
+			__u64	u64_ofs56;
+		} sfr;
+
+		/* IORING_OP_FALLOCATE */
+		struct io_uring_sqe_fallocate {
+			struct io_uring_sqe_hdr hdr;
+
+			__u64	offset;
+			__u64	length;
+			__u32	mode;
+			__u32	u32_ofs28;
+
+			struct io_uring_sqe_common common;
+
+			__u32	u32_ofs44;
+			__u64	u64_ofs48;
+			__u64	u64_ofs56;
+		} fallocate;
 	};
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e3336621e667..893252701363 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4012,6 +4012,39 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ALIAS(48,		__u64, rw.u64_ofs48,	u64_ofs48);
 	BUILD_BUG_SQE_ALIAS(56,		__u64, rw.u64_ofs56,	u64_ofs56);
 
+	BUILD_BUG_SQE_HDR_COMMON(struct io_uring_sqe_fsync, fsync);
+	BUILD_BUG_SQE_LEGACY_ALIAS(8,	__u64, fsync.offset,	off);
+	BUILD_BUG_SQE_LEGACY_ALIAS(16,	__u64, fsync.u64_ofs16,	addr);
+	BUILD_BUG_SQE_ALIAS(16,		__u64, fsync.u64_ofs16,	u64_ofs16);
+	BUILD_BUG_SQE_LEGACY_ALIAS(24,	__u32, fsync.length,	len);
+	BUILD_BUG_SQE_LEGACY_ALIAS(28,	__u32, fsync.flags,	fsync_flags);
+	BUILD_BUG_SQE_LEGACY_ALIAS(44,	__u32, fsync.u32_ofs44,	splice_fd_in);
+	BUILD_BUG_SQE_ALIAS(44,		__u32, rw.u32_ofs44,	u32_ofs44);
+	BUILD_BUG_SQE_ALIAS(48,		__u64, rw.u64_ofs48,	u64_ofs48);
+	BUILD_BUG_SQE_ALIAS(56,		__u64, rw.u64_ofs56,	u64_ofs56);
+
+	BUILD_BUG_SQE_HDR_COMMON(struct io_uring_sqe_sfr, sfr);
+	BUILD_BUG_SQE_LEGACY_ALIAS(8,	__u64, sfr.offset,	off);
+	BUILD_BUG_SQE_LEGACY_ALIAS(16,	__u64, sfr.u64_ofs16,	addr);
+	BUILD_BUG_SQE_ALIAS(16,		__u64, sfr.u64_ofs16,	u64_ofs16);
+	BUILD_BUG_SQE_LEGACY_ALIAS(24,	__u32, sfr.length,	len);
+	BUILD_BUG_SQE_LEGACY_ALIAS(28,	__u32, sfr.flags,	fsync_flags);
+	BUILD_BUG_SQE_LEGACY_ALIAS(44,	__u32, sfr.u32_ofs44,	splice_fd_in);
+	BUILD_BUG_SQE_ALIAS(44,		__u32, sfr.u32_ofs44,	u32_ofs44);
+	BUILD_BUG_SQE_ALIAS(48,		__u64, sfr.u64_ofs48,	u64_ofs48);
+	BUILD_BUG_SQE_ALIAS(56,		__u64, sfr.u64_ofs56,	u64_ofs56);
+
+	BUILD_BUG_SQE_HDR_COMMON(struct io_uring_sqe_fallocate, fallocate);
+	BUILD_BUG_SQE_LEGACY_ALIAS(8,	__u64, fallocate.offset,	off);
+	BUILD_BUG_SQE_LEGACY_ALIAS(16,	__u64, fallocate.length,	addr);
+	BUILD_BUG_SQE_LEGACY_ALIAS(24,	__u32, fallocate.mode,		len);
+	BUILD_BUG_SQE_LEGACY_ALIAS(28,	__u32, fallocate.u32_ofs28,	rw_flags);
+	BUILD_BUG_SQE_ALIAS(28,		__u32, fallocate.u32_ofs28,	u32_ofs28);
+	BUILD_BUG_SQE_LEGACY_ALIAS(44,	__u32, fallocate.u32_ofs44,	splice_fd_in);
+	BUILD_BUG_SQE_ALIAS(44,		__u32, fallocate.u32_ofs44,	u32_ofs44);
+	BUILD_BUG_SQE_ALIAS(48,		__u64, fallocate.u64_ofs48,	u64_ofs48);
+	BUILD_BUG_SQE_ALIAS(56,		__u64, fallocate.u64_ofs56,	u64_ofs56);
+
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
 	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
diff --git a/io_uring/sync.c b/io_uring/sync.c
index 64e87ea2b8fb..ba8e3a91a1ab 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define IO_URING_SQE_HIDE_LEGACY 1
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -22,16 +23,25 @@ struct io_sync {
 	int				mode;
 };
 
-int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *_sqe)
 {
+	const struct io_uring_sqe_sfr *sqe = &_sqe->sfr;
 	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
-	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
+	/*
+	 * Note for compat reasons we don't check the following
+	 * to be zero:
+	 *
+	 * sqe->u64_ofs48
+	 * sqe->u64_ofs56
+	 */
+	if (unlikely(sqe->u64_ofs16 || sqe->common.buf_info || sqe->u32_ofs44))
 		return -EINVAL;
 
-	sync->off = READ_ONCE(sqe->off);
-	sync->len = READ_ONCE(sqe->len);
-	sync->flags = READ_ONCE(sqe->sync_range_flags);
+	sync->off = READ_ONCE(sqe->offset);
+	sync->len = READ_ONCE(sqe->length);
+	sync->flags = READ_ONCE(sqe->flags);
+
 	return 0;
 }
 
@@ -49,19 +59,28 @@ int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *_sqe)
 {
+	const struct io_uring_sqe_fsync *sqe = &_sqe->fsync;
 	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
-	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
+	/*
+	 * Note for compat reasons we don't check the following
+	 * to be zero:
+	 *
+	 * sqe->u64_ofs48
+	 * sqe->u64_ofs56
+	 */
+	if (unlikely(sqe->u64_ofs16 || sqe->common.buf_info || sqe->u32_ofs44))
 		return -EINVAL;
 
-	sync->flags = READ_ONCE(sqe->fsync_flags);
+	sync->flags = READ_ONCE(sqe->flags);
 	if (unlikely(sync->flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
 
-	sync->off = READ_ONCE(sqe->off);
-	sync->len = READ_ONCE(sqe->len);
+	sync->off = READ_ONCE(sqe->offset);
+	sync->len = READ_ONCE(sqe->length);
+
 	return 0;
 }
 
@@ -81,16 +100,25 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *_sqe)
 {
+	const struct io_uring_sqe_fallocate *sqe = &_sqe->fallocate;
 	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
-	if (sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
+	/*
+	 * Note for compat reasons we don't check the following
+	 * to be zero:
+	 *
+	 * sqe->u64_ofs48
+	 * sqe->u64_ofs56
+	 */
+	if (sqe->common.buf_info || sqe->u32_ofs28 || sqe->u32_ofs44)
 		return -EINVAL;
 
-	sync->off = READ_ONCE(sqe->off);
-	sync->len = READ_ONCE(sqe->addr);
-	sync->mode = READ_ONCE(sqe->len);
+	sync->off = READ_ONCE(sqe->offset);
+	sync->len = READ_ONCE(sqe->length);
+	sync->mode = READ_ONCE(sqe->mode);
+
 	return 0;
 }
 
-- 
2.34.1

