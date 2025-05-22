Return-Path: <io-uring+bounces-8071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7C1AC0AEA
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 13:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660304E12FA
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 11:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9F928982B;
	Thu, 22 May 2025 11:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hsOXIyaD"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C041EE00C
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747915013; cv=none; b=C5zuQOJBn8tF5FdboSV0TMZpEI0GU46DVJrFrcY8C1MwufzL2syC2Ev5vT9EO1S/Ps60Hex9UiK194JoL2JBRzOaU6wym570Hrgr/l6kL53LlLkxYhV3FBbbiuJTbBqtAVrn7HinrIr6ZEWC+lOAmMzfh6Kd26qHvWLQ9T3qF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747915013; c=relaxed/simple;
	bh=SpenVr3w1qaH98/caqbxsnhjqpXBI+j5b5fXQ50oaXc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=W3e+lMNpvtAQhdCYwFFIDXRlRMx7QIn6Eqya9zSeyOW3ryOL0HxWbLCb8RxGeDqMRZfrWOJVdd3miP5wYZWp0LQS5UFUbTt1FFnq27HM8B5m86hI8/fscT69sTtNEUXyGWnMLRbesX6/sNO7OmfmqCwaUCguAKh0Mzp0mSG62Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hsOXIyaD; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250522115642epoutp04ef18ae2407275d07295dbfab8fc12fed~B128ZrCbg2978229782epoutp04Q
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 11:56:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250522115642epoutp04ef18ae2407275d07295dbfab8fc12fed~B128ZrCbg2978229782epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747915002;
	bh=2qDM2iSRPAfeA6VJl7YO03JNFrjloGgZCpt2Fe3bmB0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=hsOXIyaD675mKC3YeLt6Mj4VnQQnnxj8YSVEoSK9rOefUI7+bU7AmELI0pXDF516R
	 TWF+yFhDmsbAl3ZLOonrmkIbe7aKTrVHGGf8kdNpdivmjGZi0RIWaQSCxF8+VOvSND
	 iGmuR5sllJCMhShZlXgLV0a2BlursWIrynUXwMvc=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250522115642epcas5p4efae5aaaf34cd9485ac4ede683d48e9b~B128JAEpO0784607846epcas5p4I;
	Thu, 22 May 2025 11:56:42 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.181]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4b36G04l5bz6B9m4; Thu, 22 May
	2025 11:56:40 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250522114649epcas5p26e8ab0fef3ff0d39a64345c3d63f64a2~B1uTqwV1u0958909589epcas5p2U;
	Thu, 22 May 2025 11:46:49 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250522114649epsmtrp150dd8d86d2815a032b269fcdb8464e7b~B1uTqGFTl2485424854epsmtrp13;
	Thu, 22 May 2025 11:46:49 +0000 (GMT)
X-AuditID: b6c32a52-40bff70000004c16-0b-682f0ea8865b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.FE.19478.8AE0F286; Thu, 22 May 2025 20:46:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250522114648epsmtip132b66912ad7e12f6a71af492844ee32e~B1uStWX_52721427214epsmtip1Z;
	Thu, 22 May 2025 11:46:47 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, axboe@kernel.dk,
	asml.silence@gmail.com
Cc: joshi.k@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH liburing] test/io_uring_passthrough: enhance vectored I/O
 test coverage
Date: Thu, 22 May 2025 16:59:48 +0530
Message-Id: <20250522112948.2386-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsWy7bCSnO5KPv0Mgyc9jBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8az3HYnH0/1s2BzaPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBlHV59lLdijUrGqezZLA+MmmS5GTg4JAROJBW9+M3cxcnEICWxnlPgx8TYTREJC4tTL
	ZYwQtrDEyn/P2SGKPjJKbOqbClbEJqAuceR5K1iRiECSxL8Ny1i7GDk4mAVsJC5cjgYxhQXC
	Jc7c5gKpYBFQldi9ZC4riM0rYCHxvr+ZDWK8vMTMS9/ZIeKCEidnPmEBsZmB4s1bZzNPYOSb
	hSQ1C0lqASPTKkbR1ILi3PTc5AJDveLE3OLSvHS95PzcTYzgINQK2sG4bP1fvUOMTByMhxgl
	OJiVRHiPPtPLEOJNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCU
	amDqEfw24Wvcpt9XyvSNbVYIG/7ZJ50QxSATvftL2u4lPZ8e/eTI+7gr5ovRXXf7O9tucF4+
	3pJ+myFq9elqyd3Plv6J64zXenr83M6Lgmsebe9foX399v1/uyfPtPBS8ny+0e78mRv5h6Lq
	JZ4oft+m/nyPB9u+3AczfUxXPNS9/mv1vkadizcy5q6/dPDofe7Kvso3z97t9IxQWRF0zM4z
	3jJ0+utvkp1F1rJakhK6MRtLVnbtbg53sOW4raHwP/KQm6RZIfupaoH1nIffe4S1Jxk51l5L
	W7deaUO9eKOh2Z8u+4X6dZ69hxfcW7Dp9dm+ZCnJszILY7XSLAtXSW9MnOGWHS4z5aBWU2WH
	4h8nJZbijERDLeai4kQAwxjSXrECAAA=
