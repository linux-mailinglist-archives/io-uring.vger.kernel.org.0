Return-Path: <io-uring+bounces-9732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0213AB53053
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2581E17D8A6
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D13331076D;
	Thu, 11 Sep 2025 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOkgE6do"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6121CC43
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589906; cv=none; b=LRFEa+E/c83GgiWGo4yiEAtI1WbnDUxCzDUX90ppuoscyA9NO+COclTuPchosYienAUEoET+KlEd/Wwz13/+rED5yyTlE/ZfgPXjoW3uFZ5la1i35NcGD3IZ786AksbG4YP+ISEZx5ra+2R8M6ReLyrbLZvLgdCdjthHqQJ1WN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589906; c=relaxed/simple;
	bh=zK9lSC5VK/DOQ+6iNIxOFi8R3cvLYg/qoKeU9gwZc44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG5NzrElEi/XW8vnUMbfG+ViIVP+MxqYkwAfeQ39tf9uwm3ne8brVLqDpsdJrwozd1KuG/y7hDLKm/8jmX2av4Cv9aKxZxsOuPnWfxegvT1tY9UkJtAMAyCQ7DJ78nx4bf0ker1M41FN8E1/PSJrXJlBvqhHLFrMB20rX57tcKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOkgE6do; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45deccb2c1eso4668365e9.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589902; x=1758194702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JL8memG4V+NhdCpiXtV68vqKqfW0z8k3ewZ+8g3Gxvo=;
        b=gOkgE6doprzCLjmsCBKO+Sx5ZxMx+vSA8BxzpADJuEzyRxBkNwhZz5XMITCTJqhi17
         u9gUiTJaWrz94n1lQ4H9cVHailbz59IOhy2ITWMQBgyJsMKecjgc/x6xiGb5Wg902J7H
         WKR5JrGwh3q5YwLPkBuOA8+GhC8pZ8M63eMJlXxDAcr0v787Zvjb2qicNXzUiXezYgHG
         Eez7ZH8OODGayjO/Wnmn+v/AFDLJO5m70edeJjmKGTSgjo8ynqqWT6ZmJU5MW4mfLh6N
         +FOng0FCzC+gx6Hspccf9WxwB40zQdi9vXPGLE1033AMY9t/vBntBF3AjazjXVSVrb7+
         1mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589902; x=1758194702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL8memG4V+NhdCpiXtV68vqKqfW0z8k3ewZ+8g3Gxvo=;
        b=KG7O+Koq5UvQpPC+bVDK4LxbtmfBWTOgdrIlbgy1FP/9ClD0UdyV/IBMzyoGmtUoAL
         +dEkAEY32t7k4fYokjXNGel8TnM72OqfccLu5fBKOhMN1AC8n3WjtXns1ZTdADZR69iY
         xEPgyFgiUlI37CDQsPWC7zbnR7BuKDL9gEHAtPVDEj9GhuZeLMb5DDfXkCArnbj57gzY
         mUQTG2zdiA3aVu16XeVvoJB4etrCCyUt0aOO+YAG5VM0DYzh+C7xKVC/VCCDu4LF1Xdo
         WdYsPwUSIVwiH3c8DsTGPEAe1BZuI3B+xtFv8w3tDzPy3hHJi8wIZkicKtxOiPtFDETX
         dlNg==
X-Gm-Message-State: AOJu0Yy4MmiB1INn3sIBtSsJl2m2BVynlug2kzLaKJaYJf4IjaxHMdmo
	V2nbYHPzYqEqk4TJF2x+VcNph7cxXgSBIOtzEvVuXvClOCTpts8Ax2SutWaY7A==
X-Gm-Gg: ASbGncs93d7KkcNbhvJr965CoUX2Cx1FN2OrDQ5ZuHbicoOT5ykvHpqanl9AmqJizMj
	LmcnVDj1Cg4tOl6GPNZ6YsYcUkTebUILMRN+5xYv1IlhPmWWyH7kwsq12ft0cH3d7oDRz8luyWr
	FF9BpgcAQsCfzZaXGBz9u6AgoYBcpqMC+rYrpL1WZENAPk4GxFaJF/IxLCP85AT2n5wY4Cl5j5X
	LrtwHhxE9LHeHT4n3/0GegWp0w2FbE1gUnkfrKZMtvjuqkZEdElKNStv7CubbZSwraWn0/wrOHh
	hNnva1UX1uqYWxRtz4bcgaUs3cyhGauiqRGSWXOKOwQn+T8RRdIDU0nGPlfzCE9dHyE9q51spgg
	vVvxLiQ==
