Return-Path: <io-uring+bounces-12824-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gExyOaK/wmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12824-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:45:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B563194B5
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE9FD3123EDE
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5B13FA5FA;
	Tue, 24 Mar 2026 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YLRZ+zNs"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0530C3E5EC5
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370311; cv=none; b=N+zzs82LTQU7EeIszjZzkVwjJU6Hj5wd/r7lgHedmrIC/T/5jKvHh6rt6nqIHIdwNWO641wru0kS9F+1jiZn9MNLfsi02Hh2s4KlHigKeTfF6hexVvFx/yNGWAqB54frjuAsR7THGkzecovuRQZ3Qtyn6w8KvvO4r40KM4WWyGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370311; c=relaxed/simple;
	bh=X+/aaCpyk/pnGQnotcHx5UMTGNS2JeZEgvM07XyOEPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRcsRG1Ub9tO8RNu9CyO1APAGBHTcGIT0fA6oJXfeCMgDE7Yf2lgku8VRmWBmAZ6RfSsdkp0AEvtm2bBwJUUFZAyETi5241CfIDsXXzOSvr0cBO4HWEsMDLkMAKx+N7TD6m42VQnYHWWCu+LUl20CrrAoHigX20RBV651o3fsyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YLRZ+zNs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjXHfLAEuc/26KaBt0XT55XkiESdYScWh58tD94DbA8=;
	b=YLRZ+zNsJRs0+aYdmcF1LriikmHL+HPB2Dqsh58zad8gSAa4BZOJcrC4lwahVebA6aJZIF
	Dy5O9+D3SD3gbJiSKevz4Cljyvm/ZQu4kZPEg2VifCnR/DQONTrlzM1/8bU2/mEsmdMtHZ
	F1ysU32KbFhlbHFLwAedJfGRDXYgtvo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-2Zxybw7COoqvn4lWnqaL-Q-1; Tue,
 24 Mar 2026 12:38:25 -0400
X-MC-Unique: 2Zxybw7COoqvn4lWnqaL-Q-1
X-Mimecast-MFC-AGG-ID: 2Zxybw7COoqvn4lWnqaL-Q_1774370304
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF1B619560B7;
	Tue, 24 Mar 2026 16:38:23 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF22419560B1;
	Tue, 24 Mar 2026 16:38:22 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 04/12] io_uring: prepare for extending io_uring with bpf
Date: Wed, 25 Mar 2026 00:37:25 +0800
Message-ID: <20260324163753.1900977-5-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12824-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 67B563194B5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add one bpf operation & related framework and prepare for extending io_uring
with bpf.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  1 +
 init/Kconfig                  |  7 +++++++
 io_uring/Makefile             |  1 +
 io_uring/bpf_ext.c            | 26 ++++++++++++++++++++++++++
 io_uring/bpf_ext.h            | 15 +++++++++++++++
 io_uring/opdef.c              | 16 ++++++++++++++++
 6 files changed, 66 insertions(+)
 create mode 100644 io_uring/bpf_ext.c
 create mode 100644 io_uring/bpf_ext.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c10c4827f6b0..cb1e888761c3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -318,6 +318,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_BPF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/init/Kconfig b/init/Kconfig
index 444ce811ea67..c4587cf46765 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1884,6 +1884,13 @@ config IO_URING
 	  applications to submit and complete IO through submission and
 	  completion rings that are shared between the kernel and application.
 
+config IO_URING_BPF_EXT
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
index c54e328d1410..f540ba5d777e 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
 obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
 obj-$(CONFIG_IO_URING_BPF_OPS) += bpf-ops.o
+obj-$(CONFIG_IO_URING_BPF_EXT)	+= bpf_ext.o
diff --git a/io_uring/bpf_ext.c b/io_uring/bpf_ext.c
new file mode 100644
index 000000000000..146f70054c0a
--- /dev/null
+++ b/io_uring/bpf_ext.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Red Hat */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <uapi/linux/io_uring.h>
+#include "io_uring.h"
+#include "bpf_ext.h"
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
diff --git a/io_uring/bpf_ext.h b/io_uring/bpf_ext.h
new file mode 100644
index 000000000000..179530ce865b
--- /dev/null
+++ b/io_uring/bpf_ext.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_OP_H
+#define IOU_BPF_OP_H
+
+struct io_kiocb;
+struct io_uring_sqe;
+
+#ifdef CONFIG_IO_URING_BPF_EXT
+int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
+int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_bpf_fail(struct io_kiocb *req);
+void io_uring_bpf_cleanup(struct io_kiocb *req);
+#endif
+
+#endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c3ef52b70811..451500c61917 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -38,6 +38,7 @@
 #include "futex.h"
 #include "truncate.h"
 #include "zcrx.h"
+#include "bpf_ext.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -589,6 +590,14 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_BPF] = {
+#if defined(CONFIG_IO_URING_BPF_EXT)
+		.prep			= io_uring_bpf_prep,
+		.issue			= io_uring_bpf_issue,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -847,6 +856,13 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_BPF] = {
+		.name			= "BPF",
+#if defined(CONFIG_IO_URING_BPF_EXT)
+		.cleanup		= io_uring_bpf_cleanup,
+		.fail			= io_uring_bpf_fail,
+#endif
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.53.0


