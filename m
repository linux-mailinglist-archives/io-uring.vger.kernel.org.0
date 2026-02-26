Return-Path: <io-uring+bounces-12435-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Cq3LmtBoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12435-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3811A5E3C
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E598F302CC07
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B902D9EE8;
	Thu, 26 Feb 2026 12:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEbbWt0P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D811F2D780A
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110181; cv=none; b=LU18Zi5ALvtCjvHpMbUNB8zOVmSQo1sSLArelqoABKoUHdE56Y0kKxO0vdgoo4raJjLZWvpzGk0tc7JKVp/ts3Z5YNmdodcEZdq/WiGUn640bQkKKIoqDTcFDnCeNibIh9jYZ4bvDw8hEPg5ys5m/+DXlGGVZ+aHGLKZHZna/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110181; c=relaxed/simple;
	bh=ZmZig5r0XTYcdge3SXaaL3RIrFB+ugk0N3xe3EjTRwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TrxiaNFVOXgLgIwQWSfysPZ9X7ZIdUrgyk/elbTBtmop7G/EDCj5Z2wOMzljHJzOvuu7MUT/9eSbLn5vmi2qPv3HkjHrY+eTnPZ/sCeasFJ0VqurIG/hxX+otfJ4wib8lTf3qU14829u9+T95V/AA+ewkSpvz0I0Q7KBzHqCbZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eEbbWt0P; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48069a48629so9001295e9.0
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110178; x=1772714978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+zGSFPb0GUFbQPml20nTppQIV7uu4coyi1HcAwQ5ny8=;
        b=eEbbWt0Pkav8tsY6GfD/EfDJOHq2QaqqvyjxJfD+dCKlsnkAZ11XLOUtEKuqbdtbju
         fqQTJVvcHsW0PLI9NTlX9QxouPTBMHkiXDrD6LqcmonU6GV2YmhxayEbQ5JWQSbz+Lkw
         juOGOTmm1LB7nxEbSLdNGGZL1QO3XOw/d3goGrIgTP2u1kWdOOJpmNhjnl2+PuGZekTT
         RV9wnCISXOS6HY7fZAeR7ObkZ3AXeW8Ljxy2DX30Xmao6mNavYYVgK0zEduxtVK8IRpy
         itncoiyZGKVGWSrim1dB/dvpVDUppxmpEfbSoYC8GPBVrSGvPcvhZ0/eRytNb2fx7h5u
         l+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110178; x=1772714978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zGSFPb0GUFbQPml20nTppQIV7uu4coyi1HcAwQ5ny8=;
        b=WPw+XkZR8jb4ij/9ZIA0zgh4YtW6/jkM5JhEdXnknx0Jc/jQdvlLued9LpX1BH8FLB
         66sQ036b9rpWEqliLbG3kJhqXDi5QvjbGL4ZhuhYPpG1UyNtjtpcL9riLQqHdDC46HsZ
         H+xKxK0ykkKtklBrmx7w0NpoWm3Vy/rbkxvQ+UOgReJY+TyMlwqL9uZ+2bYEUfi4U4MJ
         vOZ3bspcc+M1T4FNs2FsBi5pz5P3mAnqNYVFiY+Dy36xpKfrObN/rKkIYuTeTc5MVM1U
         BjOWQVxWYn5oFzlONAYDPYaHdqmO6FsxIgjJMmJO2/rrXq4d8ulrjmFt34MXsqkGV5lm
         NjKQ==
X-Gm-Message-State: AOJu0YwYt2+eP428SyPJd5yXmsTRBEYNhPZMjKf1e+mMwbOxcXPEnVS9
	FHhtPyb4jC52XEvMwTAv48rsw+DhZAKs1AJZznZfawunyY/7n4OsS/T1wUq8zA==
