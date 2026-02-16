Return-Path: <io-uring+bounces-12262-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMkJA+JLk2mi3AEAu9opvQ
	(envelope-from <io-uring+bounces-12262-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:54:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 80EB2146779
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DBF2304914C
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46EE1FF61E;
	Mon, 16 Feb 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwxNzVhL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197484A35
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260712; cv=none; b=ufIEtmhh3tCg1BechicACFJ88iKVeay82VIqHcQMVsdP5uwTHQEhAQuznXvv4SHcx1/P2OX0nTuXy1iNgpKTQuWI1GCa2PEn1AclFX15J9BQ6Bes5+3yvPfBgXtDqMoK+CZxidZ6JHJG2X/RAbQ1Z3dEk6XttcwPo9T7GQqFJBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260712; c=relaxed/simple;
	bh=WzaW0s2icJd/dIjeHWiCQ77vY1eQE2BCTkHMiJxM6eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwy2KVItitdu9SR8F0KtDiLuQKtJB5/lCNjO8Klw6w8PxoL4pxr5J5NFJPyzxh8BPuaAhSYFmC/Q31erjyGKTK/BPRJmmdELFha1p1zzkO5md+yu2/HX/MAqKty/yDA3+CqkkzJdLlLwiZPC7xHZ2DUxJLJEnzZ2DSFv6csdzAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwxNzVhL; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so32723835e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260709; x=1771865509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEAsUL9tJFyi8res5MUILfhAQ913PEDGyGmPnzCOd28=;
        b=UwxNzVhLUGco69eOyyftnUIfWNepFV9UrRRV38jc4RBZJ8lXJg+t1eSw3pgnfG7WPy
         qpHsT9XqH9WcCBswz36NR4boz1XAPd7nIFXmprz4O545Dz3SsgudwdbPGFtDM8P885DZ
         CsQJp9GEhfuqMnpdmZpv2clfBLDOVlanvHKIWKCy/duTySFVAgu5ilyVRQEPmO/u4L18
         1UT4J6SMERYFU9F+NPW6hTsktsxsLWPYHi5c6DLdVQXPkN32YVScSfyQiJ9Al3vHi8Bm
         i3D/mYoEzTjY+/706EGDC2lyux179WOcJO3UqEfehmnWqgMmTnv0MpIDwfwEz/lCijJd
         HG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260709; x=1771865509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MEAsUL9tJFyi8res5MUILfhAQ913PEDGyGmPnzCOd28=;
        b=JFFDUM64VuqEbMXHLS27hskpa74eRc0J3gfGfbW4ZZdUeXPhMJHEaTmdOJ00nY99jZ
         AUZsbl83Cs4mwkgj31JIPHMQVtl+elENLMwhFbQA0NYQUA4khDz8qAGeg5nHCl+dmMnD
         X1HRrDepSzJEXatxDPdR3TM4Kvz92hZ+Ec7elTyFepXINqyvoZvSvBrR2xeg5qOg0BlJ
         ll/E0nqY7qdC8jDT2iCqXVhXOups8J5/2BueNajbP0X/b3ubanJHch7wlLaGb0f4191+
         KEDDqeilcLlEVCqzamUj2Rn1Xk1kbOVDGZgIqiHgzv4WlcerukoLw6TuLB2xWXCiBYFB
         JSEA==
X-Gm-Message-State: AOJu0Yy5Dcx4hP8ooktrxDO4G0yTjyvhmy51WWhIui6nG+9gc23ixpQl
	evIXXJX9HwDFWqlSYgQf93EkuMNt48Qhg5Esrk2chPjBxTyfiO1SVey7HphbYXA6
X-Gm-Gg: AZuq6aJY04e1mExEDkIAf2k8vNgWyAllO4yrgmO1ielkrhdtQ9zvF6njxQW3SKOv/2x
	Sfb2Mrvw5L+KuprGsKLKA9CrCbDDZK9BiadCK9c07K2LmTClyh6GOFhJiSslvEDsVAn+7e2WT6X
	L5WeUipDobPYUdkRUDkB9+xM+EVlM4EJXR647P/lNUOHqdumpeYed35rv6esAk8xo7aycg9luCE
	V6mRGRDgwK4bAMjP1y14Szb1COHaMC3JYIflu8K2BUL7wgrjcsL+EfU1R2yeL9/pn5BF/wgUJSb
	PVvhAFsZtT/cZaaA4cL2qc+1t5R45Vy99IaH5kwgM4YWz93hTqRmPhz0Bv4TlzdiW+l2+PPyv/t
	VyKuhjVSmFwULWP7NBY9JZp0cjwV7Ez+TdON5k3NpixyQHI6jTANsrJitZF4xGYeCz76d1Eg1ti
	wOZAdENVzM45F17/KvxvEWZWjR+eAvS8Xps84g1QtnXf70QXa8+cua/ns4tujoFj8l/tRYsD9T8
	Jgb5a+vLmQbQe9pYCE=
X-Received: by 2002:a05:600c:1e1d:b0:477:8985:4036 with SMTP id 5b1f17b1804b1-48373a15f31mr180605805e9.1.1771260708728;
        Mon, 16 Feb 2026 08:51:48 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b64b08bsm76454255e9.6.2026.02.16.08.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:51:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v7 2/5] io_uring/bpf-ops: implement loop_step with BPF struct_ops
Date: Mon, 16 Feb 2026 16:51:23 +0000
Message-ID: <ec7d21e6e16c49165fa1e8af2aa09d01c111ea97.1771260487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771260487.git.asml.silence@gmail.com>
References: <cover.1771260487.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12262-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 80EB2146779
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


