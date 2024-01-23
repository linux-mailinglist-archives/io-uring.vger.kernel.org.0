Return-Path: <io-uring+bounces-471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0419F839C4A
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A77E0282DD9
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1828F50245;
	Tue, 23 Jan 2024 22:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMo3U4T1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBAF20DEF
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706049236; cv=none; b=aVY0MkdFD8WKlgjXGBPwB956EJx+6XUd5IyBDH0+roEHmt/Dz8XKFbROahHye2/rS5Z/ycpssHBU8k1S0yi4IBK5bf+j6C0AARO5qEBbVzpMpEOPfBiT+EyymuifBPa2g4amU01qqkLfXPuTLqTpMbOeH2WxMRkKXIYKMEURFhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706049236; c=relaxed/simple;
	bh=U57HBOTNSUwWK6JXf7SozSGBZVqKLXFGT15jeQqjK7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrcIW05Tooh8OsPCc6v+r23ZB3v3Sh34C32mMAy5jbbQVx3hpLbSXqv7Z8k5N7pgSUFgBy0P2Geb37x3py8mZFJTwbdsSmBmUeXsXSDJdQshqhylw8k2BaL45PF4YQRFBSbBHW+kpmqD/nNoMKoKmbLTr2n7oyyzByk0Ea1oDgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EMo3U4T1; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-339237092dcso3513682f8f.3
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706049232; x=1706654032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Dvo9cggizruZ6DslyeriNdBJu5DiM1kD2mQfmdGQUk=;
        b=EMo3U4T1lpfmjxJQ6QxFYuKKuXsh/e3DYkM8EahOCq+OssPct2S1mMjhhHqNR5FerS
         aejnoqkJdq2Nj3zePDjsjGv1lPsJ+jebXatT+r7hRkkIzVrp7Q4dwEKC1MyG+O8FIDbq
         Hsmz0U7TRYvzU6PeA2GeosUiT9+A3JJrlYsK71SrdDi78MTUBUXyk3tT8vKjD2kyqQGa
         T1Z8T1ImLTjtNQRS0Gk+BGj/arLQWgJc9kJbmoGW0iJRCtxNpAXu2BEGcRHsDG6jsBQJ
         j6E5W2lguR+JzbJ0zDp363baWHbMP6mCHtwkmVXMzTrq1CqvWHzCLaI0vXWfT3QHq54L
         54KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706049232; x=1706654032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Dvo9cggizruZ6DslyeriNdBJu5DiM1kD2mQfmdGQUk=;
        b=GShXiRrFimX6qjXAJp1RZVPA7f7SvcWXKPJe2Tx6wbWSaWZ+15U4D26mWnaD4fRbbT
         jaQyI9vs4LLTOWDbp9JRypQKqIcuwPwOm7XpcK4zeDAB2CSvbtBSbSU7DN6cDOG5LRK4
         23g8Npg8RMyKcI2VwZGnDi0PUqSro02Sof4Cx8Y8mvUV5L8NFYrCm1fCOJMC+y/kLJg2
         Naj0vm03AhfDWmKOXSRNFiQ5teha4UXtnAqkU3P5quY1iqymeeIbvfsPBOtjDXLtWuXw
         Fh4p3DMfecjnmgGs7wdwjZRxc8VJFllj/WrQoSFxwRod4fL4kHAAdrq9wDKVqhMpN0uT
         8G3A==
X-Gm-Message-State: AOJu0YyIMoquT1Iovc92hnb5wkRNN5r4vTOEfAYPeqr/V8s3KdPAuBB+
	xE0ra/sYzdDgakCNJ1y10krQwSoPWBoGhTe7aL4ofZ2gEQRaAjK+
X-Google-Smtp-Source: AGHT+IE+Akp629aRN09XTCfesQ+bMap1QXe86gsbJacaBX8izJtypi9lOVkNx3vr4PA3YDhTvNIw8g==
X-Received: by 2002:adf:f5c6:0:b0:337:9870:c939 with SMTP id k6-20020adff5c6000000b003379870c939mr3158511wrp.66.1706049232216;
        Tue, 23 Jan 2024 14:33:52 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p12-20020adfce0c000000b0033865f08f2asm12436514wrn.34.2024.01.23.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 14:33:51 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v4 2/2] io_uring: add support for ftruncate
Date: Wed, 24 Jan 2024 00:33:41 +0200
Message-Id: <20240123223341.14568-3-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123223341.14568-1-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123223341.14568-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds support for doing truncate through io_uring, eliminating
the need for applications to roll their own thread pool or offload
mechanism to be able to do non-blocking truncates.

Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              | 10 ++++++++
 io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 5 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1c16f817742..be682e000c94 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -253,6 +253,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_FTRUNCATE,
 
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
index 799db44283c7..7a83b76c6ee7 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -35,6 +35,7 @@
 #include "rw.h"
 #include "waitid.h"
 #include "futex.h"
+#include "truncate.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -469,6 +470,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_FTRUNCATE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.prep			= io_ftruncate_prep,
+		.issue			= io_ftruncate,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -704,6 +711,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_FTRUNCATE] = {
+		.name			= "FTRUNCATE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/truncate.c b/io_uring/truncate.c
new file mode 100644
index 000000000000..4b48376149f9
--- /dev/null
+++ b/io_uring/truncate.c
@@ -0,0 +1,48 @@
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
+struct io_ftrunc {
+	struct file			*file;
+	loff_t				len;
+};
+
+int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
+
+	if (sqe->rw_flags || sqe->addr || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in || sqe->addr3)
+		return -EINVAL;
+
+	ft->len = READ_ONCE(sqe->off);
+
+	req->flags |= REQ_F_FORCE_ASYNC;
+	return 0;
+}
+
+int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
+	int ret;
+
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
+	ret = ftruncate_file(req->file, ft->len, 0);
+
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/truncate.h b/io_uring/truncate.h
new file mode 100644
index 000000000000..ec088293a478
--- /dev/null
+++ b/io_uring/truncate.h
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+
+int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.34.1