X-Gm-Gg: ATEYQzygBJSJtcIoxDdc9SpXQQNaT86qqplmzXQOYdshhoMVPD6CppXQ8xs6cD7QN9t
	8djO7ZYBn7333BMqtxC3URFvkXIFSrXalFBTPwyVzdvBFQv0PDAlhooPiQ4MuSy3Zjfhw0rJL6r
	khMUlJ4hyv576atYAP3A3Zq45EdtDu+ypIzRT7FpOeEP6OjuE2hmePdfiMj7H6jCtqBIFkYCeYc
	2dfsb9soVlCQIOezpg5xYqVYZsa6TvAYDD/rwxZe6ncjWNQ6at29hMqn077mxhUqki0qwu0seQw
	epJmQfkp3kWAT9QL0NDWlt1GYbs99nIcvrvUy2mxHOPkrAu1dukxiOjNHUHOFhq3CvwpZxgKrJn
	sQEjaiqjOI4/qaESRzvz/ff7BYTUC0RDLIoyDnyprPV1BciuZA97NYkMj6BL/ifR1KNBMsQw1Ob
	ZiNFDQ0m2WeSgOR+xh9GaO5u4nGoMWzFbyVF6jnGkEqbikWgxkKpgu38Cn9UWkgS7EuAHUNpuGY
	VwmUd+as8lmS2ZJgR5n
X-Received: by 2002:a05:600c:3105:b0:477:7bca:8b2b with SMTP id 5b1f17b1804b1-483c12c7d04mr98057455e9.15.1772110177683;
        Thu, 26 Feb 2026 04:49:37 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b89c99sm42408225e9.15.2026.02.26.04.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:49:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH liburing v2 1/1] tests: test io_uring bpf ops
Date: Thu, 26 Feb 2026 12:49:33 +0000
Message-ID: <818dcda223b3288c764367cb0ab8d57c83722d78.1772109275.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12435-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DB3811A5E3C
X-Rspamd-Action: no action

Add some BPF struct ops io_uring tests/examples, one is issuing nops in
a loop, the other copies a file. It needs appropriate tools for bpf and
hence is gated on a BPF_TESTS make flag for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: reworked Makefile, added bpf_cp

 test/Makefile             |  38 +++++++++-
 test/bpf-progs/cp.bpf.c   | 142 ++++++++++++++++++++++++++++++++++++++
 test/bpf-progs/nops.bpf.c |  99 ++++++++++++++++++++++++++
 test/bpf_cp.c             | 138 ++++++++++++++++++++++++++++++++++++
 test/bpf_nops.c           |  99 ++++++++++++++++++++++++++
 5 files changed, 514 insertions(+), 2 deletions(-)
 create mode 100644 test/bpf-progs/cp.bpf.c
 create mode 100644 test/bpf-progs/nops.bpf.c
 create mode 100644 test/bpf_cp.c
 create mode 100644 test/bpf_nops.c

diff --git a/test/Makefile b/test/Makefile
index 7b94a1f4..2f0806dc 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -1,6 +1,12 @@
 prefix ?= /usr
 datadir ?= $(prefix)/share
 
+CLANG ?= clang
+BPFTOOL ?= bpftool
+BPF_PROGS_DIR = bpf-progs
+BPF_OUTPUT = output/bpf
+BPF_VMLINUX ?= /sys/kernel/btf/vmlinux
+
 INSTALL=install
 
 ifneq ($(MAKECMDGOALS),clean)
@@ -310,6 +316,13 @@ ifdef CONFIG_HAVE_CXX
 endif
 all_targets += sq-full-cpp.t
 
+bpf_test_srcs := bpf_nops.c bpf_cp.c
+bpf_progs := $(patsubst bpf_%.c, %.bpf.c, $(bpf_test_srcs))
+bpf_test_targets :=
+
+ifdef BPF_TESTS
+	bpf_test_targets := $(patsubst %.c,%.t,$(bpf_test_srcs))
+endif
 
 test_targets := $(patsubst %.c,%,$(test_srcs))
 test_targets := $(patsubst %.cc,%,$(test_targets))
@@ -326,16 +339,19 @@ ifeq ($(CONFIG_USE_SANITIZER),y)
 	all_targets += $(asan_test_targets)
 endif
 
-all: $(test_targets) $(asan_test_targets)
+all: $(test_targets) $(bpf_test_targets) $(asan_test_targets)
 
 helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
 LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi)
 
