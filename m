Return-Path: <io-uring+bounces-12825-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHv5MyPBwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12825-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:51:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E63983196AA
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:51:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4E551306D13C
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D513F23B5;
	Tue, 24 Mar 2026 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHH3b5Sv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969C3E5EC5
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370313; cv=none; b=bInBMlZ8LvttDjWtoY5hlSg6IzlH5E8uLS9E5Zn7I+1FG8p6yr6TqazFAw0yuMrOe5jjHlO4NUOolKy1Fpxx52p+WLmkHVI4aUfFrQmaqIWfXqqukW/Mv8A9ZBjyP7PdTOw2Q2GbunDzsZUCEsMLu3h225a0rfyVHcIbmdw+Bhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370313; c=relaxed/simple;
	bh=CET06swaBFiaKfCvf4cmDktdVvDO4ulfoNk3FaUxUHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCve0/BkAwe3HgScSbZHLWLZbxTp9zPXyEw7kRnHhRVjiAHqhIVepKdmiu1LFVA3qAMwuTvyDqBLKQmzXqnM7XITIu5kz/DsN+DUUUMUj573Jky1+SMAZySsvLpkSb1LShscTvF4nTpktUxCa30jPmxzfTNgZ9Ectvsw8X5mdgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHH3b5Sv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0AlQu9hIJ19Lw+DfSH9upG5Xm6BDM3p4DMWzrpeRgqY=;
	b=PHH3b5SvnHSW+494PplJx8nk/wIgAhLzSR+glOV56PIzMWrCIwpSRpI8kiX+sohlk9nZWf
	MNyJbE1XpsaF4AXik+FGueo/HaZrf/HIkU11SKhZvyc1NkJBIoh3P0Ylrj59uIDt+ERG16
	hS1CcCRWRa4NBz+RRBKcsmkLj0OaqTg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-LVkcN4tgOaeWUx-BalgjRw-1; Tue,
 24 Mar 2026 12:38:29 -0400
X-MC-Unique: LVkcN4tgOaeWUx-BalgjRw-1
X-Mimecast-MFC-AGG-ID: LVkcN4tgOaeWUx-BalgjRw_1774370307
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E3FB1944EBF;
	Tue, 24 Mar 2026 16:38:27 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77EED1955F21;
	Tue, 24 Mar 2026 16:38:26 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf struct_ops
Date: Wed, 25 Mar 2026 00:37:26 +0800
Message-ID: <20260324163753.1900977-6-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12825-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lpc.events:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E63983196AA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 include/linux/io_uring_types.h |  12 +-
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/bpf-ops.c             |   7 +-
 io_uring/bpf_ext.c             | 234 ++++++++++++++++++++++++++++++++-
 io_uring/bpf_ext.h             |  41 ++++++
 io_uring/io_uring.c            |   9 +-
 io_uring/io_uring.h            |   6 +-
 7 files changed, 314 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 328c3c1e2a31..3a558da86f83 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -10,6 +10,7 @@
 
 struct iou_loop_params;
 struct io_uring_bpf_ops;
