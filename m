Return-Path: <io-uring+bounces-12167-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KI4HeTSjGm+tgAAu9opvQ
	(envelope-from <io-uring+bounces-12167-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E67D4126FEF
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BED37301945A
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 19:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45EFE303A30;
	Wed, 11 Feb 2026 19:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZnzo4Re"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F3F34B691
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836702; cv=none; b=bRcp47kAb1erkfGOAAlpkzln+IA+UhoIN2hDNRpFt2Y4EnZdwqX5Q+00/5NjotqN2DEEfJkRbbtGX1QbZAf5UZWVBZplLWq++93W/Mqh/sgN+MSHmKMZee6OO46rLr/m19lJLzMkPDNRyg1fStEN11223H63rcQu9+XL2hJGK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836702; c=relaxed/simple;
	bh=BK3XaE/cL/b4cnIeYExKm2jiwINNJJPSMqSRyjpOCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnlmiqyfQfuSUF7F0sDUozJ2xqLCh8DLkx6plhxmloCDSULhwy01q7lMFdXgEbiFOy2/aYIqMq80h4Iu1W8EMAu3mzAL73zspDYtfzpD0J1NLAgrr4hC5OOl60pymQAgH+Lr8CShELYB82BNrvHqUaRpKChDtNXg0a/tSqq7Yjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZnzo4Re; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-480706554beso61561825e9.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 11:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770836699; x=1771441499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLQBu1+0ACc4aQeDGPWwgFYDop8RauWam/9UYq+KR3Q=;
        b=cZnzo4ReW24PJPHA6sseIBqg1UefWOGKRCdEFwq9qzmIeSmhoqQWiWj0Mq2rfwN15X
         qoU2qnTDf0MjDlJM5oXSnHV+euMfPjq8WNzH7WIrupm6S5HSlXvZjonzYq3W15usYzoH
         +XDhxXn7DBDv0VPVyptB1iyhV+WAUEKLXgsFXcEiigC3J8GPIQvnTtThYUsFTPQREUQY
         DtGBV/MAKD0Jr7p/UcMnlsnpFSvzzoV/PLbism9ajse2fmMZrINdWBV49ejVpsY4Aeu1
         XN2csTgCj4vZRpeFx3LhNpUKuGoZm8axKAkpfn/USH0uIQd7FRHktk2I/BsDdNL6ZSFa
         MF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770836699; x=1771441499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vLQBu1+0ACc4aQeDGPWwgFYDop8RauWam/9UYq+KR3Q=;
        b=PZJdun6aEizqPThzN56M+pqCvC8IMpbVnARjQY2Sh0xfwiqcRHo3SCMcKCf89curjB
         qv+USAab40CarRqi3Z2W6VhpSr4YcYCUs1pNxBokbP82agkikO1eAcMcY7hRIOoCcmsO
         47b2d4QrnU6QgthHhnV3RS4qAzY4Qh/s310d2NGPZrfgJcyLCy9rQhnQx4TQ14i6T/+L
         3OJFmLnZJjUOFaG2kQhhOqGEhhSXnX27N333RG/FbHM0bq2ZETndvteg6q9gQYy78hnb
         qamvztgl1qkhicf6puHFnsMarGPmvrvIVjwb0Op1vyf57JOY3XTOLr3SGE14eq7QCv+j
         JJ+Q==
X-Gm-Message-State: AOJu0YyxTyf+MYZ/FE03ri6wOx35RK9iewXMUUeC7tRuIjvSUMoZQNv0
	dh2eKOWDez0iIOeM9p0NkM6yUlI2M97W8GuBMEKieQNIaxzJfPH5vAfp+IBBZBmK
X-Gm-Gg: AZuq6aKUavZ7aw9FqnUhRYGkZk57SG4kAXbQOUHzvurio6jktz3IMPg2l5tm0KtKmQB
	C2owQNREwfoEnUxffHG9s+XZeuGC+qWonTXYk7z9nIecEJfKEQW4cy133kjmMhdf3KwrN2zKlTq
	2gFjCX97gg0yZ7EOlhUbhwvTY4gE6zjO0A/cAroGWdQuk3juNRiHQKXzufT68Ll3KlNXS4ecw4u
	saEE9G8Q7SqE4RRjaJweb8UerybIL1z0QSHepwqKLbm6xAPQuXXB8p4WBgFfLnZhH/LW9DRERhc
	mTCL2o8Q9LIDA/BT9w8buKu+FnQOOoxrYeZbWnvFp2Hgjw9Qk7UeIkvHzaPhmGyA9reWum3SuOt
	EJIPdIW9xxbw+1Nwe9FrhJgLuGfn2N3DI5ITkhgcLe/JvWDSgt3GtBuZYZXh/Vval31mGw8dSnv
	Zsu+N/A5bwqjDau3EEGl9hlOSneNExPPQ3B9JbzLirk9mgOolDf8OvH/0U+TTg2oXo1aXVpeFBc
	yxu4BGTdBqs4SN9LOaDnNNlizRyHw==
X-Received: by 2002:a05:600c:4e91:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-4836571fdd4mr3017995e9.35.1770836698537;
        Wed, 11 Feb 2026 11:04:58 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783dfc8b9sm6174169f8f.24.2026.02.11.11.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:04:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v6 2/5] io_uring/bpf-ops: implement loop_step with BPF struct_ops
