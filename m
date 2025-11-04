Return-Path: <io-uring+bounces-10365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E027BC3209E
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAF51461A94
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17220331A61;
	Tue,  4 Nov 2025 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cds+Fc3z"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE25A3314D9
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273333; cv=none; b=rR4asYrWcnkuJAjdeM1Y+WYMaHao6fxNIcvzKeIQH1IQvfzUHOGmzUKvZ2tZkrgCuUIB59aNXlXtP0fTY2zcA8yNGY5VXMtr2KHRXXZBQAslaCCHahCnLaH1vV0XSDTBP2gIip4FCHWhQvVFBv7srxsafStNuolAaXZA/7N9IN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273333; c=relaxed/simple;
	bh=VRR7QgQy//oj55GN5t6vFdl6yw9BRDDdYhFjfZji3f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjJDwArz9cVOicwdomk4GPuU2bgzj7DIrB0hYCZp2ss+K80gNILDEdVIrI/xODRf/N4KpoDifw3rw3mDWytcdez92WUbAoat0ssAZ3sRwlOhSeNjTNGV8mllcYQizIuRaGjM2hEfC26AzMdW8LlqvM71H3EYSlYvaQAmYka7XF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cds+Fc3z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762273328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXLtYxxNbz0Gs1bth1YuFTX3+tNUPcimE5yMrYFZ1zs=;
	b=cds+Fc3zputNZzxSkhWDqyV/hZv1ZNYmCq12/Alf+mndthIbarex00o961z8xwHCXMo5Em
	J9L3gGlkkHFOu8N2QyapysBPknijiK/hWN4Hf0Tz4TtlcceUpQmbPL1alaVDv/k5YUQfRi
	AN63xIJQSzdcFhsu6Mey8fa2/p/5Hfw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-fDBb3HR0NeeyKhpZ42iBaQ-1; Tue,
 04 Nov 2025 11:22:04 -0500
X-MC-Unique: fDBb3HR0NeeyKhpZ42iBaQ-1
X-Mimecast-MFC-AGG-ID: fDBb3HR0NeeyKhpZ42iBaQ_1762273323
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F7AF180057A;
	Tue,  4 Nov 2025 16:22:03 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 893E5300019F;
	Tue,  4 Nov 2025 16:22:01 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Date: Wed,  5 Nov 2025 00:21:18 +0800
Message-ID: <20251104162123.1086035-4-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-1-ming.lei@redhat.com>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
 include/uapi/linux/io_uring.h |   9 ++
 io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
 io_uring/io_uring.c           |   1 +
 io_uring/io_uring.h           |   3 +-
 io_uring/uring_bpf.h          |  30 ++++
 5 files changed, 311 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8c49813b4e5..94d2050131ac 100644
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
@@ -427,6 +428,13 @@ enum io_uring_op {
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
 #define IORING_SEND_VECTORIZED		(1U << 5)
 
+/*
+ * sqe->bpf_op_flags		top 8bits is for storing bpf op
+ *				The other 24bits are used for bpf prog
+ */
+#define IORING_BPF_OP_BITS	(8)
+#define IORING_BPF_OP_SHIFT	(24)
+
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
  * IORING_SEND_ZC_REPORT_USAGE was requested
@@ -631,6 +639,7 @@ struct io_uring_params {
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
 #define IORING_FEAT_RW_ATTR		(1U << 16)
 #define IORING_FEAT_NO_IOWAIT		(1U << 17)
+#define IORING_FEAT_BPF			(1U << 18)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index bb1e37d1e804..8227be6d5a10 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -4,28 +4,95 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/filter.h>
 #include "io_uring.h"
 #include "uring_bpf.h"
 
+#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
+
 static DEFINE_MUTEX(uring_bpf_ctx_lock);
 static LIST_HEAD(uring_bpf_ctx_list);
+DEFINE_STATIC_SRCU(uring_bpf_srcu);
+static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
 
-int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+static inline unsigned char uring_bpf_get_op(unsigned int op_flags)
 {
-	return -ECANCELED;
+	return (unsigned char)(op_flags >> IORING_BPF_OP_SHIFT);
+}
+
+static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)
+{
+	return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
+}
+
+static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_data *data)
+{
+	return &bpf_ops[uring_bpf_get_op(data->opf)];
 }
 
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	unsigned int op_flags = READ_ONCE(sqe->bpf_op_flags);
+	struct uring_bpf_ops *ops;
+
+	if (!(req->ctx->flags & IORING_SETUP_BPF))
+		return -EACCES;
+
+	data->opf = op_flags;
+	ops = &bpf_ops[uring_bpf_get_op(data->opf)];
+
+	if (ops->prep_fn)
+		return ops->prep_fn(data, sqe);
 	return -EOPNOTSUPP;
 }
 
+static int __io_uring_bpf_issue(struct io_kiocb *req)
+{
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	struct uring_bpf_ops *ops = uring_bpf_get_ops(data);
+
+	if (ops->issue_fn)
+		return ops->issue_fn(data);
+	return -ECANCELED;
+}
+
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		int idx, ret;
+
+		idx = srcu_read_lock(&uring_bpf_srcu);
+		ret = __io_uring_bpf_issue(req);
+		srcu_read_unlock(&uring_bpf_srcu, idx);
+
+		return ret;
+	}
+	return __io_uring_bpf_issue(req);
+}
+
 void io_uring_bpf_fail(struct io_kiocb *req)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	struct uring_bpf_ops *ops = uring_bpf_get_ops(data);
+
+	if (ops->fail_fn)
+		ops->fail_fn(data);
 }
 
 void io_uring_bpf_cleanup(struct io_kiocb *req)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	struct uring_bpf_ops *ops = uring_bpf_get_ops(data);
