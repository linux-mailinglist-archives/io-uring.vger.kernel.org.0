Return-Path: <io-uring+bounces-10363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BA5C32098
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 793D64605A3
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD01331A78;
	Tue,  4 Nov 2025 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GGxIEtIt"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200B53314D9
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273324; cv=none; b=iKJLhmroikA/jllNG31IVs4Aevc5VqyHmHs0+j1WNm22CHUGoL1wNKlbSah3LqU+oh0W0l7jrlzB4HgksSnhWiUEoSqzZTYGuYsHdGp41AneE7vS6bmXNh82pWiKNxc/MU6Ioy0C1FMxvZniNkgvJEGWw0x+UK6VM6dE8IhJ3aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273324; c=relaxed/simple;
	bh=fZjpqTxUdbUOAAY+YlWPuQN4mym7m0A69bDs26Yo7H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTTT+3DSbju97ofRpgntX97xtaPh3VidCGvkPfShMCXQ0x3mDhxLl5p9ySZNMFVYDH8QBW+bvlerjv0ndcszn9wRQSlOrqhDS7npaRiSgy78UYO0vT50CjyFOSuqbYz7rbI+3LZ+bzLiPNiiIR8IPI1wu6Xkfp+zSI3WpsUam7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GGxIEtIt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762273322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYGeGVk2VZBj+l0y51oHBEBLsS2dzASI51De17yxOgY=;
	b=GGxIEtIt+WIpg1YvyHDRi+nx1geiYOeaDSaY6gXhcvtIDq9YSQWKJRVbdOsJzzo30dxmjE
	G4N+sG8HPTiyy7/34bk/xndbz0/rukfrTcYuRgtvlj10nvefaxotab4LY+73NE10db1SIY
	z/JvTTqg2BTDcDKM32AJhupECQBTt/0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-TVnDUXHaPz6eviWPICzmiw-1; Tue,
 04 Nov 2025 11:21:55 -0500
X-MC-Unique: TVnDUXHaPz6eviWPICzmiw-1
X-Mimecast-MFC-AGG-ID: TVnDUXHaPz6eviWPICzmiw_1762273314
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28D931800637;
	Tue,  4 Nov 2025 16:21:54 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2FC7B1800451;
	Tue,  4 Nov 2025 16:21:52 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/5] io_uring: prepare for extending io_uring with bpf
Date: Wed,  5 Nov 2025 00:21:16 +0800
Message-ID: <20251104162123.1086035-2-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-1-ming.lei@redhat.com>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add one bpf operation & related framework and prepare for extending io_uring
with bpf.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  1 +
 init/Kconfig                  |  7 +++++++
 io_uring/Makefile             |  1 +
 io_uring/bpf.c                | 26 ++++++++++++++++++++++++++
 io_uring/opdef.c              | 10 ++++++++++
 io_uring/uring_bpf.h          | 26 ++++++++++++++++++++++++++
 6 files changed, 71 insertions(+)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/uring_bpf.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04797a9b76bc..b167c1d4ce6e 100644
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
index cab3ad28ca49..14d566516643 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1843,6 +1843,13 @@ config IO_URING
 	  applications to submit and complete IO through submission and
 	  completion rings that are shared between the kernel and application.
 
+config IO_URING_BPF
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
index bc4e4a3fa0a5..35eeeaf64489 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF)	+= bpf.o
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
new file mode 100644
index 000000000000..8c47df13c7b5
--- /dev/null
+++ b/io_uring/bpf.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2024 Red Hat */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <uapi/linux/io_uring.h>
+#include "io_uring.h"
+#include "uring_bpf.h"
+
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return -ECANCELED;
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
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index df52d760240e..d93ee3d577d4 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -38,6 +38,7 @@
 #include "futex.h"
 #include "truncate.h"
 #include "zcrx.h"
+#include "uring_bpf.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -593,6 +594,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_BPF] = {
+		.prep			= io_uring_bpf_prep,
+		.issue			= io_uring_bpf_issue,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -851,6 +856,11 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_BPF] = {
+		.name			= "BPF",
+		.cleanup		= io_uring_bpf_cleanup,
+		.fail			= io_uring_bpf_fail,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
new file mode 100644
index 000000000000..bde774ce6ac0
--- /dev/null
+++ b/io_uring/uring_bpf.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_H
+#define IOU_BPF_H
+
+#ifdef CONFIG_IO_URING_BPF
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
+int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_bpf_fail(struct io_kiocb *req);
+void io_uring_bpf_cleanup(struct io_kiocb *req);
+#else
+static inline int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return -ECANCELED;
+}
+static inline int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+static inline void io_uring_bpf_fail(struct io_kiocb *req)
+{
+}
+static inline void io_uring_bpf_cleanup(struct io_kiocb *req)
+{
+}
+#endif
+#endif
-- 
2.47.0


