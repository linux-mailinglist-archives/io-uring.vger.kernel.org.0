Return-Path: <io-uring+bounces-12394-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKF5OwSrnWmgQwQAu9opvQ
	(envelope-from <io-uring+bounces-12394-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 14:43:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A87187EA8
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 14:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53B3730D1020
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 13:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B28F39E6D0;
	Tue, 24 Feb 2026 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9vGa/fD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD939E6CC
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771940259; cv=none; b=k9yPoyRXBZnxIE68EI8llObIa5rXLst2yXElnHPwwTaBdSjinaeGmjNt2GOTjH87cy21NRvqbcafq+lIKZThEF6s7XdhkljwPMtTFuxLUDKSPCBrtNgcOY1HS2fD/douQXgM1lfzsnaaWCtEl/rG9EgE2WbBZvuX63nHXoBeuIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771940259; c=relaxed/simple;
	bh=+2DM+sUU2jw2Kd3WeQgZYdehNHAhJXkncuRoV+/9eig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjZ2T+pPjpagoHv3DIsGvd10BXLMRSCNikJWJREo3Z4NIWSqKjrUSug6ojVucgCsEXNjIWFYKY8MBytsrFu0rdZ9hPMnWgN+R6uqF9HIhbdFhYjaLBMCh6T/0IqABx9gGYF4cx4FTcf0ph5kY8TO/f0MgDwyNz88AFwDE9EDq7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9vGa/fD; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4837f27cf2dso47255165e9.2
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 05:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771940255; x=1772545055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8h8k9L9I/3pjjg5ZucatoV/3UXXvkv0LRuMmajGAWmI=;
        b=j9vGa/fDz4CEqLaiv5AgnUWqfv3AgeqzqN74FwyS8AGewbmgZT7ocadaQSX+I1WjV1
         m2nEFqJQPpR4zZtytfmsvd04zj6IomOqqT7jjHZim6yv2BBYAQon+CL24ytpzEOz4hhf
         36XpfR3jkvXGtRohTwMHIw/lMIYF21JIxvCH3Wrp6va8qqvUvrKIJLVWDm4fr4AtmVmH
         cDC6O06C8sHSS1HYT/5XMkk7e/82ZRjOY3/JbNCvjp+QBlt8w2J/1d0csNyvHH9wCGMk
         C7hU9lZF8xN2PD1O9aNGIKUbSE/BOAG4RarlPbzHQ6hyRZsaGhKaDX22/OCtf6ohjf5U
         ZI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771940255; x=1772545055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8h8k9L9I/3pjjg5ZucatoV/3UXXvkv0LRuMmajGAWmI=;
        b=Og7V723trBWaXzfEy5Ru1nK80FrchomfrdpD3GwzPg0C+21Elcz73oZ45DDxyWRIkM
         xeoX/tzoyTVDov6yztVlTR1lYqUQS8IJ8YEyH+1h7X085DW0tHp8peZ68aoIn1RBtond
         eImsU26Lff4Hu0cYuHHWo1Do+WyY0c3v3Jl0VR3YP8D47j6aR1f1H4gcKnHrGxxUKOAf
         lER1OuoXEyWBXFw80cKuY+3zrftRnP3XY2IJEC2wWRZNTpReqg8dCIiD1Q5+AHwMMg8/
         adZehcret0HWN7Ql8D4xxMtVIwjTdfGRSxFlKVwUsiuPnEXbsyAY+e+6DTKqhz1aviJ+
         I/tg==
X-Gm-Message-State: AOJu0Yxy6MWF+p/2My9ZoUwQ+pnZjfdopg+g7C35zZQwazW8ulAf8shJ
	6JIgoc3PY3+g8fzY0rruZNamD16gQgaDjG+kqwsUUU7lwIEK6qhdfMlqY8rjzg==
X-Gm-Gg: AZuq6aJpt4l83ZZJTBH/AauifDCDmwxE6n5JW+DZXSXzJmv8d+jectkRcyyPFbC5613
	ZhPZb8fN+G12J/7aylSV9N/i+DaEAaKghJ3WYV+pIRffRCVdujyzI9vo+jcS+EqMEK5aBk14NYh
	9kNJLMy0l2RpgWUUCv0QKQr8Fyc129x8F2hzIcqSbnJJ6wHo2LTw8kbG1JmhK6rw6D9MpJrLc1m
	lNVtxLRs03IyXOPiWSslSkpIlvzhEP0M+dbgob6C7wSauAbmU297It6hg6ILF7xmHP7QcDMKhEZ
	RcOS3vukaNP4IgsrpBWpbu55ovSdcb5A3d5CZSnNzmSijjvv/Eyuuw2+rFujvfx2oM1+l/mFpZH
	1LgStZq+oUugULynU4L3+LxJtPdJM4yTbE/UQsKz2IIggyJ6m/TM39BZIq1/7aIjN+YIl+BeHq/
	IYQlVsQaeqo8tf+A4kbKwzTzkM1IHvbhiurm+/TMv6758PVChd/zI+X9n2fGiFF42DtmauwS5ev
	QmSihaWf7Mnq4FSkNsZv2foRLe0AA==
X-Received: by 2002:a05:600c:1e09:b0:480:25ae:9993 with SMTP id 5b1f17b1804b1-483a962e3c9mr226506625e9.20.1771940254973;
        Tue, 24 Feb 2026 05:37:34 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31c56d8sm506757055e9.8.2026.02.24.05.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 05:37:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing] tests: test io_uring bpf ops
