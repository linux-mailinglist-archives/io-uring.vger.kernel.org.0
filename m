Return-Path: <io-uring+bounces-11410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D5BCF7B4B
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3FED43044C1B
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1EF30E830;
	Tue,  6 Jan 2026 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TO8Yi6jS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C8A31A068
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694348; cv=none; b=lMyr5jU4AJQ2yFi8ObxufXPtHheFiOQAMrjrVqLe6MjtngoJktDombp0Y7fz58ln8TR22kFlkmGfeG1oGvJVxGxXNbd0FDkJJqucwZyJC+3VoYkRgw/yxm8ZSldKoJoqn22xOi/9dJ5qeCJUBN8yyqLdalc7pfSEH+ENRS94wZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694348; c=relaxed/simple;
	bh=lgZXgHRecSirIw5kaZYubdXpwx2ABVlavrgsgJa6Fkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtFP25dBXuNQoEj/ZMP9FcaOcrdC8ve8wQ31b7ZrHM0NjEHBh3dnF3XPB2iwtRa1tYM14LFmxAQ+OIJzrcpdI7Gub4aRZwk6QzLXoJAoNt7ulFgvxdJi1Kbsl3jekADLRFYsyeLa+e/J5AKJwzQrEv9/RvArOv5WkjMDaAAyU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TO8Yi6jS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zuYo0Tmdnk0JaxujfnfvF3TZnbZSR4bbReUc5G7rlh8=;
	b=TO8Yi6jSf1I6tBSaFSajDqY37zsEzjewRQviYM5c3+9sGdwUG2eJGzSNAvr7nsL2ti79HY
	K+LkxFsybDiAQ3T9lEDnBWc0b4wr2NkZ2Vx1SxHBUw+hewr8TcsShyBo18yEahHQ8D3TQL
	3BPRldVy4Dj9fqeYdZ0ACT+ucua/7WM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-Zo_K6zVOO3OG5qspjjK8EQ-1; Tue,
 06 Jan 2026 05:12:18 -0500
X-MC-Unique: Zo_K6zVOO3OG5qspjjK8EQ-1
X-Mimecast-MFC-AGG-ID: Zo_K6zVOO3OG5qspjjK8EQ_1767694337
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B01071955F3F;
	Tue,  6 Jan 2026 10:12:17 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D78C1180035A;
	Tue,  6 Jan 2026 10:12:16 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 10/13] selftests/io_uring: add BPF struct_ops and kfunc tests
Date: Tue,  6 Jan 2026 18:11:19 +0800
Message-ID: <20260106101126.4064990-11-ming.lei@redhat.com>
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

Add selftests for io_uring BPF struct_ops and kfunc functionality:

- basic_bpf_ops: Tests IORING_OP_BPF struct_ops registration and execution
  with multiple struct_ops support

The test framework includes:
- runner.c: Main test runner with auto-discovery
- iou_test.h: Common test infrastructure
- Makefile: Build system with BPF skeleton generation

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/.gitignore   |   2 +
 tools/testing/selftests/io_uring/Makefile     | 172 ++++++++++++++
 .../selftests/io_uring/basic_bpf_ops.bpf.c    |  94 ++++++++
 .../selftests/io_uring/basic_bpf_ops.c        | 215 ++++++++++++++++++
 .../selftests/io_uring/include/iou_test.h     |  98 ++++++++
 tools/testing/selftests/io_uring/runner.c     | 206 +++++++++++++++++
 7 files changed, 789 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/.gitignore
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic_bpf_ops.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/basic_bpf_ops.c
 create mode 100644 tools/testing/selftests/io_uring/include/iou_test.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 56e44a98d6a5..c742af56ec51 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -44,6 +44,7 @@ TARGETS += futex
 TARGETS += gpio
 TARGETS += hid
 TARGETS += intel_pstate
+TARGETS += io_uring
 TARGETS += iommu
 TARGETS += ipc
 TARGETS += ir
