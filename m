Return-Path: <io-uring+bounces-11405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DD0CF7B1E
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2A68A301D899
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980E63112D3;
	Tue,  6 Jan 2026 10:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTmagW66"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD0D1A9F85
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694330; cv=none; b=qiCH/+wsM72c1nZfi5+FbBYH4VynFjAaHbNpPM2NRQ0ND0DItnRjZslgQJGRp0VxOzpg7A3s0sGd+Q1JulUX+DYzflJfdTKcCSDlhpUv2vPLlG9Bp+3HYIVpgC9rszfuklGUVPrThCJh8F5SHR8kPL0Mgx/JsvSBOon+yVpW2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694330; c=relaxed/simple;
	bh=i2PdhXrGyLffwIu1tlplUo1cZxM2wCRYLHRDgiFtOOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL88Y/EI+TwLOMp8o+bl4H0tEfKQlUYc06evSJUEaRiC83om5GDW00CKBI2WbLi1aKoao76clXwML0lMhret0ILSXpnqNsG2c6TWhM/4EI8xBcDWpHRQj3gOGD1WqvQeRnyTzJZ5F4Ir3yh7ECIfp8yDWRCmFLJkt0U5XrRXGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTmagW66; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0CoCl3pwzQnkBwaXw//KhdOCmtrRWAx+8fj3oZUN7D0=;
	b=hTmagW66m26CKKnEIFkuR7Fos4diK+t6T0Ku+HTOYfkL2Mo/gg+kmNu7ppDWtx16ZHi2Uc
	zJ89uSZmo87lYTXh5InnhreeSwxEWUUEaB5aLwvuD6C65b7Na0xWhT+XNKeXahE/EAQb4d
	QGRVlFH4E6eGWw15rdRECK1bdYTeERg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-yJmehg8kOOqbqTgVTLFEOQ-1; Tue,
 06 Jan 2026 05:11:58 -0500
X-MC-Unique: yJmehg8kOOqbqTgVTLFEOQ-1
X-Mimecast-MFC-AGG-ID: yJmehg8kOOqbqTgVTLFEOQ_1767694317
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACC42195FCED;
	Tue,  6 Jan 2026 10:11:57 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B96DC19560AB;
	Tue,  6 Jan 2026 10:11:56 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 05/13] io_uring: bpf: extend io_uring with bpf struct_ops
Date: Tue,  6 Jan 2026 18:11:14 +0800
Message-ID: <20260106101126.4064990-6-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

io_uring can be extended with bpf struct_ops in the following ways:

1) add new io_uring operation from application
- one typical use case is for operating device zero-copy buffer, which
belongs to kernel, and not visible or too expensive to export to
userspace, such as supporting copy data from this buffer to userspace,
decompressing data to zero-copy buffer in Android case[1][2], or
checksum/decrypting.

[1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf

2) extend 64 byte SQE, since bpf map can be used to store IO data
   conveniently

3) communicate in IO chain, since bpf map can be shared among IOs,
when one bpf IO is completed, data can be written to IO chain wide
bpf map, then the following bpf IO can retrieve the data from this bpf
map, this way is more flexible than io_uring built-in buffer

4) pretty handy to inject error for test purpose

bpf struct_ops is one very handy way to attach bpf prog with kernel, and
this patch simply wires existed io_uring operation callbacks with added
uring bpf struct_ops, so application can define its own uring bpf
operations.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/bpf_op.c              | 231 ++++++++++++++++++++++++++++++++-
 io_uring/bpf_op.h              |  42 ++++++
 io_uring/io_uring.c            |   5 +
 io_uring/io_uring.h            |   6 +-
 6 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9ad389f0715b..62ff38b3ce1e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -8,6 +8,8 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+struct uring_bpf_ops_kern;
+
 enum {
 	/*
 	 * A hint to not wake right away but delay until there are enough of
@@ -276,6 +278,7 @@ struct io_ring_ctx {
 		struct io_rings		*rings;
 		struct percpu_ref	refs;
 
+		struct uring_bpf_ops_kern	*bpf_ops;
 		clockid_t		clockid;
 		enum tk_offsets		clock_offset;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 30406cfb2e21..441a1038a58a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		bpf_op_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -237,6 +238,9 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_SQE_MIXED		(1U << 19)
 
+/* Allow userspace to define io_uring operation by BPF prog */
+#define IORING_SETUP_BPF_OP		(1U << 20)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -422,6 +426,13 @@ enum io_uring_op {
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
 #define IORING_SEND_VECTORIZED		(1U << 5)
 
+/*
+ * sqe->bpf_op_flags		top 8bits is for storing bpf prog sub op
+ *				The other 24bits are used for bpf prog
+ */
+#define IORING_BPF_OP_BITS	8
+#define IORING_BPF_OP_SHIFT	24
+
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
  * IORING_SEND_ZC_REPORT_USAGE was requested
@@ -626,6 +637,7 @@ struct io_uring_params {
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
 #define IORING_FEAT_RW_ATTR		(1U << 16)
 #define IORING_FEAT_NO_IOWAIT		(1U << 17)
+#define IORING_FEAT_BPF			(1U << 18)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
index 2ab6f93bbad8..f616416652e9 100644
--- a/io_uring/bpf_op.c
+++ b/io_uring/bpf_op.c
@@ -3,24 +3,251 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/filter.h>
 #include <uapi/linux/io_uring.h>
 #include "io_uring.h"
 #include "bpf_op.h"
 
-int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+static inline unsigned char uring_bpf_get_op(u32 op_flags)
 {
-	return -EOPNOTSUPP;
+	return (unsigned char)(op_flags >> IORING_BPF_OP_SHIFT);
+}
+
+static inline unsigned int uring_bpf_get_flags(u32 op_flags)
+{
+	return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
 }
 
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	u32 opf = READ_ONCE(sqe->bpf_op_flags);
+	unsigned char bpf_op = uring_bpf_get_op(opf);
+	const struct uring_bpf_ops *ops;
+
+	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_OP)))
+		goto fail;
+
+	if (bpf_op >= IO_RING_MAX_BPF_OPS)
+		return -EINVAL;
+
+	ops = req->ctx->bpf_ops[bpf_op].ops;
+	data->opf = opf;
+	data->ops = ops;
+	if (ops && ops->prep_fn)
+		return ops->prep_fn(data, sqe);
+fail:
 	return -EOPNOTSUPP;
 }
 
