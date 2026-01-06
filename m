Return-Path: <io-uring+bounces-11406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CCDCF7BAE
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C587304A116
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2BC3176F8;
	Tue,  6 Jan 2026 10:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCkRDw5H"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E430FC25
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694333; cv=none; b=bQ8Gf1zZmYeNo6gQC/jjSWD/+WEhu879ANVMKSX0o5AxpA5G8ndBmVMiYEPLiNNVpv92Ku3c9j3HcqHYI7vrwUtEpA5zbCRwjk1N7ZNlhif9vYOPuY+omPrWm2FfXWtKdMcQWCs8rtFR4vkpHW6qinTsntPkwdBaUzGMwkKoXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694333; c=relaxed/simple;
	bh=J/4ChU3/CbicmYX00BATmS4nNmKeg/ROc8ABhTb7mqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9eXhsdpDGi8+KWEyI8VYXedvi40bourE3TNw/MgHvVInClXpkXmOQj61WZAuEwOcsS86voO4el87uk4f7w3cCjxjSkquU+GrI3QUX+8NV8J4aWXtMViekOGNeK41gfNg0Uqzz3TKFVGff5aQkhRJYPXnkw4hx5oQjiNTjuOBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCkRDw5H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JPgjuU0f6FU9PDW1CnE7hcn8nMd83AlkwlXn6SbZQa4=;
	b=hCkRDw5HY7lMtc06FFQDrhEhotpuIyiul0BHMvmXLR4KhcVvv0T//klCm0WuZf6CQ+gox9
	6NQgUubwKVz7Ntm5nOe2P0oXALOEsxTyUWDT6nWuKncCmNj5U/WBflAlact/MZD+K0sbf1
	BrtXAMTNc2icOZSf3CQsIz1x16cHTn4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-5BhqNv4uOQS6HXB92XCkqw-1; Tue,
 06 Jan 2026 05:12:02 -0500
X-MC-Unique: 5BhqNv4uOQS6HXB92XCkqw-1
X-Mimecast-MFC-AGG-ID: 5BhqNv4uOQS6HXB92XCkqw_1767694321
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B794E18002C1;
	Tue,  6 Jan 2026 10:12:01 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4A6D180044F;
	Tue,  6 Jan 2026 10:11:59 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 06/13] io_uring: bpf: implement struct_ops registration
Date: Tue,  6 Jan 2026 18:11:15 +0800
Message-ID: <20260106101126.4064990-7-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Complete the BPF struct_ops registration mechanism by implementing
refcount-based lifecycle management:

- Add refcount field to struct uring_bpf_ops_kern for tracking active
  requests
- Add wait_queue_head_t bpf_wq to struct io_ring_ctx for synchronizing
  unregistration with in-flight requests
- Implement io_bpf_reg_unreg() to handle registration (refcount=1) and
  unregistration (wait for in-flight requests to complete)
- Update io_uring_bpf_prep() to increment refcount on success and reject
  new requests when refcount is zero (unregistration in progress)
- Update io_uring_bpf_cleanup() to decrement refcount and wake up waiters
  when it reaches zero

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |   2 +
 io_uring/bpf_op.c              | 104 ++++++++++++++++++++++++++++++++-
 io_uring/bpf_op.h              |   3 +
 3 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 62ff38b3ce1e..b8eb9d8ba4ce 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -474,6 +474,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
+
+	wait_queue_head_t		bpf_wq;
 };
 
 /*
diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
index f616416652e9..d6f146abe304 100644
--- a/io_uring/bpf_op.c
+++ b/io_uring/bpf_op.c
@@ -12,6 +12,7 @@
 #include <linux/filter.h>
 #include <uapi/linux/io_uring.h>
 #include "io_uring.h"
+#include "register.h"
 #include "bpf_op.h"
 
 static inline unsigned char uring_bpf_get_op(u32 op_flags)
@@ -29,7 +30,9 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
 	u32 opf = READ_ONCE(sqe->bpf_op_flags);
 	unsigned char bpf_op = uring_bpf_get_op(opf);
+	struct uring_bpf_ops_kern *ops_kern;
 	const struct uring_bpf_ops *ops;
+	int ret;
 
 	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_OP)))
 		goto fail;
@@ -37,11 +40,20 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (bpf_op >= IO_RING_MAX_BPF_OPS)
 		return -EINVAL;
 
-	ops = req->ctx->bpf_ops[bpf_op].ops;
+	ops_kern = &req->ctx->bpf_ops[bpf_op];
+	ops = ops_kern->ops;
+	if (!ops || !ops->prep_fn || !ops_kern->refcount)
+		goto fail;
+
 	data->opf = opf;
 	data->ops = ops;
-	if (ops && ops->prep_fn)
-		return ops->prep_fn(data, sqe);
+	ret = ops->prep_fn(data, sqe);
+	if (!ret) {
+		/* Only increment refcount on success (uring_lock already held) */
+		req->flags |= REQ_F_NEED_CLEANUP;
+		ops_kern->refcount++;
+	}
+	return ret;
 fail:
 	return -EOPNOTSUPP;
 }
