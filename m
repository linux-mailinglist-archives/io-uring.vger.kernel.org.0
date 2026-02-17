Return-Path: <io-uring+bounces-12287-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAlpOYlSlGlFCgIAu9opvQ
	(envelope-from <io-uring+bounces-12287-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8581314B718
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A584305ACA0
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8FB32A3C1;
	Tue, 17 Feb 2026 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiQEzI3i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08A333720
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328038; cv=none; b=bzkLl5/h546s6/U4ocuVejrbzgziTXaMLWvJv+GdpY9WeChyhrXJKTo2JjjTxIc1Mo8xGs+uWxm/8gTPHFWt25yZ+roa++XxuwxFztL2lvrKGbHNkVId+SGYDmBwfHAJVpPATQx82vDyVsbhRKdcdmycjit3Nr5yxBGQPRitPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328038; c=relaxed/simple;
	bh=bTaF2MQ3EfzwNpXixmF70ewnIDKL3yoorxmfbpq/QAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vte/TmXIiT/Eszsr2QS2aWE4x/Zb0tkv6tj/fhk78ljgXrkQXEY9NJ0/rSBuKp0M9AtSALLa1mtNdt0JqCezTFgcriRskTe7RZ0HfG3RTmkjr0dJ9ddGc7G602ugmCQlwQQ2rGp/Ii+ZNiaT4Svf4vcfp0euYYMcJK57g6MYwGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiQEzI3i; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-436317c80f7so4140620f8f.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771328034; x=1771932834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dj8gWq51EpHZ9jkXD8suC5LuUkyRO0R1IpZbPV+RIfk=;
        b=GiQEzI3iO+mvXnXazTxgzgnFOeVwhpOsQawc6dEzjJdA19Op/8powNfru89YmZlzsL
         U0oFON4hPsSBE6+v2NEkHlwmZ3A35sriATESTJW+yNYvnZSjfOKnbPa1CBdtT9iIgqM1
         Eo9+YkFKjZCJahu8NnM1hk7GMa/qt0SBMVPIssQH5PCWla6kJmn8WccQHbXA6vP08Aoz
         RaslYQc1z7gBEhzQc0ifZuL6jIgK/H+ED8vMpU4MFpxmgUwoo30dBVp8WYxDi6IfT545
         7xWzv5fgks0uP/BeAkKH4Bj0D7I/NemhCV3KyfUhvJWoyDeA5qdAFgCa5GquTCfhMLQT
         ZB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771328034; x=1771932834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dj8gWq51EpHZ9jkXD8suC5LuUkyRO0R1IpZbPV+RIfk=;
        b=UIuFAK9roh9m24JtSuFQM8WM1qLlm2yktom9Ob8Blb5Gih6nrOIKVUfTX4ODrHOV1X
         Y4xzKiSz19X0XfK4rBufQxcbpj76XumXf4FXP5pKPLFHbQiVLY5jgptr09G85GBf88kQ
         OtCKHfgx6AfK5wKPLUJ9qtzoTpxAMtx4MKIZ7nTGuSuth16AhUAgGA2NyLnIDnUjc+47
         wUMLJRlPkCdCJ7LxnvOGl7uva0rdKo9wcHESuryfVdqTEq3bPH5+ULz4SDgPfZTL9kyb
         aQ2Ey9UfqT41PCvBfj7Pp+zWoLCMdOM4VN3+WEpkmzAgKNB2LIswbGtA9rrVc9AF+Scl
         7Tfw==
X-Gm-Message-State: AOJu0YzVMw8tfLyG6NQ+c5hZJ0rodGrUJMvUzJL10dP0lpuI22xnUc0W
	RTmKedPiurzbv3mHalz8v4qaGU2v0poUnEoumqJ+mGbBf2cQBdovJrLqNnvn6Q==
X-Gm-Gg: AZuq6aJsqS+TezxszlePTD/oSFkQRehSEiNIfggRCYNLyK0Lcc4iLR9f1oipIsufiks
	hfEZBbiSgAiq9N78FlLIYG2kGoD5eBHkAceJfcNGOGzIm0dJiTmr2d7B+NUI8gRyHd+oPb/I/+9
	dnEmIrJ4F/mBvYWF2CvmdloxyCv9CmSchFfI2BnNqMRFbPUYUE2kyT7XEQeIeWEfy2hPT8f2bOO
	o97LqaoREq2e1MAUH8Q0cpl8Gv/bEgvG8xTxHzgQoKi8a7gj/2mysaNILEgUocGOzxCiSnKLrHI
	FG3RNJQywYgDngmKjnAJiLWGrG6VZYILACgswsAmJKvvjNnOPRJI6cyQC5s4FLMyubkYWKqvPKk
	iyjsmw072T7WbfZgN7KOW9p2tkngrCbdL1lE5mGfjLmVM2/T4RvEB4vvIZlw5PTdU/eOiKeWYbO
	qWkuZi2PMamRdJLouoonUIWESBIQ4MovfvEOcU7dEsTlvG1FOiNsEQFN4uI+UvfEL8JADBT0Eis
	mP5ON2SPVoblHDhRadA6WL4oke69ASDdw==
X-Received: by 2002:a05:6000:4006:b0:436:549:e15d with SMTP id ffacd0b85a97d-4379d60cbf2mr19981072f8f.18.1771328034001;
        Tue, 17 Feb 2026 03:33:54 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac800esm36258343f8f.27.2026.02.17.03.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 03:33:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v8 2/5] io_uring/bpf-ops: implement loop_step with BPF struct_ops
Date: Tue, 17 Feb 2026 11:33:44 +0000
Message-ID: <745ade542ab7eaa91af04bb1b9f22a4b3820477c.1771327059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771327059.git.asml.silence@gmail.com>
References: <cover.1771327059.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12287-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 8581314B718
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
 io_uring/bpf-ops.c  | 127 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h  |  14 +++++
 io_uring/io_uring.c |   1 +
 5 files changed, 148 insertions(+)
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
index 000000000000..975db5a78188
--- /dev/null
+++ b/io_uring/bpf-ops.c
@@ -0,0 +1,127 @@
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
+		if (off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
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
index 0c8bb4e8480a..548ea5a080a0 100644
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


