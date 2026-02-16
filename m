Return-Path: <io-uring+bounces-12265-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHHaBWhLk2mi3AEAu9opvQ
	(envelope-from <io-uring+bounces-12265-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:52:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DF89146724
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ECAF53024A17
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492D22D5410;
	Mon, 16 Feb 2026 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHpTq4zF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F102D1F6B
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260717; cv=none; b=eAFbdqZv4L8fHSjqU5+SAgFs6NTrxGMYrfhuCck9UkORs06SYQHVYRYOTkWEm1k43SF8MAs50R9rssLaUmiHPAZV3abI2RuBkr8m/F/N2PF7L/1EG19p6M+7HE5mWwcc/WirQv30BKSgK5WUoPe0B4DSBKRg4+3JIq54G22fjvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260717; c=relaxed/simple;
	bh=VgibeFX/GUkiXuz+iFy7AUNd56iy3FtzsHfEcFBSPcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHZJg/urgtRXNn/TUjqp/cziiDAxoTG2cb3KG80jpu/acz1wAKMFZE9oSi0DF2ViJrh26n8QNGQoTm0KOWE81i3HGoVkkalAHRuqji16udTHNoHN9zT5tol3qVGF7S/FfOIc6oMneuuyrdYwtZyn/FS6YHiDrp/D6CXp6a8IXqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHpTq4zF; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-482f2599980so37225485e9.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260712; x=1771865512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlcL7xPtLGHxrDz3BL0MVsR2yjomAgjT0B7HZ8rmZ6o=;
        b=JHpTq4zFetCvnf0C+mwJa4qp70tPb7EOtIh4o2ZPT39RF8VxsBzCiOBeuxtynhYdxe
         a//v4h+GyWUB2B+d42b78KVe5Ugt6dkfb5P2upS/fLgiwH3/cVFJUi/CB36Rsp50+/Tk
         dLuOMzCInCtvPbWOL5s+f8LdINTQjM3WC8iOj6UE9MvnXB9n8ewSsxVEIaAGijCAi5bw
         e2h9qr0r/mdcJ/kTqOFAxi2mxtBPthUJA9NjH+4meDnU0zo9JaIib8VTy7gkazUKDKTF
         kTUii8Iw0XYgqLQFU44z7dPTzYI38xR2nRlmuOO92ehuf57/3Jw5mKf0368DIxHsg16D
         IkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260712; x=1771865512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YlcL7xPtLGHxrDz3BL0MVsR2yjomAgjT0B7HZ8rmZ6o=;
        b=EKg6jNKTvbMRVgooCJbEs0rEO1+c1EWvebEQHZMNrvC1WAraItAEa8YjZHcDkkahhb
         4J5JJOVg4RtDxKSyPisdOwfsysDn2MisDfy9HDCX9krlZOcL4V6F47wSl2WeCumAgAx8
         sXmF8CF1QoggBWXysCMnv1+rJCnfEycnlDHKIYN183We8KKyIzN4RP7U5FeD79387F4D
         GB0Ckw4xb6iJIqPb+31JuXfX9QnYejwHrRGU4UeJHLd9o0HLSGxz0kTC/e7T5UYj0ZMI
         lihAHCLpabB8C+9H/lgWIkmfUrdtZyQDB00+LQIIHaEP/tiHTn+HiLDicfQf975H39CF
         RI9g==
X-Gm-Message-State: AOJu0YwSstyNwDiuoo0SboRU3uEdioN9bg/wnYygvVz3k0QFBhi95uZe
	YN/kUykJ20895Oo0PhTtLjQ+9KGXlycXHoXufAn2EG5suqfFHuypQEvIdI1LyiDU
X-Gm-Gg: AZuq6aLjOcP/wdnw7caa0FwMv9x/9rmTUdvKL/G2k4bfvL5AcIJtPlPaBueyfxtmHYW
	dmwv+/Vnmxk3uOzk4Di+fHBa7JpOVQG/adZYMj/Ed3ldYoNef7y5N/WGBVuNcoI7bRvNqR1Fugq
	19gTnyeFrud11bApvuiZN0vI++oup94cXFFoRcAkDv8c4hrtqArlsKRVJHpWWBVMjaZuXnYEMjh
	ucANMWJqQv7qz9GYPkICBKdQ9Qb+LFibBVj7vk6Jdv8Ra71pBW3RINIXTRFFXbMsJYwKktr7uru
	x2DgoBkcqSUje8QlFmALWym1jxOlBkn0CJDA1MSDhcCSz2MmMLL7kha4PhC2Mz1CpcnuwpSqVhz
	XgaBGkCJ6D08Oc4WonvgsxTq1e+iHHvMTB1v9cQ+04t0hKb7xPl8dAyFlzkr8stYeAxaESMUPW0
	l4p96aCdP3TR3NoWDWI9Kh1EPH+LffVdUg5/u09ZYKxvf9mi60K1Dx/a00FgZKbAwpMWl3gsQOj
	5ob5PeG
X-Received: by 2002:a05:600c:82c3:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-48373a25cffmr183579305e9.15.1771260712101;
        Mon, 16 Feb 2026 08:51:52 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b64b08bsm76454255e9.6.2026.02.16.08.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:51:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v7 5/5] selftests/io_uring: add a bpf io_uring selftest
