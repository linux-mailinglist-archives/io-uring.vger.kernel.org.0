Return-Path: <io-uring+bounces-12379-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEsTAlNgnGntFQQAu9opvQ
	(envelope-from <io-uring+bounces-12379-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:12:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A01F8177D70
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7330330429B1
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FDE285C8E;
	Mon, 23 Feb 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zuksh2+Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE17283FD8
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855933; cv=none; b=ALIDWdiDdAj7Xday6SpP0CitxOiDcJqIS7+6Dk7GVAEW9xrbNRU0lll/5m+kOwmk1tJuBKGPSkyBtQi3Zma7XV0poZvUvPC7vAXtSjtSUW1IfzFvQunGjD1vqwX2wCZOhk9NccSeQPR2FahxMF0m/4jSQIiJ/n/j7V70ER0rv7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855933; c=relaxed/simple;
	bh=su3yMT7fMvd4etXp8KrJE9ELIgGTCW4J/N0WBgkwbSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdU51Xcd1+J213I4PUCo4vK8ny4xVmKZXyXL3PXm3cC1dpFZQbFcHUNnXZJvigMjC71uiyCqcG4ebQyEXRDo27fV32WasYHC2LqUKkfoTUwEL7HZzI2/jMJdOUTa/nX09kmXDpu+DM41gMwH8bovc/Io0z5iRcloV7sZzhqawsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zuksh2+Q; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-483a233819aso42061975e9.3
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855930; x=1772460730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEpADA0qr9NXlrkOVl8FYbNTdN5kvBnCfaHkjzG7nPM=;
        b=Zuksh2+QcG21yPrSJclXqEG8BADEbi4uIXJsW6wYUqy/h0ySQqwUa0xAtRcV7zTGPr
         K8jjIXZwmRTgnlQ4RW2zVPK0u/E0PmL8n7YMvJ/7NeBEp0KPhbuS7XSkc2z+e+BIpTWP
         H/S5sFD6rRTlz11Wu80GC8YVjlfI1x3JaFut0ItuyEnTc1aGtp4Dc04Mh1kmBz/85TX9
         wJHMQ+YigFPSg/zzUlgb9BS798BszBqdLMGRNjCam7JoUBbW8U3oTTHHmmjiVy30tjyI
         FKLS4b2Sb2j7ejkJqb71paKxoiEVYirzTC5UNL4JaQ6YT+UQwJWE6FqlX3M7ESInE4xI
         /jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855930; x=1772460730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YEpADA0qr9NXlrkOVl8FYbNTdN5kvBnCfaHkjzG7nPM=;
        b=iZZS/HZBC/EYZdT9D3y4YUZMK+WtEi2kvU/x5W3GYn70cqo+irvsvUYt2FGc34X8fr
         KLwDlmmBKT7PkfTbXn2dgsMgnq36jAhp06mxiu2WEJPMva+40WYL2jO83MFqR8bqGHBX
         zy0JvQKRdeTwNWA5qL/7XYXM4DEpx2V6z63KvCQCS09nCF9hs+OvnxKuyaMQCG4essMB
         AIJczy4vnrsaX5HzxwCzFffnatcHpXUt0njCwE9wcLF1TNvp43pwY7jWGjMpiD04evNo
         2cnnrmqyAAM698okZoB1HFBlCBDa9FpIacUMTducM4/npAzzypUQXhfQjEwTgChI0Doa
         PJlg==
X-Gm-Message-State: AOJu0YyGhGPycxQcer6E+ZdCkcFnYuJCcv5ETrrG87rnJJFimb/92dwR
	YkOmUHQ2ssdXV41Hz+y0FLKDt/pqDSah/jogiZ87djR8JNcOfPFf/I1zOWoWRg==
X-Gm-Gg: AZuq6aJHCgn54zTC7/PKOWY70H6tiAYEJHh3Gs5s7NDZkXFOwud0trZ/ZBVxPE+wq0C
	j8kXpXzLXFxwkwn8TgGsPBbr4m/tps0xl/U3c9uWjdKIre+7OdQh+kWU/sJdGaozM5alaKFejRQ
	TMVBbinHuByW6gNX+WHtzvJnfSG7nfqafemSRzlsrJxaTjzk4Dwlw23/5FKPgfCnP7ToZI1DkpG
	za5Dr67vH0KsolsLvFiiilzT/zvoq2KaKSxcpEr/vLXvUMnd/H4Vrgbu5oGt/FbD0D8Pbzvoaz+
	lJuvgBvFlUVA4rlB1kH9FhDIDGeCaGyv39rJSQxd5IorW+a/NpKOmjzWljf8kRTL4PdgYBs3a7P
	zTx3fGKT+NYuvj1kJKAX6H7YlLQVWrq6RO4bwMoXJEcqJfSSxMtNvMXqCDxo86jhpYEbe3vlR/8
	vMrIvSSMnBKzlTGo/oW0ob+uy4CDMMrOPYMYgrOYanGzS/o6wlDXYNAqsQCjIZTai7HDXJZg8CP
	vdsv1ON2Q==
X-Received: by 2002:a05:600c:3553:b0:47e:e87b:af8 with SMTP id 5b1f17b1804b1-483a962e491mr144175795e9.21.1771855929583;
        Mon, 23 Feb 2026 06:12:09 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31bc0e3sm247077275e9.5.2026.02.23.06.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:12:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH 1/3] io_uring/selftests: add BPF'ed cp example
