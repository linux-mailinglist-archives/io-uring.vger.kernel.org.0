Return-Path: <io-uring+bounces-11938-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EurIIuReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11938-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B02092ABC
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E729931730AE
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2511633C19F;
	Tue, 27 Jan 2026 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJZF5TJt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0584233B6FA
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508879; cv=none; b=JG4iXjTT84NxRDDkUceUFOMyI28eUVgvDMKbdmVWWenSD/Fo0JdM2eUftiJz3VImng6ZUkk9wAl74C/OxdeErtu71dpfAf4sW/qiC+qLZqoMjBM/EE/StxPEYbJKVSJnWr+2cJa8s0pyZi2gdIizYRUt2CrA6DX5Qr3VyyWfnyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508879; c=relaxed/simple;
	bh=/1szb2H6Xx/lKih2kRWMs7yZOT8bB/k1n9BqMnkRSek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHSFPuKrhU1KYEw/eNGJQ60Aix3lj9oSF7xLZF3uJW/QMMbAGfztJQty1rctgDLpqjbMm58yndoVfL7DsCXkHQ5Du/KbbSGlNe7CKZCAebaI+YZJGENOAcc4UrJBFzqrGhTkrcsywt/MzWQISTmkf/TqmsCvNnJhp56hFjsYxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJZF5TJt; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43596062728so3937613f8f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508875; x=1770113675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmgizQ3Ze6W0FH3pKqbOeHCA2/VzsLuCznhuAnbTU7E=;
        b=KJZF5TJtrxRzoPy4lYe45OI0XBuocZqLAx1D5oJp3nu6n+8CrpY5cnvEzMKYAcnX9F
         qRa6wAjx7RKpL4u8uLi1rZf3gZlwRhCAARvmSf+2KKZLBwt62SfVkTZjxPOu2SjCNksm
         yILyW3qAMlDy66AVTnamUy9GZMpP72HNyR+8PiYSNQBFBe0AR/wQSVMFhmvPXrRNr/9i
         f+2e1wqq03zcsPBl5dnEuMP1rhlhXiYxEWf5/UfP4OsiLjYJ8TsEZr3sH1hKTOeFpGMb
         kvb6srdFbbjKNtO5oAuVPADXFIdAKxsYEuEtWe5hOitpk9Nho4graN9yS6hFV3cs2VQ/
         W4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508875; x=1770113675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YmgizQ3Ze6W0FH3pKqbOeHCA2/VzsLuCznhuAnbTU7E=;
        b=i1KBmPDc0FF/Fu4fPYpmkTQ8GNOtRLkQ+cvGMTT5UO177YQJgZhoCmt2q9594aAMeL
         P7nUfRFtWuonSGhgsZZ+9adTjtMA8H7VfEL/M+zHx4ZSAxp3/th3xRlA6Qf4Is898+34
         PtTLkz93RkrPuva508idlPVN5M8wCTPNHLpihUyOUTyQNRpxgwYO3YoOoQGnDwe0vXnW
         pXPUAriPeHLvCu+tag5JMpyRL4Fbkv89h5ZOqy2+p9DADHbZkTWYo7qD9BhIiXx5CerS
         zVDn4CgSbRkY5SnRWh6xjQ0WXJVVXF63jDSRuqNsMOPoLjfN9sHPWANYCkd7GO/1HS/J
         5ByA==
X-Gm-Message-State: AOJu0Yz2tQ2sw6pHU//qqaSi1q2pzqY8KZ/dVezrZKciFe975juOVFXM
	tOp7eYgx6M0tjMjamoAY8b1W/bd2JjgN8OF5MTNz+mzM7BQ9i8oZ9J1vzrkjwgKM
X-Gm-Gg: AZuq6aLtmZMCBv3Bk2XHStUYTeK75r932RWVYEIo0NgaDVzerKjeqB8x8yTwzYgZi+0
	fGRp7s8hxRomSC53c7HR5ToRrg3anOns74DnH9IrgRDK7umwl+Vk0PHaHS9OxLt9ctjmhQPa4JR
	+duY7GYKeTWQ5SW5JLKRT6BGjJw+/iBeydIsyNARE9y3XhTDjbf87k16oaD9uiaj9rVFczB+5NV
	rmoLC+BY2VNAaELUFhJoTWvv9Wh5oXkdvpDeiPQZzjWimAbgLx8Ty1Dwn6F6TVFOK0iC5DCnsWo
	me1ISJINKfqvTpBNktmPcDBdCiDWkgZe85TCZKxrIoxAXtW8rRFu6vZvzA/gk6NHxoXGWPCMOPN
	sktYaNEXqkuq5e5grtLxN2oE0YM4XLT9HsY7fhcAY+PgZgKbby71D5FKbp9i4lfnZ1NwEjYQB9q
	0bYuaN0PCMhjlHWS7deohDjsm39w0nSx/hykyaBE/tHiXy8/0gMevJcBpcqjfedPgpLPqaEI27f
	RZqaUNiL9LnzFVj11dIJo5Ba1t+
X-Received: by 2002:a05:6000:26c7:b0:435:db93:7311 with SMTP id ffacd0b85a97d-435dd1f0a91mr1567584f8f.18.1769508874742;
        Tue, 27 Jan 2026 02:14:34 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 2/6] io_uring/bpf-ops: add basic bpf struct_ops boilerplate
Date: Tue, 27 Jan 2026 10:14:06 +0000
Message-ID: <4d5bd945d68c6505443daa83329da766d886370d.1769470552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769470552.git.asml.silence@gmail.com>
References: <cover.1769470552.git.asml.silence@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11938-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 2B02092ABC
X-Rspamd-Action: no action

Add boilerplate code with a basic bpf_struct_ops implementation and
related files and definitions. It'll be used in following patches to add
support for io_uring bpf ops.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Kconfig    |  5 +++
 io_uring/Makefile   |  1 +
 io_uring/bpf-ops.c  | 91 +++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h  | 10 +++++
 io_uring/io_uring.c |  1 +
 5 files changed, 108 insertions(+)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h

diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 4b949c42c0bf..b4dad9b74544 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -9,3 +9,8 @@ config IO_URING_ZCRX
 	depends on PAGE_POOL
 	depends on INET
 	depends on NET_RX_BUSY_POLL
+
+config IO_URING_BPF
+	def_bool y
+	depends on IO_URING
+	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
diff --git a/io_uring/Makefile b/io_uring/Makefile
index d4dbc16a58a5..675865ddb906 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF)	+= bpf-ops.o
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
new file mode 100644
index 000000000000..a89d1dea60c7
--- /dev/null
+++ b/io_uring/bpf-ops.c
@@ -0,0 +1,91 @@
+#include <linux/mutex.h>
+#include <linux/bpf.h>
+
+#include "io_uring.h"
+#include "register.h"
+#include "bpf-ops.h"
+
+static struct io_uring_bpf_ops io_bpf_ops_stubs = {
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
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops bpf_io_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.is_valid_access = bpf_io_is_valid_access,
+	.btf_struct_access = bpf_io_btf_struct_access,
+};
+
+static int bpf_io_init(struct btf *btf)
+{
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
index 000000000000..a6756b391387
--- /dev/null
+++ b/io_uring/bpf-ops.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_OPS_H
+#define IOU_BPF_OPS_H
+
+#include <linux/io_uring_types.h>
+
+struct io_uring_bpf_ops {
+};
+
+#endif /* IOU_BPF_OPS_H */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aea27e3538bb..09920e56c9c9 100644
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


