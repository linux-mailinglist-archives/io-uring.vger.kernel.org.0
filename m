Return-Path: <io-uring+bounces-3169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 527499766EF
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 12:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 852481C233B5
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 10:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0037919F10C;
	Thu, 12 Sep 2024 10:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvmR31Qz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE1019F139
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726138220; cv=none; b=D+o8CErmPwsrmIr4Ewh9jO5TuvJ7TybwLYGd68P4z3iQ6C6GYOwqPgA33xVyvIpPUE6Gx/WhBG633WPMWGqvggJzRxG3c34h/TtXTxuKou0NtGS5RHKX1SI8xDuGCsnK1XlY2Mtsv5SFJgqExhe0VpUI6imFGEbQai2eYl8fsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726138220; c=relaxed/simple;
	bh=k+9CZkmpUU+8alJnseVa/RY//8Wdo85JlqtiJ0EHlg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzaeQFvSVj21bWUeU3jgQCE3xgO8o7eR6jlZCwVVfSWO1ehN6Xf876pKNjJmJv0BgHdLby8r3lGHIOIEXo8Qk7ZipMfI9NeBejFebPIqlaB2w+BJmJjzng86DCv3SvcP1AnorUnujVLfsibZgsjfkZ7T0J4yEWin2qaztTxd9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvmR31Qz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726138218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJNbXT6gWzPWTEwDqRwkOFcd0ukNE0jbUtXz4nk/skw=;
	b=dvmR31QzrthXWIjDBt5bYLp+F+Sbd4PPyhqa1cZMymFFIXnKTDjJr2Hk1NfzohF3GmT/FP
	BLzgfJAM/J0zySXxb+XpTOacBF5nOi7W2/BKV6er/F5kiGao3DY24KURGdQHJG/uAgQaQU
	Wf20SWfGmw60JpBpaiPQT+sYYDGpoCM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-mE-q5j2fN0agf7NWN2om5A-1; Thu,
 12 Sep 2024 06:50:15 -0400
X-MC-Unique: mE-q5j2fN0agf7NWN2om5A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71F661955DC9;
	Thu, 12 Sep 2024 10:50:14 +0000 (UTC)
Received: from localhost (unknown [10.72.116.81])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C1E619560AA;
	Thu, 12 Sep 2024 10:50:12 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel buffer
Date: Thu, 12 Sep 2024 18:49:27 +0800
Message-ID: <20240912104933.1875409-8-ming.lei@redhat.com>
In-Reply-To: <20240912104933.1875409-1-ming.lei@redhat.com>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
index 2af32745ebd3..11985eeac10e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -271,9 +271,14 @@ enum io_uring_op {
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
index 8391c7c7c1ec..ac92ba70de9d 100644
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


