Return-Path: <io-uring+bounces-12751-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGTXMw8Tu2k3ewIAu9opvQ
	(envelope-from <io-uring+bounces-12751-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 22:03:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBD72C2CD3
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 22:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E68893174C8C
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 21:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BCA37419B;
	Wed, 18 Mar 2026 21:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SO3MxjAQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FA26FD9B
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867694; cv=none; b=SIO/muV8HrCcQqb6V8Y28B9Imu/gXOOMom7h+D0k7MDJhg0Xj4FaVnL+g0+uNpUU8vZ3PKruxxGp3iUV3CSXi2u98FcJiniIFbu4yd/s4wd7UFsaiPxy0fUq4br/qtKEA/sFJoOIBcMUfKneOJhBXBH4leXdqo7X6MWkTyPCxkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867694; c=relaxed/simple;
	bh=L+V1oAuWfe12Zcx1CeXNNXFUvp57lGeZoeJH1dACeeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O9CZNRkZFUmFZ6zBNuc8qBz//Z59AxsYXHJHT73ZT89y6rMGGLrqNawiFwyKNGFn+Wrh8msQKVzNt/4F2weTdgDO0v66EDnx40TAzQ/8431AL2CudTadsH0JdbF2BSwPsy80LNBJ47Q4/Rx16h4TFsVcQUkiX25rM1qDm4AMK1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SO3MxjAQ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so3015705e9.2
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 14:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773867691; x=1774472491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kVBcKPo+IKwfWqXzR03/7civgsuVAlKowLQuAbzQ+xc=;
        b=SO3MxjAQRWA3Bm8hYHRcNEiq+U74fBJnvy0YVUHXDrhwN4u+aXb6YgCfN8ILBpMhao
         Jq/QVbCb/6GgS3EBCk6IKU2+RgUzbH+rWmmn8++GHoQV54XuwPgBSVwqRJuVmrd1InUu
         31Fs3ovC11QsHktgnDWymjp8YvYADE5lRR06tp2stqFs+xPDetXmhEY69fK7zOKk9cae
         yyNeLsyc5ZwrEHJxdpcF6sIdEpOiZMua2MLiU9wjR3tfbA1XnS91l6R+xR8WmmJso9JI
         34hT5QsL2vHuZtoGN8Slg4flGUqNEkE0fKBdMr9Oy/hqlSAUrUxpuQI5wE1vTGuAQ8Ux
         AGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773867691; x=1774472491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVBcKPo+IKwfWqXzR03/7civgsuVAlKowLQuAbzQ+xc=;
        b=s2Wkphetdx9lVgV+SWDRaS/KYzeiKreSoB5CXl+7GTfvWeOIVX4nGTuqX04PQlNXA6
         Z9NR+qtWhqjtY0fAoZSGKrQTEsmXqEGTD52tJq3NkQnkES1cysl7Ulgw8e9xaxOpxFyw
         i/7NWpifhWkMS1YIFoX3H8yhU7ei+ycJZUwiArGeaBEFWcDOINus+qgz39Ti/Ky0MdL3
         V7JoUM1m7+8Lj+XBDY1LOH6b5D4OFlDa+zAEgN/uSUsey8qTwiO3+Sv/cMj1oSKCfGXw
         gwqoCGRNJO3RqRrp51aWsNnHXhUer8nugdFm9t1xN+/xJyv3bntkLuhEMlv0vbst3YPy
         EZeA==
X-Gm-Message-State: AOJu0YyQxFYk/B7euKDALM4YoEvagH8ib2B2KafyaSkYoNp2iHy3jHnR
	ESTZsJWNPWU+WXESMHmB6SkMY5/Zq3FKJ/MKt0M8KbTr3OhkjAcl0mDSAc9hGA==
X-Gm-Gg: ATEYQzwMJ+wG/g5kBUsoj+77xlBmBY1BdYY0cy6vVvI0htW6NZZFZQtaCzpZpgEN05+
	29KtTxlnu8Je8lm4rKfabXXZv+ZErVX62ifEp/dxTyoRBuyDZSO4jUu5ohih4rlK8/HGdU9srU7
	vtTyxjVoJe8OVei12hmq7PRIO3tbN/oGooJ4nKqWrjYt/UAupQ3er05xKVawj5tmYxRuBMupt+O
	U8xsPJQ4h5rasjajzOSf3NE8wS38Yut1Na6rU+QHPe8FEXubnmBcJPrjggwngexjf7YjGPJzPQ1
	uhq80wBUELjRwaUXUS+q4zWeXVqm1+42frdWDs5B6OT7i0T8ciQp09pgvWJKxyuCNNv5v9ipsWV
	PzLaASCDSbS1tD7VYY7FY+MesfQr3VUO7SQm7egqhn6fXzd/Hu3k+4kgp1TNTHqOFIfv/GHf8oN
	cLtfyl490xhuOf91WdCG9YTpBdyk5PzAUBAqVO+eNv41pWt8ALjMuzQTZsnvn5TlHPhDRLliB1s
	xuzlKxlj/8KhiqAljSP6jaDLDIVdw==
X-Received: by 2002:a05:600c:c491:b0:486:d76c:fa57 with SMTP id 5b1f17b1804b1-486f4469363mr80320895e9.17.1773867690671;
        Wed, 18 Mar 2026 14:01:30 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8ba4baesm24512625e9.13.2026.03.18.14.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 14:01:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing v4 1/1] tests: test io_uring bpf ops