@@ -78,9 +90,18 @@ void io_uring_bpf_cleanup(struct io_kiocb *req)
 {
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
 	const struct uring_bpf_ops *ops = data->ops;
+	struct uring_bpf_ops_kern *ops_kern;
+	unsigned char bpf_op;
 
 	if (ops && ops->cleanup_fn)
 		ops->cleanup_fn(data);
+
+	bpf_op = uring_bpf_get_op(data->opf);
+	ops_kern = &req->ctx->bpf_ops[bpf_op];
+
+	/* Decrement refcount after cleanup (uring_lock already held) */
+	if (--ops_kern->refcount == 0)
+		wake_up(&req->ctx->bpf_wq);
 }
 
 static const struct btf_type *uring_bpf_data_type;
@@ -157,10 +178,82 @@ static int uring_bpf_ops_init_member(const struct btf_type *t,
 		 */
 		kuring_bpf_ops->id = uuring_bpf_ops->id;
 		return 1;
+	case offsetof(struct uring_bpf_ops, ring_fd):
+		kuring_bpf_ops->ring_fd = uuring_bpf_ops->ring_fd;
+		return 1;
 	}
 	return 0;
 }
 
+static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
+{
+	struct uring_bpf_ops_kern *ops_kern;
+	struct io_ring_ctx *ctx;
+	struct file *file;
+	int ret = -EINVAL;
+
+	if (ops->id >= IO_RING_MAX_BPF_OPS)
+		return -EINVAL;
+
+	file = io_uring_register_get_file(ops->ring_fd, false);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ctx = file->private_data;
+	if (!(ctx->flags & IORING_SETUP_BPF_OP))
+		goto out;
+
+	ops_kern = &ctx->bpf_ops[ops->id];
+
+	mutex_lock(&ctx->uring_lock);
+	if (reg) {
+		/* Registration: set refcount to 1 and store ops */
+		if (ops_kern->ops) {
+			ret = -EBUSY;
+		} else {
+			ops_kern->ops = ops;
+			ops_kern->refcount = 1;
+			ret = 0;
+		}
+	} else {
+		/* Unregistration */
+		if (!ops_kern->ops) {
+			ret = -EINVAL;
+		} else {
+			ops_kern->refcount--;
+retry:
+			if (ops_kern->refcount == 0) {
+				ops_kern->ops = NULL;
+				ret = 0;
+			} else {
+				mutex_unlock(&ctx->uring_lock);
+				wait_event(ctx->bpf_wq, ops_kern->refcount == 0);
+				mutex_lock(&ctx->uring_lock);
+				goto retry;
+			}
+		}
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+out:
+	fput(file);
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
 static int io_bpf_prep_io(struct uring_bpf_data *data, const struct io_uring_sqe *sqe)
 {
 	return 0;
@@ -191,6 +284,8 @@ static struct bpf_struct_ops bpf_uring_bpf_ops = {
 	.init = uring_bpf_ops_init,
 	.check_member = uring_bpf_ops_check_member,
 	.init_member = uring_bpf_ops_init_member,
+	.reg = io_bpf_reg,
+	.unreg = io_bpf_unreg,
 	.name = "uring_bpf_ops",
 	.cfi_stubs = &__bpf_uring_bpf_ops,
 	.owner = THIS_MODULE,
@@ -218,6 +313,8 @@ static const struct btf_kfunc_id_set uring_kfunc_set = {
 
 int io_bpf_alloc(struct io_ring_ctx *ctx)
 {
+	init_waitqueue_head(&ctx->bpf_wq);
+
 	if (!(ctx->flags & IORING_SETUP_BPF_OP))
 		return 0;
 
@@ -225,6 +322,7 @@ int io_bpf_alloc(struct io_ring_ctx *ctx)
 			sizeof(struct uring_bpf_ops_kern), GFP_KERNEL);
 	if (!ctx->bpf_ops)
 		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/io_uring/bpf_op.h b/io_uring/bpf_op.h
index 99708140992f..9de0606f5d25 100644
--- a/io_uring/bpf_op.h
+++ b/io_uring/bpf_op.h
@@ -27,14 +27,17 @@ typedef void (*uring_bpf_cleanup_t)(struct uring_bpf_data *data);
 
 struct uring_bpf_ops {
 	unsigned short		id;
+	int			ring_fd;
 	uring_bpf_prep_t	prep_fn;
 	uring_bpf_issue_t	issue_fn;
 	uring_bpf_fail_t	fail_fn;
 	uring_bpf_cleanup_t	cleanup_fn;
 };
 
+/* TODO: manage it via `io_rsrc_node` */
 struct uring_bpf_ops_kern {
 	const struct uring_bpf_ops *ops;
+	int refcount;
 };
 
 #ifdef CONFIG_IO_URING_BPF_OP
-- 
2.47.0