+
+	if (ops->cleanup_fn)
+		ops->cleanup_fn(data);
 }
 
 void uring_bpf_add_ctx(struct io_ring_ctx *ctx)
@@ -39,3 +106,203 @@ void uring_bpf_del_ctx(struct io_ring_ctx *ctx)
 	guard(mutex)(&uring_bpf_ctx_lock);
 	list_del(&ctx->bpf_node);
 }
+
+static const struct btf_type *uring_bpf_data_type;
+
+static bool uring_bpf_ops_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
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
+			off + size >= sizeof(struct uring_bpf_data))
+		return -EACCES;
+
+	return NOT_INIT;
+}
+
+static const struct bpf_verifier_ops io_bpf_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.is_valid_access = uring_bpf_ops_is_valid_access,
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
+	uuring_bpf_ops = (const struct uring_bpf_ops *)udata;
+	kuring_bpf_ops = (struct uring_bpf_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct uring_bpf_ops, id):
+		/* For dev_id, this function has to copy it and return 1 to
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
+static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
+{
+	struct io_ring_ctx *ctx;
+	int ret = 0;
+
+	guard(mutex)(&uring_bpf_ctx_lock);
+	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
+		mutex_lock(&ctx->uring_lock);
+
+	if (reg) {
+		if (bpf_ops[ops->id].issue_fn)
+			ret = -EBUSY;
+		else
+			bpf_ops[ops->id] = *ops;
+	} else {
+		bpf_ops[ops->id] = (struct uring_bpf_ops) {0};
+	}
+
+	synchronize_srcu(&uring_bpf_srcu);
+
+	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
+		mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
+static int io_bpf_reg(void *kdata, struct bpf_link *link)
+{
+	struct uring_bpf_ops *ops = kdata;
+
+	return io_bpf_reg_unreg(ops, true);
+}
+
+static void io_bpf_unreg(void *kdata, struct bpf_link *link)
+{
+	struct uring_bpf_ops *ops = kdata;
+
+	io_bpf_reg_unreg(ops, false);
+}
+
+static int io_bpf_prep_io(struct uring_bpf_data *data, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_bpf_issue_io(struct uring_bpf_data *data)
+{
+	return -ECANCELED;
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
+	.reg = io_bpf_reg,
+	.unreg = io_bpf_unreg,
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
+
+/* io_kiocb layout might be changed */
+__bpf_kfunc struct io_kiocb *uring_bpf_data_to_req(struct uring_bpf_data *data)
+{
+	return cmd_to_io_kiocb(data);
+}
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(uring_bpf_kfuncs)
+BTF_ID_FLAGS(func, uring_bpf_set_result)
+BTF_ID_FLAGS(func, uring_bpf_data_to_req)
+BTF_KFUNCS_END(uring_bpf_kfuncs)
+
+static const struct btf_kfunc_id_set uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &uring_bpf_kfuncs,
+};
+
+int __init io_bpf_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &uring_kfunc_set);
+	if (err) {
+		pr_warn("error while setting UBLK BPF tracing kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf_ops);
+	if (err)
+		pr_warn("error while registering io_uring bpf struct ops: %d", err);
+
+	return 0;
+}
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 38f03f6c28cb..d2517e09407a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3851,6 +3851,7 @@ static int __init io_uring_init(void)
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
 #endif
 
+	io_bpf_init();
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4baf21a9e1ee..3f19bb079bcc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -34,7 +34,8 @@
 			IORING_FEAT_RECVSEND_BUNDLE |\
 			IORING_FEAT_MIN_TIMEOUT |\
 			IORING_FEAT_RW_ATTR |\
-			IORING_FEAT_NO_IOWAIT)
+			IORING_FEAT_NO_IOWAIT |\
+			IORING_FEAT_BPF);
 
 #define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
 			IORING_SETUP_SQPOLL |\
diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
index b6cda6df99b1..c76eba887d22 100644
--- a/io_uring/uring_bpf.h
+++ b/io_uring/uring_bpf.h
@@ -2,6 +2,29 @@
 #ifndef IOU_BPF_H
 #define IOU_BPF_H
 
+struct uring_bpf_data {
+	/* readonly for bpf prog */
+	struct file     *file;
+	u32		opf;
+
+	/* writeable for bpf prog */
+	u8              pdu[64 - sizeof(struct file *) - sizeof(u32)];
+};
+
+typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
+			       const struct io_uring_sqe *sqe);
+typedef int (*uring_io_issue_t)(struct uring_bpf_data *data);
+typedef void (*uring_io_fail_t)(struct uring_bpf_data *data);
+typedef void (*uring_io_cleanup_t)(struct uring_bpf_data *data);
+
+struct uring_bpf_ops {
+	unsigned short		id;
+	uring_io_prep_t		prep_fn;
+	uring_io_issue_t	issue_fn;
+	uring_io_fail_t		fail_fn;
+	uring_io_cleanup_t	cleanup_fn;
+};
+
 #ifdef CONFIG_IO_URING_BPF
 int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -11,6 +34,8 @@ void io_uring_bpf_cleanup(struct io_kiocb *req);
 void uring_bpf_add_ctx(struct io_ring_ctx *ctx);
 void uring_bpf_del_ctx(struct io_ring_ctx *ctx);
 
+int __init io_bpf_init(void);
+
 #else
 static inline int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -33,5 +58,10 @@ static inline void uring_bpf_add_ctx(struct io_ring_ctx *ctx)
 static inline void uring_bpf_del_ctx(struct io_ring_ctx *ctx)
 {
 }
+
+static inline int __init io_bpf_init(void)
+{
+	return 0;
+}
 #endif
 #endif
-- 
2.47.0