X-CMS-MailID: 20250522114649epcas5p26e8ab0fef3ff0d39a64345c3d63f64a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250522114649epcas5p26e8ab0fef3ff0d39a64345c3d63f64a2
References: <CGME20250522114649epcas5p26e8ab0fef3ff0d39a64345c3d63f64a2@epcas5p2.samsung.com>

This patch improves the vectored io test coverage by ensuring that we
exercise all three kinds of iovec imports:
1. Single segment iovec
2. Multi segment iovec, below dynamic allocation threshold
3. Multi segment iovec, above dynamic allocation threshold

To support this we adjust the test logic to vary iovcnt appropriately
across submissions. For fixed vectored I/O support (case 2 and 3), we
register a single large buffer and slice it into vecs[]. This ensures
that all iovecs map to valid regions within the registered fixed buffer.
Additionally buffer allocation is adjusted accordingly, while
maintaining compatibility with existing non-vectored  tests.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 test/io_uring_passthrough.c | 40 +++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 74bbfe0..5efe2a0 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -13,12 +13,14 @@
 #include "../src/syscall.h"
 #include "nvme.h"
 
+#define min(a, b)	((a) < (b) ? (a) : (b))
+
 #define FILE_SIZE	(256 * 1024)
 #define BS		8192
 #define BUFFERS		(FILE_SIZE / BS)
 
 static void *meta_mem;
-static struct iovec *vecs;
+static struct iovec *vecs, *backing_vec;
 static int no_pt;
 static bool vec_fixed_supported = true;
 
@@ -75,7 +77,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 	struct nvme_uring_cmd *cmd;
 	int open_flags;
 	int do_fixed;
-	int i, ret, fd = -1, use_fd = -1;
+	int i, ret, fd = -1, use_fd = -1, submit_count = 0;
 	off_t offset;
 	__u64 slba;
 	__u32 nlb;
@@ -86,7 +88,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 		open_flags = O_WRONLY;
 
 	if (fixed) {
-		ret = t_register_buffers(ring, vecs, BUFFERS);
+		ret = t_register_buffers(ring, backing_vec, 1);
 		if (ret == T_SETUP_SKIP)
 			return 0;
 		if (ret != T_SETUP_OK) {
@@ -116,6 +118,9 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 
 	offset = 0;
 	for (i = 0; i < BUFFERS; i++) {
+		unsigned int iovcnt = 1;
+		size_t total_len;
+
 		sqe = io_uring_get_sqe(ring);
 		if (!sqe) {
 			fprintf(stderr, "sqe get failed\n");
@@ -129,7 +134,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 		if (fixed && (i & 1))
 			do_fixed = 0;
 		if (do_fixed)
-			sqe->buf_index = i;
+			sqe->buf_index = 0;
 		if (nonvec)
 			sqe->cmd_op = NVME_URING_CMD_IO;
 		else
@@ -147,8 +152,14 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 
 		cmd->opcode = read ? nvme_cmd_read : nvme_cmd_write;
 
+		if (!nonvec) {
+			iovcnt = (submit_count % 3 == 0) ? 1 : ((submit_count % 3 == 1) ? 3 : 9);
+			iovcnt = min(iovcnt, BUFFERS - i);
+		}
+		total_len = BS * iovcnt;
+
 		slba = offset >> lba_shift;
-		nlb = (BS >> lba_shift) - 1;
+		nlb = (total_len >> lba_shift) - 1;
 
 		/* cdw10 and cdw11 represent starting lba */
 		cmd->cdw10 = slba & 0xffffffff;
@@ -160,7 +171,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 			cmd->data_len = vecs[i].iov_len;
 		} else {
 			cmd->addr = (__u64)(uintptr_t)&vecs[i];
-			cmd->data_len = 1;
+			cmd->data_len = iovcnt;
 		}
 
 		if (meta_size) {
@@ -170,16 +181,19 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 		}
 		cmd->nsid = nsid;
 
-		offset += BS;
+		offset += total_len;
+		if (!nonvec)
+			i += iovcnt - 1;
+		submit_count++;
 	}
 
 	ret = io_uring_submit(ring);
-	if (ret != BUFFERS) {
+	if (ret != submit_count) {
 		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
 		goto err;
 	}
 
-	for (i = 0; i < BUFFERS; i++) {
+	for (i = 0; i < submit_count; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
 		if (ret) {
 			fprintf(stderr, "wait_cqe=%d\n", ret);
@@ -439,7 +453,13 @@ int main(int argc, char *argv[])
 	if (ret)
 		return T_EXIT_SKIP;
 
-	vecs = t_create_buffers(BUFFERS, BS);
+	vecs = t_malloc(BUFFERS * sizeof(struct iovec));
+	backing_vec = t_create_buffers(1, BUFFERS * BS);
+	/* Slice single large backing_vec into multiple smaller vecs */
+	for (int i = 0; i < BUFFERS; i++) {
+		vecs[i].iov_base = backing_vec[0].iov_base + i * BS;
+		vecs[i].iov_len = BS;
+	}
 	if (meta_size)
 		t_posix_memalign(&meta_mem, 0x1000,
 				 meta_size * BUFFERS * (BS >> lba_shift));
-- 
2.25.1