X-Google-Smtp-Source: AGHT+IE+Ci68Yxi5Mety/HkkR67//iFCP45n4+OzBdgNWlZN3xUCNtXUiQPYYrB6E3G5adu0pbgcDA==
X-Received: by 2002:a5d:640a:0:b0:3e7:5edd:cdeb with SMTP id ffacd0b85a97d-3e75eddcfe4mr1734126f8f.35.1757589901924;
        Thu, 11 Sep 2025 04:25:01 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:00 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/6] tests: test the query interface
Date: Thu, 11 Sep 2025 12:26:26 +0100
Message-ID: <71ff0fec25ae279ba6bdc1ce81e3ad86995340f1.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the header / definitions and tests for the query interface.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h                |   1 +
 src/include/liburing/io_uring.h       |   3 +
 src/include/liburing/io_uring/query.h |  41 ++++
 test/Makefile                         |   1 +
 test/ring-query.c                     | 322 ++++++++++++++++++++++++++
 5 files changed, 368 insertions(+)
 create mode 100644 src/include/liburing/io_uring/query.h
 create mode 100644 test/ring-query.c

diff --git a/src/include/liburing.h b/src/include/liburing.h
index e3f394ea..46d3cccf 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -16,6 +16,7 @@
 #include <sys/wait.h>
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
+#include "liburing/io_uring/query.h"
 #include "liburing/io_uring_version.h"
 #include "liburing/barrier.h"
 
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 212b5874..55b69f9d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -641,6 +641,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_MEM_REGION		= 34,
 
+	/* query various aspects of io_uring, see linux/io_uring/query.h */
+	IORING_REGISTER_QUERY			= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/src/include/liburing/io_uring/query.h b/src/include/liburing/io_uring/query.h
new file mode 100644
index 00000000..5d754322
--- /dev/null
+++ b/src/include/liburing/io_uring/query.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring query interface.
+ */
+#ifndef LINUX_IO_URING_QUERY_H
+#define LINUX_IO_URING_QUERY_H
+
+#include <linux/types.h>
+
+struct io_uring_query_hdr {
+	__u64 next_entry;
+	__u64 query_data;
+	__u32 query_op;
+	__u32 size;
+	__s32 result;
+	__u32 __resv[3];
+};
+
+enum {
+	IO_URING_QUERY_OPCODES			= 0,
+
+	__IO_URING_QUERY_MAX,
+};
+
+/* Doesn't require a ring */
+struct io_uring_query_opcode {
+	/* The number of supported IORING_OP_* opcodes */
+	__u32	nr_request_opcodes;
+	/* The number of supported IORING_[UN]REGISTER_* opcodes */
+	__u32	nr_register_opcodes;
+	/* Bitmask of all supported IORING_FEAT_* flags */
+	__u64	feature_flags;
+	/* Bitmask of all supported IORING_SETUP_* flags */
+	__u64	ring_setup_flags;
+	/* Bitmask of all supported IORING_ENTER_** flags */
+	__u64	enter_flags;
+	/* Bitmask of all supported IOSQE_* flags */
+	__u64	sqe_flags;
+};
+
+#endif
diff --git a/test/Makefile b/test/Makefile
index edfc0df7..626ae674 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -255,6 +255,7 @@ test_srcs := \
 	zcrx.c \
 	vec-regbuf.c \
 	timestamp.c \
