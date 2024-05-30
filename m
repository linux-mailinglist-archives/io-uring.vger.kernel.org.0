Return-Path: <io-uring+bounces-1994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01678D44A9
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 07:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56AB3B22C31
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 05:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AA2143724;
	Thu, 30 May 2024 05:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X+FhBpzb"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3832BD0F
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 05:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717045456; cv=none; b=mMHS1WSv4chXaPTEIjftrExVEJuhYSxGhjuoxqkVih1Kcxd78NNGPefQwl24Z1B7MySJfIEF/eUIWvAHf36UDc7aoDYzfZxpePhyFaczlTxvpXQZBCEtGvpMTxAZ3A7VNjjQl9gOIN0oXKq5wmGzPvtIVyI7yWR9vchaZ2YRtBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717045456; c=relaxed/simple;
	bh=XWp9mncpNxiZR+LoPDk8oND+FKwYorYq4u9OwJCDo1U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=ILoOqDO8w05CW3M98V21mRgxVMZuP4OiypF3LSI4k7ElaWfoWBa/hbxpwzg1Mfx0TPIQ/VLl19JXUQ1/B+oErGBt26HCwi7SHu1+RbRE1iUxw8q32YQd+oHWIFk6xVIMPr7yMMPBWb988wPWVszcLlIFCmD3a0oA0fL4wkh7ApU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=X+FhBpzb; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240530050410epoutp02d8d16ed08adfff5ea6d5433a24fe4837~UK71YtRR-1361613616epoutp02w
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 05:04:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240530050410epoutp02d8d16ed08adfff5ea6d5433a24fe4837~UK71YtRR-1361613616epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717045450;
	bh=0kSufolA/3kcncLpDKaDGkZktYsGHnO4fhJtR/IyGdM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=X+FhBpzbBLP5y/YpBKlhVxcjbUVS+ahIcvsh9Etv6rJF0b+CVfTZFXPvfaldoBd7b
	 1U2M6oljsPL7psFUJfanBZqrWyG/cLgi4zPdi7yMw1d/ayHC0Uy9MJ7ZQX7pWe6sLM
	 RO/kjC9WMdiFwvCplxJPyHKZkutW5Etbrp1aDTCw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240530050409epcas5p2a917d0013a0916f5f4d65d2400a790bd~UK71Bmsom0609006090epcas5p21;
	Thu, 30 May 2024 05:04:09 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VqZ0l3r1zz4x9Py; Thu, 30 May
	2024 05:04:07 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	35.8B.08853.7C808566; Thu, 30 May 2024 14:04:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240530031555epcas5p352110986064e3d9bcd31683fe59188ee~UJdUjgdLL2057520575epcas5p3m;
	Thu, 30 May 2024 03:15:55 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240530031555epsmtrp2f403b1b531972fe2eb54cd483070040b~UJdUhW6sj2006620066epsmtrp2Y;
	Thu, 30 May 2024 03:15:55 +0000 (GMT)
X-AuditID: b6c32a44-d67ff70000002295-b0-665808c72783
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.42.07412.B6FE7566; Thu, 30 May 2024 12:15:55 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240530031553epsmtip242127587d6a895e9d0b101f5818b446d~UJdTWfD9V0129801298epsmtip2f;
	Thu, 30 May 2024 03:15:53 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	gost.dev@samsung.com, Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH liburing v2] test: add test cases for hugepage registered
 buffers
