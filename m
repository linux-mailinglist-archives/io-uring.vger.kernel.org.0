Return-Path: <io-uring+bounces-11941-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Cu8AHyReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11941-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3067C92AA0
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD98C313A182
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 692FB33DEF6;
	Tue, 27 Jan 2026 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IImCer1v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA4133D517
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508882; cv=none; b=l7h7yYVKHWB8DeW3bcSnpN1iO/zw8gBIecQcJV+wzEZG+flt7Lh9L7c8lmUSvPetu5e2WS3hdKpYfqMSSc6KSG3Agz7p10jaWHkjnIo2I9hbJyN4dot+hLsiW8DxDGruZgJZXwhMaLUVB6vHvpa2wEglYTf0n0/gfGc/mn6TzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508882; c=relaxed/simple;
	bh=3CNc1lB4IFzqGOnLxshcT7rxH0U2zaMaYe753GOMbQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaNig7wAGtftLg6Nu4Bv6Z4twh+CIG+lMsy6/szHLxmxDvv2kAepXOQj1rEwNQ+ldbsp5YSAdZB7a06kpSXMxmxXKqBrZehwcCnWaaOxZtX5KoUdJuLr4gkQW6BJ6ujZB9FSCxs55lFlDQsFK3ZpXjeftREThAziVcu7ljSG8/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IImCer1v; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4327555464cso3788874f8f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508878; x=1770113678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BI3j5L8QaNLUosP6Q+BBEy6f1JO6/4XTAGV1WNs8w6o=;
        b=IImCer1v68gRQRSwOaGkOQU0p8cCjRXGNIYygDFRWTmlQ8mC9A9/5V2L/4B5RfsWWA
         ELf5hE0pbU6lvlPguupGHKEYOGLyVDKYyLBF6lTZ01mB/hwUyA3bfzt3XVobUUjRIq9t
         McCe8aLv6MPiShzgLSsFetgmz4VUvmeWIuSo44O5ZJ2X9Yv7hs5R0B+Tvs2sEnsk6sQu
         fAjDFD0+5OR/EBi69s/6N0RjPAPbQpaXx/TwuvSqoJJpSrJvCWJKN+0OyGeOeT11B3We
         CMBY94aJUuw/Kcq0HDJYH0e9EdejBgqXiliirQ223bG/J3xjAp+YWPv6tCtJHmlQ9Gjf
         9+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508878; x=1770113678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BI3j5L8QaNLUosP6Q+BBEy6f1JO6/4XTAGV1WNs8w6o=;
        b=hOgzIz82XME3cjbMx7B2Eqw9VXTuR3Cq9ia3WAbwBBoaQbAyNPtLFYlFgKu0XJkwOy
         06m1/Er7417cVs+x/R4xY5tOMl+VpbCmlJ+/DkbePBOgis4XZ8nf+nHJTd2BooYqh7H5
         ExbdKgvOXiUkJorOuIjXpsN+AZCSl0nfKHO2TSr+pgtC87R6IZOu3HHW8UPQ0BN/z4cX
         VypwmU0v/b4Xyn+G3297gYAD+Sn7ehUDsoRdyL9WU/+FRDHUJBa1uM/6pMcBuN09Gcqx
         Tt7d0DX1MZUyW88Q5+HA7bZgE2mIgCeOoQuPQZBVCf5fxn3NmDVi9HX/2MuTNNAG+ZVZ
         1dRA==
X-Gm-Message-State: AOJu0Yw6+YRfygmh8/5MxczIBer1dly98qmMs7/dp5oU44qwZYPv1TLD
	JJyefR+42gT57Cku1qlNQ+rTkJlm4RdX6BOFbqmw/F6OWL6qHr4MY2qh3Zl3Hgg7
X-Gm-Gg: AZuq6aJB6VHZHEHeu+iBoofG9q5sTMYozVxV6EPXluzWBAo8IB9naDxc4R7qLYF4gui
	85fkWgdqQHejmqfus4qVimYQ/T7pk2SHrg59d+GrMtc0yIVn3I3ybkwkV+7WA8WhYhFW8wymuao
	sfm8SxptRs/8uTwXA3xjDp+4aRd6zgC4CgyLZltvIAFxyKBYzGTz1CZ8ySOkjOtPRWM9fOTuDK1
	NzPC2JTkH4iwtkFIUMu/066SiLJSAUTKivHQFbTc7IvlwHGI5oefhBWLScUBlteFgfgQ8hx3R6V
	XZ9fCbVv4g31YSEg2Eo7MosvkqYwyXfddC8FGoEfDMCcYRI7vl1ytldFaJbp8l+c5vqm7JyQTYm
	F40xgTI5nXuGeOlTo/htM6szCk0OBk1TD+YpeJVCo/Av7iiwIURYG0FBNtSw607VzxcKi+VnuJL
	GZyXI1k9kLVtZ10NUIkLzJ5/IJ+bxQL7LARrIVlbtGmSsHUuwUJTYnCH2KpvHwtmAsq+Jn1ZvL0
	EO+/xXnAaCJ/97+CQ==