Date: Wed, 18 Mar 2026 21:01:34 +0000
Message-ID: <86e1f8328bac2a01af16139d6ef954eb0e1dd4c2.1773867669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12751-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.935];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[runtests-loop.sh:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,runtests.sh:url]
X-Rspamd-Queue-Id: 5DBD72C2CD3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add some BPF struct ops io_uring tests/examples, one is issuing nops in
a loop, the other copies a file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 configure                 |  35 ++++++++++
 test/Makefile             |  32 ++++++++-
 test/bpf-progs/cp.bpf.c   | 140 ++++++++++++++++++++++++++++++++++++++
 test/bpf-progs/nops.bpf.c |  97 ++++++++++++++++++++++++++
 test/bpf_cp.c             | 138 +++++++++++++++++++++++++++++++++++++
 test/bpf_defs.h           |  41 +++++++++++
 test/bpf_nops.c           |  99 +++++++++++++++++++++++++++
 7 files changed, 581 insertions(+), 1 deletion(-)
 create mode 100644 test/bpf-progs/cp.bpf.c
 create mode 100644 test/bpf-progs/nops.bpf.c
 create mode 100644 test/bpf_cp.c
 create mode 100644 test/bpf_defs.h
 create mode 100644 test/bpf_nops.c

diff --git a/configure b/configure
index af0e10ab..536e5e6d 100755
--- a/configure
+++ b/configure
@@ -468,6 +468,41 @@ if compile_prog "" "" "idtype_t"; then
 fi
 print_config "has_idtype_t" "$has_idtype_t"
 
+##########################################
+# Check for BPF toolchain
+
+has_bpftool="no"
+if command -v bpftool >/dev/null 2>&1; then
+  has_bpftool="yes"
+fi
+
+tmp_bpf_c=$(mktemp /tmp/test_bpfXXXX.c)
+tmp_bpf_o=$(mktemp /tmp/test_bpfXXXX.o)
+
+cat > "$tmp_bpf_c" << EOF
+int tmp = 0;
+EOF
+
+has_bpf_clang="no"
+if clang -target bpf -mcpu=v4 -c "$tmp_bpf_c" -o "$tmp_bpf_o"; then
+  has_bpf_clang="yes"
+fi
+rm "$tmp_bpf_c" "$tmp_bpf_o"
+
+has_libbpf="no"
+if pkg-config --exists libbpf; then
+  has_libbpf="yes"
+fi
+
+print_config "has_bpftool" "$has_bpftool"
+print_config "has_bpf_clang" "$has_bpf_clang"
+print_config "has_libbpf" "$has_libbpf"
+
+has_bpf_loop_ops="no"
+if test "$has_bpftool" = "yes" && test "$has_bpf_clang" = "yes" && test "$has_libbpf" = "yes"; then
+  output_mak "bpf_toolchain" "y"
+fi
+
 #############################################################################
 liburing_nolibc="no"
 if test "$use_libc" != "yes"; then
diff --git a/test/Makefile b/test/Makefile
index 10c3bcfa..182ba30a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -1,6 +1,11 @@
 prefix ?= /usr
 datadir ?= $(prefix)/share
 
+CLANG ?= clang
+BPFTOOL ?= bpftool
+BPF_PROGS_DIR = bpf-progs
+BPF_OUTPUT = output/bpf
+
 INSTALL=install
 
 ifneq ($(MAKECMDGOALS),clean)
@@ -312,11 +317,19 @@ ifdef CONFIG_HAVE_CXX
 endif
 all_targets += sq-full-cpp.t
 
+bpf_test_srcs := bpf_nops.c bpf_cp.c
+bpf_progs := $(patsubst bpf_%.c, %.bpf.c, $(bpf_test_srcs))
+bpf_test_targets :=
+
+ifeq ($(bpf_toolchain),y)
+	bpf_test_targets := $(patsubst %.c,%.tt,$(bpf_test_srcs))
+endif
 
 test_targets := $(patsubst %.c,%,$(test_srcs))
 test_targets := $(patsubst %.cc,%,$(test_targets))
 run_test_targets := $(patsubst %,%.run_test,$(test_targets))
 test_targets := $(patsubst %,%.t,$(test_targets))