Date: Thu, 30 May 2024 11:15:48 +0800
Message-Id: <20240530031548.1401768-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmhu5xjog0gwsrxC2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7Iw3p+6wF7wOq7h5ZR9bA+Nvly5GTg4JAROJ669uMncxcnEICexm
	lLg8s50NwvnEKHHu+UlGCOcbo8T72eeZYFrm959ggUjsZZS4enwRVP8vRomLTxaxglSxCehI
	/F7xiwXEFhEQltjf0QrWwSxwiVHi/5O1bCAJYYFgiVVda4EaODhYBFQlOh5wgJi8AnYSK1q1
	IJbJS+w/eJYZxOYVEJQ4OfMJ2EhmoHjz1tlgeyUE7rFLbL1yih2iwUVi0qEeKFtY4tXxLVC2
	lMTnd3vZQOZLCBRLLFsnB9HbAvTZuzmMEDXWEv+u7GEBqWEW0JRYv0sfIiwrMfXUOiaIvXwS
	vb+fQAOCV2LHPBhbVeLCwW1Qq6Ql1k7Yygxhe0is69kKNl5IIFbi/MO9bBMY5WcheWcWkndm
	IWxewMi8ilEytaA4Nz012bTAMC+1HB6xyfm5mxjBSVPLZQfjjfn/9A4xMnEwHmKU4GBWEuE9
	Myk0TYg3JbGyKrUoP76oNCe1+BCjKTCEJzJLiSbnA9N2Xkm8oYmlgYmZmZmJpbGZoZI47+vW
	uSlCAumJJanZqakFqUUwfUwcnFINTK3+dydJX3OtL66RyvvwL/74FhNdReGK5646UzqSbibn
	Zc4u21IiIWtsyfnA9UjCz+8afz1at749IGawPXetnti9UOnjTP3vjzx3O1y7h/X0x1md+jFG
	rAmCGfPU3ywJrTFzOPL4rNTO5uV81+2dYhXTRLR+88o0CB49y8Y3pdb5+LTJVxw2rrMoPOk+
	P7Io5bSwyK71RfncEUnmhik1xlcTlK7IvD4Y4slccX9n8NnaDUmX97jGtjJ/rqqVUd8t+7Nh
	FWvYjqalajd/L6v0DIy1mPlxiVSh/rs931tT1zX7MX02kqq9HMA/iUs8hW8tQ0L9H3ODmJyN
	99K15r0/HfqkecqnrSxzn0y5tNFEiaU4I9FQi7moOBEAQIHiXiMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSvG72+/A0g8M32SyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxptTd9gLXodV3Lyyj62B8bdLFyMnh4SA
	icT8/hMsXYxcHEICuxklFrU9ZYRISEt0HGplh7CFJVb+e84OUfSDUeLX9OmsIAk2AR2J3yt+
	sYDYIkBF+ztawSYxC9xhlLh7/j1Yt7BAoMSyVWeZuxg5OFgEVCU6HnCAmLwCdhIrWrUg5stL
	7D8IUsEJFBaUODnzCdhIZqB489bZzBMY+WYhSc1CklrAyLSKUTK1oDg3PTfZsMAwL7Vcrzgx
	t7g0L10vOT93EyM4fLU0djDem/9P7xAjEwfjIUYJDmYlEd4zk0LThHhTEiurUovy44tKc1KL
	DzFKc7AoifMazpidIiSQnliSmp2aWpBaBJNl4uCUamAK3vdxEueS3a8E3U7fVXx5RX53YTIX
	n3KlAMPCJv/5y076W720OsRS2tl0/VaAHEetJks5D89D6YUv3l+bv25n1btml5VCb/+o/O3/
	/Sc2S/JGuNbtZwFnetTvmzlXNkaWHjgYFSUca1kyK/yOcdsp969C1207uDlm+ETMO6Jn+f1S
	42Q/3oXqKyqSVextPbzt34UqHH5mrb7D8GbbBGG74we6ynmW1nV+3qzQk3/wxa3gWGOt72rn
	64sXei5kMzpgGXB34QKOFj+BaP1io23ipjYznkVMKZ2nGLBGTavQ4NL/Mk6dCOvHgrsf+lTp
	6vKJ1/9dfaXw+imVFrnkF0ZP2Ty81PyX+6+9q7rEQ4mlOCPRUIu5qDgRAOY4KynOAgAA
X-CMS-MailID: 20240530031555epcas5p352110986064e3d9bcd31683fe59188ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240530031555epcas5p352110986064e3d9bcd31683fe59188ee
References: <CGME20240530031555epcas5p352110986064e3d9bcd31683fe59188ee@epcas5p3.samsung.com>

Add a test file for hugepage registered buffers, to make sure the
fixed buffer coalescing feature works safe and soundly.

Testcases include read/write with single/multiple/unaligned/non-2MB
hugepage fixed buffers, and also a should-not coalesce case where
buffer is a mixture of different size'd pages.

-----
Changes since v1:
1. Added unaligned/non-2MB hugepage/page mixture testcases.
2. Rearranged the code.

v1: https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 test/Makefile         |   1 +
 test/fixed-hugepage.c | 391 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 392 insertions(+)
 create mode 100644 test/fixed-hugepage.c

diff --git a/test/Makefile b/test/Makefile
index 94bdc25..364514d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -88,6 +88,7 @@ test_srcs := \
 	file-update.c \
 	file-verify.c \
 	fixed-buf-iter.c \
+	fixed-hugepage.c \
 	fixed-link.c \
 	fixed-reuse.c \
 	fpos.c \
