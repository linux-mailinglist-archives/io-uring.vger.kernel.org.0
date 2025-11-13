Return-Path: <io-uring+bounces-10600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C03DC57513
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 896133B868C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815E934DCCE;
	Thu, 13 Nov 2025 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfkHaiJL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09134F490
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035217; cv=none; b=IIg/rytcU3emetkJCBmr9ll5WwEpo3762JpivyxiX41k6P6Xr/S6tZZ+/pyMLEP4okKIS2CjZ8C25KeXTTGc1R89HB92jScs95pKD0LT9TyXgO8pT6pn2/MEZuIaplQnBXQ9gQp8UcwfutxJFVVbRl/VQoO8noN6pFm71/VUYjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035217; c=relaxed/simple;
	bh=abH028Lq9fueLicr4/Jah0NeuJ9oT3/YGBNXH2+9yTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3TPbaPBJjE7xtEKrOOqFxoLUbqgIh+X/dAUEkGeL1fh4oRCkufJXvcK/YTMe+2oP5Ng4pe1cxr5/sVgRI5ROVgmsYkvZ6XU5FlTdTm8MfIpNdFIH6iu2rqLJe9G4XdDw/dKikNaceFcpgFs5GU1/UMi8dvXHhiGCOFW0padyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfkHaiJL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477442b1de0so4941705e9.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035213; x=1763640013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zw+tfYhQ8qHsl+zYAb5pbI4BEvQcHfceIbK6XCK8UJ4=;
        b=GfkHaiJLYQ5iM9ZoVwzGjm0HFt+UO2lfDQ71HxT4Fy9h5M4yEmCjHObNAkYmMq+NOn
         uItu5JwBfZyy/xf6VaT2meOsa95rBJVE5KtCLi3MyES+0FNj33TLoB+UScDXdgjHfj0q
         jQhYQ7hsJGYGh7FAfbWgSq+cyEh39Djl38qk54haFH89XRELwab90h3/JTmmJ0DkPXx6
         ZU1tzyv14oDCnSYg8NKtWkR73/DlO8g+FCotm5W+ircA46DZOx4GH+adAcIqKkBoGjM9
         uLJ8z9hZk9BgTYK1Y16uG6rojx3el6zLUz4hVeE14FlD+E5HyuBGKhGVA/ylS0iPMgp6
         Xvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035213; x=1763640013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zw+tfYhQ8qHsl+zYAb5pbI4BEvQcHfceIbK6XCK8UJ4=;
        b=GuoudvfblONI+uKJzvS3V8eKa8iWREMreUDZWWzzaIiRuSjdfYFHsrYPpYFAjeUfHu
         KrDkYoYckZzEbUki9/3G0B3oabfoUGzKGWWXNx9JGGMGBLVJW8xqBh9r0Eha7Be2rjBE
         xr19m3VTM5MPEuVtX64uFe8jzQOOp6i1mzzGJYnzlJ2mg+Dfgc6ylssks/XhwEmk23Xu
         l1ulERmPMZUxMLvvX/dJsiH7Vc23d1Hsj+/vGwQAdap+AaOlWXHrFRB3VdZHg1MwWRoJ
         9yr6K59QWluSkvJ8aSbQx79MezwwhsG9fIfkez1DHTE5DmHWv/eHy/+O1WlVhj3uAzES
         c2hw==
X-Gm-Message-State: AOJu0YxYITrqpz7F46/ThQDRF1q2p58kVc9sDcCxjsUakGDOgO5TrW8z
	Ip1qcSI0wP3xlwrz6gj+aKG9egdeQ+8VzkbpOKds8fe8szUuN0bYQPQ+qFaR9w==
X-Gm-Gg: ASbGncvQXHp/KH7dnuKkrMtZooai6+9K43vm+VvQeQE6GvxK+sWlF0b8Wgfk1uiuWm6
	8P56eigzWchmWxN+p9C3krzeiZTycXVfe46cLEDlez5+obMSBIF0RRqFCBi/SU5rbMJIumXB1Us
	p2TR7DwT7A6WO2ZCphGMl2JR5X/N0BtiQy3Gz7x+rN797ytst2V0Dg6rYF9U+VUQRymc4ji+rqU
	DRcaa/GgCWytSIBcJcZ/8g+wPLI8n8/5fcDLagcuWdefAGZ1uB6DP94TyMMW9iMm6dM3EZc0B3Q
	5wVZpeii1YUPrFC8zJ1KRMEcVYeWRZZiZIQ0TfbyXHW0Jqmk7yBFEKAogIrF9uNXIVFAFd4zkeW
	nyJJDtFDKA4J55/nUgkOoBKT9fzRyClarTZotmt2iELIOcN8OjNRZ/LaTvK0=
