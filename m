Return-Path: <io-uring+bounces-9058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A42B2C0DB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 13:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D32E1891437
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 11:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E715F257AC7;
	Tue, 19 Aug 2025 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q0JlKQe0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E51326D49
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755603947; cv=none; b=owA4D1YLRQePbvhJ/uUaBSX7eVUswA0p/sL3GcXQwr2zdvyy6tc2/fjZ8G0CzzwUrDpQFub7qhppac1KfUhuCYtYkaGWmZl5xyPsXwv99Nwm0IyEBEEvp3UFcm+s9en5oFjYjJ1Jfec1Saf5cMqiKxX9oPQuOsoGns7/OeWcUSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755603947; c=relaxed/simple;
	bh=hgZl3jdLBsdxr3x4J1Qc0y06VyUhvRz+/25G2vbuG9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hkmnXxaRVU064x+e9OKiQMc5C9KIc00ZxwD7PHl1hxrYTdukT17V8pQT7JLP0QoaX/Wo9mrWMewxfb/67ugg0It2YwdgI3OzpfB0CcUu3dV3kVQdr1vZquTFZRrsxiYSHDBQ49+Vb1w38AxL67mNawJR9RNQJ9MID2LlgNVxXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q0JlKQe0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755603944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y1o7EXKjdwykmr2zbN7vo0bjpPJHotFiPnOPX4xo/xk=;
	b=Q0JlKQe0JKUVLZJ6obtTXcGfDrIqt9k7qsuyxM9rMW1RqL/XDcrQTz5UBHDSUAzD9vQMby
	sEHtHjHePcmXCWRfP8M3bhV1qkcxT3rsb1StL2YxzSo/WTOIfQW7BZz6hyA3a3go3KVzqE
	FP5cOmN4LR6iSP89DI2+TDXRQETvUGI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-PIDBAnKMPEKe2D2HjMWUvw-1; Tue,
 19 Aug 2025 07:45:41 -0400
X-MC-Unique: PIDBAnKMPEKe2D2HjMWUvw-1
X-Mimecast-MFC-AGG-ID: PIDBAnKMPEKe2D2HjMWUvw_1755603940
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D7041800371;
	Tue, 19 Aug 2025 11:45:40 +0000 (UTC)
Received: from localhost (unknown [10.72.116.16])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E89F030001A5;
	Tue, 19 Aug 2025 11:45:38 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] io_uring: uring_cmd: add multishot support
Date: Tue, 19 Aug 2025 19:45:32 +0800
Message-ID: <20250819114532.959011-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
uring_cmd operations with provided buffer.

This enables drivers to post multiple completion events from a single
uring_cmd submission, which is useful for:

- Notifying userspace of device events (e.g., interrupt handling)
- Supporting devices with multiple event sources (e.g., multi-queue devices)
- Avoiding the need for device poll() support when events originate
  from multiple sources device-wide

The implementation adds two new APIs:
- io_uring_cmd_select_buffer(): selects a buffer from the provided
  buffer group for multishot uring_cmd
- io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
  pushed to the provided buffer

Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
and is mutually exclusive with IORING_URING_CMD_FIXED for now.

The ublk driver will be the first user of this functionality:

	https://github.com/ming1/linux/commits/ublk-devel/

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
- Fixed static inline return type
- Updated UAPI comments: Clarified that IORING_URING_CMD_MULTISHOT must be used with buffer select
- Refactored validation checks: Moved the mutual exclusion checks into the individual flag validation
sections for better code organization
- Added missing req_set_fail(): Added the missing failure handling in io_uring_mshot_cmd_post_cqe
- Improved commit message: Rewrote the commit message to be clearer, more technical, and better explain
the use cases and API changes


 include/linux/io_uring/cmd.h  | 28 +++++++++++++++
 include/uapi/linux/io_uring.h |  6 +++-
 io_uring/opdef.c              |  1 +
 io_uring/uring_cmd.c          | 66 ++++++++++++++++++++++++++++++++++-
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index cfa6d0c0c322..72832757f8ef 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -70,6 +70,22 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 /* Execute the request from a blocking context */
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
+/*
+ * Select a buffer from the provided buffer group for multishot uring_cmd.
+ * Returns the selected buffer address and size.
+ */
+int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
+			       unsigned buf_group,
+			       void **buf, size_t *len,
+			       unsigned int issue_flags);
+
+/*
+ * Complete a multishot uring_cmd event. This will post a CQE to the completion
+ * queue and update the provided buffer.
+ */
+bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
+				 ssize_t ret, unsigned int issue_flags);
+
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -102,6 +118,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 }
+static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
+				unsigned buf_group,
+				void **buf, size_t *len,
+				unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
+				ssize_t ret, unsigned int issue_flags)
+{
+	return true;
+}
 #endif
 
 /*
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..1e935f8901c5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -298,9 +298,13 @@ enum io_uring_op {
  * sqe->uring_cmd_flags		top 8bits aren't available for userspace
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_URING_CMD_MULTISHOT	must be used with buffer select, like other
+ *				multishot commands. Not compatible with
+ *				IORING_URING_CMD_FIXED, for now.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
-#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
+#define IORING_URING_CMD_MULTISHOT	(1U << 1)
+#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
 
 
 /*
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9568785810d9..932319633eac 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -413,6 +413,7 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_URING_CMD] = {
+		.buffer_select		= 1,
 		.needs_file		= 1,
 		.plug			= 1,
 		.iopoll			= 1,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 053bac89b6c0..808090fdc3dd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "alloc_cache.h"
 #include "rsrc.h"
+#include "kbuf.h"
 #include "uring_cmd.h"
 #include "poll.h"
 
@@ -194,8 +195,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
 
-	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
+			return -EINVAL;
+		if (req->flags & REQ_F_BUFFER_SELECT)
+			return -EINVAL;
 		req->buf_index = READ_ONCE(sqe->buf_index);
+	}
+
+	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
+		if (ioucmd->flags & IORING_URING_CMD_FIXED)
+			return -EINVAL;
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+	}
 
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
@@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
+	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
+		if (ret >= 0)
+			return IOU_ISSUE_SKIP_COMPLETE;
+		io_kbuf_recycle(req, issue_flags);
+	}
 	if (ret == -EAGAIN) {
 		ioucmd->flags |= IORING_URING_CMD_REISSUE;
 		return ret;
@@ -333,3 +351,49 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
 		return false;
 	return io_req_post_cqe32(req, cqe);
 }
+
+int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
+			       unsigned buf_group,
+			       void __user **buf, size_t *len,
+			       unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	void __user *ubuf;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+
+	ubuf = io_buffer_select(req, len, buf_group, issue_flags);
+	if (!ubuf)
+		return -ENOBUFS;
+
+	*buf = ubuf;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
+
+/*
+ * Return true if this multishot uring_cmd needs to be completed, otherwise
+ * the event CQE is posted successfully.
+ *
+ * Should only be used from a task_work
+ *
+ */
+bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
+				 ssize_t ret, unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	unsigned int cflags = 0;
+
+	if (ret > 0) {
+		cflags = io_put_kbuf(req, ret, issue_flags);
+		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
+			return false;
+	}
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, cflags);
+	return true;
+}
+EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
-- 
2.47.0