Date: Mon, 23 Feb 2026 14:12:00 +0000
Message-ID: <3c300bb41da3004cba8924e1a6a8dbeb50c3468c.1771850496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771850496.git.asml.silence@gmail.com>
References: <cover.1771850496.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12379-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lib.mk:url]
X-Rspamd-Queue-Id: A01F8177D70
X-Rspamd-Action: no action

Implement a simple QD=1 cp using BPF io_uring as an example of a state
machine handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/io_uring/Makefile     |   2 +-
 .../testing/selftests/io_uring/common-defs.h  |  10 ++
 tools/testing/selftests/io_uring/cp.bpf.c     | 134 ++++++++++++++++++
 tools/testing/selftests/io_uring/cp.c         | 130 +++++++++++++++++
 4 files changed, 275 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/cp.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/cp.c

diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
index 37f50acdba37..26e4cf721b86 100644
--- a/tools/testing/selftests/io_uring/Makefile
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -3,7 +3,7 @@ include ../../../build/Build.include
 include ../../../scripts/Makefile.arch
 include ../../../scripts/Makefile.include
 
-TEST_GEN_PROGS := nops_loop overflow unreg
+TEST_GEN_PROGS := nops_loop overflow unreg cp
 
 # override lib.mk's default rules
 OVERRIDE_TARGETS := 1
diff --git a/tools/testing/selftests/io_uring/common-defs.h b/tools/testing/selftests/io_uring/common-defs.h
index 9a44e0687436..20b59adbe703 100644
--- a/tools/testing/selftests/io_uring/common-defs.h
+++ b/tools/testing/selftests/io_uring/common-defs.h
@@ -28,4 +28,14 @@ struct unreg_state {
 	unsigned	times_invoked;
 };
 
+struct cp_state {
+	int input_fd;
+	int output_fd;
+	void *buffer;
+	unsigned nr_infligt;
+	unsigned cur_offset;
+	size_t buffer_size;
+	int res;
+};
+
 #endif /* IOU_TOOLS_COMMON_DEFS_H */
