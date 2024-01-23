Return-Path: <io-uring+bounces-451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 877B4838D77
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 12:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB7FD1C21AF8
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 11:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2353D7B;
	Tue, 23 Jan 2024 11:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cc5Vx7w+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2A5D747
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706009562; cv=none; b=Ij+1ZnuusDx4lcn2fDZfbTeFImkMTL25lTNtpchNZPQvQM4d/A+ejPc+pD0UZmnCv6rFRmtQjikkppRLnFONbfi+/KQ7vI048wiLjZ6GQFIHWja07YJeJBk9TcxC0mGbLlQJjbvqrnDd9ob0a4/519lekd39R+b9tzbhPF4QZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706009562; c=relaxed/simple;
	bh=fN/zMxdFgNeUFouHDDtugaWiWniqxZeJ5PqLCMBwqHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NLrkA3ryv7uD769oi1mPAYeE5OiamUlijRqdNWDH+AcNbtqVtPW4z9aRqMwzm5GQTcyj2H6bAE4GvR4Vf7c12wHlbq15aWSvYCoPI3FDNSdHfPJcgNBU3aN/Nj/PyuNC+1jAf4tlBPxmo/RHgzDGwL+X1RdTfKxtGyTWpmZn01k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cc5Vx7w+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e72a567eeso50369135e9.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 03:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706009558; x=1706614358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9u7g2HslwKZSytizBWPalW48FAJklGyoWzpo7dZUnHM=;
        b=cc5Vx7w+KzGYo8MmN4B70GycqFvzsjNfc6AjNpbiOP+QDSul0MKR5gZ3XhjT5gUlIK
         imCCsU2sfDwCa2wA0zsfH9Wef94upAwU4vFPka+651aTqYXN8aMxzM11x6xdg4KswLsc
         Z3DV17D+um4uHbgybLgwhnGpCh1SpG5hmVwZ9fRlAfJO8H3yS+nd+mnTpt32d5rAh0iN
         x2svlLjYSUPHROkq2ijjUF/teaTLal4Y/Dit4PIy6I9ippYqx7ijG+lYElP5pF+pTdV6
         v+fNOOan5cv6mUniXC2QgwH7pN0JJ1C4b1RYxH377l568pLBEeb0gC5+bLllCMvm1+Ew
         CDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706009558; x=1706614358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9u7g2HslwKZSytizBWPalW48FAJklGyoWzpo7dZUnHM=;
        b=HtwBD8xzxgwH2F0aoATyKyqnuUWiPxEPRxkgKdDJ0IlNIKdFHmroMkyKl/dGs09dlh
         egc3ey1vERkwpz08Ke3qja9Mtqnu/vcfvL+leGsUplvvj9gNJyhxe3UvJTmhaMfgAcwK
         V84h1RzqGEQrJlRYPoOUZ41Zls2Zl4/Q4bvCIvoQ/jRpqXymh9boVNhJeoDSak9UgfTY
         r6gbnVhNeJPw5EI4cZYp8di+2XztJwOoYJ8T2agpvbubkrJeGfl8jqxlRK4xX22fTlTq
         YN1zMlaa86kY2Sy/zNex+tOW2W3eFfty59kfkJhA6BZW7kUuVJacHhCnD0jimIuKwPhF
         qcUQ==
X-Gm-Message-State: AOJu0YwqDJyTlM9RKKDWO313Zb3FntnGDoQj7NNSD7VrceiBheAKizxz
	2mP45sdcSU8/23q2HArq3wbghCVE9cx4TDvUal6B2Sq0iv7evCA/
X-Google-Smtp-Source: AGHT+IGPl4QMm50FzSC1qrSzHO3COF7kHcI59yA/NasftSs0q2Rm+idpgAg0nooREZ50u8RnuCORcA==
X-Received: by 2002:a05:600c:1e0f:b0:40e:becc:8938 with SMTP id ay15-20020a05600c1e0f00b0040ebecc8938mr187532wmb.98.1706009558569;
        Tue, 23 Jan 2024 03:32:38 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id q7-20020adffec7000000b0033926505eafsm8998771wrs.32.2024.01.23.03.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 03:32:38 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v2 2/2] io_uring: add support for ftruncate
Date: Tue, 23 Jan 2024 13:32:24 +0200
Message-Id: <20240123113224.79315-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123113224.79315-1-tony.solomonik@gmail.com>
References: <20240123112358.78030-1-tony.solomonik@gmail.com>
 <20240123113224.79315-1-tony.solomonik@gmail.com>
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