+	ring-query.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/ring-query.c b/test/ring-query.c
new file mode 100644
index 00000000..46080c77
--- /dev/null
+++ b/test/ring-query.c
@@ -0,0 +1,322 @@
+/* SPDX-License-Identifier: MIT */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+#include "test.h"
+#include "helpers.h"
+
+struct io_uring_query_opcode_short {
+	__u32	nr_request_opcodes;
+	__u32	nr_register_opcodes;
+};
+
+struct io_uring_query_opcode_large {
+	__u32	nr_request_opcodes;
+	__u32	nr_register_opcodes;
+	__u64	feature_flags;
+	__u64	ring_setup_flags;
+	__u64	enter_flags;
+	__u64	sqe_flags;
+	__u64	placeholder[8];
+};
+
+static struct io_uring_query_opcode sys_ops;
+
+static int io_uring_query(struct io_uring *ring, struct io_uring_query_hdr *arg)
+{
+	int fd = ring ? ring->ring_fd : -1;
+
+	return io_uring_register(fd, IORING_REGISTER_QUERY, arg, 0);
+}
+
+static int test_basic_query(void)
+{
+	struct io_uring_query_opcode op;
+	struct io_uring_query_hdr hdr = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op),
+		.size = sizeof(op),
+	};
+	int ret;
+
+	ret = io_uring_query(NULL, &hdr);
+	if (ret == -EINVAL)
+		return T_EXIT_SKIP;
+
+	if (ret != 0) {
+		fprintf(stderr, "query failed %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (hdr.size != sizeof(op)) {
+		fprintf(stderr, "unexpected size %i vs %i\n",
+				(int)hdr.size, (int)sizeof(op));
+		return T_EXIT_FAIL;
+	}
+
+	if (hdr.result) {
+		fprintf(stderr, "unexpected result %i\n", hdr.result);
+		return T_EXIT_FAIL;
+	}
+
+	if (op.nr_register_opcodes <= IORING_REGISTER_QUERY) {
+		fprintf(stderr, "too few opcodes (%i)\n", op.nr_register_opcodes);
+		return T_EXIT_FAIL;
+	}
+
+	memcpy(&sys_ops, &op, sizeof(sys_ops));
+	return T_EXIT_PASS;
+}
+
+static int test_invalid(void)
+{
+	int ret;
+	struct io_uring_query_opcode op;
+	struct io_uring_query_hdr invalid_hdr = {
+		.query_op = -1U,
+		.query_data = uring_ptr_to_u64(&op),
+		.size = sizeof(struct io_uring_query_opcode),
+	};
+	struct io_uring_query_hdr invalid_next_hdr = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op),
+		.size = sizeof(struct io_uring_query_opcode),
+		.next_entry = 0xdeadbeefUL,
+	};
+	struct io_uring_query_hdr invalid_data_hdr = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = 0xdeadbeefUL,
+		.size = sizeof(struct io_uring_query_opcode),
+	};
+
+	ret = io_uring_query(NULL, &invalid_hdr);
+	if (ret || invalid_hdr.result != -EOPNOTSUPP) {
+		fprintf(stderr, "failed invalid opcode %i (%i)\n",
+			ret, invalid_hdr.result);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_query(NULL, &invalid_next_hdr);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "invalid next %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_query(NULL, &invalid_data_hdr);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "invalid next %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_chain(void)
+{
+	int ret;
+	struct io_uring_query_opcode op1, op2, op3;
+	struct io_uring_query_hdr hdr3 = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op3),
+		.size = sizeof(struct io_uring_query_opcode),
+	};
+	struct io_uring_query_hdr hdr2 = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op2),
+		.size = sizeof(struct io_uring_query_opcode),
+		.next_entry = uring_ptr_to_u64(&hdr3),
+	};
+	struct io_uring_query_hdr hdr1 = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op1),
+		.size = sizeof(struct io_uring_query_opcode),
+		.next_entry = uring_ptr_to_u64(&hdr2),
+	};
+
+	ret = io_uring_query(NULL, &hdr1);
+	if (ret) {
+		fprintf(stderr, "chain failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (hdr1.result || hdr2.result || hdr3.result) {
+		fprintf(stderr, "chain invalid result entries %i %i %i\n",
+			hdr1.result, hdr2.result, hdr3.result);
+		return T_EXIT_FAIL;
+	}
+
+	if (op1.nr_register_opcodes != sys_ops.nr_register_opcodes ||
+	    op2.nr_register_opcodes != sys_ops.nr_register_opcodes ||
+	    op3.nr_register_opcodes != sys_ops.nr_register_opcodes) {
+		fprintf(stderr, "chain invalid register opcodes\n");
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_chain_loop(void)
+{
+	int ret;
+	struct io_uring_query_opcode op1, op2;
+	struct io_uring_query_hdr hdr2 = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op2),
+		.size = sizeof(struct io_uring_query_opcode),
+	};
+	struct io_uring_query_hdr hdr1 = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op1),
+		.size = sizeof(struct io_uring_query_opcode),
+	};
+	struct io_uring_query_hdr hdr_self_circular = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op1),
+		.size = sizeof(struct io_uring_query_opcode),
+		.next_entry = uring_ptr_to_u64(&hdr_self_circular),
+	};
+
+	hdr1.next_entry = uring_ptr_to_u64(&hdr2);
+	hdr2.next_entry = uring_ptr_to_u64(&hdr1);
+	ret = io_uring_query(NULL, &hdr1);
+	if (!ret) {
+		fprintf(stderr, "chain loop failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_query(NULL, &hdr_self_circular);
+	if (!ret) {
+		fprintf(stderr, "chain loop failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_compatibile_shorter(void)
+{
+	int ret;
+	struct io_uring_query_opcode_short op;
+	struct io_uring_query_hdr hdr = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op),
+		.size = sizeof(op),
+	};
+
+	ret = io_uring_query(NULL, &hdr);
+	if (ret || hdr.result) {
+		fprintf(stderr, "failed invalid short result %i (%i)\n",
+			ret, hdr.result);
+		return T_EXIT_FAIL;
+	}
+
+	if (hdr.size != sizeof(struct io_uring_query_opcode_short)) {
+		fprintf(stderr, "unexpected short query size %i %i\n",
+			(int)hdr.size,
+			(int)sizeof(struct io_uring_query_opcode_short));
+		return T_EXIT_FAIL;
+	}
+
+	if (sys_ops.nr_register_opcodes != op.nr_register_opcodes ||
+	    sys_ops.nr_request_opcodes != op.nr_request_opcodes) {
+		fprintf(stderr, "invalid short data\n");
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_compatibile_larger(void)
+{
+	int ret;
+	struct io_uring_query_opcode_large op;
+	struct io_uring_query_hdr hdr = {
+		.query_op = IO_URING_QUERY_OPCODES,
+		.query_data = uring_ptr_to_u64(&op),
+		.size = sizeof(op),
+	};
+
+	ret = io_uring_query(NULL, &hdr);
+	if (ret || hdr.result) {
+		fprintf(stderr, "failed invalid large result %i (%i)\n",
+			ret, hdr.result);
+		return T_EXIT_FAIL;
+	}
+
+	if (hdr.size < sizeof(struct io_uring_query_opcode)) {
+		fprintf(stderr, "unexpected large query size %i %i\n",
+			(int)hdr.size,
+			(int)sizeof(struct io_uring_query_opcode));
+		return T_EXIT_FAIL;
+	}
+
+	if (sys_ops.nr_register_opcodes != op.nr_register_opcodes ||
+	    sys_ops.nr_request_opcodes != op.nr_request_opcodes ||
+	    sys_ops.ring_setup_flags != op.ring_setup_flags ||
+	    sys_ops.feature_flags != op.feature_flags) {
+		fprintf(stderr, "invalid large data\n");
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = test_basic_query();
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_SKIP)
+			fprintf(stderr, "ring query not supported, skip\n");
+		else
+			fprintf(stderr, "test_basic_query failed\n");
+
+		return T_EXIT_SKIP;
+	}
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "init failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_invalid();
+	if (ret)
+		return T_EXIT_FAIL;
+
+	ret = test_chain();
+	if (ret) {
+		fprintf(stderr, "test_chain failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_chain_loop();
+	if (ret) {
+		fprintf(stderr, "test_chain_loop failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_compatibile_shorter();
+	if (ret) {
+		fprintf(stderr, "test_compatibile_shorter failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_compatibile_larger();
+	if (ret) {
+		fprintf(stderr, "test_compatibile_larger failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	return 0;
+}
-- 
2.49.0