-%.t: %.c $(helpers) helpers.h $(LIBURING)
+%.t: %.c $(helpers) helpers.h $(LIBURING) $(opt_deps)
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
+bpf_%.t: bpf_%.c $(helpers) helpers.h $(LIBURING) $(BPF_OUTPUT)/%.skel.h
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -I$(BPF_OUTPUT) -o $@ $< $(helpers) $(LDFLAGS) -lbpf
+
 #
 # Clang++ is not happy with -Wmissing-prototypes:
 #
@@ -348,6 +364,24 @@ LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi
 	$(patsubst -Wmissing-prototypes,,$(CXXFLAGS)) \
 	-o $@ $< $(helpers) $(LDFLAGS)
 
+CLANG_BPF_SYS_INCLUDES ?= $(shell $(CLANG) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+
+$(BPF_OUTPUT)/vmlinux.h:
+	mkdir -p $(BPF_OUTPUT)
+	$(BPFTOOL) btf dump file $(BPF_VMLINUX) format c > $@
+
+# Build BPF code
+$(BPF_OUTPUT)/%.bpf.o: $(BPF_PROGS_DIR)/%.bpf.c $(wildcard %.h) $(BPF_OUTPUT)/vmlinux.h
+	mkdir -p ${BPF_OUTPUT}
+	$(QUIET_CC)$(CLANG) -g -O2 -target bpf \
+		     -I$(BPF_OUTPUT) $(CLANG_BPF_SYS_INCLUDES) \
+		     -Wno-missing-declarations \
+		     -c $(filter %.c,$^) -o $(patsubst %.bpf.o,%.tmp.bpf.o,$@) -mcpu=v4
+	$(BPFTOOL) gen object $@ $(patsubst %.bpf.o,%.tmp.bpf.o,$@)
+
+$(BPF_OUTPUT)/%.skel.h: $(BPF_OUTPUT)/%.bpf.o $(BPF_OUTPUT)/vmlinux.h
+	$(BPFTOOL) gen skeleton $< > $@
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/bpf-progs/cp.bpf.c b/test/bpf-progs/cp.bpf.c
new file mode 100644
index 00000000..42aee2cd
--- /dev/null
+++ b/test/bpf-progs/cp.bpf.c
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "vmlinux.h"
+#include <linux/errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+enum {
+	REQ_TOKEN_READ = 1,
+	REQ_TOKEN_WRITE
+};
+
+const volatile unsigned cq_hdr_offset;
+const volatile unsigned sq_hdr_offset;
+const volatile unsigned cqes_offset;
+const volatile unsigned sq_entries;
+const volatile unsigned cq_entries;
+
+int input_fd;
+int output_fd;
+void *buffer_uptr;
+unsigned nr_infligt;
+unsigned cur_offset;
+size_t buffer_size;
+int cp_result;
+
+#define t_min(a, b) ((a) < (b) ? (a) : (b))
+
+static inline void sqe_prep_rw(struct io_uring_sqe *sqe, unsigned opcode,
+				   int fd, void *addr,
+				   __u32 len, __u64 offset)
+{
+	*sqe = (struct io_uring_sqe){};
+	sqe->opcode = opcode;
+	sqe->fd = fd;
+	sqe->off = offset;
+	sqe->addr = (__u64)(unsigned long)addr;
+	sqe->len = len;
+}
+
+static int issue_next_req(struct io_ring_ctx *ring, struct io_uring_sqe *sqes,
+			  int type, size_t size)
+{
+	struct io_uring_sqe *sqe = sqes;
+	__u8 req_type;
+	int fd, ret;
+
+	if (type == REQ_TOKEN_READ) {
+		req_type = IORING_OP_READ;
+		fd = input_fd;
+	} else {
+		req_type = IORING_OP_WRITE;
+		fd = output_fd;
+	}
+
+	sqe_prep_rw(sqes, req_type, fd, buffer_uptr, size, cur_offset);
+	sqe->user_data = type;
+
+	ret = bpf_io_uring_submit_sqes(ring, 1);
+	if (ret != 1) {
+		cp_result = ret;
+		return ret < 0 ? ret : -EFAULT;
+	}
+	return 0;
+}
+
+SEC("struct_ops.s/cp_loop_step")
+int BPF_PROG(cp_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
+{
+	struct io_uring_sqe *sqes;
+	struct io_uring_cqe *cqes;
+	struct io_uring *cq_hdr;
+	void *rings;
+	int ret;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+				sq_entries * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
+				cqes_offset + cq_entries * sizeof(struct io_uring_cqe));
+	if (!rings || !sqes)
+		return IOU_LOOP_STOP;
+	cq_hdr = rings + cq_hdr_offset;
+	cqes = rings + cqes_offset;
+
+	if (!nr_infligt) {
+		nr_infligt++;
+		ret = issue_next_req(ring, sqes, REQ_TOKEN_READ,
+				     buffer_size);
+		if (ret)
+			return IOU_LOOP_STOP;
+	}
+
+	if (cq_hdr->tail != cq_hdr->head) {
+		struct io_uring_cqe *cqe;
+
+		if (cq_hdr->tail - cq_hdr->head != 1) {
+			cp_result = -ERANGE;
+			return IOU_LOOP_STOP;
+		}
+
+		cqe = &cqes[cq_hdr->head & (cq_entries - 1)];
+		if (cqe->res < 0) {
+			cp_result = cqe->res;
+			return IOU_LOOP_STOP;
+		}
+
+		switch (cqe->user_data) {
+		case REQ_TOKEN_READ:
+			if (cqe->res == 0) {
+				cp_result = 0;
+				return IOU_LOOP_STOP;
+			}
+			ret = issue_next_req(ring, sqes, REQ_TOKEN_WRITE,
+					     cqe->res);
+			if (ret)
+				return IOU_LOOP_STOP;
+			break;
+		case REQ_TOKEN_WRITE:
+			cur_offset += cqe->res;
+			ret = issue_next_req(ring, sqes, REQ_TOKEN_READ,
+					     buffer_size);
+			if (ret)
+				return IOU_LOOP_STOP;
+			break;
+		default:
+			bpf_printk("invalid token\n");
+			cp_result = -EINVAL;
+			return IOU_LOOP_STOP;
+		};
+
+		cq_hdr->head++;
+	}
+
+	ls->cq_wait_idx = cq_hdr->head + 1;
+	return IOU_LOOP_CONTINUE;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops cp_ops = {
+	.loop_step = (void *)cp_loop_step,
+};
diff --git a/test/bpf-progs/nops.bpf.c b/test/bpf-progs/nops.bpf.c
new file mode 100644
index 00000000..00075bb6
--- /dev/null
+++ b/test/bpf-progs/nops.bpf.c
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <linux/errno.h>
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+#define REQ_TOKEN 0xabba1741
+
+const unsigned max_inflight = 8;
+const volatile unsigned cq_hdr_offset;
+const volatile unsigned sq_hdr_offset;
+const volatile unsigned cqes_offset;
+const volatile unsigned cq_entries;
+const volatile unsigned sq_entries;
+
+unsigned reqs_inflight = 0;
+int reqs_to_run;
+
+#define t_min(a, b) ((a) < (b) ? (a) : (b))
+
+static unsigned nr_to_submit(void)
+{
+	unsigned to_submit = 0;
+	unsigned inflight = reqs_inflight;
+
+	if (inflight < max_inflight) {
+		to_submit = max_inflight - inflight;
+		to_submit = t_min(to_submit, reqs_to_run - inflight);
+	}
+	return to_submit;
+}
+
+SEC("struct_ops.s/nops_loop_step")
+int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
+{
+	struct io_uring_sqe *sqes;
+	struct io_uring_cqe *cqes;
+	struct io_uring *cq_hdr;
+	unsigned to_submit;
+	unsigned to_wait;
+	unsigned nr_cqes;
+	void *rings;
+	int ret, i;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+				sq_entries * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
+				cqes_offset + cq_entries * sizeof(struct io_uring_cqe));
+	if (!rings || !sqes)
+		return IOU_LOOP_STOP;
+	cq_hdr = rings + cq_hdr_offset;
+	cqes = rings + cqes_offset;
+
+	to_submit = nr_to_submit();
+	if (to_submit) {
+		for (i = 0; i < to_submit; i++) {
+			struct io_uring_sqe *sqe = &sqes[i];
+
+			*sqe = (struct io_uring_sqe){};
+			sqe->opcode = IORING_OP_NOP;
+			sqe->user_data = REQ_TOKEN;
+		}
+
+		ret = bpf_io_uring_submit_sqes(ring, to_submit);
+		if (ret != to_submit)
+			return IOU_LOOP_STOP;
+		reqs_inflight += to_submit;
+	}
+
+	nr_cqes = cq_hdr->tail - cq_hdr->head;
+	nr_cqes = t_min(nr_cqes, max_inflight);
+	for (i = 0; i < nr_cqes; i++) {
+		struct io_uring_cqe *cqe = &cqes[cq_hdr->head & (cq_entries - 1)];
+
+		if (cqe->user_data != REQ_TOKEN)
+			return IOU_LOOP_STOP;
+		cq_hdr->head++;
+	}
+
+	reqs_inflight -= nr_cqes;
+	reqs_to_run -= nr_cqes;
+
+	if (reqs_to_run <= 0 && !reqs_inflight)
+		return IOU_LOOP_STOP;
+
+	to_wait = reqs_inflight;
+	/* Don't sleep if there are still CQEs left */
+	if (cq_hdr->tail != cq_hdr->head)
+		to_wait = 0;
+	ls->cq_wait_idx = cq_hdr->head + to_wait;
+	return IOU_LOOP_CONTINUE;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops nops_ops = {
+	.loop_step = (void *)nops_loop_step,
+};
diff --git a/test/bpf_cp.c b/test/bpf_cp.c
new file mode 100644
index 00000000..d04fdcb6
--- /dev/null
+++ b/test/bpf_cp.c
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <bpf/libbpf.h>
+
+#include "liburing.h"
+#include "cp.skel.h"
+#include "helpers.h"
+
+static struct cp_bpf *skel;
+static struct bpf_link *cp_bpf_link;
+
+static char *in_fname;
+static char *out_fname;
+
+static size_t buffer_size = 4096;
+static int input_fd;
+static int output_fd;
+static void *buffer;
+
+#define CQ_ENTRIES 8
+#define SQ_ENTRIES 8
+
+static int setup_ring_ops(struct io_uring *ring)
+{
+	struct io_uring_params params;
+	int ret;
+
+	memset(&params, 0, sizeof(params));
+	params.cq_entries = CQ_ENTRIES;
+	params.flags = IORING_SETUP_SINGLE_ISSUER |
+			IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_SQARRAY |
+			IORING_SETUP_CQSIZE |
+			IORING_SETUP_SQ_REWIND;
+
+	ret = t_create_ring_params(SQ_ENTRIES, ring, &params);
+	if (ret == T_SETUP_SKIP) {
+		printf("Can't setup a ring, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret != T_SETUP_OK)
+		return T_EXIT_FAIL;
+
+	skel = cp_bpf__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		return T_EXIT_FAIL;
+	}
+
+	skel->struct_ops.cp_ops->ring_fd = ring->ring_fd;
+	skel->rodata->sq_hdr_offset = params.sq_off.head;
+	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cqes_offset = params.cq_off.cqes;
+	skel->rodata->cq_entries = CQ_ENTRIES;
+	skel->rodata->sq_entries = SQ_ENTRIES;
+	skel->bss->input_fd = input_fd;
+	skel->bss->output_fd = output_fd;
+	skel->bss->buffer_uptr = buffer;
+	skel->bss->buffer_size = buffer_size;
+	skel->bss->cp_result = -EBUSY;
+
+	ret = cp_bpf__load(skel);
+	if (ret) {
+		if (ret == -ESRCH) {
+			printf("io_uring BPF ops are not supported\n");
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "failed to load skeleton\n");
+		return T_EXIT_FAIL;
+	}
+
+	cp_bpf_link = bpf_map__attach_struct_ops(skel->maps.cp_ops);
+	if (!cp_bpf_link) {
+		fprintf(stderr, "failed to attach ops\n");
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	size_t file_size;
+	struct stat st;
+	int ret;
+
+	if (argc != 3)
+		return 0;
+
+	in_fname = argv[1];
+	out_fname = argv[2];
+
+	input_fd = open(in_fname, O_RDONLY | O_DIRECT);
+	output_fd = open(out_fname, O_WRONLY | O_DIRECT | O_CREAT, 0644);
+	if (input_fd < 0 || output_fd < 0) {
+		fprintf(stderr, "can't open files");
+		return T_EXIT_FAIL;
+	}
+	if (fstat(input_fd, &st) == -1) {
+		fprintf(stderr, "stat failed\n");
+		return T_EXIT_FAIL;
+	}
+	file_size = st.st_size;
+
+	buffer = aligned_alloc(4096, buffer_size);
+	if (!buffer) {
+		fprintf(stderr, "can't allocate buffer\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = setup_ring_ops(&ring);
+	if (ret != T_EXIT_PASS)
+		return ret;
+
+	if (ftruncate(output_fd, file_size) == -1) {
+		fprintf(stderr, "ftruncate failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_enter(ring.ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+	if (ret) {
+		fprintf(stderr, "run failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = skel->bss->cp_result;
+	if (ret) {
+		fprintf(stderr, "cp failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	bpf_link__destroy(cp_bpf_link);
+	cp_bpf__destroy(skel);
+	return 0;
+}
diff --git a/test/bpf_nops.c b/test/bpf_nops.c
new file mode 100644
index 00000000..3fe6befe
--- /dev/null
+++ b/test/bpf_nops.c
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <bpf/libbpf.h>
+
+#include "liburing.h"
+#include "nops_loop.skel.h"
+#include "helpers.h"
+
+static struct nops_loop_bpf *skel;
+static struct bpf_link *nops_loop_bpf_link;
+
+#define CQ_ENTRIES 8
+#define SQ_ENTRIES 8
+#define NR_ITERS 1000
+
+static int setup_ring_ops(struct io_uring *ring)
+{
+	struct io_uring_params params;
+	int ret;
+
+	memset(&params, 0, sizeof(params));
+	params.cq_entries = CQ_ENTRIES;
+	params.flags = IORING_SETUP_SINGLE_ISSUER |
+			IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_SQARRAY |
+			IORING_SETUP_CQSIZE |
+			IORING_SETUP_SQ_REWIND;
+
+	ret = t_create_ring_params(SQ_ENTRIES, ring, &params);
+	if (ret == T_SETUP_SKIP) {
+		printf("Can't setup a ring, skip\n");
+		return T_EXIT_SKIP;
+	}
+	if (ret != T_SETUP_OK)
+		return T_EXIT_FAIL;
+
+	skel = nops_loop_bpf__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		return T_EXIT_FAIL;
+	}
+
+	skel->struct_ops.nops_ops->ring_fd = ring->ring_fd;
+	skel->bss->reqs_to_run = NR_ITERS;
+	skel->rodata->sq_hdr_offset = params.sq_off.head;
+	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cqes_offset = params.cq_off.cqes;
+	skel->rodata->cq_entries = CQ_ENTRIES;
+	skel->rodata->sq_entries = SQ_ENTRIES;
+
+	ret = nops_loop_bpf__load(skel);
+	if (ret) {
+		if (ret == -ESRCH) {
+			printf("io_uring BPF ops are not supported\n");
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "failed to load skeleton\n");
+		return T_EXIT_FAIL;
+	}
+
+	nops_loop_bpf_link = bpf_map__attach_struct_ops(skel->maps.nops_ops);
+	if (!nops_loop_bpf_link) {
+		fprintf(stderr, "failed to attach ops\n");
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+int main()
+{
+	struct io_uring ring;
+	unsigned left;
+	int ret;
+
+	ret = setup_ring_ops(&ring);
+	if (ret != T_EXIT_PASS)
+		return ret;
+
+	ret = io_uring_enter(ring.ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+	if (ret) {
+		fprintf(stderr, "run failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	left = skel->bss->reqs_to_run;
+	if (left) {
+		fprintf(stderr, "Run failed, couldn't submit all nops %i / %i\n",
+			NR_ITERS - left, NR_ITERS);
+		return T_EXIT_FAIL;
+	}
+
+	bpf_link__destroy(nops_loop_bpf_link);
+	nops_loop_bpf__destroy(skel);
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.53.0