diff --git a/tools/testing/selftests/io_uring/cp.bpf.c b/tools/testing/selftests/io_uring/cp.bpf.c
new file mode 100644
index 000000000000..7c19b687ab37
--- /dev/null
+++ b/tools/testing/selftests/io_uring/cp.bpf.c
@@ -0,0 +1,134 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "vmlinux.h"
+#include "common-defs.h"
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+enum {
+	REQ_TOKEN_READ = 1,
+	REQ_TOKEN_WRITE
+};
+
+const volatile struct ring_info ri;
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
+			  struct cp_state *cs, int type, size_t size)
+{
+	struct io_uring_sqe *sqe = sqes;
+	__u8 req_type;
+	int fd, ret;
+
+	if (type == REQ_TOKEN_READ) {
+		req_type = IORING_OP_READ;
+		fd = cs->input_fd;
+	} else {
+		req_type = IORING_OP_WRITE;
+		fd = cs->output_fd;
+	}
+
+	sqe_prep_rw(sqes, req_type, fd, cs->buffer, size, cs->cur_offset);
+	sqe->user_data = type;
+
+	ret = bpf_io_uring_submit_sqes(ring, 1);
+	if (ret != 1) {
+		cs->res = ret;
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
+	struct cp_state *cs;
+	void *rings;
+	int ret;
+
+	sqes = (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
+				ri.sq_entries * sizeof(struct io_uring_sqe));
+	rings = (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
+				ri.cqes_offset + ri.cq_entries * sizeof(struct io_uring_cqe));
+	cs = (void *)bpf_io_uring_get_region(ring, IOU_REGION_MEM, sizeof(*cs));
+	if (!rings || !sqes || !cs)
+		return IOU_LOOP_STOP;
+	cq_hdr = rings + ri.cq_hdr_offset;
+	cqes = rings + ri.cqes_offset;
+
+	if (!cs->nr_infligt) {
+		cs->nr_infligt++;
+		ret = issue_next_req(ring, sqes, cs, REQ_TOKEN_READ,
+				     cs->buffer_size);
+		if (ret)
+			return IOU_LOOP_STOP;
+	}
+
+	if (cq_hdr->tail != cq_hdr->head) {
+		struct io_uring_cqe *cqe;
+
+		if (cq_hdr->tail - cq_hdr->head != 1) {
+			cs->res = -ERANGE;
+			return IOU_LOOP_STOP;
+		}
+
+		cqe = &cqes[cq_hdr->head & (ri.cq_entries - 1)];
+		if (cqe->res < 0) {
+			cs->res = cqe->res;
+			return IOU_LOOP_STOP;
+		}
+
+		switch (cqe->user_data) {
+		case REQ_TOKEN_READ:
+			if (cqe->res == 0) {
+				cs->res = 0;
+				return IOU_LOOP_STOP;
+			}
+			ret = issue_next_req(ring, sqes, cs, REQ_TOKEN_WRITE,
+					     cqe->res);
+			if (ret)
+				return IOU_LOOP_STOP;
+			break;
+		case REQ_TOKEN_WRITE:
+			cs->cur_offset += cqe->res;
+			ret = issue_next_req(ring, sqes, cs, REQ_TOKEN_READ,
+					     cs->buffer_size);
+			if (ret)
+				return IOU_LOOP_STOP;
+			break;
+		default:
+			bpf_printk("invalid token\n");
+			cs->res = -EINVAL;
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
diff --git a/tools/testing/selftests/io_uring/cp.c b/tools/testing/selftests/io_uring/cp.c
new file mode 100644
index 000000000000..333b3f2a370d
--- /dev/null
+++ b/tools/testing/selftests/io_uring/cp.c
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "common-defs.h"
+#include "helpers.h"
+#include "cp.bpf.skel.h"
+
+static struct cp *skel;
+static struct bpf_link *cp_link;
+
+static char *in_fname;
+static char *out_fname;
+
+struct ring_ctx {
+	struct io_uring ring;
+	struct ring_info ri;
+
+	void *region;
+	size_t region_size;
+};
+
+static void setup_bpf_prog(struct ring_ctx *ctx)
+{
+	int ret;
+
+	skel = cp__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.cp_ops->ring_fd = ctx->ring.ring_fd;
+	skel->rodata->ri = ctx->ri;
+
+	ret = cp__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	cp_link = bpf_map__attach_struct_ops(skel->maps.cp_ops);
+	if (!cp_link) {
+		fprintf(stderr, "failed to attach ops\n");
+		exit(1);
+	}
+}
+
+static void do_cp(struct ring_ctx *ctx)
+{
+	size_t page_size = sysconf(_SC_PAGE_SIZE);
+	struct cp_state *cs = ctx->region;
+	unsigned input_fd, output_fd;
+	size_t buffer_size = 4096;
+	size_t file_size;
+	struct stat st;
+	void *buffer;
+	int ret;
+
+	input_fd = open(in_fname, O_RDONLY | O_DIRECT);
+	output_fd = open(out_fname, O_WRONLY | O_DIRECT | O_CREAT, 0644);
+	if (input_fd < 0 || output_fd < 0) {
+		fprintf(stderr, "can't open files");
+		exit(1);
+	}
+	if (fstat(input_fd, &st) == -1) {
+		fprintf(stderr, "stat failed\n");
+		exit(1);
+	}
+	file_size = st.st_size;
+
+	if (ftruncate(output_fd, file_size) == -1) {
+		fprintf(stderr, "ftruncate failed\n");
+		exit(1);
+	}
+
+	buffer = aligned_alloc(page_size, buffer_size);
+	if (!buffer) {
+		fprintf(stderr, "can't allocate buffer\n");
+		exit(1);
+	}
+
+	cs->input_fd = input_fd;
+	cs->output_fd = output_fd;
+	cs->buffer = buffer;
+	cs->buffer_size = buffer_size;
+	cs->res = -EBUSY;
+
+	ret = ring_ctx_run(ctx);
+	if (ret) {
+		fprintf(stderr, "run failed %i\n", ret);
+		exit(1);
+	}
+
+	if (cs->res)
+		fprintf(stderr, "run failed: %i\n", cs->res);
+
+	free(buffer);
+	close(input_fd);
+	close(output_fd);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ring_ctx ctx;
+
+	if (argc != 3)
+		return 0;
+
+	in_fname = argv[1];
+	out_fname = argv[2];
+
+	ring_ctx_create(&ctx, sizeof(struct nops_state));
+	setup_bpf_prog(&ctx);
+
+	do_cp(&ctx);
+
+	bpf_link__destroy(cp_link);
+	cp__destroy(skel);
+	ring_ctx_destroy(&ctx);
+	return 0;
+}
-- 
2.52.0