Date: Mon, 16 Feb 2026 16:51:26 +0000
Message-ID: <e8e98d45559418b7bb80f6f9d40fff3512bcf35e.1771260487.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12265-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 8DF89146724
X-Rspamd-Action: no action

Add simple io_uring BPF selftests. nops_loop emulates a typical event
loop but with NOP requests. It maintains a given QD, submits requests
and reaps completions until it processes a pre-determined number of
requests. Other tests check CQE overflows and that unregistration
of BPF from io_uring works well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/Makefile     | 162 ++++++++++++++++++
 tools/testing/selftests/io_uring/common.h     |   7 +
 .../selftests/io_uring/nops_loop.bpf.c        | 131 ++++++++++++++
 tools/testing/selftests/io_uring/nops_loop.c  | 110 ++++++++++++
 .../testing/selftests/io_uring/overflow.bpf.c |  52 ++++++
 tools/testing/selftests/io_uring/overflow.c   |  82 +++++++++
 tools/testing/selftests/io_uring/unreg.bpf.c  |  27 +++
 tools/testing/selftests/io_uring/unreg.c      | 113 ++++++++++++
 9 files changed, 686 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.c
 create mode 100644 tools/testing/selftests/io_uring/overflow.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/overflow.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 450f13ba4cca..f618efaaf684 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -131,6 +131,7 @@ TARGETS += vfio
 TARGETS += x86
 TARGETS += x86/bugs
 TARGETS += zram
+TARGETS += io_uring
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
 # "make quicktest=1 kselftest" from top level Makefile
