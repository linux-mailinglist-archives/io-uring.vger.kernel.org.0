Return-Path: <io-uring+bounces-480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2995083A42E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 09:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC9D41F21EE1
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 08:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572D5175A1;
	Wed, 24 Jan 2024 08:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlpvWwdu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D591756B;
	Wed, 24 Jan 2024 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706085202; cv=none; b=XjK6eH5NgMjB+Vl34m5brJAS9KODN2vsB40aDBPf9zjt8NgIombv5FIkOIlqMHI4BHJ6JBTX8lGXgoYmcf+vi8ubkx1nNawu/rWP8h+OhDiobb5iaeHWq30/qGwVy4K/tZN9cZPaKqe2DRaMAMn4SiugEteTZ0/9JTy1oo0149Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706085202; c=relaxed/simple;
	bh=U57HBOTNSUwWK6JXf7SozSGBZVqKLXFGT15jeQqjK7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gdcnH8dnS8c/Q7Cqpt2rjLeL2dGFHZE6x9cZwZ5gxzGfsHYT25d0qG2bRV8jCcKfB01i1hzfNGUSRqSr9Teb2sjH7msbNf+TfkXpPfT00hR627pc5KQ1O1AKEVzDJv2/9RpDUh9GIbERNFH5Cyg4dAnclsE3bLJzH0KEyiPvx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JlpvWwdu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40eac352733so33194225e9.0;
        Wed, 24 Jan 2024 00:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706085198; x=1706689998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Dvo9cggizruZ6DslyeriNdBJu5DiM1kD2mQfmdGQUk=;
        b=JlpvWwduOYg5+nyNsq+XdGwIJ/2dcvErwIE2PQpWuFy/FFBaSRGh62+7QvrB9THdJh
         WfgHvIK1nzWRcEpQSROaR8FKZ8WVMGrBssRGsN4ChzaZon3bB/J18MwwNp8zdOy8lSYO
         YNSfGzLlvKZfl00I4ntXPTjSVu8n6x0H8vQygMYwcblJf7e2SuacJjbUuUOOUl2VTYc2
         YdBI0e7l7YblUDZUvDvNK9zs0Wr3Cq4zcAjGqF47PeBW31MNaa/2X7JSl0nJ0fO8Xopn
         L3TAddKZCGuETTLhGiQgzwK+OZ7DxOGRHI+mFm8tlWE6JoCsiZcCG8gP+TDAxueUMsq3
         ktvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706085198; x=1706689998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Dvo9cggizruZ6DslyeriNdBJu5DiM1kD2mQfmdGQUk=;
        b=ia+c98lIpCt0NoyarCvo7I13JdAJ4mSsRPjy8sq7fejlDo1NeuagSKfUcjzFBuIL1o
         MoxCByeQY/285UPNs67s0OtXay7VP9wX1sIxNnrsvMF5e8SuiPhMvFmnF5kjDt1xVvGz
         XuN1bxPHpBr/MscTaPI13ADv6vH1BeaQ6mjnsvx0avIE32lvFeWcwKRds3fYTdQXFa6Y
         D8eltDLojYwwvs1xNNh4IxPKUzx82ymFBNXLeyPsKamhDSh8I3F3osT6yWLKobNOvymr
         LnXKD2dzmnsiglwXVxfnPbc7Sr6IzNC+CGnMmYGLJgE/N749BKRBkES2GmdCuJoC22M6
         gr2w==
X-Gm-Message-State: AOJu0Ywn5g7lS9/BI5NfoaFMlaYIGfoce4Sp4/VrZZECcL7KHFofnhKu
	TbjB6wQn5O2gjbcIwnXIvnv/2m/a9asxx9qvjVqoN7FMY43kVj8a76imPxwzOijcrA==
X-Google-Smtp-Source: AGHT+IEfr2HQF4B9/TcVQ2rGPNwZ25m8t8xFcgrlVtvhMPFcIgOGznGNP8ESmNDF7c421MauC3XhEg==
X-Received: by 2002:a05:600c:12cb:b0:40e:47d2:8b01 with SMTP id v11-20020a05600c12cb00b0040e47d28b01mr854639wmd.162.1706085198497;
        Wed, 24 Jan 2024 00:33:18 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c469000b0040e39cbf2a4sm49324365wmo.42.2024.01.24.00.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 00:33:18 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: 
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v5 2/2] io_uring: add support for ftruncate
Date: Wed, 24 Jan 2024 10:33:01 +0200
Message-Id: <20240124083301.8661-3-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240124083301.8661-1-tony.solomonik@gmail.com>
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
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


