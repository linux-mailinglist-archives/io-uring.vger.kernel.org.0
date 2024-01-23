Return-Path: <io-uring+bounces-463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7019839AF4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:20:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D8AE1F2C18E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 21:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076802C682;
	Tue, 23 Jan 2024 21:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCbt2fHn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339A733CD2
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706044801; cv=none; b=Ajc0hv44o57TcMN9MpbLlnSGcSXLbbM2Bs1Wm2UGT0rcneB2IwVeQ7PLim0b4BG4LLOF32yo0+H28M9N1iiTRhgGOpdCh/2apfe0s+77tOXDcbtFy7RIzgZoVRpA7ln3k8jt1SpWP4AJPf2x8PuWKtBNObqZjKGzXBPQAbUYPjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706044801; c=relaxed/simple;
	bh=07tTn7B3o5+aXkQC1LqDUief03BXynr0E+7U0/WwOdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JzsC0J7v+ftdonMQ/bT6mdZIr97ec8G9lnv4jNO7XFZCqGvmAw7ms/JKk8vPrID1k7KPgF05rP+3ngqg7vpi2Yg8y84K/k/HWIQh971hwvVDHMcwnG9t1JKDrNmVCxJzyKWYGNsVv/H1kLWgaAYR+fI27QfMpGcp/9IY4KH0P3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCbt2fHn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40e9ef9853bso27368255e9.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 13:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706044798; x=1706649598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZyvqlbqmxu9uUwpC7laVCoL48NulKhLKqFfOmt5yN8=;
        b=NCbt2fHn5ooHOGhR9OdvW8ue7/fQBXNPgb3g4bvE+i4316knbjgksdSktD2hA0DCDE
         QuS+m3pmbBu1nW+LfvoeDqUgmdXF0sIAz6ODg7VZrm5cpPPV45elDO2B9ldaRChzgEtw
         MqGOr6bob1uHMVhAcScemnPpah+71PURF4dsmds13pqZNbwSUQ8BHUzU9SrO7UpEaiGf
         aT1cooMg3hWKKGcLYzAYV1wqk213OsW1ZU2QpX66fMHIU1A5ISIvfwfbxejxeR9ephe3
         Af3MJa06K9SP1Hup3S+M1ybXXdNk1TM0bcZdsXiPK7gl19QW217eFugGh0e7Qeu8ZBHM
         FdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706044798; x=1706649598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZyvqlbqmxu9uUwpC7laVCoL48NulKhLKqFfOmt5yN8=;
        b=r/lgqGTQ+0DSljVlKLtFnxrI9KooqEwJDbCA4eSl0nBhOujDDpoj6/lYm1k74YM7hw
         FxhauJHJy7Q3bt/x4sU+1+ZWSDugk9OKp6bN6l2PH3XRWd0vhiMgusvAFVeAaoG6msPk
         e6n9SAIvn5wGkZ3WkIpaguOE17bk05QtZ5qmUwYP1CjbIVxgXOy2FgBF3nZFX3esjnx2
         Znls62iC0qxptLoBayfDaqCK67+6xbNC7BtrBawl+2TGlVMXIvDJX87zjCv6+iWymAIS
         EgyncrElLC0d0T64qW726DFdk83QJCCHSutrxa6t8g9r46xeHrjn6p96ryZ+qZ1Q2DgP
         u/3w==
X-Gm-Message-State: AOJu0YxemIBiYmi8GXqsJe16Wa5JUC0WVRtJRmTA+dEgApoGMVPseL9m
	Jabf5rZ9BfxSjFtA+Zbi6mIrwlLoOcflKUpvZAjAmkLj0mYZzow5
X-Google-Smtp-Source: AGHT+IFpFT7XFSN6DsgdNJ1htI3JwNmh8hl3EAG1gqUADlT5GJvn0iTUNtJXUdbwnNiRYGxOckgpvg==
X-Received: by 2002:a05:600c:4c0a:b0:40e:b908:3100 with SMTP id d10-20020a05600c4c0a00b0040eb9083100mr102469wmp.107.1706044798053;
        Tue, 23 Jan 2024 13:19:58 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b0040e47dc2e8fsm43512169wmq.6.2024.01.23.13.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 13:19:57 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v3 2/2] io_uring: add support for ftruncate
Date: Tue, 23 Jan 2024 23:19:52 +0200
Message-Id: <20240123211952.32342-3-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123211952.32342-1-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123211952.32342-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libraries that are built on io_uring currently need to maintain a
separate thread pool implementation when they want to truncate a file.

Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              |  9 +++++++
 io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 5 files changed, 63 insertions(+), 1 deletion(-)
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
index 799db44283c7..7830d087d03f 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -35,6 +35,7 @@
 #include "rw.h"
 #include "waitid.h"
 #include "futex.h"
+#include "truncate.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -469,6 +470,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_FTRUNCATE] = {
+		.needs_file		= 1,
+		.prep			= io_ftruncate_prep,
+		.issue			= io_ftruncate,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -704,6 +710,9 @@ const struct io_cold_def io_cold_defs[] = {
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


