Return-Path: <io-uring+bounces-1865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1E08C2DDD
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 02:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C14C81C21564
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 00:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6C17E9;
	Sat, 11 May 2024 00:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQp5AbTe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC75F7F6
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715386378; cv=none; b=h+2IaFc7tWYh27IIoyq94A3yIl/wefvl2DbyQmjsbvmAbZP3MA6kpXnHmLY0b7aB4029B2Z6LEK9tyBx0jikMaR4yCB1PHVJNRnjj5la9F24LwuzCcb6X2ImwKGNaevkTBH1uBEqHo0IjSp7QKQzF8TbkJG30JMd9QNajhbnhRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715386378; c=relaxed/simple;
	bh=g5ChI12Mp8fqwkYgDjzYiibp18gQVCZVc9fkPJHWiQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAAlVjzS1wYCjNYlrqiBUUIL7AmvQi1qzk5HtCsVWZE4PE8G0Hkz7aL9TtI8IdyXBGny8/QIlq4tDqk2t1xkijIriOHaZs3n3TATxtleLXaYGNnLwAb8tacL8QHSdLB7WJ2IBZz914OM61uUrJAhgb2j7dJmCsIePhRHQKV9N20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQp5AbTe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715386375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RVHwqmTxEZ6gG9dU4ziCuL7C8QgiDlIk47tf0Qpv0k=;
	b=UQp5AbTebMGum8IeexlPrmm8YsYIjcg3ufXvmf8LPc4opfQD81TRpoYWDKxdTvVkc1f9PF
	LXgC/ljx0mxWHKxIjkWffwD84lL6SbXhFVAHBFG7TLVwdHML++Raz88NwHhYXUNcw+A5Nb
	mTenQwipp/hcXFWWKQbCvx3EsJn2R/4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-Eut85X0XMHqwkOPpRzvz2g-1; Fri, 10 May 2024 20:12:50 -0400
X-MC-Unique: Eut85X0XMHqwkOPpRzvz2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C79B08029EC;
	Sat, 11 May 2024 00:12:49 +0000 (UTC)
Received: from localhost (unknown [10.72.116.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D452121249E1;
	Sat, 11 May 2024 00:12:48 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 8/9] io_uring/uring_cmd: support provide group kernel buffer
Date: Sat, 11 May 2024 08:12:11 +0800
Message-ID: <20240511001214.173711-9-ming.lei@redhat.com>
In-Reply-To: <20240511001214.173711-1-ming.lei@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Allow uring command to be group leader for providing kernel buffer,
and this way can support generic device zero copy over device buffer.

The following patch will use the way to support zero copy for ublk.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring/cmd.h  |  7 +++++++
 include/uapi/linux/io_uring.h |  7 ++++++-
 io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 447fbfd32215..fde3a2ec7d9a 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -48,6 +48,8 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
 
+int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
+		const struct io_uring_kernel_buf *grp_kbuf);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -67,6 +69,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 }
+static inline int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
+		const struct io_uring_kernel_buf *grp_kbuf)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /*
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2b99d9d0b93e..7c510937e53e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -269,9 +269,14 @@ enum io_uring_op {
  * sqe->uring_cmd_flags		top 8bits aren't available for userspace
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
+ *				for member requests which can retrieve
+ *				any sub-buffer with offset(sqe->addr) and
+ *				len(sqe->len)
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
-#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
+#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
+#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)
 
 
 /*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 21ac5fb2d5f0..14744eac9158 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -15,6 +15,7 @@
 #include "alloc_cache.h"
 #include "rsrc.h"
 #include "uring_cmd.h"
+#include "kbuf.h"
 
 static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
 {
@@ -175,6 +176,26 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+/*
+ * Provide kernel buffer for sqe group members to consume, and the caller
+ * has to guarantee that the provided buffer and the callback are valid
+ * until the callback is called.
+ */
+int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
+		const struct io_uring_kernel_buf *grp_kbuf)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	if (unlikely(!(ioucmd->flags & IORING_PROVIDE_GROUP_KBUF)))
+		return -EINVAL;
+
+	if (unlikely(!req_support_group_dep(req)))
+		return -EINVAL;
+
+	return io_provide_group_kbuf(req, grp_kbuf);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_provide_kbuf);
+
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
@@ -207,6 +228,13 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
 
+	if (ioucmd->flags & IORING_PROVIDE_GROUP_KBUF) {
+		/* LEADER flag isn't set yet, so check GROUP only */
+		if (!(req->flags & REQ_F_SQE_GROUP))
+			return -EINVAL;
+		req->flags |= REQ_F_SQE_GROUP_DEP;
+	}
+
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		struct io_ring_ctx *ctx = req->ctx;
 		u16 index;
-- 
2.42.0


