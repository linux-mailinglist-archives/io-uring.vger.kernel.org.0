Return-Path: <io-uring+bounces-11945-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HPmKvYEeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11945-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B730991DE
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 328A0300690D
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8115328257;
	Tue, 27 Jan 2026 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DoQH372g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA42FFDFA
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538800; cv=none; b=Mg7sOFbR5jTLXIBReQExtUEAPiNxJjfIgQV0Pok2bACZncpyf/SMHs2wXjYrM3xekz6JaGrPJrkACK4QB65RypMk2hh+LflgY/XyOkoAl4uFiD91CRs7SOx85fOBg00RD8DzMVFBok/2cbFZq4HEExtQMsaz9MVNQvb+6oOVPcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538800; c=relaxed/simple;
	bh=VM//sJR8FmOhe1nehm1X9tjb+ZUPg09nVhO/iJ54L5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt0wIEyV2VnjE/TwKAEHzX21KQYYiJwIy5T+zscwol3K0jO7wmqWu0/+kETPBMmmk4XzeHugEuSxv9P826o4N2zaqoc+f0pEqOkZMwyoNSPj3SStYQIxS9RC/nOX6KsEErc7uDpHzvjTme/OIiWRwm2uAXKL7cCH49iSGM7Xe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DoQH372g; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-124899ee9d3so99243c88.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538796; x=1770143596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpj2SU7aWh0jnM2kQHnSU+K4BHelkghf0eMnwlvdFA0=;
        b=DoQH372gx56wcgUmjzF45SRfRZJLyafCfRTM6iu4oGGFywkUtcl5QHCrtCmUMO1eTu
         nPb7oDg9buWkjsdHtkg41WXU1bIDmpqBCWmQYJdlWwkuDfVZHmBiGpx87RTbBRFi52Z+
         gvGONbRGDyDvn/QrqNr1pYOGglgFAy/vNWDI3kNexCM49Ipkq9yUPx0EsKlyJ3BF1GMP
         174CuLSwu7mm+O1Tgkb1+mo7vsPLxbi9248FOB2U8N1VfqZ8+af8vOapTDsOcZc+e0ZL
         6L6Fae0WoTrwvbasEIGTAituF85hFs9pdwGvpdRNVXjTNRogex0P15WQ/xej5DYrHYi8
         F7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538796; x=1770143596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gpj2SU7aWh0jnM2kQHnSU+K4BHelkghf0eMnwlvdFA0=;
        b=CXxENMTX4fyhv9us99+y9qNhdV2Jiu2unFyCnZYE1cpw0MsDGYlDcbbSu/FAHmFyQm
         FSOtPDxMzF0oXJUBg9CTdtO0Wu0FmVJOMBU0Gz/H9P4vNRTTvdcuMmwPb04uRP11VoVu
         BrZSp1M2zkXu5+xKTpDoNBy3Xh/PctPKy9qUAtC1UdCTwUcmY0/eS0miUtJAJKNz42ZK
         v1VkoAWr43CSU56m+aK/y5NqDhITgrlk5d+jXUFSCo8VPOBNDCUY20ETXDXzc1/1V16+
         MU8bmsTmA6eo9PjEOFtWhkYpjg4XFuNylxRPCJGq2ElGv10sGwrYPFFysrlWVbdpoqgC
         VmDQ==
X-Gm-Message-State: AOJu0YyWBzGjvHP+LEYLk7d2nBt85gN0mhskeJciWwvf10SOvBLhgDf4
	Uf56nUsTMwdm0pKjIzV7lHSIrXkNKh4X6EwQFMJguFkzvJ9Y/a1DcsqT7e5E98/e6giwDb+4oqp
	z/PNM
