Return-Path: <io-uring+bounces-11404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA598CF7B18
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EAE4C301C3B7
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FA03112B3;
	Tue,  6 Jan 2026 10:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBIDztXT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257F81E515
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694326; cv=none; b=Hgvf4MxbTb2UyNiJt4aM50ZqYKp7YS4ILa92THg+VE7bhfDxkZvVEM7IdAmHF7ohSWzsPR/fJANqYHcv3QUXlr15L2W5BoIL4ITq+uQ8Xe5O99IRcx6lIG2WxvZG0qvYXeDZqGeK/26a0XumQ3l4DZ5JcbLeqS21vxdCkR4YbHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694326; c=relaxed/simple;
	bh=++cqvz2Vb3u702yDXIRGsCRLzl7ckmWtyFnQ5jbEveg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2qObv+gGMvlEssVO/4TBsH0Tp9sADrM9XTdDKb8B6N9oL74DoVorC2YJY7IUof56JeR3kw1InAUl3G3+9cBpInLmoxb/WVkuAsis5/JE6eteseht1D5nMYWaAQFwoYGv+E8WNWnKXKsck/XzMzKvMcCRDwftwyixNGOIcpLcy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBIDztXT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfhHeJQE03Qt9ixdtQgqOAcwKkq9G5Gq2ipXD3h/86o=;
	b=eBIDztXTX+Y0aLhr0tHvcR/32smNE5Dl6wos0dhid6FqWB7kob/+xG5VAeCQnXqVxUySpO
	98UjDsuUr/ASDrgx912F88gpwg7yDK1RHY/mA9N+Ty8uIDfsiv7QZKsfTNB14F89xKoHog
	leID6Cgnwd5xr/YvicXTfIBwdxqGAh8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-wi5yGhE8M-aCpeCyJsb7cw-1; Tue,
 06 Jan 2026 05:11:55 -0500
X-MC-Unique: wi5yGhE8M-aCpeCyJsb7cw-1
X-Mimecast-MFC-AGG-ID: wi5yGhE8M-aCpeCyJsb7cw_1767694314
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA6A418002C1;
	Tue,  6 Jan 2026 10:11:53 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B8366180035A;
	Tue,  6 Jan 2026 10:11:52 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 04/13] io_uring: prepare for extending io_uring with bpf
Date: Tue,  6 Jan 2026 18:11:13 +0800
Message-ID: <20260106101126.4064990-5-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add one bpf operation & related framework and prepare for extending io_uring
with bpf.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  1 +
 init/Kconfig                  |  7 +++++++
 io_uring/Makefile             |  1 +
 io_uring/bpf_op.c             | 26 ++++++++++++++++++++++++++
 io_uring/bpf_op.h             | 15 +++++++++++++++
 io_uring/opdef.c              | 16 ++++++++++++++++
 6 files changed, 66 insertions(+)
 create mode 100644 io_uring/bpf_op.c
 create mode 100644 io_uring/bpf_op.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..30406cfb2e21 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -303,6 +303,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_BPF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/init/Kconfig b/init/Kconfig
index fa79feb8fe57..b2f2a5473538 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1868,6 +1868,13 @@ config IO_URING
 	  applications to submit and complete IO through submission and
 	  completion rings that are shared between the kernel and application.
 
+config IO_URING_BPF_OP
+	bool "Enable IO uring bpf extension" if EXPERT
+	depends on IO_URING && BPF
+	help
+	  This option enables bpf extension for the io_uring interface, so
+	  application can define its own io_uring operation by bpf program.
+
 config GCOV_PROFILE_URING
 	bool "Enable GCOV profiling on the io_uring subsystem"
 	depends on IO_URING && GCOV_KERNEL
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..b2db2b334cee 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF_OP)	+= bpf_op.o
diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
new file mode 100644
index 000000000000..2ab6f93bbad8
--- /dev/null
+++ b/io_uring/bpf_op.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Red Hat */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <uapi/linux/io_uring.h>
+#include "io_uring.h"
+#include "bpf_op.h"
+
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+
+int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+void io_uring_bpf_fail(struct io_kiocb *req)
+{
+}
+
+void io_uring_bpf_cleanup(struct io_kiocb *req)
+{
+}
diff --git a/io_uring/bpf_op.h b/io_uring/bpf_op.h
new file mode 100644
index 000000000000..7b61612c28c4
--- /dev/null
+++ b/io_uring/bpf_op.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_OP_H
+#define IOU_BPF_OP_H
+
+struct io_kiocb;
+struct io_uring_sqe;
+
+#ifdef CONFIG_IO_URING_BPF_OP
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
+int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_bpf_fail(struct io_kiocb *req);
+void io_uring_bpf_cleanup(struct io_kiocb *req);
+#endif
+
+#endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index df52d760240e..289107f3c00a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -38,6 +38,7 @@
 #include "futex.h"
 #include "truncate.h"
 #include "zcrx.h"
+#include "bpf_op.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -593,6 +594,14 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_BPF] = {
+#if defined(CONFIG_IO_URING_BPF_OP)
+		.prep			= io_uring_bpf_prep,
+		.issue			= io_uring_bpf_issue,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -851,6 +860,13 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_BPF] = {
+		.name			= "BPF",
+#if defined(CONFIG_IO_URING_BPF_OP)
+		.cleanup		= io_uring_bpf_cleanup,
+		.fail			= io_uring_bpf_fail,
+#endif
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.47.0