+test_targets += $(bpf_test_targets)
 all_targets += $(test_targets)
 helpers = helpers.o
 
@@ -338,6 +351,9 @@ LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi
 %.t: %.c $(helpers) helpers.h $(LIBURING)
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
+bpf_%.tt: bpf_%.c $(helpers) helpers.h $(LIBURING) $(BPF_OUTPUT)/%.bpf.o $(BPF_OUTPUT)/%.skel.h
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -I$(BPF_OUTPUT) -o $@ $< $(helpers) $(LDFLAGS) -lbpf
+
 #
 # Clang++ is not happy with -Wmissing-prototypes:
 #
@@ -350,6 +366,20 @@ LIBURING := $(shell if [ -e ../src/liburing.a ]; then echo ../src/liburing.a; fi
 	$(patsubst -Wmissing-prototypes,,$(CXXFLAGS)) \
 	-o $@ $< $(helpers) $(LDFLAGS)
 
+CLANG_BPF_SYS_INCLUDES ?= $(shell $(CLANG) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+
+# Build BPF code
+$(BPF_OUTPUT)/%.bpf.o: $(BPF_PROGS_DIR)/%.bpf.c $(wildcard %.h)
+	mkdir -p ${BPF_OUTPUT}
+	$(QUIET_CC)$(CLANG) -g -O2 -target bpf \
+		     -I$(BPF_OUTPUT) $(CLANG_BPF_SYS_INCLUDES) \
+		     -Wno-missing-declarations \
+		     -c $(filter %.c,$^) -o $(patsubst %.bpf.o,%.tmp.bpf.o,$@) -mcpu=v4
+	$(BPFTOOL) gen object $@ $(patsubst %.bpf.o,%.tmp.bpf.o,$@)
+
+$(BPF_OUTPUT)/%.skel.h: $(BPF_OUTPUT)/%.bpf.o
+	$(BPFTOOL) gen skeleton $< > $@
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
@@ -361,7 +391,7 @@ uninstall:
 	@rm -rf $(datadir)/liburing-test/
 
 clean:
-	@rm -f $(all_targets) helpers.o output/*
+	@rm -rf $(all_targets) helpers.o output/*
 	@rm -rf output/
 
 runtests: all
diff --git a/test/bpf-progs/cp.bpf.c b/test/bpf-progs/cp.bpf.c
new file mode 100644
index 00000000..67a9f825
--- /dev/null
+++ b/test/bpf-progs/cp.bpf.c
@@ -0,0 +1,140 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "../bpf_defs.h"
+#include <linux/errno.h>
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
index 00000000..0aefc76e
--- /dev/null
+++ b/test/bpf-progs/nops.bpf.c
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "../bpf_defs.h"
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
diff --git a/test/bpf_defs.h b/test/bpf_defs.h
new file mode 100644
index 00000000..8e120057
--- /dev/null
+++ b/test/bpf_defs.h
@@ -0,0 +1,41 @@
+#ifndef T_LIBURING_BPF_DEFS_H_
+#define T_LIBURING_BPF_DEFS_H_
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "liburing/io_uring.h"
+
+struct io_ring_ctx {};
+
+struct iou_loop_params {
+	__u32 cq_wait_idx;
+};
+
+struct io_uring {
+	__u32 head;
+	__u32 tail;
+};
+
+enum {
+	IOU_REGION_MEM = 0,
+	IOU_REGION_CQ = 1,
+	IOU_REGION_SQ = 2,
+};
+
+enum {
+	IOU_LOOP_CONTINUE = 0,
+	IOU_LOOP_STOP = 1,
+};
+
+struct io_uring_bpf_ops {
+	int (*loop_step)(struct io_ring_ctx *, struct iou_loop_params *);
+	__u32 ring_fd;
+};
+
+extern __u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id, const size_t rdwr_buf_size) __weak __ksym;
+extern int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, __u32 nr) __weak __ksym;
+
+#endif /* T_LIBURING_BPF_DEFS_H_ */
diff --git a/test/bpf_nops.c b/test/bpf_nops.c
new file mode 100644
index 00000000..bdd4df47
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
+#include "nops.skel.h"
+#include "helpers.h"
+
+static struct nops_bpf *skel;
+static struct bpf_link *nops_bpf_link;
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
+	skel = nops_bpf__open();
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
+	ret = nops_bpf__load(skel);
+	if (ret) {
+		if (ret == -ESRCH) {
+			printf("io_uring BPF ops are not supported\n");
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "failed to load skeleton\n");
+		return T_EXIT_FAIL;
+	}
+
+	nops_bpf_link = bpf_map__attach_struct_ops(skel->maps.nops_ops);
+	if (!nops_bpf_link) {
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
+	bpf_link__destroy(nops_bpf_link);
+	nops_bpf__destroy(skel);
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.53.0