X-Google-Smtp-Source: AGHT+IEfj/tLS8AVEgvw0utWmKw7zX7eY1oKrhLQsy0qwWN6/XC+729CAJaGIKIZboKF8zMxHBVIKA==
X-Received: by 2002:a05:600c:1384:b0:477:6363:d3f0 with SMTP id 5b1f17b1804b1-47787041416mr66231615e9.3.1763035212164;
        Thu, 13 Nov 2025 04:00:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
Date: Thu, 13 Nov 2025 11:59:47 +0000
Message-ID: <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a io_uring bpf selftest/example. runner.c sets up a ring and BPF and
calls io_uring_enter syscall to run the BPF program. All the execution
logic is in basic.bpf.c, which creates a request, waits for its
completion and repeats it N=10 times, after which it terminates. The
makefile is borrowed from sched_ext.

Note, it doesn't need to be all in BPF and can be intermingled with
userspace code. This needs a separate example.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/Makefile             |   3 +-
 tools/testing/selftests/io_uring/Makefile    | 164 +++++++++++++++++++
 tools/testing/selftests/io_uring/basic.bpf.c |  81 +++++++++
 tools/testing/selftests/io_uring/common.h    |   2 +
 tools/testing/selftests/io_uring/runner.c    |  80 +++++++++
 tools/testing/selftests/io_uring/types.bpf.h | 136 +++++++++++++++
 6 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c
 create mode 100644 tools/testing/selftests/io_uring/types.bpf.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c46ebdb9b8ef..31dd369a7154 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -129,6 +129,7 @@ TARGETS += vfio
 TARGETS += x86
 TARGETS += x86/bugs
 TARGETS += zram
+TARGETS += io_uring
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
 # "make quicktest=1 kselftest" from top level Makefile
@@ -146,7 +147,7 @@ endif
 # User can optionally provide a TARGETS skiplist. By default we skip
 # targets using BPF since it has cutting edge build time dependencies
 # which require more effort to install.
-SKIP_TARGETS ?= bpf sched_ext
+SKIP_TARGETS ?= bpf sched_ext io_uring
 ifneq ($(SKIP_TARGETS),)
 	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
 	override TARGETS := $(TMP)
diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
new file mode 100644
index 000000000000..7dfba422e5a6
--- /dev/null
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -0,0 +1,164 @@
+# SPDX-License-Identifier: GPL-2.0
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
+LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
+BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
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
+# Get Clang's default includes on this system, as opposed to those seen by
+# '-target bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
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
+	     -I$(INCLUDE_DIR) -I$(APIDIR) 	\
+	     -I$(REPOROOT)/include						\
+	     $(CLANG_SYS_INCLUDES) 						\
+	     -Wall -Wno-compare-distinct-pointer-types				\
+	     -Wno-incompatible-function-pointer-types				\
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
+all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
+
+$(IOUOBJ_DIR)/runner.o: runner.c $(all_test_bpfprogs) | $(IOUOBJ_DIR) $(BPFOBJ)
+	$(CC) $(CFLAGS) -c $< -o $@
+
+$(OUTPUT)/runner: $(IOUOBJ_DIR)/runner.o $(BPFOBJ)
+	@echo "$(testcase-targets)"
+	echo 111
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+.DEFAULT_GOAL := all
+
+.DELETE_ON_ERROR:
+
+.SECONDARY:
diff --git a/tools/testing/selftests/io_uring/basic.bpf.c b/tools/testing/selftests/io_uring/basic.bpf.c
new file mode 100644
index 000000000000..c7954146ae4d
--- /dev/null
+++ b/tools/testing/selftests/io_uring/basic.bpf.c
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "types.bpf.h"
+#include "common.h"
+
+extern int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr) __ksym;
+extern __u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
+				     const __u64 rdwr_buf_size) __ksym;
+
+static inline void io_bpf_wait_nr(struct io_ring_ctx *ring,
+				  struct iou_loop_state *ls, int nr)
+{
+	ls->cq_tail = ring->rings->cq.head + nr;
+}
+
+enum {
+	RINGS_REGION_ID		= 0,
+	SQ_REGION_ID		= 1,
+};
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+int reqs_to_run;
+
+SEC("struct_ops.s/link_loop")
+int BPF_PROG(link_loop, struct io_ring_ctx *ring, struct iou_loop_state *ls)
+{
+	struct ring_hdr *sq_hdr, *cq_hdr;
+	struct io_uring_cqe *cqe, *cqes;
+	struct io_uring_sqe *sqes, *sqe;
+	void *rings;
+	int ret;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, SQ_REGION_ID,
+				SQ_ENTRIES * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, RINGS_REGION_ID,
+				64 + CQ_ENTRIES * sizeof(struct io_uring_cqe));
+	if (!rings || !sqes) {
+		bpf_printk("error: can't get regions");
+		return IOU_LOOP_STOP;
+	}
+
+	sq_hdr = rings;
+	cq_hdr = sq_hdr + 1;
+	cqes = rings + 64;
+
+	if (cq_hdr->tail != cq_hdr->head) {
+		unsigned cq_mask = CQ_ENTRIES - 1;
+
+		cqe = &cqes[cq_hdr->head++ & cq_mask];
+		bpf_printk("found cqe: data %lu res %i",
+			   (unsigned long)cqe->user_data, (int)cqe->res);
+
+		int left = --reqs_to_run;
+		if (left <= 0) {
+			bpf_printk("finished");
+			return IOU_LOOP_STOP;
+		}
+	}
+
+	bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_to_run);
+	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
+	sqe->user_data = reqs_to_run;
+	sq_hdr->tail++;
+
+	ret = bpf_io_uring_submit_sqes(ring, 1);
+	if (ret != 1) {
+		bpf_printk("bpf submit failed %i", ret);
+		return IOU_LOOP_STOP;
+	}
+
+	io_bpf_wait_nr(ring, ls, 1);
+	return IOU_LOOP_WAIT;
+}
+
+SEC(".struct_ops")
+struct io_uring_ops basic_ops = {
+	.loop = (void *)link_loop,
+};
diff --git a/tools/testing/selftests/io_uring/common.h b/tools/testing/selftests/io_uring/common.h
new file mode 100644
index 000000000000..b86914f756f2
--- /dev/null
+++ b/tools/testing/selftests/io_uring/common.h
@@ -0,0 +1,2 @@
+#define CQ_ENTRIES 8
+#define SQ_ENTRIES 8
diff --git a/tools/testing/selftests/io_uring/runner.c b/tools/testing/selftests/io_uring/runner.c
new file mode 100644
index 000000000000..f4226d576220
--- /dev/null
+++ b/tools/testing/selftests/io_uring/runner.c
@@ -0,0 +1,80 @@
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <io_uring/mini_liburing.h>
+#include "basic.bpf.skel.h"
+#include "common.h"
+
+struct basic *skel;
+struct bpf_link *basic_link;
+
+static void setup_ring(struct io_uring *ring)
+{
+	struct io_uring_params params;
+	int ret;
+
+	memset(&params, 0, sizeof(params));
+	params.cq_entries = CQ_ENTRIES;
+	params.flags = IORING_SETUP_SINGLE_ISSUER |
+			IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_SQARRAY |
+			IORING_SETUP_CQSIZE;
+
+	ret = io_uring_queue_init_params(SQ_ENTRIES, ring, &params);
+	if (ret) {
+		fprintf(stderr, "ring init failed\n");
+		exit(1);
+	}
+}
+
+static void setup_bpf_ops(struct io_uring *ring)
+{
+	int ret;
+
+	skel = basic__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.basic_ops->ring_fd = ring->ring_fd;
+	skel->bss->reqs_to_run = 10;
+
+	ret = basic__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	basic_link = bpf_map__attach_struct_ops(skel->maps.basic_ops);
+	if (!basic_link) {
+		fprintf(stderr, "failed to attach ops\n");
+		exit(1);
+	}
+}
+
+static void run_ring(struct io_uring *ring)
+{
+	int ret;
+
+	ret = io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+	if (ret) {
+		fprintf(stderr, "run failed\n");
+		exit(1);
+	}
+}
+
+int main() {
+	struct io_uring ring;
+
+	setup_ring(&ring);
+	setup_bpf_ops(&ring);
+
+	run_ring(&ring);
+
+	bpf_link__destroy(basic_link);
+	basic__destroy(skel);
+	return 0;
+}
diff --git a/tools/testing/selftests/io_uring/types.bpf.h b/tools/testing/selftests/io_uring/types.bpf.h
new file mode 100644
index 000000000000..f2345fa68c4a
--- /dev/null
+++ b/tools/testing/selftests/io_uring/types.bpf.h
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+
+struct io_uring {
+	__u32 head;
+	__u32 tail;
+};
+
+struct io_rings {
+	struct io_uring		sq, cq;
+	__u32			cq_overflow;
+};
+
+struct io_ring_ctx {
+	unsigned int		flags;
+	struct io_rings		*rings;
+};
+
+struct io_uring_sqe {
+	__u8	opcode;		/* type of operation for this sqe */
+	__u8	flags;		/* IOSQE_ flags */
+	__u16	ioprio;		/* ioprio for the request */
+	__s32	fd;		/* file descriptor to do IO on */
+	union {
+		__u64	off;	/* offset into file */
+		__u64	addr2;
+		struct {
+			__u32	cmd_op;
+			__u32	__pad1;
+		};
+	};
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	splice_off_in;
+		struct {
+			__u32	level;
+			__u32	optname;
+		};
+	};
+	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__u32		fsync_flags;
+		__u16		poll_events;	/* compatibility */
+		__u32		poll32_events;	/* word-reversed for BE */
+		__u32		sync_range_flags;
+		__u32		msg_flags;
+		__u32		timeout_flags;
+		__u32		accept_flags;
+		__u32		cancel_flags;
+		__u32		open_flags;
+		__u32		statx_flags;
+		__u32		fadvise_advice;
+		__u32		splice_flags;
+		__u32		rename_flags;
+		__u32		unlink_flags;
+		__u32		hardlink_flags;
+		__u32		xattr_flags;
+		__u32		msg_ring_flags;
+		__u32		uring_cmd_flags;
+		__u32		waitid_flags;
+		__u32		futex_flags;
+		__u32		install_fd_flags;
+		__u32		nop_flags;
+		__u32		pipe_flags;
+	};
+	__u64	user_data;	/* data to be passed back at completion time */
+	/* pack this to avoid bogus arm OABI complaints */
+	union {
+		/* index into fixed buffers, if used */
+		__u16	buf_index;
+		/* for grouped buffer selection */
+		__u16	buf_group;
+	} __attribute__((packed));
+	/* personality to use, if used */
+	__u16	personality;
+	union {
+		__s32	splice_fd_in;
+		__u32	file_index;
+		__u32	zcrx_ifq_idx;
+		__u32	optlen;
+		struct {
+			__u16	addr_len;
+			__u16	__pad3[1];
+		};
+	};
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		struct {
+			__u64	attr_ptr; /* pointer to attribute information */
+			__u64	attr_type_mask; /* bit mask of attributes */
+		};
+		__u64	optval;
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
+};
+
+struct io_uring_cqe {
+	__u64	user_data;
+	__s32	res;
+	__u32	flags;
+};
+
+
+struct iou_loop_state {
+	/*
+	 * The CQE index to wait for. Only serves as a hint and can still be
+	 * woken up earlier.
+	 */
+	__u32		cq_tail;
+	__s64		timeout;
+};
+
+struct io_uring_ops {
+	int (*loop)(struct io_ring_ctx *ctx, struct iou_loop_state *ls);
+
+	__u32 ring_fd;
+	void *priv;
+};
+
+enum {
+	IOU_LOOP_WAIT,
+	IOU_LOOP_STOP,
+};
+
+struct ring_hdr {
+	__u32 head;
+	__u32 tail;
+};
-- 
2.49.0


