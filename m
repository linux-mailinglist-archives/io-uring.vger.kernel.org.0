Return-Path: <io-uring+bounces-1449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 476EB89B4FC
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF3DD28145A
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D5010E9;
	Mon,  8 Apr 2024 01:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IraDnspl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395CE7FB
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538244; cv=none; b=plyuXh9B4rp+lDXhNvrNM+HhL4jwsoxhQEIKJq23L24sH43Dk+O6eVYRgybWWnL8KepGskgpAQOVaNKFcLqN5kSI753bnJ2cFouM9Qvf9VU9uE+DBRuFVIZAExbpHb7ZBvB5FPsiclTD0XgUUzI91y3kn7bPsnBU8IgFr0hesT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538244; c=relaxed/simple;
	bh=vAU4WfxbE5asbbG9GUSc01+FP7Xfa9wIs5vwZzbHqbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHANMsCiIzTrGSawI7cgq0CNElBZ6wV+k0p6cqkuTJdH+1K3Le1mWM2blq6aWDfa8Xa5h31j5eDZqlbF67Qj3+iqvjMMVGrjA0eoOgaHwvIDv7QEfLg+j5brVgtqmg+pPmzm02E12U7ZE09ow1eV7n6rGbVsti4H/Dyjc5xYm20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IraDnspl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qM6NHLD66oZBDenxTut2lYwJA+IsUNu2ImiCulPd8c0=;
	b=IraDnsplhX6kd0vkQOe7jKQ09NfkI4LQBoVJAIYUrmEUN6NbhJSMPFmfozcCT0BIQjDAqI
	ZJ28/Ud04BNF+SvblJe3/nNqpCDEM+IAJQnG8EILVh8SR27TNvgM5UDYxQqQP9PwA0dfUJ
	7u83J3hdBkFuwAyLXGWMr4aTfBrOZN0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-KFvhzIdkOgeYE-3bWPYPYQ-1; Sun,
 07 Apr 2024 21:03:57 -0400
X-MC-Unique: KFvhzIdkOgeYE-3bWPYPYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9DAB29AC02D;
	Mon,  8 Apr 2024 01:03:56 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B270210FD1B;
	Mon,  8 Apr 2024 01:03:54 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/9] io_uring: support user sqe ext flags
Date: Mon,  8 Apr 2024 09:03:15 +0800
Message-ID: <20240408010322.4104395-3-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

sqe->flags is u8, and now we have used 7 bits, so take the last one for
extending purpose.

If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
IORING_OP_URING_CMD.

io_slot_flags() return value is converted to `ULL` because the affected bits
are beyond 32bit now.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  6 ++++--
 include/uapi/linux/io_uring.h  | 13 +++++++++++++
 io_uring/filetable.h           |  2 +-
 io_uring/io_uring.c            | 14 +++++++++++++-
 io_uring/uring_cmd.c           |  3 ++-
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e72fa52f1e3..67347e5d06ec 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -435,6 +435,7 @@ struct io_tw_state {
 };
 
 enum {
+	/* 1st byte is from sqe->flags, and 2nd is from sqe ext_flags */
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
@@ -442,9 +443,10 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_SQE_EXT_FLAGS_BIT	= IOSQE_HAS_EXT_FLAGS_BIT,
 
-	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_BIT		= 8,
+	/* first 2 bytes are taken by user flags, shift it to not overlap */
+	REQ_F_FAIL_BIT		= 16,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a7f847543a7f..4847d7cf1ac9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	__pad2[1];
 		};
 		__u64	optval;
+		struct {
+			__u8	__pad4[15];
+			__u8	ext_flags;
+		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -123,6 +127,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_HAS_EXT_FLAGS_BIT,
 };
 
 /*
@@ -142,6 +147,11 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/*
+ * sqe ext flags carried in the last byte, or bit23~bit16 of
+ * sqe->uring_cmd_flags for IORING_URING_CMD.
+ */
+#define IOSQE_HAS_EXT_FLAGS	(1U << IOSQE_HAS_EXT_FLAGS_BIT)
 
 /*
  * io_uring_setup() flags
@@ -263,11 +273,14 @@ enum io_uring_op {
 
 /*
  * sqe->uring_cmd_flags		top 8bits aren't available for userspace
+ * bit31 ~ bit24		kernel internal usage
+ * bit23 ~ bit16		sqe ext flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
 #define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
+#define IORING_URING_CMD_EXT_MASK	0x00ff0000
 
 
 /*
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index b2435c4dca1f..d25247c9b9f5 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -43,7 +43,7 @@ io_fixed_file_slot(struct io_file_table *table, unsigned i)
 #define FFS_ISREG		0x2UL
 #define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
 
-static inline unsigned int io_slot_flags(struct io_fixed_file *slot)
+static inline unsigned long io_slot_flags(struct io_fixed_file *slot)
 {
 	return (slot->file_ptr & ~FFS_MASK) << REQ_F_SUPPORT_NOWAIT_BIT;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8df9ad010803..6d4def11aebf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -109,7 +109,8 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_HAS_EXT_FLAGS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
@@ -2080,6 +2081,17 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
 			return io_init_fail_req(req, -EINVAL);
+		if (sqe_flags & IOSQE_HAS_EXT_FLAGS) {
+			u32 sqe_ext_flags;
+
+			if (opcode != IORING_OP_URING_CMD)
+				sqe_ext_flags = READ_ONCE(sqe->ext_flags);
+			else
+				sqe_ext_flags = (READ_ONCE(sqe->uring_cmd_flags)
+					& IORING_URING_CMD_EXT_MASK) >> 16;
+			req->flags |= sqe_ext_flags << 8;
+		}
+
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
 			if (!def->buffer_select)
 				return io_init_fail_req(req, -EOPNOTSUPP);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 334d31dd6628..43b71f29e7b3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -202,7 +202,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->__pad1)
 		return -EINVAL;
 
-	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags) &
+		~IORING_URING_CMD_EXT_MASK;
 	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
 
-- 
2.42.0