X-Gm-Gg: AZuq6aKOReUWy/sgGi4XzStiA6YO+rMwHdtL4wX5kQJ6l+58+qwz+6gOI5DH2k1SLqJ
	82kvFjsbrHUiWyesbbB/msxC5PL6Z1TV/9k3KIJ5guGaIVZvc56bD92JLFleknvD6Oa6Yt8RG1R
	fbodSwMVHlzNg+cgondAf5skExh+5Ibs6os19UEymW79xGRSj91qfOaTQqzvxsDHLtSQVc3l5Up
	tIYroFSRwFMWxc822hK6Xq6OTTIy1oBrdM+mHxdFWH3N6N2Wff98iYGnDT5/t3hPyEHB5NnxqO/
	aSHBAmFP32EC9Z+PEPjhym9rwtAgY+tMSI/2sruU8OK1EC007lNNmYXnzkvpuIXsKomY/U7bnf/
	lLb6awZa0HSVq7KhW5oFAE+IfLRFffhClecoIlfdj21j5d9qO34TKzZfGiJIwILH9rd0nOQeimx
	vf5J/b4EkNvWGEg4xSQUIf8bzQ6haEn+luMk5sEjTgKzbPGPPHNJPJUEdJX4F6yQ==
X-Received: by 2002:a05:7022:123:b0:119:e569:f865 with SMTP id a92af1059eb24-124a0577c42mr1440487c88.2.1769538796192;
        Tue, 27 Jan 2026 10:33:16 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring: add support for BPF filtering for opcode restrictions
Date: Tue, 27 Jan 2026 11:29:56 -0700
Message-ID: <20260127183311.86505-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127183311.86505-1-axboe@kernel.dk>
References: <20260127183311.86505-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11945-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 0B730991DE
X-Rspamd-Action: no action

Add support for loading classic BPF programs with io_uring to provide
fine-grained filtering of SQE operations. Unlike
IORING_REGISTER_RESTRICTIONS which only allows bitmap-based allow/deny
of opcodes, BPF filters can inspect request attributes and make dynamic
decisions.

The filter is registered via IORING_REGISTER_BPF_FILTER with a struct
io_uring_bpf:

struct io_uring_bpf_filter {
	__u32	opcode;		/* io_uring opcode to filter */
	__u32	flags;
	__u32	filter_len;	/* number of BPF instructions */
	__u32	resv;
	__u64	filter_ptr;	/* pointer to BPF filter */
	__u64	resv2[5];
};

enum {
	IO_URING_BPF_CMD_FILTER	= 1,
};

struct io_uring_bpf {
	__u16	cmd_type;	/* IO_URING_BPF_* values */
	__u16	cmd_flags;	/* none so far */
	__u32	resv;
	union {
		struct io_uring_bpf_filter	filter;
	};
};

and the filters get supplied a struct io_uring_bpf_ctx:

struct io_uring_bpf_ctx {
	__u64	user_data;
	__u8	opcode;
	__u8	sqe_flags;
	__u8	pdu_size;
	__u8	pad[5];
};

where it's possible to filter on opcode and sqe_flags, with pdu_size
indicating how much extra data is being passed in beyond the pad field.
This will used for specific finer grained filtering inside an opcode.
An example of that for sockets is in one of the following patches.
Anything the opcode supports can end up in this struct, populated by
the opcode itself, and hence can be filtered for.

Filters have the following semantics:
  - Return 1 to allow the request
  - Return 0 to deny the request with -EACCES
  - Multiple filters can be stacked per opcode. All filters must
    return 1 for the opcode to be allowed.
  - Filters are evaluated in registration order (most recent first)

The implementation uses classic BPF (cBPF) rather than eBPF for as
that's required for containers, and since they can be used by any
user in the system.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h           |   9 +
 include/uapi/linux/io_uring.h            |   3 +
 include/uapi/linux/io_uring/bpf_filter.h |  50 ++++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 321 +++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  42 +++
 io_uring/io_uring.c                      |   8 +
 io_uring/register.c                      |   8 +
 9 files changed, 447 insertions(+)
 create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
 create mode 100644 io_uring/bpf_filter.c
 create mode 100644 io_uring/bpf_filter.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dc6bd6940a0d..74bf98362876 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -219,9 +219,18 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+struct io_bpf_filter;
