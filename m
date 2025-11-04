Return-Path: <io-uring+bounces-10366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CA7C320AA
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 20E1A4ED701
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60F73314CD;
	Tue,  4 Nov 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+cKpQ96"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79603328F0
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273339; cv=none; b=REl0gvAFN4xq30gM899TcmpOcA76fTXGWg7vIs3/jNtxIK8edJ9VCGeM5tb0rc2djeInQHndR6SNRXJaaPUsYT76w79pYATkpZ1uTV+c9geRbz7KsElS1//QPyJj4Wp9WGpNy58z2gtApFAPsKs0SqqpSiWC6fG3SmW1R/Sxkz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273339; c=relaxed/simple;
	bh=piDS9mMrnSecJsBeyZFy8IzPQGLIw91uE6VeNLk4QUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ1bGPjaAofefDBpdq+V6HcnYC344O/tV2NzqL8O9uHM6QdarkH31AoLvstLDtGEz0a9uuNeHn4nuUnMmN86I7k8sfQgVxiqhpCro37FNk6VVvMYZ426QjGAb8FKJxkbQyctWBx+9VAYb5//4b+cL9Q2So6J/0wX1OfgxD76gi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+cKpQ96; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762273336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vOlqN5gimYucMhmykdPEMaBFX4vtUUlmFK7LLyscj/4=;
	b=V+cKpQ96X21lm1QiitJWAS7NItSEg7N773R7WtkTT68SHCSFw2mVcFnKmsugEN2p09QFGE
	xENYJsZig98GGrdGzr99kxhTbXkGtQRwYzD3TejZkuYBwZbRcHKRxUvnnvApHip82GvTcp
	Arty5w2/4pfsTXUfuVI1FOZCABAcYYM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-Mg0-CK_jMCuYTFASAdjC9Q-1; Tue,
 04 Nov 2025 11:22:10 -0500
X-MC-Unique: Mg0-CK_jMCuYTFASAdjC9Q-1
X-Mimecast-MFC-AGG-ID: Mg0-CK_jMCuYTFASAdjC9Q_1762273329
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE4BD1955F02;
	Tue,  4 Nov 2025 16:22:08 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0C8B1956056;
	Tue,  4 Nov 2025 16:22:06 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/5] io_uring: bpf: add buffer support for IORING_OP_BPF
Date: Wed,  5 Nov 2025 00:21:19 +0800
Message-ID: <20251104162123.1086035-5-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-1-ming.lei@redhat.com>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add support for passing 0-2 buffers to BPF operations through
IORING_OP_BPF. Buffer types are encoded in sqe->bpf_op_flags
using dedicated 3-bit fields for each buffer.

Buffer 1 can be:
- None (no buffer)
- Plain user buffer (addr=sqe->addr, len=sqe->len)
- Fixed/registered buffer (index=sqe->buf_index, offset=sqe->addr,
  len=sqe->len)

Buffer 2 can be:
- None (no buffer)
- Plain user buffer (addr=sqe->addr3, len=sqe->optlen)

The sqe->bpf_op_flags layout (32 bits):
  Bits 31-24: BPF operation ID (8 bits)
  Bits 23-21: Buffer 1 type (3 bits)
  Bits 20-18: Buffer 2 type (3 bits)
  Bits 17-0:  Custom BPF flags (18 bits)

Using 3-bit encoding for each buffer type allows for future
expansion to 8 types (0-7). Currently types 0-2 are defined
(none/plain/fixed) and 3-7 are reserved for future use.

Buffer 2 currently only supports none/plain types because the
io_uring framework can only handle one fixed buffer per request
(via req->buf_index). The 3-bit encoding provides room for
future enhancements.

Buffer metadata (addresses, lengths) is stored in the extended
uring_bpf_data structure and is accessible to BPF programs with
readonly permissions. Buffer types can be extracted from the opf
field using IORING_BPF_BUF1_TYPE() and IORING_BPF_BUF2_TYPE()
macros.

