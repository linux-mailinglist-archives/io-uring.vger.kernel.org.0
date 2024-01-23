Return-Path: <io-uring+bounces-453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 140D7838D7F
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 12:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8B0728583A
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 11:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7027E5D73B;
	Tue, 23 Jan 2024 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivyt8NhH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B335D749
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 11:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706009621; cv=none; b=BujOwveQs+amnHp8uM6ugBkY5lDg9LFloeZxT6SlWF2n7CrdyPqG9hI5IPb/ggatQzfNe6AEtyawUHZFaoUWcyznUSfHVEwCOPcA8CcXK1gxZPP+/nU1ZcBa+1Og8J32+jbTZMO1lGJ6sN1zFpmnp6EE7kERVj9LN/bk28+nyy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706009621; c=relaxed/simple;
	bh=fN/zMxdFgNeUFouHDDtugaWiWniqxZeJ5PqLCMBwqHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ww0tiu/6so+G+dIg3PGenYraM8BBPr/9nqWhhJD/eMGv24XoS/U8Grj2b334iUWqT+v2dLBew7IIOT0qpxP7U+CMe3oS+lqgqPcp8bov1T8pvEpZ3tJCt5yVwarXD/6QoQ5/uIrwuz6JaFLqKY4KkrT1nIJUXSD1hCCJs84xblQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivyt8NhH; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-337d5480a6aso4008612f8f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 03:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706009618; x=1706614418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9u7g2HslwKZSytizBWPalW48FAJklGyoWzpo7dZUnHM=;
        b=ivyt8NhHWM5APHJ5W4PQ5RuT7lTtQg+NKl8DKTG4vNV5bQ+6jsI10o9L8K0sWlhpop
         sM/LFaiHk3IfrVq/eT3hidRv3oM88vrkFpemPyYu1lRwjx+NIwxnVnx7DOK5IiDmIpzE
         mZoKDk3FQKcYtGqPyzVFtAULfdXuzI8LunVOzWgRzpif0bk8hJTl34Wz2GULFLfHmLJb
         5vBZu6IibyP8rXIacnNPM+NkuqY/WP34f8sSFl2oHgBlrV3Ue+PpIisELmGi4uP92zZu
         hwlt/8CvaxhnzCB3ycFiRi+R9jGZwHk87h5FyhNPGSiH+JADzpmtGB8uZRhxv3izCtE1
         V7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706009618; x=1706614418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9u7g2HslwKZSytizBWPalW48FAJklGyoWzpo7dZUnHM=;
        b=s8aKhXNqBTol0a1RkR4whzB3ueVjhEVYc+a7YVbh2TdCzaYhf/kIUvzn8jCOkA7RIP
         swfz6COd0bRBhDM1BhpZ1JPi3uGf5ZddHAgWFxtQvdko2efaFgGykqP9TjrUd2+lKJik
         nK9XEgRKONFKXpbcEQXS73am0SM7H9G0e9SlnsPR1SalREOLg/eVzes99l1KOUEnDgbH
         zPI3igXJ1VYa/3m5YhdesJvnqdiZojW0JL2ga3w9rxlwUEqiTRCtGmpSPsihLYmXX0FY
         X3cZG8EDoI++ry2ylpC9RvrUl/Jj3xCw09GS8vHsCDN3MGJCCFMItsm18g0cC5fM6pix
         tXIA==
X-Gm-Message-State: AOJu0YzDvAO8WXDMgfSKNBJQG2NrolblmejSLxBfIO9swS5Xj8TDI6if
	7un7pz3j9cRjWC5BsmIAntj/cUmW0XY4d+BbIprRwlSiZreqoKTSl73WAt2rgWK3gA==
X-Google-Smtp-Source: AGHT+IGV7uxu8wQYEp+PBjxZSrJ98MhcVX56GBbaJVYCHruxGMuk3p+uGaQ2Ad4ejGlSCwe9gtVATg==
X-Received: by 2002:a5d:5103:0:b0:337:c3ed:bd1e with SMTP id s3-20020a5d5103000000b00337c3edbd1emr2839078wrt.25.1706009617720;
        Tue, 23 Jan 2024 03:33:37 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d4448000000b0033925e94c89sm9078884wrr.12.2024.01.23.03.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 03:33:37 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v2 2/2] io_uring: add support for ftruncate
Date: Tue, 23 Jan 2024 13:33:33 +0200
Message-Id: <20240123113333.79503-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123113333.79503-1-tony.solomonik@gmail.com>
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
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
 io_uring/opdef.c              |  9 +++++++
 io_uring/truncate.c           | 47 +++++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 5 files changed, 62 insertions(+), 1 deletion(-)
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
index 000000000000..9d160b91949c
--- /dev/null
+++ b/io_uring/truncate.c
@@ -0,0 +1,47 @@
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
+	if (sqe->addr || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
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
+	ret = __do_ftruncate(req->file, ft->len, 1);
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