+struct io_bpf_filters {
+	refcount_t refs;	/* ref for ->bpf_filters */
+	spinlock_t lock;	/* protects ->bpf_filters modifications */
+	struct io_bpf_filter __rcu **filters;
+	struct rcu_head rcu_head;
+};
+
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	struct io_bpf_filters *bpf_filters;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	/* IORING_OP_* restrictions exist */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..94669b77fee8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -700,6 +700,9 @@ enum io_uring_register_op {
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
 	IORING_REGISTER_ZCRX_CTRL		= 36,
 
+	/* register bpf filtering programs */
+	IORING_REGISTER_BPF_FILTER		= 37,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..2d4d0e5743e4
--- /dev/null
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring BPF filters.
+ */
+#ifndef LINUX_IO_URING_BPF_FILTER_H
+#define LINUX_IO_URING_BPF_FILTER_H
+
+#include <linux/types.h>
+
+/*
+ * Struct passed to filters.
+ */
+struct io_uring_bpf_ctx {
+	__u64	user_data;
+	__u8	opcode;
+	__u8	sqe_flags;
+	__u8	pdu_size;	/* size of aux data for filter */
+	__u8	pad[5];
+};
+
+enum {
+	/*
+	 * If set, any currently unset opcode will have a deny filter attached
+	 */
+	IO_URING_BPF_FILTER_DENY_REST	= 1,
+};
+
+struct io_uring_bpf_filter {
+	__u32	opcode;		/* io_uring opcode to filter */
+	__u32	flags;
+	__u32	filter_len;	/* number of BPF instructions */
+	__u32	resv;
+	__u64	filter_ptr;	/* pointer to BPF filter */
+	__u64	resv2[5];
+};
+
+enum {
+	IO_URING_BPF_CMD_FILTER	= 1,
+};
+
+struct io_uring_bpf {
+	__u16	cmd_type;	/* IO_URING_BPF_* values */
+	__u16	cmd_flags;	/* none so far */
+	__u32	resv;
+	union {
+		struct io_uring_bpf_filter	filter;
+	};
+};
+
+#endif
diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 4b949c42c0bf..a7ae23cf1035 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -9,3 +9,8 @@ config IO_URING_ZCRX
 	depends on PAGE_POOL
 	depends on INET
 	depends on NET_RX_BUSY_POLL
+
+config IO_URING_BPF
+	def_bool y
+	depends on BPF
+	depends on NET
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bf9eff88427a..931f9156132a 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
new file mode 100644
index 000000000000..5207226d72ea
--- /dev/null
+++ b/io_uring/bpf_filter.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF filter support for io_uring. Supports SQE opcodes for now.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/io_uring.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "bpf_filter.h"
+#include "net.h"
+
+struct io_bpf_filter {
+	struct bpf_prog		*prog;
+	struct io_bpf_filter	*next;
+};
+
+/* Deny if this is set as the filter */
+static const struct io_bpf_filter dummy_filter;
+
+static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
+				      struct io_kiocb *req)
+{
+	bctx->opcode = req->opcode;
+	bctx->sqe_flags = (__force int) req->flags & SQE_VALID_FLAGS;
+	bctx->user_data = req->cqe.user_data;
+	/* clear residual, anything from pdu_size and below */
+	memset((void *) bctx + offsetof(struct io_uring_bpf_ctx, pdu_size), 0,
+		sizeof(*bctx) - offsetof(struct io_uring_bpf_ctx, pdu_size));
+}
+
+/*
+ * Run registered filters for a given opcode. For filters, a return of 0 denies
+ * execution of the request, a return of 1 allows it. If any filter for an
+ * opcode returns 0, filter processing is stopped, and the request is denied.
+ * This also stops the processing of filters.
+ *
+ * __io_uring_run_bpf_filters() returns 0 on success, allow running the
+ * request, and -EACCES when a request is denied.
+ */
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
+{
+	struct io_bpf_filter *filter;
+	struct io_uring_bpf_ctx bpf_ctx;
+	int ret;
+
+	/* Fast check for existence of filters outside of RCU */
+	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
+		return 0;
+
+	/*
+	 * req->opcode has already been validated to be within the range
+	 * of what we expect, io_init_req() does this.
+	 */
+	guard(rcu)();
+	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
+	if (!filter)
+		return 0;
+	else if (filter == &dummy_filter)
+		return -EACCES;
+
+	io_uring_populate_bpf_ctx(&bpf_ctx, req);
+
+	/*
+	 * Iterate registered filters. The opcode is allowed IFF all filters
+	 * return 1. If any filter returns denied, opcode will be denied.
+	 */
+	do {
+		if (filter == &dummy_filter)
+			return -EACCES;
+		ret = bpf_prog_run(filter->prog, &bpf_ctx);
+		if (!ret)
+			return -EACCES;
+		filter = filter->next;
+	} while (filter);
+
+	return 0;
+}
+
+static void io_free_bpf_filters(struct rcu_head *head)
+{
+	struct io_bpf_filter __rcu **filter;
+	struct io_bpf_filters *filters;
+	int i;
+
+	filters = container_of(head, struct io_bpf_filters, rcu_head);
+	scoped_guard(spinlock, &filters->lock) {
+		filter = filters->filters;
+		if (!filter)
+			return;
+	}
+
+	for (i = 0; i < IORING_OP_LAST; i++) {
+		struct io_bpf_filter *f;
+
+		rcu_read_lock();
+		f = rcu_dereference(filter[i]);
+		while (f) {
+			struct io_bpf_filter *next = f->next;
+
+			/*
+			 * Even if stacked, dummy filter will always be last
+			 * as it can only get installed into an empty spot.
+			 */
+			if (f == &dummy_filter)
+				break;
+			bpf_prog_destroy(f->prog);
+			kfree(f);
+			f = next;
+		}
+		rcu_read_unlock();
+	}
+	kfree(filters->filters);
+	kfree(filters);
+}
+
+static void __io_put_bpf_filters(struct io_bpf_filters *filters)
+{
+	if (refcount_dec_and_test(&filters->refs))
+		call_rcu(&filters->rcu_head, io_free_bpf_filters);
+}
+
+void io_put_bpf_filters(struct io_restriction *res)
+{
+	if (res->bpf_filters)
+		__io_put_bpf_filters(res->bpf_filters);
+}
+
+static struct io_bpf_filters *io_new_bpf_filters(void)
+{
+	struct io_bpf_filters *filters __free(kfree) = NULL;
+
+	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
+	if (!filters)
+		return ERR_PTR(-ENOMEM);
+
+	filters->filters = kcalloc(IORING_OP_LAST,
+				   sizeof(struct io_bpf_filter *),
+				   GFP_KERNEL_ACCOUNT);
+	if (!filters->filters)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&filters->refs, 1);
+	spin_lock_init(&filters->lock);
+	return no_free_ptr(filters);
+}
+
+/*
+ * Validate classic BPF filter instructions. Only allow a safe subset of
+ * operations - no packet data access, just context field loads and basic
+ * ALU/jump operations.
+ */
+static int io_uring_check_cbpf_filter(struct sock_filter *filter,
+				      unsigned int flen)
+{
+	int pc;
+
+	for (pc = 0; pc < flen; pc++) {
+		struct sock_filter *ftest = &filter[pc];
+		u16 code = ftest->code;
+		u32 k = ftest->k;
+
+		switch (code) {
+		case BPF_LD | BPF_W | BPF_ABS:
+			ftest->code = BPF_LDX | BPF_W | BPF_ABS;
+			/* 32-bit aligned and not out of bounds. */
+			if (k >= sizeof(struct io_uring_bpf_ctx) || k & 3)
+				return -EINVAL;
+			continue;
+		case BPF_LD | BPF_W | BPF_LEN:
+			ftest->code = BPF_LD | BPF_IMM;
+			ftest->k = sizeof(struct io_uring_bpf_ctx);
+			continue;
+		case BPF_LDX | BPF_W | BPF_LEN:
+			ftest->code = BPF_LDX | BPF_IMM;
+			ftest->k = sizeof(struct io_uring_bpf_ctx);
+			continue;
+		/* Explicitly include allowed calls. */
+		case BPF_RET | BPF_K:
+		case BPF_RET | BPF_A:
+		case BPF_ALU | BPF_ADD | BPF_K:
+		case BPF_ALU | BPF_ADD | BPF_X:
+		case BPF_ALU | BPF_SUB | BPF_K:
+		case BPF_ALU | BPF_SUB | BPF_X:
+		case BPF_ALU | BPF_MUL | BPF_K:
+		case BPF_ALU | BPF_MUL | BPF_X:
+		case BPF_ALU | BPF_DIV | BPF_K:
+		case BPF_ALU | BPF_DIV | BPF_X:
+		case BPF_ALU | BPF_AND | BPF_K:
+		case BPF_ALU | BPF_AND | BPF_X:
+		case BPF_ALU | BPF_OR | BPF_K:
+		case BPF_ALU | BPF_OR | BPF_X:
+		case BPF_ALU | BPF_XOR | BPF_K:
+		case BPF_ALU | BPF_XOR | BPF_X:
+		case BPF_ALU | BPF_LSH | BPF_K:
+		case BPF_ALU | BPF_LSH | BPF_X:
+		case BPF_ALU | BPF_RSH | BPF_K:
+		case BPF_ALU | BPF_RSH | BPF_X:
+		case BPF_ALU | BPF_NEG:
+		case BPF_LD | BPF_IMM:
+		case BPF_LDX | BPF_IMM:
+		case BPF_MISC | BPF_TAX:
+		case BPF_MISC | BPF_TXA:
+		case BPF_LD | BPF_MEM:
+		case BPF_LDX | BPF_MEM:
+		case BPF_ST:
+		case BPF_STX:
+		case BPF_JMP | BPF_JA:
+		case BPF_JMP | BPF_JEQ | BPF_K:
+		case BPF_JMP | BPF_JEQ | BPF_X:
+		case BPF_JMP | BPF_JGE | BPF_K:
+		case BPF_JMP | BPF_JGE | BPF_X:
+		case BPF_JMP | BPF_JGT | BPF_K:
+		case BPF_JMP | BPF_JGT | BPF_X:
+		case BPF_JMP | BPF_JSET | BPF_K:
+		case BPF_JMP | BPF_JSET | BPF_X:
+			continue;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+#define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg)
+{
+	struct io_bpf_filter *filter, *old_filter;
+	struct io_bpf_filters *filters;
+	struct io_uring_bpf reg;
+	struct bpf_prog *prog;
+	struct sock_fprog fprog;
+	int ret;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
+		return -EINVAL;
+	if (reg.cmd_flags || reg.resv)
+		return -EINVAL;
+
+	if (reg.filter.opcode >= IORING_OP_LAST)
+		return -EINVAL;
+	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
+		return -EINVAL;
+	if (reg.filter.resv)
+		return -EINVAL;
+	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
+		return -EINVAL;
+	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
+		return -EINVAL;
+
+	fprog.len = reg.filter.filter_len;
+	fprog.filter = u64_to_user_ptr(reg.filter.filter_ptr);
+
+	ret = bpf_prog_create_from_user(&prog, &fprog,
+					io_uring_check_cbpf_filter, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * No existing filters, allocate set.
+	 */
+	filters = res->bpf_filters;
+	if (!filters) {
+		filters = io_new_bpf_filters();
+		if (IS_ERR(filters)) {
+			ret = PTR_ERR(filters);
+			goto err_prog;
+		}
+	}
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
+	if (!filter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	filter->prog = prog;
+	res->bpf_filters = filters;
+
+	/*
+	 * Insert filter - if the current opcode already has a filter
+	 * attached, add to the set.
+	 */
+	rcu_read_lock();
+	spin_lock_bh(&filters->lock);
+	old_filter = rcu_dereference(filters->filters[reg.filter.opcode]);
+	if (old_filter)
+		filter->next = old_filter;
+	rcu_assign_pointer(filters->filters[reg.filter.opcode], filter);
+
+	/*
+	 * If IO_URING_BPF_FILTER_DENY_REST is set, fill any unregistered
+	 * opcode with the dummy filter. That will cause them to be denied.
+	 */
+	if (reg.filter.flags & IO_URING_BPF_FILTER_DENY_REST) {
+		for (int i = 0; i < IORING_OP_LAST; i++) {
+			if (i == reg.filter.opcode)
+				continue;
+			old_filter = rcu_dereference(filters->filters[i]);
+			if (old_filter)
+				continue;
+			rcu_assign_pointer(filters->filters[i], &dummy_filter);
+		}
+	}
+
+	spin_unlock_bh(&filters->lock);
+	rcu_read_unlock();
+	return 0;
+err:
+	if (filters != res->bpf_filters)
+		__io_put_bpf_filters(filters);
+err_prog:
+	bpf_prog_destroy(prog);
+	return ret;
+}
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..27eae9705473
--- /dev/null
+++ b/io_uring/bpf_filter.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IO_URING_BPF_FILTER_H
+#define IO_URING_BPF_FILTER_H
+
+#include <uapi/linux/io_uring/bpf_filter.h>
+
+#ifdef CONFIG_IO_URING_BPF
+
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req);
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg);
+
+void io_put_bpf_filters(struct io_restriction *res);
+
+static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+					   struct io_kiocb *req)
+{
+	if (res->bpf_filters)
+		return __io_uring_run_bpf_filters(res, req);
+
+	return 0;
+}
+
+#else
+
+static inline int io_register_bpf_filter(struct io_restriction *res,
+					 struct io_uring_bpf __user *arg)
+{
+	return -EINVAL;
+}
+static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+					   struct io_kiocb *req)
+{
+	return 0;
+}
+static inline void io_put_bpf_filters(struct io_restriction *res)
+{
+}
+#endif /* CONFIG_IO_URING_BPF */
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a50459238bee..9b9794dfc27a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -94,6 +94,7 @@
 #include "alloc_cache.h"
 #include "eventfd.h"
 #include "wait.h"
+#include "bpf_filter.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -1874,6 +1875,12 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
+	if (unlikely(ctx->restrictions.bpf_filters)) {
+		ret = io_uring_run_bpf_filters(&ctx->restrictions, req);
+		if (ret)
+			return io_submit_fail_init(sqe, req, ret);
+	}
+
 	trace_io_uring_submit_req(req);
 
 	/*
@@ -2161,6 +2168,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+	io_put_bpf_filters(&ctx->restrictions);
 
 	WARN_ON_ONCE(ctx->nr_req_allocated);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 8551f13920dc..30957c2cb5eb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -33,6 +33,7 @@
 #include "memmap.h"
 #include "zcrx.h"
 #include "query.h"
+#include "bpf_filter.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -830,6 +831,13 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_ZCRX_CTRL:
 		ret = io_zcrx_ctrl(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_BPF_FILTER:
+		ret = -EINVAL;
+
+		if (nr_args != 1)
+			break;
+		ret = io_register_bpf_filter(&ctx->restrictions, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.51.0