X-Received: by 2002:a05:6000:1acc:b0:430:8583:d182 with SMTP id ffacd0b85a97d-435dd0b9089mr1804229f8f.29.1769508877880;
        Tue, 27 Jan 2026 02:14:37 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 6/6] selftests/io_uring: add a bpf io_uring selftest
Date: Tue, 27 Jan 2026 10:14:10 +0000
Message-ID: <b766b428ec90862d69c9ab843dc89b6d0a017628.1769470552.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11941-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lib.mk:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3067C92AA0
X-Rspamd-Action: no action

Add a simple io_uring BPF selftest, where the BPF program implemented in
basic.bpf.c executes a given number of NOP requests with QD=1, writes
some stats and returns back. The makefile is borrowed from sched_ext
tests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/Makefile             |   3 +-
 tools/testing/selftests/io_uring/Makefile    | 143 +++++++++++++++++++
 tools/testing/selftests/io_uring/basic.bpf.c | 116 +++++++++++++++
 tools/testing/selftests/io_uring/common.h    |   6 +
 tools/testing/selftests/io_uring/runner.c    | 107 ++++++++++++++
 tools/testing/selftests/io_uring/types.bpf.h | 131 +++++++++++++++++
 6 files changed, 505 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c
 create mode 100644 tools/testing/selftests/io_uring/types.bpf.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 56e44a98d6a5..5e965ba3697c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -130,6 +130,7 @@ TARGETS += vfio
 TARGETS += x86
 TARGETS += x86/bugs
 TARGETS += zram
+TARGETS += io_uring
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
 # "make quicktest=1 kselftest" from top level Makefile