@@ -148,7 +149,7 @@ endif
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
index 000000000000..82a1fc5c4b2b
--- /dev/null
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -0,0 +1,162 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../../../build/Build.include
+include ../../../scripts/Makefile.arch
+include ../../../scripts/Makefile.include
+
+TEST_GEN_PROGS := unreg nops_loop overflow
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
+$(IOUOBJ_DIR)/%.bpf.o: %.bpf.c $(INCLUDE_DIR)/vmlinux.h | $(BPFOBJ) $(IOUOBJ_DIR)
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
+$(OUTPUT)/%: $(IOUOBJ_DIR)/%.o $(BPFOBJ)
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+$(IOUOBJ_DIR)/%.o: %.c $(all_test_bpfprogs) | $(IOUOBJ_DIR) $(BPFOBJ)
+	$(CC) $(CFLAGS) -c $< -o $@
+
+.DEFAULT_GOAL := all
+
+.DELETE_ON_ERROR:
+
+.SECONDARY:
diff --git a/tools/testing/selftests/io_uring/common.h b/tools/testing/selftests/io_uring/common.h
new file mode 100644
index 000000000000..9e726ca72d0c
--- /dev/null
+++ b/tools/testing/selftests/io_uring/common.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define CQ_ENTRIES 8
+#define SQ_ENTRIES 8
+
+#define SLOT_RES	0
+#define SLOT_NR_CQES	1
+#define SLOT_NR_SQES	2
diff --git a/tools/testing/selftests/io_uring/nops_loop.bpf.c b/tools/testing/selftests/io_uring/nops_loop.bpf.c
new file mode 100644
index 000000000000..6952d9f231e5
--- /dev/null
+++ b/tools/testing/selftests/io_uring/nops_loop.bpf.c
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "vmlinux.h"
+#include "common.h"
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+#define REQ_TOKEN 0xabba1741
+
+const unsigned max_inflight = 8;
+const volatile unsigned cq_hdr_offset;
+const volatile unsigned sq_hdr_offset;
+const volatile unsigned cqes_offset;
+
+int reqs_to_run;
+unsigned inflight;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 3);
+	__type(key, u32);
+	__type(value, s64);
+} res_map SEC(".maps");
+
+#define t_min(a, b) ((a) < (b) ? (a) : (b))
+
+static inline void set_cq_wait(struct iou_loop_params *lp,
+			       struct io_uring *cq_hdr, unsigned to_wait)
+{
+	lp->cq_wait_idx = cq_hdr->head + to_wait;
+}
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
+static inline void write_stats(int idx, unsigned int v)
+{
+	u32 key = idx;
+	u64 *val;
+
+	val = bpf_map_lookup_elem(&res_map, &key);
+	if (val)
+		*val += v;
+}
+
+SEC("struct_ops.s/nops_loop_step")
+int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
+{
+	struct io_uring *sq_hdr, *cq_hdr;
+	struct io_uring_sqe *sqes;
+	struct io_uring_cqe *cqes;
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
+	unsigned to_wait = cq_hdr->tail - cq_hdr->head;
+	to_wait = t_min(to_wait, CQ_ENTRIES);
+	for (int i = 0; i < to_wait; i++) {
+		struct io_uring_cqe *cqe = &cqes[cq_hdr->head & (CQ_ENTRIES - 1)];
+
+		if (cqe->user_data != REQ_TOKEN) {
+			write_result(-3);
+			return IOU_LOOP_STOP;
+		}
+		cq_hdr->head++;
+	}
+
+	reqs_to_run -= to_wait;
+	inflight -= to_wait;
+	write_stats(SLOT_NR_CQES, to_wait);
+
+	if (reqs_to_run <= 0) {
+		write_result(1);
+		return IOU_LOOP_STOP;
+	}
+
+	if (inflight < max_inflight) {
+		unsigned to_submit = max_inflight - inflight;
+
+		to_submit = t_min(to_submit, reqs_to_run);
+
+		for (int i = 0; i < to_submit; i++) {
+			struct io_uring_sqe *sqe;
+
+			sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
+			*sqe = (struct io_uring_sqe){};
+			sqe->opcode = IORING_OP_NOP;
+			sqe->user_data = REQ_TOKEN;
+			sq_hdr->tail++;
+		}
+
+		ret = bpf_io_uring_submit_sqes(ring, to_submit);
+		if (ret != to_submit) {
+			write_result(-2);
+			return IOU_LOOP_STOP;
+		}
+
+		inflight += to_submit;
+		write_stats(SLOT_NR_SQES, to_submit);
+	}
+
+	set_cq_wait(ls, cq_hdr, 1);
+	return IOU_LOOP_CONTINUE;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops nops_ops = {
+	.loop_step = (void *)nops_loop_step,
+};
diff --git a/tools/testing/selftests/io_uring/nops_loop.c b/tools/testing/selftests/io_uring/nops_loop.c
new file mode 100644
index 000000000000..2da28b141870
--- /dev/null
+++ b/tools/testing/selftests/io_uring/nops_loop.c
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "nops_loop.bpf.skel.h"
+#include "common.h"
+
+static struct io_uring_params params;
+static struct nops_loop *skel;
+static struct bpf_link *nops_loop_link;
+
+#define NR_ITERS 1000
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
+	skel = nops_loop__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.nops_ops->ring_fd = ring->ring_fd;
+	skel->bss->reqs_to_run = NR_ITERS;
+	skel->rodata->sq_hdr_offset = params.sq_off.head;
+	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cqes_offset = params.cq_off.cqes;
+
+	ret = nops_loop__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	nops_loop_link = bpf_map__attach_struct_ops(skel->maps.nops_ops);
+	if (!nops_loop_link) {
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
+int main()
+{
+	struct io_uring ring;
+
+	setup_ring(&ring);
+	setup_bpf_ops(&ring);
+
+	run_ring(&ring);
+
+	bpf_link__destroy(nops_loop_link);
+	nops_loop__destroy(skel);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
diff --git a/tools/testing/selftests/io_uring/overflow.bpf.c b/tools/testing/selftests/io_uring/overflow.bpf.c
new file mode 100644
index 000000000000..c1c629dd2a54
--- /dev/null
+++ b/tools/testing/selftests/io_uring/overflow.bpf.c
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "vmlinux.h"
+#include "common.h"
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+const volatile unsigned sq_hdr_offset;
+const volatile unsigned cqes_offset;
+static unsigned submitted;
+
+SEC("struct_ops.s/overflow_loop_step")
+int BPF_PROG(overflow_loop_step, struct io_ring_ctx *ring,
+				 struct iou_loop_params *ls)
+{
+	struct io_uring_sqe *sqes, *sqe;
+	struct io_uring_cqe *cqes;
+	struct io_uring *sq_hdr;
+	void *rings;
+	int ret;
+
+	if (submitted >= 2 * SQ_ENTRIES)
+		return IOU_LOOP_STOP;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+				SQ_ENTRIES * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
+				cqes_offset + CQ_ENTRIES * sizeof(struct io_uring_cqe));
+	if (!rings || !sqes)
+		return IOU_LOOP_STOP;
+
+	sq_hdr = rings + (sq_hdr_offset & 63);
+	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
+	*sqe = (struct io_uring_sqe){};
+	sqe->opcode = IORING_OP_NOP;
+	sq_hdr->tail++;
+
+	ret = bpf_io_uring_submit_sqes(ring, 1);
+	if (ret != 1)
+		return IOU_LOOP_STOP;
+
+	submitted++;
+	return IOU_LOOP_CONTINUE;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops overflow_ops = {
+	.loop_step = (void *)overflow_loop_step,
+};
\ No newline at end of file
diff --git a/tools/testing/selftests/io_uring/overflow.c b/tools/testing/selftests/io_uring/overflow.c
new file mode 100644
index 000000000000..12e4d8b5de6b
--- /dev/null
+++ b/tools/testing/selftests/io_uring/overflow.c
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "overflow.bpf.skel.h"
+#include "common.h"
+
+static struct io_uring_params params;
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
+static struct overflow *load_overflow(struct io_uring *ring)
+{
+	struct overflow *skel;
+	int ret;
+
+	skel = overflow__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.overflow_ops->ring_fd = ring->ring_fd;
+	skel->rodata->sq_hdr_offset = params.sq_off.head;
+	skel->rodata->cqes_offset = params.cq_off.cqes;
+
+	ret = overflow__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	return skel;
+}
+
+static void run_ring(struct io_uring *ring)
+{
+	io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+}
+
+int main()
+{
+	struct bpf_link *link;
+	struct io_uring ring;
+	struct overflow *skel;
+
+	setup_ring(&ring);
+	skel = load_overflow(&ring);
+	link = bpf_map__attach_struct_ops(skel->maps.overflow_ops);
+	if (!link) {
+		fprintf(stderr, "failed to attach ops\n");
+		return 1;
+	}
+
+	run_ring(&ring);
+
+	bpf_link__destroy(link);
+	overflow__destroy(skel);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
diff --git a/tools/testing/selftests/io_uring/unreg.bpf.c b/tools/testing/selftests/io_uring/unreg.bpf.c
new file mode 100644
index 000000000000..fef7f9df59b5
--- /dev/null
+++ b/tools/testing/selftests/io_uring/unreg.bpf.c
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "vmlinux.h"
+#include "common.h"
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+SEC("struct_ops.s/unreg_loop_step")
+int BPF_PROG(unreg_loop_step, struct io_ring_ctx *ring,
+			      struct iou_loop_params *ls)
+{
+	struct io_uring_sqe *sqes;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+						sizeof(struct io_uring_sqe));
+	if (sqes)
+		sqes->user_data++;
+	return IOU_LOOP_STOP;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops unreg_ops = {
+	.loop_step = (void *)unreg_loop_step,
+};
diff --git a/tools/testing/selftests/io_uring/unreg.c b/tools/testing/selftests/io_uring/unreg.c
new file mode 100644
index 000000000000..b0e75e671a5c
--- /dev/null
+++ b/tools/testing/selftests/io_uring/unreg.c
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "unreg.bpf.skel.h"
+#include "common.h"
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
+static struct unreg *load_unreg(struct io_uring *ring)
+{
+	struct unreg *skel;
+	int ret;
+
+	skel = unreg__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.unreg_ops->ring_fd = ring->ring_fd;
+
+	ret = unreg__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	return skel;
+}
+
+static void run_ring(struct io_uring *ring)
+{
+	io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_GETEVENTS, NULL);
+}
+
+int main()
+{
+	struct bpf_link *link1, *link2;
+	struct unreg *skel1, *skel2;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+
+	setup_ring(&ring);
+	sqe = &ring.sq.sqes[0];
+	sqe->user_data = 0;
+
+	skel1 = load_unreg(&ring);
+	skel2 = load_unreg(&ring);
+
+	link1 = bpf_map__attach_struct_ops(skel1->maps.unreg_ops);
+	if (!link1) {
+		fprintf(stderr, "failed to attach ops\n");
+		return 1;
+	}
+
+	run_ring(&ring);
+	if (sqe->user_data != 1) {
+		fprintf(stderr, "failed to run BPF\n");
+		return 1;
+	}
+
+	/* remove the program and give the kernel time to actually destroy it */
+	bpf_link__destroy(link1);
+	unreg__destroy(skel1);
+	sleep(1);
+
+	run_ring(&ring);
+	if (sqe->user_data != 1) {
+		fprintf(stderr, "Executed removed BPF\n");
+		return 1;
+	}
+
+	/* try to attach another program */
+	link2 = bpf_map__attach_struct_ops(skel2->maps.unreg_ops);
+	if (!link2) {
+		fprintf(stderr, "failed to reattach ops\n");
+		return 1;
+	}
+
+	run_ring(&ring);
+	if (sqe->user_data != 2) {
+		fprintf(stderr, "failed to run reattached BPF\n");
+		return 1;
+	}
+
+	bpf_link__destroy(link2);
+	unreg__destroy(skel2);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
-- 
2.52.0