Valid buffer combinations:
- 0 buffers
- 1 plain buffer
- 1 fixed buffer
- 2 plain buffers
- 1 fixed buffer + 1 plain buffer

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h | 45 +++++++++++++++++++++++--
 io_uring/bpf.c                | 63 ++++++++++++++++++++++++++++++++++-
 io_uring/uring_bpf.h          | 12 ++++++-
 3 files changed, 116 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 94d2050131ac..950f4cfbbf86 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -429,12 +429,53 @@ enum io_uring_op {
 #define IORING_SEND_VECTORIZED		(1U << 5)
 
 /*
- * sqe->bpf_op_flags		top 8bits is for storing bpf op
- *				The other 24bits are used for bpf prog
+ * sqe->bpf_op_flags layout (32 bits total):
+ *   Bits 31-24: BPF operation ID (8 bits, 256 possible operations)
+ *   Bits 23-21: Buffer 1 type (3 bits: none/plain/fixed/reserved)
+ *   Bits 20-18: Buffer 2 type (3 bits: none/plain/reserved)
+ *   Bits 17-0:  Custom BPF flags (18 bits, available for BPF programs)
+ *
+ * For IORING_OP_BPF, buffers are specified as follows:
+ *   Buffer 1 (plain):  addr=sqe->addr, len=sqe->len
+ *   Buffer 1 (fixed):  index=sqe->buf_index, offset=sqe->addr, len=sqe->len
+ *   Buffer 2 (plain):  addr=sqe->addr3, len=sqe->optlen
+ *
+ * Note: Buffer 1 can be none/plain/fixed. Buffer 2 can only be none/plain.
+ *       3-bit encoding for each buffer allows for future expansion to 8 types (0-7).
+ *       Currently only one fixed buffer per request is supported (buffer 1).
+ *       Valid combinations: 0 buffers, 1 plain, 1 fixed, 2 plain, 1 fixed + 1 plain.
  */
 #define IORING_BPF_OP_BITS	(8)
 #define IORING_BPF_OP_SHIFT	(24)
 
+/* Buffer type encoding in sqe->bpf_op_flags */
+#define IORING_BPF_BUF1_TYPE_SHIFT	(21)
+#define IORING_BPF_BUF2_TYPE_SHIFT	(18)
+#define IORING_BPF_BUF_TYPE_NONE	(0)	/* No buffer */
+#define IORING_BPF_BUF_TYPE_PLAIN	(1)	/* Plain user buffer */
+#define IORING_BPF_BUF_TYPE_FIXED	(2)	/* Fixed/registered buffer */
+#define IORING_BPF_BUF_TYPE_MASK	(7)	/* 3-bit mask */
+
+/* Helper macros to encode/decode buffer types */
+#define IORING_BPF_BUF1_TYPE(flags) \
+	(((flags) >> IORING_BPF_BUF1_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MASK)
+#define IORING_BPF_BUF2_TYPE(flags) \
+	(((flags) >> IORING_BPF_BUF2_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MASK)
+#define IORING_BPF_SET_BUF1_TYPE(type) \
+	(((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF1_TYPE_SHIFT)
+#define IORING_BPF_SET_BUF2_TYPE(type) \
+	(((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF2_TYPE_SHIFT)
+
+/* Custom BPF flags mask (18 bits available, bits 17-0) */
+#define IORING_BPF_CUSTOM_FLAGS_MASK	((1U << 18) - 1)
+
+/* Encode all components into sqe->bpf_op_flags */
+#define IORING_BPF_OP_FLAGS(op, buf1_type, buf2_type, flags) \
+	(((op) << IORING_BPF_OP_SHIFT) | \
+	 IORING_BPF_SET_BUF1_TYPE(buf1_type) | \
+	 IORING_BPF_SET_BUF2_TYPE(buf2_type) | \
+	 ((flags) & IORING_BPF_CUSTOM_FLAGS_MASK))
+
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
  * IORING_SEND_ZC_REPORT_USAGE was requested
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 8227be6d5a10..e837c3d57b96 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -11,8 +11,10 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/filter.h>
+#include <linux/uio.h>
 #include "io_uring.h"
 #include "uring_bpf.h"
+#include "rsrc.h"
 
 #define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
 
@@ -28,7 +30,7 @@ static inline unsigned char uring_bpf_get_op(unsigned int op_flags)
 
 static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)
 {
-	return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
+	return op_flags & IORING_BPF_CUSTOM_FLAGS_MASK;
 }
 
 static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_data *data)
@@ -36,18 +38,77 @@ static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_data *dat
 	return &bpf_ops[uring_bpf_get_op(data->opf)];
 }
 
+static int io_bpf_prep_buffers(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe,
+			       struct uring_bpf_data *data,
+			       unsigned int op_flags)
+{
+	u8 buf1_type, buf2_type;
+
+	/* Extract buffer configuration from bpf_op_flags */
+	buf1_type = IORING_BPF_BUF1_TYPE(op_flags);
+	buf2_type = IORING_BPF_BUF2_TYPE(op_flags);
+
+	/* Prepare buffer 1 */
+	if (buf1_type == IORING_BPF_BUF_TYPE_PLAIN) {
+		/* Plain user buffer: addr=sqe->addr, len=sqe->len */
+		data->buf1_addr = READ_ONCE(sqe->addr);
+		data->buf1_len = READ_ONCE(sqe->len);
+	} else if (buf1_type == IORING_BPF_BUF_TYPE_FIXED) {
+		/* Fixed buffer: index=sqe->buf_index, offset=sqe->addr, len=sqe->len */
+		req->buf_index = READ_ONCE(sqe->buf_index);
+		data->buf1_addr = READ_ONCE(sqe->addr);  /* offset within fixed buffer */
+		data->buf1_len = READ_ONCE(sqe->len);
+
+		/* Validate buffer index */
+		if (unlikely(!req->ctx->buf_table.nr))
+			return -EFAULT;
+		if (unlikely(req->buf_index >= req->ctx->buf_table.nr))
+			return -EINVAL;
+	} else if (buf1_type == IORING_BPF_BUF_TYPE_NONE) {
+		data->buf1_addr = 0;
+		data->buf1_len = 0;
+	} else {
+		return -EINVAL;
+	}
+
+	/* Prepare buffer 2 (plain only - io_uring only supports one fixed buffer) */
+	if (buf2_type == IORING_BPF_BUF_TYPE_PLAIN) {
+		/* Plain user buffer: addr=sqe->addr3, len=sqe->optlen */
+		data->buf2_addr = READ_ONCE(sqe->addr3);
+		data->buf2_len = READ_ONCE(sqe->optlen);
+	} else if (buf2_type == IORING_BPF_BUF_TYPE_NONE) {
+		data->buf2_addr = 0;
+		data->buf2_len = 0;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
 	unsigned int op_flags = READ_ONCE(sqe->bpf_op_flags);
 	struct uring_bpf_ops *ops;
+	int ret;
 
 	if (!(req->ctx->flags & IORING_SETUP_BPF))
 		return -EACCES;
 
+	if (uring_bpf_get_flags(op_flags))
+		return -EINVAL;
+
 	data->opf = op_flags;
 	ops = &bpf_ops[uring_bpf_get_op(data->opf)];
 
+	/* Prepare buffers based on buffer type flags */
+	ret = io_bpf_prep_buffers(req, sqe, data, op_flags);
+	if (ret)
+		return ret;
+
 	if (ops->prep_fn)
 		return ops->prep_fn(data, sqe);
 	return -EOPNOTSUPP;
diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
index c76eba887d22..c919931cb4b0 100644
--- a/io_uring/uring_bpf.h
+++ b/io_uring/uring_bpf.h
@@ -7,8 +7,18 @@ struct uring_bpf_data {
 	struct file     *file;
 	u32		opf;
 
+	/* Buffer 1 metadata - readable for bpf prog */
+	u32		buf1_len;		/* buffer 1 length, bytes 12-15 */
+	u64		buf1_addr;		/* buffer 1 address or offset, bytes 16-23 */
+
+	/* Buffer 2 metadata - readable for bpf prog (plain only) */
+	u64		buf2_addr;		/* buffer 2 address, bytes 24-31 */
+	u32		buf2_len;		/* buffer 2 length, bytes 32-35 */
+	u32		__pad;			/* padding, bytes 36-39 */
+
 	/* writeable for bpf prog */
-	u8              pdu[64 - sizeof(struct file *) - sizeof(u32)];
+	u8              pdu[64 - sizeof(struct file *) - 4 * sizeof(u32) -
+		2 * sizeof(u64)];
 };
 
 typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
-- 
2.47.0