@@ -147,7 +148,7 @@ endif
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
index 000000000000..edc8c83d4273
--- /dev/null
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -0,0 +1,143 @@
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
+$(IOUOBJ_DIR)/%.bpf.o: %.bpf.c | $(BPFOBJ) $(IOUOBJ_DIR)
+	$(call msg,CLNG-BPF,,$(notdir $@))
+	$(Q)$(CLANG) $(BPF_CFLAGS) -target bpf -c $< -o $@
+
+$(INCLUDE_DIR)/%.bpf.skel.h: $(IOUOBJ_DIR)/%.bpf.o $(BPFTOOL) | $(INCLUDE_DIR)
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
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+.DEFAULT_GOAL := all
+
+.DELETE_ON_ERROR:
+
+.SECONDARY:
diff --git a/tools/testing/selftests/io_uring/basic.bpf.c b/tools/testing/selftests/io_uring/basic.bpf.c
new file mode 100644
index 000000000000..b2f6f3279090
--- /dev/null
+++ b/tools/testing/selftests/io_uring/basic.bpf.c
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "types.bpf.h"
+#include "common.h"
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+extern int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx,
+				    unsigned int nr) __ksym;
+extern __u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
+				    const __u64 rdwr_buf_size) __ksym;
+
+static inline void io_update_cq_wait(struct iou_loop_params *lp,
+				     struct io_ring_hdr *cq_hdr,
+				     unsigned to_wait)
+{
+	lp->cq_wait_idx = cq_hdr->head + to_wait;
+}
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+int reqs_to_run;
+const volatile unsigned cq_hdr_offset;
+const volatile unsigned sq_hdr_offset;
+const volatile unsigned cqes_offset;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 3);
+	__type(key, u32);
+	__type(value, s64);
+} res_map SEC(".maps");
+
+static inline void write_result(int res)
+{
+	u32 key = SLOT_RES;
+	u64 *val;
+
+	val = bpf_map_lookup_elem(&res_map, &key);
+	if (val)
+		*val = res;
+}
+
+static inline void inc_slot(int idx)
+{
+	u32 key = idx;
+	u64 *val;
+
+	val = bpf_map_lookup_elem(&res_map, &key);
+	if (val)
+		*val += 1;
+}
+
+SEC("struct_ops.s/link_loop")
+int BPF_PROG(link_loop, struct io_ring_ctx *ring, struct iou_loop_params *ls)
+{
+	struct io_ring_hdr *sq_hdr, *cq_hdr;
+	struct io_uring_cqe *cqes;
+	struct io_uring_sqe *sqes, *sqe;
+	void *rings;
+	int ret;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+				SQ_ENTRIES * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
+				cqes_offset + CQ_ENTRIES * sizeof(struct io_uring_cqe));
+	if (!rings || !sqes) {
+		write_result(-1);
+		return IOU_LOOP_STOP;
+	}
+
+	sq_hdr = rings + (sq_hdr_offset & 63);
+	cq_hdr = rings + (cq_hdr_offset & 63);
+	cqes = rings + cqes_offset;
+
+	if (cq_hdr->tail != cq_hdr->head) {
+		unsigned cq_mask = CQ_ENTRIES - 1;
+		struct io_uring_cqe *cqe = &cqes[cq_hdr->head++ & cq_mask];
+
+		if (cqe->user_data != reqs_to_run) {
+			write_result(-3);
+			return IOU_LOOP_STOP;
+		}
+
+		--reqs_to_run;
+		inc_slot(SLOT_NR_CQES);
+
+		if (reqs_to_run <= 0) {
+			write_result(1);
+			return IOU_LOOP_STOP;
+		}
+	}
+
+	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
+	*sqe = (struct io_uring_sqe){};
+	sqe->opcode = IORING_OP_NOP;
+	sqe->user_data = reqs_to_run;
+	sq_hdr->tail++;
+
+	ret = bpf_io_uring_submit_sqes(ring, 1);
+	if (ret != 1) {
+		write_result(-2);
+		return IOU_LOOP_STOP;
+	}
+
+	inc_slot(SLOT_NR_SQES);
+	io_update_cq_wait(ls, cq_hdr, 1);
+	return IOU_LOOP_CONTINUE;
+}
+
+SEC(".struct_ops")
+struct io_uring_bpf_ops basic_ops = {
+	.loop_step = (void *)link_loop,
+};
diff --git a/tools/testing/selftests/io_uring/common.h b/tools/testing/selftests/io_uring/common.h
new file mode 100644
index 000000000000..40e3182b8e5a
--- /dev/null
+++ b/tools/testing/selftests/io_uring/common.h
@@ -0,0 +1,6 @@
+#define CQ_ENTRIES 8
+#define SQ_ENTRIES 8
+
+#define SLOT_RES	0
+#define SLOT_NR_CQES	1
+#define SLOT_NR_SQES	2
diff --git a/tools/testing/selftests/io_uring/runner.c b/tools/testing/selftests/io_uring/runner.c
new file mode 100644
index 000000000000..5fc25ddc20e8
--- /dev/null
+++ b/tools/testing/selftests/io_uring/runner.c
@@ -0,0 +1,107 @@
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "basic.bpf.skel.h"
+#include "common.h"
+
+static struct io_uring_params params;
+static struct basic *skel;
+static struct bpf_link *basic_link;
+
+#define NR_ITERS 10
+
+static void setup_ring(struct io_uring *ring)
+{
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
+	skel->bss->reqs_to_run = NR_ITERS;
+	skel->rodata->sq_hdr_offset = params.sq_off.head;
+	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cqes_offset = params.cq_off.cqes;
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
+	__s64 res[3] = {};
+	int i, ret;
+
+	ret = io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+	if (ret) {
+		fprintf(stderr, "run failed\n");
+		exit(1);
+	}
+
+	for (i = 0; i < 3; i++) {
+		__u32 key = i;
+
+		ret = bpf_map__lookup_elem(skel->maps.res_map,
+					&key, sizeof(key),
+					&res[i], sizeof(res[i]), 0);
+		if (ret)
+			fprintf(stderr, "can't read map idx %i: %i\n", i, ret);
+	}
+
+	if (res[SLOT_RES] != 1)
+		fprintf(stderr, "run failed: %i\n", (int)res[SLOT_RES]);
+	if (res[SLOT_NR_CQES] != NR_ITERS)
+		fprintf(stderr, "unexpected number of CQEs: %i\n",
+			(int)res[SLOT_NR_CQES]);
+	if (res[SLOT_NR_SQES] != NR_ITERS)
+		fprintf(stderr, "unexpected submitted number: %i\n",
+			(int)res[SLOT_NR_SQES]);
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
index 000000000000..7a170cb2f388
--- /dev/null
+++ b/tools/testing/selftests/io_uring/types.bpf.h
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+
+struct io_ring_ctx {
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
+struct iou_loop_params {
+	__u32			cq_wait_idx;
+};
+
+enum {
+	IOU_LOOP_CONTINUE = 0,
+	IOU_LOOP_STOP,
+};
+
+enum {
+	IOU_REGION_MEM,
+	IOU_REGION_CQ,
+	IOU_REGION_SQ,
+};
+
+struct io_uring_bpf_ops {
+	int (*loop_step)(struct io_ring_ctx *ctx, struct iou_loop_params *lp);
+
+	__u32 ring_fd;
+};
+
+struct io_ring_hdr {
+	u32 head;
+	u32 tail;
+};
+
+
+enum io_uring_op {
+	IORING_OP_NOP,
+
+	/* this goes last, obviously */
+	IORING_OP_LAST,
+};
-- 
2.52.0