+static int __io_uring_bpf_issue(struct io_kiocb *req)
+{
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	const struct uring_bpf_ops *ops = data->ops;
+	int ret = 0;
+
+	if (ops && ops->issue_fn) {
+		ret = ops->issue_fn(data);
+		if (ret == IOU_ISSUE_SKIP_COMPLETE)
+			return -EINVAL;
+	}
+	return ret;
+}
+
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return __io_uring_bpf_issue(req);
+}
+
 void io_uring_bpf_fail(struct io_kiocb *req)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	const struct uring_bpf_ops *ops = data->ops;
+
+	if (ops && ops->fail_fn)
+		ops->fail_fn(data);
 }
 
 void io_uring_bpf_cleanup(struct io_kiocb *req)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	const struct uring_bpf_ops *ops = data->ops;
+
+	if (ops && ops->cleanup_fn)
+		ops->cleanup_fn(data);
+}
+
+static const struct btf_type *uring_bpf_data_type;
+
+static int uring_bpf_ops_btf_struct_access(struct bpf_verifier_log *log,
+					const struct bpf_reg_state *reg,
+					int off, int size)
+{
+	const struct btf_type *t;
+
+	t = btf_type_by_id(reg->btf, reg->btf_id);
+	if (t != uring_bpf_data_type) {
+		bpf_log(log, "only read is supported\n");
+		return -EACCES;
+	}
+
+	if (off < offsetof(struct uring_bpf_data, pdu) ||
+			off + size > sizeof(struct uring_bpf_data))
+		return -EACCES;
+
+	return NOT_INIT;
+}
+
+static const struct bpf_verifier_ops io_bpf_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.is_valid_access = bpf_tracing_btf_ctx_access,
+	.btf_struct_access = uring_bpf_ops_btf_struct_access,
+};
+
+static int uring_bpf_ops_init(struct btf *btf)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, "uring_bpf_data", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	uring_bpf_data_type = btf_type_by_id(btf, type_id);
+	return 0;
+}
+
+static int uring_bpf_ops_check_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   const struct bpf_prog *prog)
+{
+	/*
+	 * All io_uring BPF ops callbacks are called in non-sleepable
+	 * context, so reject sleepable BPF programs.
+	 */
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int uring_bpf_ops_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	const struct uring_bpf_ops *uuring_bpf_ops;
+	struct uring_bpf_ops *kuring_bpf_ops;
+	u32 moff;
+
+	uuring_bpf_ops = udata;
+	kuring_bpf_ops = kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct uring_bpf_ops, id):
+		/* For id, this function has to copy it and return 1 to
+		 * indicate that the data has been handled by the struct_ops
+		 * type, or the verifier will reject the map if the value of
+		 * those fields is not zero.
+		 */
+		kuring_bpf_ops->id = uuring_bpf_ops->id;
+		return 1;
+	}
+	return 0;
+}
+
+static int io_bpf_prep_io(struct uring_bpf_data *data, const struct io_uring_sqe *sqe)
+{
+	return 0;
+}
+
+static int io_bpf_issue_io(struct uring_bpf_data *data)
+{
+	return 0;
+}
+
+static void io_bpf_fail_io(struct uring_bpf_data *data)
+{
+}
+
+static void io_bpf_cleanup_io(struct uring_bpf_data *data)
+{
+}
+
+static struct uring_bpf_ops __bpf_uring_bpf_ops = {
+	.prep_fn	= io_bpf_prep_io,
+	.issue_fn	= io_bpf_issue_io,
+	.fail_fn	= io_bpf_fail_io,
+	.cleanup_fn	= io_bpf_cleanup_io,
+};
+
+static struct bpf_struct_ops bpf_uring_bpf_ops = {
+	.verifier_ops = &io_bpf_verifier_ops,
+	.init = uring_bpf_ops_init,
+	.check_member = uring_bpf_ops_check_member,
+	.init_member = uring_bpf_ops_init_member,
+	.name = "uring_bpf_ops",
+	.cfi_stubs = &__bpf_uring_bpf_ops,
+	.owner = THIS_MODULE,
+};
+
+__bpf_kfunc_start_defs();
+__bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(data);
+
+	if (res < 0)
+		req_set_fail(req);
+	io_req_set_res(req, res, 0);
+}
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(uring_bpf_kfuncs)
+BTF_ID_FLAGS(func, uring_bpf_set_result)
+BTF_KFUNCS_END(uring_bpf_kfuncs)
+
+static const struct btf_kfunc_id_set uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &uring_bpf_kfuncs,
+};
+
+int io_bpf_alloc(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_BPF_OP))
+		return 0;
+
+	ctx->bpf_ops = kcalloc(IO_RING_MAX_BPF_OPS,
+			sizeof(struct uring_bpf_ops_kern), GFP_KERNEL);
+	if (!ctx->bpf_ops)
+		return -ENOMEM;
+	return 0;
+}
+
+void io_bpf_free(struct io_ring_ctx *ctx)
+{
+	kfree(ctx->bpf_ops);
+	ctx->bpf_ops = NULL;
+}
+
+static int __init io_bpf_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &uring_kfunc_set);
+	if (err) {
+		pr_warn("error while setting io_uring BPF kfuncs: %d\n", err);
+		return err;
+	}
+
+	err = register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf_ops);
+	if (err)
+		pr_warn("error while registering io_uring BPF struct ops: %d\n", err);
+
+	return err;
 }
