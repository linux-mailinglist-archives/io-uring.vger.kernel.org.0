Return-Path: <io-uring+bounces-442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E69768372B9
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AE1A1F2B7FA
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 19:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7A61EF07;
	Mon, 22 Jan 2024 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HwVbLKxe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701FE3FE20
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952262; cv=none; b=Y1X/u1p0kUY3HGXgV6SmjYVGEU6MbIKDsusrr9hjfqNQS6bsKTdzed34rDDVMjgd6b73Ex2pLQypLQW9Y9uYZ35/Jg1p+u9Po7hFOfYpZHkMSXJgFkZPRgcOLWxCE6IYKRJA5EehOccBsd+smufw2uib8OPcrQSCh2uFzCZjD/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952262; c=relaxed/simple;
	bh=AHFObzqfId6D8Q9I3qIITZU9grudFSjgFeCwFQ4W1qg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Co+bIuo2mDxMFU3t2ANVkWS5vIFzB3A+2smx5K5ZRQaEFY2I6lYKCt153EmrKfnc9RAMvbimF8JjPxak5h0cKTuFfWlmnnDoeXDOlnOoQ8/zfbSgWS9EesGoLkbclHS1W7Jz2XjbOAt6gynBYfbRNvwD5fw2itszYUJ2nSnNfXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HwVbLKxe; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40ea5653f6bso29302455e9.3
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 11:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705952258; x=1706557058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RZBZDM7Z/3ImhQIIJDORnYpE1fF/KIxark+QD7Q3aFM=;
        b=HwVbLKxefi+Cqr8kQlMgzq8ZdUzjQzy7ak7SuAqO0CjKxIjePEGLN0TL2eB7kUWKVo
         iXEaXiuXhqx3R60e8WQH+O2JcAOPDLpFo8TJsfJVqH0ra2dYK+rkS9TG7f9mfl9aa45M
         XFC9sS3q/pDMuFCsOc+lPQykWU2XqJ6+FzURmH36hTCRW/ohsS58siA3tGp9XoyAg8r0
         /4eFsos8aJPg163Xa9Iv+QPw5XzIXAt8tjvZJdI70HUQB2gbq03Kgt5MZorXKbMzwz9H
         W0xTmCaR3M0HEwhHCN3hqqhdL2pTNO+2CG9GjoTJYRyn7tTsk3k4bVki+kWtJOxQ6P5r
         JcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705952258; x=1706557058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RZBZDM7Z/3ImhQIIJDORnYpE1fF/KIxark+QD7Q3aFM=;
        b=F3vPxpjGd7HmqwdovRBDR/5jvP2ed1pYtGI6/mSJKFdS+jTiieOc7v3H11udx6E14R
         DA6Wr7P67iyG8z13DERoJpVauQNPmNj5VWwp/uVhQtqfe/UF7emX9MkP6f5zo8+5jcqQ
         rlEF+07ChIvMVrYl4jun2ZZWWPmz71DziwMBCIw1yLsRKc54vrWUMtAOhpXapaHUvx6N
         u8pxLJG050yNvSIdEWbxBMJKkUcbPpSFIyEDBKNt9/Pa3iknafgDR/ZYHGMY9oUJS1um
         ahNxQ/agIsXl/QT5THsJMRVnkdVxb1Mw1Xxc8zA3AifmUAxsH4ik2dY2ZscmBr6f7Q6J
         EcPQ==
X-Gm-Message-State: AOJu0YzE1dYFiQgEJhpkjM6mgX9PrBwhmPEt84JrOzCYyS9n9f5hkqD+
	lR4VvRVGqOhEKrP8somVjYZWOmQOIL20yu4d0rhTgUKorFgXGDoiJMeezmyHprhMxA==
X-Google-Smtp-Source: AGHT+IHdNmMb8XnbrnlkU7FPqVyzC6bGfrFyW50y2LTk8uXemOqcofEPfiKs5JWbSc/Bj/4JTOTn1Q==
X-Received: by 2002:a05:600c:1d24:b0:40e:697a:701b with SMTP id l36-20020a05600c1d2400b0040e697a701bmr2520020wms.247.1705952258335;
        Mon, 22 Jan 2024 11:37:38 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id jb13-20020a05600c54ed00b0040e418494absm39138945wmb.46.2024.01.22.11.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 11:37:37 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH 1/2] io_uring: add support for truncate
Date: Mon, 22 Jan 2024 21:37:31 +0200
Message-Id: <20240122193732.23217-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libraries that are built on io_uring currently need to maintain a
separate thread pool implementation when they want to truncate a file.
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              |  8 ++++++
 io_uring/truncate.c           | 53 +++++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 5 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1c16f817742..513f31ee8ce9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -253,6 +253,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_TRUNCATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index e5be47e4fc3b..4f8ed6530a29 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
-					notif.o waitid.o
+					notif.o waitid.o truncate.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 799db44283c7..60827099e244 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -35,6 +35,7 @@
 #include "rw.h"
 #include "waitid.h"
 #include "futex.h"
+#include "truncate.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -469,6 +470,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_TRUNCATE] = {
+		.prep			= io_truncate_prep,
+		.issue			= io_truncate,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -704,6 +709,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_TRUNCATE] = {
+		.name			= "TRUNCATE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/truncate.c b/io_uring/truncate.c
new file mode 100644
index 000000000000..82648b2fbc7e
--- /dev/null
+++ b/io_uring/truncate.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "../fs/internal.h"
+
+#include "io_uring.h"
+#include "truncate.h"
+
+struct io_trunc {
+	struct files    *file;
+	char __user     *pathname;
+	loff_t				len;
+};
+
+int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
+
+	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	tr->pathname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	tr->len = READ_ONCE(sqe->len);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	req->flags |= REQ_F_FORCE_ASYNC;
+	return 0;
+}
+
+int io_truncate(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
+	int ret;
+
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
+	ret = do_sys_truncate(tr->pathname, tr->len);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/truncate.h b/io_uring/truncate.h
new file mode 100644
index 000000000000..ab17cb9acc90
--- /dev/null
+++ b/io_uring/truncate.h
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+
+int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_truncate(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.34.1


