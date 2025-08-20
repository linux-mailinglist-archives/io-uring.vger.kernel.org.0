Return-Path: <io-uring+bounces-9106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 627C1B2E164
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 17:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 457D55C19C4
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41462C08BD;
	Wed, 20 Aug 2025 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRlMes7N"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B382BF017
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704426; cv=none; b=WqpUTajryZMPoXZ6J7EGiDWJE8Zc2cy/3pKUT3xEKdzrt8iZRNbR402GeS4zHuXwppoadJzP3SwTw9OBE6n4p2NmriYJUuqx8ISo2ypgU5mexL79FxIKp6Pr8zZXW9Ke9BvSu9utXkFRkC6U1isTiHscc1RvzYSyo0fSm3l/1JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704426; c=relaxed/simple;
	bh=hwtDDBclq9MsNsINlfZmszXgAkjK4oDVrBCzIUfScdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5o5hMeJbQJVgjwgLVDGj6BV6qOVWbLO9Tb4QdYaIwqvobnF0aW/z1aLRHAAS6aqXA4WMzQBfeZlKAp1rVFeVTRyVzQqfFMoL1xZ7gAhY16RPhO687sdnLqPAJaZTL9tVxlDXv6Ye4VnOFhsqTIQ4PxgZ/j3y9nuswdHXDqXJQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SRlMes7N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755704424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y093hh6avOyOI0zlUbek+KBO8KMFMhoa8I80j82RO6A=;
	b=SRlMes7NrEOV67tQbJEJXrmc/3Lb1RlnvwIl2tzsBa0rVP1p9E7Yja0F1BjdUF75XPMot6
	Hcj+dtNvtnfYoweV0U2lVIhXYsaHbZiCH0TaUuwqggwXdZO1W1pQtCh/i+vu+N1F4ZnS/G
	iqS7vz27tjSWOAAG58bfxX13DCm6y3s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-baTz3atCM2CDMFrpM-ZyNw-1; Wed,
 20 Aug 2025 11:40:20 -0400
X-MC-Unique: baTz3atCM2CDMFrpM-ZyNw-1
X-Mimecast-MFC-AGG-ID: baTz3atCM2CDMFrpM-ZyNw_1755704419
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 649691800352;
	Wed, 20 Aug 2025 15:40:19 +0000 (UTC)
Received: from localhost (unknown [10.72.116.9])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6034B19560B0;
	Wed, 20 Aug 2025 15:40:16 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4] io_uring: uring_cmd: add multishot support
Date: Wed, 20 Aug 2025 23:40:05 +0800
Message-ID: <20250820154005.1086709-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
V4:
- add io_do_buffer_select() check in io_uring_cmd_select_buffer(()
- comments that the two APIs should work together for committing buffer
  upfront(Jens)

V3:
- enhance buffer select check(Jens)

V2:
- Fixed static inline return type
- Updated UAPI comments: Clarified that IORING_URING_CMD_MULTISHOT must be used with buffer select
- Refactored validation checks: Moved the mutual exclusion checks into the individual flag validation
sections for better code organization
- Added missing req_set_fail(): Added the missing failure handling in io_uring_mshot_cmd_post_cqe
- Improved commit message: Rewrote the commit message to be clearer, more technical, and better explain
the use cases and API changes

 include/linux/io_uring/cmd.h  | 28 ++++++++++++
 include/uapi/linux/io_uring.h |  6 ++-
 io_uring/opdef.c              |  1 +
 io_uring/uring_cmd.c          | 81 ++++++++++++++++++++++++++++++++++-
 4 files changed, 114 insertions(+), 2 deletions(-)

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
index 053bac89b6c0..babb6a4b3542 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "alloc_cache.h"
 #include "rsrc.h"
+#include "kbuf.h"
 #include "uring_cmd.h"
 #include "poll.h"
 
@@ -194,8 +195,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
 
-	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
+			return -EINVAL;
 		req->buf_index = READ_ONCE(sqe->buf_index);
+	}
+
+	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
+		if (ioucmd->flags & IORING_URING_CMD_FIXED)
+			return -EINVAL;
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+	} else {
+		if (req->flags & REQ_F_BUFFER_SELECT)
+			return -EINVAL;
+	}
 
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
@@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -333,3 +352,63 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
 		return false;
 	return io_req_post_cqe32(req, cqe);
 }
+
+/*
+ * Work with io_uring_mshot_cmd_post_cqe() together for committing the
+ * provided buffer upfront
+ *
+ * The two must be paired, and both must be called within the same
+ * uring_cmd submission context.
+ */
+int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
+			       unsigned buf_group,
+			       void __user **buf, size_t *len,
+			       unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	void __user *ubuf;
+
+	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(!io_do_buffer_select(req)))
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
+ * This function must be paired with io_uring_cmd_select_buffer(), and both
+ * must be called within the same uring_cmd submission context.
+ */
+bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
+				 ssize_t ret, unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	unsigned int cflags = 0;
+
+	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
+		return true;
+
+	if (ret > 0) {
+		cflags = io_put_kbuf(req, ret, issue_flags);
+		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
+			return false;
+	}
+
+	io_kbuf_recycle(req, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, cflags);
+	return true;
+}
+EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
-- 
2.47.0