+__initcall(io_bpf_init);
diff --git a/io_uring/bpf_op.h b/io_uring/bpf_op.h
index 7b61612c28c4..99708140992f 100644
--- a/io_uring/bpf_op.h
+++ b/io_uring/bpf_op.h
@@ -4,12 +4,54 @@
 
 struct io_kiocb;
 struct io_uring_sqe;
+struct uring_bpf_ops;
+
+/* Arbitrary limit, can be raised if need be */
+#define IO_RING_MAX_BPF_OPS 16
+
+struct uring_bpf_data {
+	void				*req_data;  /* not for bpf prog */
+	const struct uring_bpf_ops	*ops;
+	u32				opf;
+
+	/* writeable for bpf prog */
+	u8              pdu[64 - sizeof(void *) -
+		sizeof(struct uring_bpf_ops *) - sizeof(u32)];
+};
+
+typedef int (*uring_bpf_prep_t)(struct uring_bpf_data *data,
+				const struct io_uring_sqe *sqe);
+typedef int (*uring_bpf_issue_t)(struct uring_bpf_data *data);
+typedef void (*uring_bpf_fail_t)(struct uring_bpf_data *data);
+typedef void (*uring_bpf_cleanup_t)(struct uring_bpf_data *data);
+
+struct uring_bpf_ops {
+	unsigned short		id;
+	uring_bpf_prep_t	prep_fn;
+	uring_bpf_issue_t	issue_fn;
+	uring_bpf_fail_t	fail_fn;
+	uring_bpf_cleanup_t	cleanup_fn;
+};
+
+struct uring_bpf_ops_kern {
+	const struct uring_bpf_ops *ops;
+};
 
 #ifdef CONFIG_IO_URING_BPF_OP
 int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_uring_bpf_fail(struct io_kiocb *req);
 void io_uring_bpf_cleanup(struct io_kiocb *req);
+int io_bpf_alloc(struct io_ring_ctx *ctx);
+void io_bpf_free(struct io_ring_ctx *ctx);
+#else
+static inline int io_bpf_alloc(struct io_ring_ctx *ctx)
+{
+	return 0;
+}
+static inline void io_bpf_free(struct io_ring_ctx *ctx)
+{
+}
 #endif
 
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1ddd7a2c53a6..d6ac43bc0e63 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -105,6 +105,7 @@
 #include "rw.h"
 #include "alloc_cache.h"
 #include "eventfd.h"
+#include "bpf_op.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -353,6 +354,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
 
+	if (io_bpf_alloc(ctx))
+		goto free_ref;
+
 	return ctx;
 
 free_ref:
@@ -2867,6 +2871,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	io_napi_free(ctx);
+	io_bpf_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a790c16854d3..71b4a44dba49 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -48,7 +48,8 @@ struct io_ctx_config {
 			IORING_FEAT_RECVSEND_BUNDLE |\
 			IORING_FEAT_MIN_TIMEOUT |\
 			IORING_FEAT_RW_ATTR |\
-			IORING_FEAT_NO_IOWAIT)
+			IORING_FEAT_NO_IOWAIT |\
+			IORING_FEAT_BPF)
 
 #define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
 			IORING_SETUP_SQPOLL |\
@@ -69,7 +70,8 @@ struct io_ctx_config {
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
 			IORING_SETUP_CQE_MIXED |\
-			IORING_SETUP_SQE_MIXED)
+			IORING_SETUP_SQE_MIXED |\
+			IORING_SETUP_BPF_OP)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
-- 
2.47.0