+struct uring_bpf_ops_kern;
 
 enum {
 	/*
@@ -493,7 +494,16 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
-	struct io_uring_bpf_ops		*bpf_ops;
+	/*
+	 * bpf_ops and bpf_ext_ops are mutually exclusive: bpf_ops is used
+	 * for io_uring_bpf_ops struct_ops, while bpf_ext_ops provides
+	 * per-opcode BPF extension operations (IORING_SETUP_BPF_EXT).
+	 * The two cannot be active at the same time on the same ring.
+	 */
+	union {
+		struct io_uring_bpf_ops		*bpf_ops;
+		struct uring_bpf_ops_kern	*bpf_ext_ops;
+	};
 
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cb1e888761c3..3bf9be78a00a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -76,6 +76,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		bpf_op_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -252,6 +253,9 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_SQ_REWIND		(1U << 20)
 
+/* Allow userspace to define io_uring operation by BPF prog */
+#define IORING_SETUP_BPF_EXT		(1U << 21)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -442,6 +446,13 @@ enum io_uring_op {
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
@@ -646,6 +657,7 @@ struct io_uring_params {
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
 #define IORING_FEAT_RW_ATTR		(1U << 16)
 #define IORING_FEAT_NO_IOWAIT		(1U << 17)
+#define IORING_FEAT_BPF			(1U << 18)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index e4b244337aa9..e91c6964405c 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -162,7 +162,6 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
 		return -EOPNOTSUPP;
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EOPNOTSUPP;
-
 	if (ctx->bpf_ops)
 		return -EBUSY;
 	if (WARN_ON_ONCE(!ops->loop_step))
@@ -186,6 +185,12 @@ static int bpf_io_reg(void *kdata, struct bpf_link *link)
 		return PTR_ERR(file);
 	ctx = file->private_data;
 
+	/* bpf_ops and bpf_ext_ops share storage and are mutually exclusive */
+	if (ctx->flags & IORING_SETUP_BPF_EXT) {
+		fput(file);
+		return -EINVAL;
+	}
+
 	scoped_guard(mutex, &io_bpf_ctrl_mutex) {
 		guard(mutex)(&ctx->uring_lock);
 		ret = io_install_bpf(ctx, ops);
diff --git a/io_uring/bpf_ext.c b/io_uring/bpf_ext.c
index 146f70054c0a..e2151cc7f9f5 100644
--- a/io_uring/bpf_ext.c
+++ b/io_uring/bpf_ext.c
@@ -3,24 +3,254 @@
 
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
 #include "bpf_ext.h"
 
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
+	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_EXT)))
+		goto fail;
+
+	if (bpf_op >= IO_RING_MAX_BPF_OPS)
+		return -EINVAL;
+
+	ops = req->ctx->bpf_ext_ops[bpf_op].ops;
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
+	if (!(ctx->flags & IORING_SETUP_BPF_EXT))
+		return 0;
+
+	ctx->bpf_ext_ops = kcalloc(IO_RING_MAX_BPF_OPS,
+			sizeof(struct uring_bpf_ops_kern), GFP_KERNEL);
+	if (!ctx->bpf_ext_ops)
+		return -ENOMEM;
+	return 0;
+}
+
+void io_bpf_free(struct io_ring_ctx *ctx)
+{
+	/* bpf_ops and bpf_ext_ops share storage; only free if bpf_ext is active */
+	if (!(ctx->flags & IORING_SETUP_BPF_EXT))
+		return;
+	kfree(ctx->bpf_ext_ops);
+	ctx->bpf_ext_ops = NULL;
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
diff --git a/io_uring/bpf_ext.h b/io_uring/bpf_ext.h
index 179530ce865b..5a74f91bdcad 100644
--- a/io_uring/bpf_ext.h
+++ b/io_uring/bpf_ext.h
@@ -4,12 +4,53 @@
 
 struct io_kiocb;
 struct io_uring_sqe;
+struct uring_bpf_ops;
 
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
 #ifdef CONFIG_IO_URING_BPF_EXT
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
index 6eaa21e09469..15e9735af559 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -97,6 +97,7 @@
 #include "wait.h"
 #include "bpf_filter.h"
 #include "loop.h"
+#include "bpf_ext.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -294,6 +295,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
 
+	if (io_bpf_alloc(ctx))
+		goto free_ref;
+
 	return ctx;
 
 free_ref:
@@ -2150,7 +2154,9 @@ static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
 
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
-	io_unregister_bpf_ops(ctx);
+	/* bpf_ops and bpf_ext_ops share storage; skip if bpf_ext_ops is active */
+	if (!(ctx->flags & IORING_SETUP_BPF_EXT))
+		io_unregister_bpf_ops(ctx);
 	io_sq_thread_finish(ctx);
 
 	mutex_lock(&ctx->uring_lock);
@@ -2196,6 +2202,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	io_napi_free(ctx);
+	io_bpf_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 91cf67b5d85b..1af33a89ed2f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -49,7 +49,8 @@ struct io_ctx_config {
 			IORING_FEAT_RECVSEND_BUNDLE |\
 			IORING_FEAT_MIN_TIMEOUT |\
 			IORING_FEAT_RW_ATTR |\
-			IORING_FEAT_NO_IOWAIT)
+			IORING_FEAT_NO_IOWAIT |\
+			IORING_FEAT_BPF)
 
 #define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
 			IORING_SETUP_SQPOLL |\
@@ -71,7 +72,8 @@ struct io_ctx_config {
 			IORING_SETUP_HYBRID_IOPOLL |\
 			IORING_SETUP_CQE_MIXED |\
 			IORING_SETUP_SQE_MIXED |\
-			IORING_SETUP_SQ_REWIND)
+			IORING_SETUP_SQ_REWIND |\
+			IORING_SETUP_BPF_EXT)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
-- 
2.53.0