Date: Tue, 24 Feb 2026 13:37:27 +0000
Message-ID: <a16c8d4e58335129c0548372daa6976f84662d6b.1771940194.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12394-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 34A87187EA8
X-Rspamd-Action: no action

Add a BPF struct ops io_uring example issuing nop requests in a loop. It
needs clang, llvm, bpftool, libbpf, etc. to compile so it's gated on
passing BPF_TESTS to make. The Makefile change looks sane but maybe
there are better ways, starting with probing all the toolchain
availability.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile                  | 44 ++++++++++++++-
 test/bpf-nops.c                | 99 ++++++++++++++++++++++++++++++++++
 test/bpf-progs/nops_loop.bpf.c | 99 ++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+), 2 deletions(-)
 create mode 100644 test/bpf-nops.c
 create mode 100644 test/bpf-progs/nops_loop.bpf.c

diff --git a/test/Makefile b/test/Makefile
index 1bbae1cc..0a4f275a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -1,6 +1,12 @@
 prefix ?= /usr
 datadir ?= $(prefix)/share
 
+CLANG ?= clang
+BPFTOOL ?= bpftool
+BPF_PROGS_DIR = bpf-progs
+BPF_OUTPUT = output/bpf/
+BPF_VMLINUX ?= /sys/kernel/btf/vmlinux
+
 INSTALL=install
 
 ifneq ($(MAKECMDGOALS),clean)
@@ -298,6 +304,17 @@ ifdef CONFIG_HAVE_CXX
 endif
 all_targets += sq-full-cpp.t
 
+bpf_tests := bpf-nops.c
+opt_deps :=
+
+ifdef BPF_TESTS
+	override CFLAGS += -I$(BPF_OUTPUT)
+	override LDFLAGS += -lbpf
+	test_srcs += $(bpf_tests)
+	opt_deps += bpf-progs
+endif
+
+$(info flags $(CFLAGS))
 
 test_targets := $(patsubst %.c,%,$(test_srcs))
 test_targets := $(patsubst %.cc,%,$(test_targets))
@@ -321,7 +338,7 @@ helpers.o: helpers.c
 
 LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi)
 
-%.t: %.c $(helpers) helpers.h $(LIBURING)
+%.t: %.c $(helpers) helpers.h $(LIBURING) $(opt_deps)
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 #
@@ -336,6 +353,29 @@ LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi
 	$(patsubst -Wmissing-prototypes,,$(CXXFLAGS)) \
 	-o $@ $< $(helpers) $(LDFLAGS)
 
+BPF_PROGS = nops_loop.bpf.c
+
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
+	$(CLANG) -g -O2 -target bpf \
+		     -I$(BPF_OUTPUT) $(CLANG_BPF_SYS_INCLUDES) \
+		     -Wno-missing-declarations \
+		     -c $(filter %.c,$^) -o $(patsubst %.bpf.o,%.tmp.bpf.o,$@) -mcpu=v4
+	$(BPFTOOL) gen object $@ $(patsubst %.bpf.o,%.tmp.bpf.o,$@)
+
+$(BPF_OUTPUT)/%.skel.h: $(BPF_OUTPUT)/%.bpf.o $(BPF_OUTPUT)/vmlinux.h
+	$(BPFTOOL) gen skeleton $< > $@
+
+bpf-progs: $(patsubst %.bpf.c,$(BPF_OUTPUT)/%.bpf.o,$(BPF_PROGS)) \
+			$(patsubst %.bpf.c,$(BPF_OUTPUT)/%.skel.h,$(BPF_PROGS))
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
@@ -362,4 +402,4 @@ runtests-loop: all
 runtests-parallel: $(run_test_targets)
 	@echo "All tests passed"
 
-.PHONY: all install clean runtests runtests-loop runtests-parallel
+.PHONY: all install clean runtests runtests-loop runtests-parallel bpf-progs
diff --git a/test/bpf-nops.c b/test/bpf-nops.c
new file mode 100644
index 00000000..3fe6befe
--- /dev/null
+++ b/test/bpf-nops.c
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
diff --git a/test/bpf-progs/nops_loop.bpf.c b/test/bpf-progs/nops_loop.bpf.c
new file mode 100644
index 00000000..00075bb6
--- /dev/null
+++ b/test/bpf-progs/nops_loop.bpf.c
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
-- 
2.53.0