diff --git a/test/fixed-hugepage.c b/test/fixed-hugepage.c
new file mode 100644
index 0000000..a5a0947
--- /dev/null
+++ b/test/fixed-hugepage.c
@@ -0,0 +1,391 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test fixed buffers consisting of hugepages.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
+#include <sys/shm.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+/*
+ * Before testing
+ * echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
+ * echo always > /sys/kernel/mm/transparent_hugepage/hugepages-16kB/enabled
+ *
+ * Not 100% guaranteed to get THP-backed memory, but in general it does.
+ */
+#define MTHP_16KB	(16UL * 1024)
+#define HUGEPAGE_SIZE	(2UL * 1024 * 1024)
+#define NR_BUFS		1
+#define IN_FD		"/dev/urandom"
+#define OUT_FD		"/dev/zero"
+
+static int open_files(int *fd_in, int *fd_out)
+{
+	*fd_in = open(IN_FD, O_RDONLY, 0644);
+	if (*fd_in < 0) {
+		perror("open in");
+		return -1;
+	}
+
+	*fd_out = open(OUT_FD, O_RDWR, 0644);
+	if (*fd_out < 0) {
+		perror("open out");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void unmap(struct iovec *iov, int nr_bufs, size_t offset)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++)
+		munmap(iov[i].iov_base - offset, iov[i].iov_len + offset);
+
+	return;
+}
+
+static int mmap_hugebufs(struct iovec *iov, int nr_bufs, size_t buf_size, size_t offset)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++) {
+		void *base = NULL;
+
+		base = mmap(NULL, buf_size, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+		if (!base || base == MAP_FAILED) {
+			fprintf(stderr, "Error in mmapping the %dth buffer: %s\n", i, strerror(errno));
+			unmap(iov, i, offset);
+			return -1;
+		}
+
+		memset(base, 0, buf_size);
+		iov[i].iov_base = base + offset;
+		iov[i].iov_len = buf_size - offset;
+	}
+
+	return 0;
+}
+
+/* map a hugepage and smaller page to a contiguous memory */
+static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
+{
+	int i;
+	void *small_base = NULL, *huge_base = NULL, *start = NULL;
+	size_t small_size = buf_size - HUGEPAGE_SIZE;
+	size_t seg_size = ((buf_size / HUGEPAGE_SIZE) + 1) * HUGEPAGE_SIZE;
+
+	start = mmap(NULL, seg_size * nr_bufs, PROT_NONE, 
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (start == MAP_FAILED) {
+		fprintf(stderr, "preserve contiguous memory for page mixture failed.\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		huge_base = mmap(start, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED, -1, 0);
+		if (huge_base == MAP_FAILED) {
+			fprintf(stderr, "Error in mapping the %dth huge page in mixture: %s\n", i, strerror(errno));
+			unmap(iov, nr_bufs, 0);
+			return -1;
+		}
+
+		small_base = mmap(start + HUGEPAGE_SIZE, small_size, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+		if (small_base == MAP_FAILED) {
+			fprintf(stderr, "Error in mapping the %dth small page in mixture: %s\n", i, strerror(errno));
+			unmap(iov, nr_bufs, 0);
+			return -1;
+		}
+
+		memset(huge_base, 0, buf_size);
+		iov[i].iov_base = huge_base;
+		iov[i].iov_len = buf_size;
+		start += seg_size;
+	}
+
+	return 0;
+}
+
+static void free_bufs(struct iovec *iov, int nr_bufs, size_t offset)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++)
+		free(iov[i].iov_base - offset);
+
+	return;
+}
+
+static int get_mthp_bufs(struct iovec *iov, int nr_bufs, size_t buf_size,
+		size_t alignment, size_t offset)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++) {
+		void *base = NULL;
+
+		if (posix_memalign(&base, alignment, buf_size)) {
+			fprintf(stderr, "Failed to allocate the %dth MTHP_16KB buf\n", i);
+			free_bufs(iov, i, offset);
+			return -1;
+		}
+
+		memset(base, 0, buf_size);
+		iov[i].iov_base = base + offset;
+		iov[i].iov_len = buf_size - offset;
+	}
+
+	return 0;
+}
+
+static int do_read(struct io_uring *ring, int fd, struct iovec *iov, int nr_bufs)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int i, ret;
+
+	for (i = 0; i < nr_bufs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "Could not get SQE.\n");
+			return -1;
+		}
+
+		io_uring_prep_read_fixed(sqe, fd, iov[i].iov_base, iov[i].iov_len, 0, i);
+		io_uring_submit(ring);
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "Error waiting for completion: %s\n", strerror(-ret));
+			return -1;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "Error in async read operation: %s\n", strerror(-cqe->res));
+			return -1;
+		}
+		if (cqe->res != iov[i].iov_len) {
+			fprintf(stderr, "cqe res: %d, expected: %lu\n", cqe->res, iov[i].iov_len);
+			return -1;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int do_write(struct io_uring *ring, int fd, struct iovec *iov, int nr_bufs)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int i, ret;
+
+	for (i = 0; i < nr_bufs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "Could not get SQE.\n");
+			return -1;
+		}
+
+		io_uring_prep_write_fixed(sqe, fd, iov[i].iov_base, iov[i].iov_len, 0, i);
+		io_uring_submit(ring);
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "Error waiting for completion: %s\n", strerror(-ret));
+			return -1;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "Error in async write operation: %s\n", strerror(-cqe->res));
+			return -1;
+		}
+		if (cqe->res != iov[i].iov_len) {
+			fprintf(stderr, "cqe res: %d, expected: %lu\n", cqe->res, iov[i].iov_len);
+			return -1;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int register_submit(struct io_uring *ring, struct iovec *iov,
+						int nr_bufs, int fd_in, int fd_out)
+{
+	int ret;
+
+	ret = io_uring_register_buffers(ring, iov, nr_bufs);
+	if (ret) {
+		fprintf(stderr, "Error registering buffers: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	ret = do_read(ring, fd_in, iov, nr_bufs);
+	if (ret) {
+		fprintf(stderr, "Read test failed\n");
+		return ret;
+	}
+
+	ret = do_write(ring, fd_out, iov, nr_bufs);
+	if (ret) {
+		fprintf(stderr, "Write test failed\n");
+		return ret;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "Error unregistering buffers for one hugepage test: %s", strerror(-ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+static int test_one_hugepage(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = HUGEPAGE_SIZE;
+	int ret;
+
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, 0)) {
+		fprintf(stderr, "Skipping one hugepage test.\n");
+		return 0;
+	}
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret;
+}
+
+static int test_multi_hugepages(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = 4 * HUGEPAGE_SIZE;
+	int ret;
+
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, 0)) {
+		fprintf(stderr, "Skipping multi hugepages test.\n");
+		return 0;
+	}
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret;
+}
+
+static int test_unaligned_hugepage(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = 3 * HUGEPAGE_SIZE;
+	size_t offset = 0x1234;
+	int ret;
+
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, offset)) {
+		fprintf(stderr, "Skipping unaligned page test.\n");
+		return 0;
+	}
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, offset);
+	return ret;
+}
+
+static int test_multi_unaligned_mthps(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	int ret;
+	size_t buf_size = 3 * MTHP_16KB;
+	size_t offset = 0x1234;
+
+	if (get_mthp_bufs(iov, NR_BUFS, buf_size, MTHP_16KB, offset)) {
+		fprintf(stderr, "Skipping multi-szied transparent hugepages test.\n");
+		return 0;
+	}
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	free_bufs(iov, NR_BUFS, offset);
+	return ret;
+}
+
+/* Should not coalesce */
+static int test_page_mixture(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = HUGEPAGE_SIZE + MTHP_16KB;
+	int ret;
+
+	if (mmap_mixture(iov, NR_BUFS, buf_size)) {
+		fprintf(stderr, "Skipping page mixture test.\n");
+		return 0;
+	}
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret, fd_in, fd_out;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	if (open_files(&fd_in, &fd_out))
+		return T_EXIT_FAIL;
+
+	ret = t_create_ring(8, &ring, 0);
+	if (ret == T_SETUP_SKIP)
+		return T_EXIT_SKIP;
+	else if (ret < 0)
+		return T_EXIT_FAIL;
+
+	ret = test_one_hugepage(&ring, fd_in, fd_out);
+	if (ret) {
+		fprintf(stderr, "Test one hugepage failed");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_multi_hugepages(&ring, fd_in, fd_out);
+	if (ret) {
+		fprintf(stderr, "Test multi hugepages failed");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_unaligned_hugepage(&ring, fd_in, fd_out);
+	if (ret) {
+		fprintf(stderr, "Test unaligned huge page failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_multi_unaligned_mthps(&ring, fd_in, fd_out);
+	if (ret) {
+		fprintf(stderr, "Test multi unaligned MTHP_16KB huge pages failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_page_mixture(&ring, fd_in, fd_out);
+	if (ret) {
+		fprintf(stderr, "Test page mixture failed");
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.34.1