Date: Wed, 11 Feb 2026 19:04:53 +0000
Message-ID: <f9cf0331a4954f4f92b49175380b67633a574bb2.1770836401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1770836401.git.asml.silence@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12167-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E67D4126FEF
X-Rspamd-Action: no action

Introduce io_uring BPF struct ops implementing the loop_step callback,
which will allow BPF to overwrite the default io_uring event loop logic.

The callback takes an io_uring context, the main role of which is to be
passed to io_uring kfuncs. The other argument is a struct iou_loop_params,
which BPF can use to request CQ waiting and communicate other parameters.
See the event loop description in the previous patch for more details.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Kconfig    |   5 ++
 io_uring/Makefile   |   1 +
 io_uring/bpf-ops.c  | 128 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h  |  14 +++++
 io_uring/io_uring.c |   1 +
 5 files changed, 149 insertions(+)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h

diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index a7ae23cf1035..a283d9e53787 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -14,3 +14,8 @@ config IO_URING_BPF
 	def_bool y
 	depends on BPF
 	depends on NET
+
+config IO_URING_BPF_OPS
+	def_bool y
+	depends on IO_URING
+	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 1c1f47de32a4..c54e328d1410 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
 obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
+obj-$(CONFIG_IO_URING_BPF_OPS) += bpf-ops.o
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
new file mode 100644
index 000000000000..ea9c062a4d9f
--- /dev/null
+++ b/io_uring/bpf-ops.c
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/mutex.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+
+#include "io_uring.h"
+#include "register.h"
+#include "bpf-ops.h"
+#include "loop.h"
+
+static const struct btf_type *loop_params_type;
+
+static int io_bpf_ops__loop_step(struct io_ring_ctx *ctx,
+				 struct iou_loop_params *lp)
+{
+	return IOU_LOOP_STOP;
+}
+
+static struct io_uring_bpf_ops io_bpf_ops_stubs = {
+	.loop_step = io_bpf_ops__loop_step,
+};
+
+static bool bpf_io_is_valid_access(int off, int size,
+				    enum bpf_access_type type,
+				    const struct bpf_prog *prog,
+				    struct bpf_insn_access_aux *info)
+{
+	if (type != BPF_READ)
+		return false;
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (off % size != 0)
+		return false;
+
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
+				    const struct bpf_reg_state *reg, int off,
+				    int size)
+{
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	if (t == loop_params_type) {
+		if (off >= offsetof(struct iou_loop_params, cq_wait_idx) &&
+		    off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
+			return SCALAR_VALUE;
+	}
+
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops bpf_io_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.is_valid_access = bpf_io_is_valid_access,
+	.btf_struct_access = bpf_io_btf_struct_access,
+};
+
+static const struct btf_type *
+io_lookup_struct_type(struct btf *btf, const char *name)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return NULL;
+	return btf_type_by_id(btf, type_id);
+}
+
+static int bpf_io_init(struct btf *btf)
+{
+	loop_params_type = io_lookup_struct_type(btf, "iou_loop_params");
+	if (!loop_params_type) {
+		pr_err("io_uring: Failed to locate iou_loop_params\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int bpf_io_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_io_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_io_reg(void *kdata, struct bpf_link *link)
+{
+	return -EOPNOTSUPP;
+}
+
+static void bpf_io_unreg(void *kdata, struct bpf_link *link)
+{
+}
+
+static struct bpf_struct_ops bpf_ring_ops = {
+	.verifier_ops = &bpf_io_verifier_ops,
+	.reg = bpf_io_reg,
+	.unreg = bpf_io_unreg,
+	.check_member = bpf_io_check_member,
+	.init_member = bpf_io_init_member,
+	.init = bpf_io_init,
+	.cfi_stubs = &io_bpf_ops_stubs,
+	.name = "io_uring_bpf_ops",
+	.owner = THIS_MODULE,
+};
+
+static int __init io_uring_bpf_init(void)
+{
+	int ret;
+
+	ret = register_bpf_struct_ops(&bpf_ring_ops, io_uring_bpf_ops);
+	if (ret) {
+		pr_err("io_uring: Failed to register struct_ops (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+__initcall(io_uring_bpf_init);
diff --git a/io_uring/bpf-ops.h b/io_uring/bpf-ops.h
new file mode 100644
index 000000000000..e8a08ae2df0a
--- /dev/null
+++ b/io_uring/bpf-ops.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_OPS_H
+#define IOU_BPF_OPS_H
+
+#include <linux/io_uring_types.h>
+
+struct io_uring_bpf_ops {
+	int (*loop_step)(struct io_ring_ctx *ctx, struct iou_loop_params *lp);
+
+	__u32 ring_fd;
+	void *priv;
+};
+
+#endif /* IOU_BPF_OPS_H */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 52f9a5c766c1..1f7c03728083 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -87,6 +87,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "bpf-ops.h"
 
 #include "timeout.h"
 #include "poll.h"
-- 
2.52.0