@@ -147,7 +148,7 @@ endif
 # User can optionally provide a TARGETS skiplist. By default we skip
 # targets using BPF since it has cutting edge build time dependencies
 # which require more effort to install.
-SKIP_TARGETS ?= bpf sched_ext
+SKIP_TARGETS ?= bpf io_uring sched_ext
 ifneq ($(SKIP_TARGETS),)
 	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
 	override TARGETS := $(TMP)
diff --git a/tools/testing/selftests/io_uring/.gitignore b/tools/testing/selftests/io_uring/.gitignore
new file mode 100644
index 000000000000..c0e488dc0622
--- /dev/null
+++ b/tools/testing/selftests/io_uring/.gitignore
@@ -0,0 +1,2 @@
+/build/
+/runner
diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
new file mode 100644
index 000000000000..f88a6a749484
--- /dev/null
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -0,0 +1,172 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat, Inc.
+include ../../../build/Build.include
+include ../../../scripts/Makefile.arch
+include ../../../scripts/Makefile.include
+
+TEST_GEN_PROGS := runner
+
+# override lib.mk's default rules
+OVERRIDE_TARGETS := 1
+include ../lib.mk
+
+CURDIR := $(abspath .)
+REPOROOT := $(abspath ../../../..)
+TOOLSDIR := $(REPOROOT)/tools
+LIBDIR := $(TOOLSDIR)/lib
+BPFDIR := $(LIBDIR)/bpf
+TOOLSINCDIR := $(TOOLSDIR)/include
+BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
+APIDIR := $(TOOLSINCDIR)/uapi
+GENDIR := $(REPOROOT)/include/generated
+GENHDR := $(GENDIR)/autoconf.h
+
+OUTPUT_DIR := $(OUTPUT)/build
+OBJ_DIR := $(OUTPUT_DIR)/obj
+INCLUDE_DIR := $(OUTPUT_DIR)/include
+BPFOBJ_DIR := $(OBJ_DIR)/libbpf
+IOUOBJ_DIR := $(OBJ_DIR)/io_uring
+BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
+LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
+
+DEFAULT_BPFTOOL := $(OUTPUT_DIR)/host/sbin/bpftool
+HOST_OBJ_DIR := $(OBJ_DIR)/host/bpftool
+HOST_LIBBPF_OUTPUT := $(OBJ_DIR)/host/libbpf/
+HOST_LIBBPF_DESTDIR := $(OUTPUT_DIR)/host/
+HOST_DESTDIR := $(OUTPUT_DIR)/host/
+
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)					\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)		\
+		     ../../../../vmlinux					\
+		     /sys/kernel/btf/vmlinux					\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+
+ifneq ($(wildcard $(GENHDR)),)
+  GENFLAGS := -DHAVE_GENHDR
+endif
+
+CFLAGS += -g -O2 -rdynamic -pthread -Wall -Werror $(GENFLAGS)			\
+	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)				\
+	  -I$(REPOROOT)/usr/include						\
+	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(CURDIR)/include
+
+# Silence some warnings when compiled with clang
+ifneq ($(LLVM),)
+CFLAGS += -Wno-unused-command-line-argument
+endif
+
+LDFLAGS = -lelf -lz -lpthread -lzstd
+
+IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null |				\
+			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
+
+# Get Clang's default includes on this system
+define get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
+
+BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH)					\
+	     $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)		\
+	     -I$(CURDIR)/include -I$(CURDIR)/include/bpf-compat			\
+	     -I$(INCLUDE_DIR) -I$(APIDIR)					\
+	     -I$(REPOROOT)/include						\
+	     $(CLANG_SYS_INCLUDES)						\
+	     -Wall -Wno-compare-distinct-pointer-types				\
+	     -Wno-incompatible-function-pointer-types				\
+	     -Wno-missing-declarations						\
+	     -O2 -mcpu=v3
+
+# sort removes libbpf duplicates when not cross-building
+MAKE_DIRS := $(sort $(OBJ_DIR)/libbpf $(OBJ_DIR)/libbpf				\
+	       $(OBJ_DIR)/bpftool $(OBJ_DIR)/resolve_btfids			\
+	       $(HOST_OBJ_DIR) $(INCLUDE_DIR) $(IOUOBJ_DIR))
+
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
+	   $(APIDIR)/linux/bpf.h						\
+	   | $(OBJ_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OBJ_DIR)/libbpf/	\
+		    ARCH=$(ARCH) CC="$(CC)" CROSS_COMPILE=$(CROSS_COMPILE)	\
+		    EXTRA_CFLAGS='-g -O0 -fPIC'					\
+		    DESTDIR=$(OUTPUT_DIR) prefix= all install_headers
+
+$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)	\
+		    $(LIBBPF_OUTPUT) | $(HOST_OBJ_DIR)
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)				\
+		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD)		\
+		    EXTRA_CFLAGS='-g -O0'					\
+		    OUTPUT=$(HOST_OBJ_DIR)/					\
+		    LIBBPF_OUTPUT=$(HOST_LIBBPF_OUTPUT)				\
+		    LIBBPF_DESTDIR=$(HOST_LIBBPF_DESTDIR)			\
+		    prefix= DESTDIR=$(HOST_DESTDIR) install-bin
+
+$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$@)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(call msg,CP,,$@)
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+$(IOUOBJ_DIR)/%.bpf.o: %.bpf.c $(INCLUDE_DIR)/vmlinux.h	| $(BPFOBJ) $(IOUOBJ_DIR)
+	$(call msg,CLNG-BPF,,$(notdir $@))
+	$(Q)$(CLANG) $(BPF_CFLAGS) -target bpf -c $< -o $@
+
+$(INCLUDE_DIR)/%.bpf.skel.h: $(IOUOBJ_DIR)/%.bpf.o $(INCLUDE_DIR)/vmlinux.h $(BPFTOOL) | $(INCLUDE_DIR)
+	$(eval sched=$(notdir $@))
+	$(call msg,GEN-SKEL,,$(sched))
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked2.o) $(<:.o=.linked1.o)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked3.o) $(<:.o=.linked2.o)
+	$(Q)diff $(<:.o=.linked2.o) $(<:.o=.linked3.o)
+	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $@
+	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $(@:.skel.h=.subskel.h)
+
+override define CLEAN
+	rm -rf $(OUTPUT_DIR)
+	rm -f $(TEST_GEN_PROGS)
+endef
+
+# Every testcase takes all of the BPF progs as dependencies by default.
+all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
+
+auto-test-targets :=			\
+	basic_bpf_ops			\
+
+testcase-targets := $(addsuffix .o,$(addprefix $(IOUOBJ_DIR)/,$(auto-test-targets)))
+
+$(IOUOBJ_DIR)/runner.o: runner.c | $(IOUOBJ_DIR) $(BPFOBJ)
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
+
+$(testcase-targets): $(IOUOBJ_DIR)/%.o: %.c $(IOUOBJ_DIR)/runner.o $(all_test_bpfprogs) | $(IOUOBJ_DIR)
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
+
+$(OUTPUT)/runner: $(IOUOBJ_DIR)/runner.o $(BPFOBJ) $(testcase-targets)
+	$(call msg,LINK,,$@)
+	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+.DEFAULT_GOAL := all
+
+.DELETE_ON_ERROR:
+
+.SECONDARY:
diff --git a/tools/testing/selftests/io_uring/basic_bpf_ops.bpf.c b/tools/testing/selftests/io_uring/basic_bpf_ops.bpf.c
new file mode 100644
index 000000000000..2343c647575b
--- /dev/null
+++ b/tools/testing/selftests/io_uring/basic_bpf_ops.bpf.c
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Basic io_uring BPF struct_ops test.
+ *
+ * This tests registering a minimal uring_bpf_ops struct_ops
+ * with prep/issue/cleanup callbacks.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char LICENSE[] SEC("license") = "GPL";
+
+/* Counters to verify callbacks are invoked */
+int prep_count = 0;
+int issue_count = 0;
+int cleanup_count = 0;
+
+/* Test result stored in pdu */
+#define PDU_MAGIC 0xdeadbeef
+
+SEC("struct_ops/basic_prep")
+int BPF_PROG(basic_prep, struct uring_bpf_data *data,
+	     const struct io_uring_sqe *sqe)
+{
+	__u32 *magic;
+
+	prep_count++;
+
+	/* Store magic value in pdu to verify data flow */
+	magic = (__u32 *)data->pdu;
+	*magic = PDU_MAGIC;
+
+	bpf_printk("basic_prep: count=%d", prep_count);
+	return 0;
+}
+
+extern void uring_bpf_set_result(struct uring_bpf_data *data, int res) __ksym;
+
+SEC("struct_ops/basic_issue")
+int BPF_PROG(basic_issue, struct uring_bpf_data *data)
+{
+	__u32 *magic;
+
+	issue_count++;
+
+	/* Verify pdu contains the magic value from prep */
+	magic = (__u32 *)data->pdu;
+	if (*magic != PDU_MAGIC) {
+		bpf_printk("basic_issue: pdu magic mismatch!");
+		uring_bpf_set_result(data, -22); /* -EINVAL */
+		return 0;
+	}
+
+	bpf_printk("basic_issue: count=%d, pdu_magic=0x%x", issue_count, *magic);
+
+	/* Set successful result */
+	uring_bpf_set_result(data, 42);
+	return 0;
+}
+
+SEC("struct_ops/basic_fail")
+void BPF_PROG(basic_fail, struct uring_bpf_data *data)
+{
+	bpf_printk("basic_fail: invoked");
+}
+
+SEC("struct_ops/basic_cleanup")
+void BPF_PROG(basic_cleanup, struct uring_bpf_data *data)
+{
+	cleanup_count++;
+	bpf_printk("basic_cleanup: count=%d", cleanup_count);
+}
+
+SEC(".struct_ops.link")
+struct uring_bpf_ops basic_bpf_ops = {
+	.id		= 0,
+	.prep_fn	= (void *)basic_prep,
+	.issue_fn	= (void *)basic_issue,
+	.fail_fn	= (void *)basic_fail,
+	.cleanup_fn	= (void *)basic_cleanup,
+};
+
+/* Second struct_ops to verify multiple registrations work */
+SEC(".struct_ops.link")
+struct uring_bpf_ops basic_bpf_ops_2 = {
+	.id		= 1,
+	.prep_fn	= (void *)basic_prep,
+	.issue_fn	= (void *)basic_issue,
+	.fail_fn	= (void *)basic_fail,
+	.cleanup_fn	= (void *)basic_cleanup,
+};
diff --git a/tools/testing/selftests/io_uring/basic_bpf_ops.c b/tools/testing/selftests/io_uring/basic_bpf_ops.c
new file mode 100644
index 000000000000..c68aea0b5ed7
--- /dev/null
+++ b/tools/testing/selftests/io_uring/basic_bpf_ops.c
@@ -0,0 +1,215 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Basic io_uring BPF struct_ops test - userspace part.
+ */
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <errno.h>
+#include <linux/io_uring.h>
+#include <io_uring/mini_liburing.h>
+
+#include "iou_test.h"
+#include "basic_bpf_ops.bpf.skel.h"
+
+struct test_ctx {
+	struct basic_bpf_ops *skel;
+	struct bpf_link *link;
+	struct bpf_link *link_2;
+	struct io_uring ring;
+	int nr_ops;
+};
+
+static enum iou_test_status bpf_setup(struct test_ctx *ctx)
+{
+	int ret;
+
+	/* Load BPF skeleton */
+	ctx->skel = basic_bpf_ops__open();
+	if (!ctx->skel) {
+		IOU_ERR("Failed to open BPF skeleton");
+		return IOU_TEST_FAIL;
+	}
+
+	/* Set ring_fd in struct_ops before loading (id is hardcoded in BPF) */
+	ctx->skel->struct_ops.basic_bpf_ops->ring_fd = ctx->ring.ring_fd;
+	ctx->skel->struct_ops.basic_bpf_ops_2->ring_fd = ctx->ring.ring_fd;
+
+	ret = basic_bpf_ops__load(ctx->skel);
+	if (ret) {
+		IOU_ERR("Failed to load BPF skeleton: %d", ret);
+		basic_bpf_ops__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+
+	/* Attach first struct_ops */
+	ctx->link = bpf_map__attach_struct_ops(ctx->skel->maps.basic_bpf_ops);
+	if (!ctx->link) {
+		IOU_ERR("Failed to attach struct_ops");
+		basic_bpf_ops__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+	ctx->nr_ops++;
+
+	/* Attach second struct_ops */
+	ctx->link_2 = bpf_map__attach_struct_ops(ctx->skel->maps.basic_bpf_ops_2);
+	if (!ctx->link_2) {
+		IOU_ERR("Failed to attach struct_ops_2");
+		bpf_link__destroy(ctx->link);
+		ctx->link = NULL;
+		basic_bpf_ops__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+	ctx->nr_ops++;
+
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status setup(void **ctx_out)
+{
+	struct io_uring_params p;
+	struct test_ctx *ctx;
+	enum iou_test_status status;
+	int ret;
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx) {
+		IOU_ERR("Failed to allocate context");
+		return IOU_TEST_FAIL;
+	}
+
+	/* Setup io_uring ring with BPF_OP flag */
+	memset(&p, 0, sizeof(p));
+	p.flags = IORING_SETUP_BPF_OP | IORING_SETUP_NO_SQARRAY;
+
+	ret = io_uring_queue_init_params(8, &ctx->ring, &p);
+	if (ret < 0) {
+		IOU_ERR("io_uring_queue_init_params failed: %s (flags=0x%x)",
+			strerror(-ret), p.flags);
+		free(ctx);
+		return IOU_TEST_SKIP;
+	}
+
+	status = bpf_setup(ctx);
+	if (status != IOU_TEST_PASS) {
+		io_uring_queue_exit(&ctx->ring);
+		free(ctx);
+		return status;
+	}
+
+	*ctx_out = ctx;
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status test_bpf_op(struct test_ctx *ctx, int op_id)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	__u64 user_data = 0x12345678 + op_id;
+	int ret;
+
+	sqe = io_uring_get_sqe(&ctx->ring);
+	if (!sqe) {
+		IOU_ERR("Failed to get SQE for op %d", op_id);
+		return IOU_TEST_FAIL;
+	}
+
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = IORING_OP_BPF;
+	sqe->fd = -1;
+	sqe->bpf_op_flags = (op_id << IORING_BPF_OP_SHIFT);
+	sqe->user_data = user_data;
+
+	ret = io_uring_submit(&ctx->ring);
+	if (ret < 0) {
+		IOU_ERR("io_uring_submit for op %d failed: %d", op_id, ret);
+		return IOU_TEST_FAIL;
+	}
+
+	ret = io_uring_wait_cqe(&ctx->ring, &cqe);
+	if (ret < 0) {
+		IOU_ERR("io_uring_wait_cqe for op %d failed: %d", op_id, ret);
+		return IOU_TEST_FAIL;
+	}
+
+	if (cqe->user_data != user_data) {
+		IOU_ERR("CQE user_data mismatch for op %d: 0x%llx", op_id, cqe->user_data);
+		return IOU_TEST_FAIL;
+	}
+
+	if (cqe->res != 42) {
+		IOU_ERR("CQE result mismatch for op %d: %d (expected 42)", op_id, cqe->res);
+		return IOU_TEST_FAIL;
+	}
+
+	io_uring_cqe_seen(&ctx->ring);
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status verify_counters(struct test_ctx *ctx, int expected)
+{
+	if (ctx->skel->bss->prep_count != expected) {
+		IOU_ERR("prep_count mismatch: %d (expected %d)",
+			ctx->skel->bss->prep_count, expected);
+		return IOU_TEST_FAIL;
+	}
+	if (ctx->skel->bss->issue_count != expected) {
+		IOU_ERR("issue_count mismatch: %d (expected %d)",
+			ctx->skel->bss->issue_count, expected);
+		return IOU_TEST_FAIL;
+	}
+	if (ctx->skel->bss->cleanup_count != expected) {
+		IOU_ERR("cleanup_count mismatch: %d (expected %d)",
+			ctx->skel->bss->cleanup_count, expected);
+		return IOU_TEST_FAIL;
+	}
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status run(void *ctx_ptr)
+{
+	struct test_ctx *ctx = ctx_ptr;
+	enum iou_test_status status;
+	int i;
+
+	/* Test all registered struct_ops */
+	for (i = 0; i < ctx->nr_ops; i++) {
+		status = test_bpf_op(ctx, i);
+		if (status != IOU_TEST_PASS)
+			return status;
+
+		/* Verify counters after each op */
+		status = verify_counters(ctx, i + 1);
+		if (status != IOU_TEST_PASS)
+			return status;
+	}
+
+	IOU_INFO("IORING_OP_BPF multiple struct_ops test passed");
+	return IOU_TEST_PASS;
+}
+
+static void cleanup(void *ctx_ptr)
+{
+	struct test_ctx *ctx = ctx_ptr;
+
+	if (ctx->link_2)
+		bpf_link__destroy(ctx->link_2);
+	if (ctx->link)
+		bpf_link__destroy(ctx->link);
+	if (ctx->skel)
+		basic_bpf_ops__destroy(ctx->skel);
+	io_uring_queue_exit(&ctx->ring);
+	free(ctx);
+}
+
+struct iou_test basic_bpf_ops_test = {
+	.name = "basic_bpf_ops",
+	.description = "Test IORING_OP_BPF struct_ops registration and execution",
+	.setup = setup,
+	.run = run,
+	.cleanup = cleanup,
+};
+REGISTER_IOU_TEST(basic_bpf_ops_test)
diff --git a/tools/testing/selftests/io_uring/include/iou_test.h b/tools/testing/selftests/io_uring/include/iou_test.h
new file mode 100644
index 000000000000..8e7880e81314
--- /dev/null
+++ b/tools/testing/selftests/io_uring/include/iou_test.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ */
+
+#ifndef __IOU_TEST_H__
+#define __IOU_TEST_H__
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+enum iou_test_status {
+	IOU_TEST_PASS = 0,
+	IOU_TEST_SKIP,
+	IOU_TEST_FAIL,
+};
+
+struct iou_test {
+	/**
+	 * name - The name of the testcase.
+	 */
+	const char *name;
+
+	/**
+	 * description - A description of the testcase.
+	 */
+	const char *description;
+
+	/**
+	 * setup - Setup callback to initialize the test.
+	 * @ctx: A pointer to a context object that will be passed to run
+	 *       and cleanup.
+	 *
+	 * Return: IOU_TEST_PASS if setup was successful, IOU_TEST_SKIP
+	 *         if the test should be skipped, or IOU_TEST_FAIL if the
+	 *         test should be marked as failed.
+	 */
+	enum iou_test_status (*setup)(void **ctx);
+
+	/**
+	 * run - The main test function.
+	 * @ctx: Context object returned from setup().
+	 *
+	 * Return: IOU_TEST_PASS if the test passed, or IOU_TEST_FAIL
+	 *         if it failed.
+	 */
+	enum iou_test_status (*run)(void *ctx);
+
+	/**
+	 * cleanup - Cleanup callback.
+	 * @ctx: Context object returned from setup().
+	 */
+	void (*cleanup)(void *ctx);
+};
+
+void iou_test_register(struct iou_test *test);
+
+#define REGISTER_IOU_TEST(__test)					\
+	__attribute__((constructor))					\
+	static void __test##_register(void)				\
+	{								\
+		iou_test_register(&(__test));				\
+	}
+
+#define IOU_BUG(__cond, __fmt, ...)					\
+	do {								\
+		if (__cond) {						\
+			fprintf(stderr, "FATAL (%s:%d): " __fmt "\n",	\
+				__FILE__, __LINE__,			\
+				##__VA_ARGS__);				\
+			exit(1);					\
+		}							\
+	} while (0)
+
+#define IOU_BUG_ON(__cond) IOU_BUG(__cond, "BUG: %s", #__cond)
+
+#define IOU_FAIL(__fmt, ...)						\
+	do {								\
+		fprintf(stderr, "FAIL (%s:%d): " __fmt "\n",		\
+			__FILE__, __LINE__, ##__VA_ARGS__);		\
+		return IOU_TEST_FAIL;					\
+	} while (0)
+
+#define IOU_FAIL_IF(__cond, __fmt, ...)					\
+	do {								\
+		if (__cond)						\
+			IOU_FAIL(__fmt, ##__VA_ARGS__);			\
+	} while (0)
+
+#define IOU_ERR(__fmt, ...)						\
+	fprintf(stderr, "ERR: " __fmt "\n", ##__VA_ARGS__)
+
+#define IOU_INFO(__fmt, ...)						\
+	fprintf(stdout, "INFO: " __fmt "\n", ##__VA_ARGS__)
+
+#endif /* __IOU_TEST_H__ */
diff --git a/tools/testing/selftests/io_uring/runner.c b/tools/testing/selftests/io_uring/runner.c
new file mode 100644
index 000000000000..09ac1ac2d633
--- /dev/null
+++ b/tools/testing/selftests/io_uring/runner.c
@@ -0,0 +1,206 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Test runner for io_uring BPF selftests.
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <signal.h>
+#include <libgen.h>
+#include <bpf/bpf.h>
+#include "iou_test.h"
+
+const char help_fmt[] =
+"The runner for io_uring BPF tests.\n"
+"\n"
+"The runner is statically linked against all testcases, and runs them all serially.\n"
+"\n"
+"Usage: %s [-t TEST] [-h]\n"
+"\n"
+"  -t TEST       Only run tests whose name includes this string\n"
+"  -s            Include print output for skipped tests\n"
+"  -l            List all available tests\n"
+"  -q            Don't print the test descriptions during run\n"
+"  -h            Display this help and exit\n";
+
+static volatile int exit_req;
+static bool quiet, print_skipped, list;
+
+#define MAX_IOU_TESTS 2048
+
+static struct iou_test __iou_tests[MAX_IOU_TESTS];
+static unsigned __iou_num_tests = 0;
+
+static void sigint_handler(int simple)
+{
+	exit_req = 1;
+}
+
+static void print_test_preamble(const struct iou_test *test, bool quiet)
+{
+	printf("===== START =====\n");
+	printf("TEST: %s\n", test->name);
+	if (!quiet)
+		printf("DESCRIPTION: %s\n", test->description);
+	printf("OUTPUT:\n");
+
+	fflush(stdout);
+	fflush(stderr);
+}
+
+static const char *status_to_result(enum iou_test_status status)
+{
+	switch (status) {
+	case IOU_TEST_PASS:
+	case IOU_TEST_SKIP:
+		return "ok";
+	case IOU_TEST_FAIL:
+		return "not ok";
+	default:
+		return "<UNKNOWN>";
+	}
+}
+
+static void print_test_result(const struct iou_test *test,
+			      enum iou_test_status status,
+			      unsigned int testnum)
+{
+	const char *result = status_to_result(status);
+	const char *directive = status == IOU_TEST_SKIP ? "SKIP " : "";
+
+	printf("%s %u %s # %s\n", result, testnum, test->name, directive);
+	printf("=====  END  =====\n");
+}
+
+static bool should_skip_test(const struct iou_test *test, const char *filter)
+{
+	return !strstr(test->name, filter);
+}
+
+static enum iou_test_status run_test(const struct iou_test *test)
+{
+	enum iou_test_status status;
+	void *context = NULL;
+
+	if (test->setup) {
+		status = test->setup(&context);
+		if (status != IOU_TEST_PASS)
+			return status;
+	}
+
+	status = test->run(context);
+
+	if (test->cleanup)
+		test->cleanup(context);
+
+	return status;
+}
+
+static bool test_valid(const struct iou_test *test)
+{
+	if (!test) {
+		fprintf(stderr, "NULL test detected\n");
+		return false;
+	}
+
+	if (!test->name) {
+		fprintf(stderr,
+			"Test with no name found. Must specify test name.\n");
+		return false;
+	}
+
+	if (!test->description) {
+		fprintf(stderr, "Test %s requires description.\n", test->name);
+		return false;
+	}
+
+	if (!test->run) {
+		fprintf(stderr, "Test %s has no run() callback\n", test->name);
+		return false;
+	}
+
+	return true;
+}
+
+int main(int argc, char **argv)
+{
+	const char *filter = NULL;
+	unsigned testnum = 0, i;
+	unsigned passed = 0, skipped = 0, failed = 0;
+	int opt;
+
+	signal(SIGINT, sigint_handler);
+	signal(SIGTERM, sigint_handler);
+
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
+	while ((opt = getopt(argc, argv, "qslt:h")) != -1) {
+		switch (opt) {
+		case 'q':
+			quiet = true;
+			break;
+		case 's':
+			print_skipped = true;
+			break;
+		case 'l':
+			list = true;
+			break;
+		case 't':
+			filter = optarg;
+			break;
+		default:
+			fprintf(stderr, help_fmt, basename(argv[0]));
+			return opt != 'h';
+		}
+	}
+
+	for (i = 0; i < __iou_num_tests; i++) {
+		enum iou_test_status status;
+		struct iou_test *test = &__iou_tests[i];
+
+		if (list) {
+			printf("%s\n", test->name);
+			if (i == (__iou_num_tests - 1))
+				return 0;
+			continue;
+		}
+
+		if (filter && should_skip_test(test, filter)) {
+			if (print_skipped) {
+				print_test_preamble(test, quiet);
+				print_test_result(test, IOU_TEST_SKIP, ++testnum);
+			}
+			continue;
+		}
+
+		print_test_preamble(test, quiet);
+		status = run_test(test);
+		print_test_result(test, status, ++testnum);
+		switch (status) {
+		case IOU_TEST_PASS:
+			passed++;
+			break;
+		case IOU_TEST_SKIP:
+			skipped++;
+			break;
+		case IOU_TEST_FAIL:
+			failed++;
+			break;
+		}
+	}
+	printf("\n\n=============================\n\n");
+	printf("RESULTS:\n\n");
+	printf("PASSED:  %u\n", passed);
+	printf("SKIPPED: %u\n", skipped);
+	printf("FAILED:  %u\n", failed);
+
+	return failed ? 1 : 0;
+}
+
+void iou_test_register(struct iou_test *test)
+{
+	IOU_BUG_ON(!test_valid(test));
+	IOU_BUG_ON(__iou_num_tests >= MAX_IOU_TESTS);
+
+	__iou_tests[__iou_num_tests++] = *test;
+}
-- 
2.47.0


