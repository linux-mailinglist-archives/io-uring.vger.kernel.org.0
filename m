Return-Path: <io-uring+bounces-2031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3460E8D59E2
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 07:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B35E1C21776
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 05:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4DE208B0;
	Fri, 31 May 2024 05:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZwiSC9xF"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929F380
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 05:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133718; cv=none; b=Qa1AMEx1DHCn0nS1y20ootSlubR/csY9rK37jm0JBTXmGQUJVAw/KIXqJGLP5BQZvkLlTpnosgE02AMt8ZxDSrdMQ3NKyuPPbySgHkc6pap53GozNjezYUw7pGxvakjzWrScs0tPCv0EkbngSmMMli3SIuOBsR9xqo689G+MVyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133718; c=relaxed/simple;
	bh=CzeH/4DiqPAnDb2cgWzwTFATkvWrN8d1fE18u9RXV08=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=anTtzsZK/Hj2BehGgVaOviEqokq3eqoDfgumDt9C260GLfhQsWn91J4ERA64bUqPS1MuAVdMT61I6NaUIbb1tti//sCPWA2agBKG759v0Ky3NJn3sTqhUVGHtvXvLmwcLS2p9UQe+GKjv31qjs5s/UV4fXPTl/ARYpmU2CC74VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZwiSC9xF; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531053504epoutp03bc4edcc0b45782d14ee0556ff6cab02d~UfAG5ie8t0733707337epoutp03H
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 05:35:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531053504epoutp03bc4edcc0b45782d14ee0556ff6cab02d~UfAG5ie8t0733707337epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717133704;
	bh=q4+EAQh1pltkQEMof7XH8V7zKS43/4lyaptNkZDS5D0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ZwiSC9xFOMZ+GRG9ypEy4Fbn6m7VIIw5Wu/OhwkYRIxh0xsGT8GQj1StgDshsKszc
	 5JzuUdMmUUBufsnfdrQAnEKphXaJPNLNCq7YCUh27x0nM3DMZFMyHTDyLXWHCEJGX6
	 GsWyJ/aFYGpyPS0qpSxmVdbsEbTBYjadR6EN1BYw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240531053504epcas5p208c2c48b3b8c5e42dc5a174c449c92cf~UfAGfSlbC2622726227epcas5p2f;
	Fri, 31 May 2024 05:35:04 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VrBdy51mLz4x9Q8; Fri, 31 May
	2024 05:35:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.7B.19174.68169566; Fri, 31 May 2024 14:35:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288~UezZTDp7k1610716107epcas5p3Y;
	Fri, 31 May 2024 05:20:31 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531052031epsmtrp15d1280fc45c1546e52d09aeb6074dbfa~UezZRR5Pa0157601576epsmtrp1S;
	Fri, 31 May 2024 05:20:31 +0000 (GMT)
X-AuditID: b6c32a50-b33ff70000004ae6-79-665961864686
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.B8.07412.E1E59566; Fri, 31 May 2024 14:20:30 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531052029epsmtip118b9acd9f04677a9d632a7884b269028~UezYBgSs40358303583epsmtip1C;
	Fri, 31 May 2024 05:20:29 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	gost.dev@samsung.com, Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH liburing v3] test: add test cases for hugepage registered
 buffers
Date: Fri, 31 May 2024 13:20:23 +0800
Message-Id: <20240531052023.1446914-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpm5bYmSawYWdChZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdkbzs3/sBVOiKxacamVsYDzr0cXIySEhYCLx4/Juxi5GLg4hgT2M
	EqfaDzFDOJ8YJZYf+M8C4XxjlJh95h87TMvkNa9ZIRJ7GSXOXtzABuH8YpSYeHMCE0gVm4CO
	xO8Vv1hAbBEBYYn9Ha1go5gFLjFK/H+ylg0kISwQLPFg6kKwBhYBVYmmo4fBGngF7CSOzTzI
	CLFOXmL/wbPMEHFBiZMzn4DVMAPFm7fOBjtWQuARu8SH2/uZIRpcJB5134FqFpZ4dXwL1N1S
	Ei/724BsDiC7WGLZOjmI3hZGiffv5kDVW0v8u7KHBaSGWUBTYv0ufYiwrMTUU+uYIPbySfT+
	fsIEEeeV2DEPxlaVuHBwG9QqaYm1E7ZCneMhcXfZJ1YQW0ggVuLKoxamCYzys5C8MwvJO7MQ
	Ni9gZF7FKJVaUJybnppsWmCom5daDo/b5PzcTYzg1KkVsINx9Ya/eocYmTgYDzFKcDArifD+
	So9IE+JNSaysSi3Kjy8qzUktPsRoCgzkicxSosn5wOSdVxJvaGJpYGJmZmZiaWxmqCTO+7p1
	boqQQHpiSWp2ampBahFMHxMHp1QD07RHzFY2qtYdXEq/mDKX/oqbkmWddn/vyffPdn4/f8/S
	zM+tX/jTGt/ZmoGyQr0zHz6LlH9jpH33mgdLafe2h+yO1v57Ft5Vjj3LfMGtZcKU1FfG/Eba
	B2+117qY/N3RJtIQYHmcg6n1ZUTd7rZ/heHpbe2chyblRhttz29dyHI54Lh334znSzfu4N/V
	JXYkU+5E3g2LutV8h73rJ/Ny60RwnNbvlHq2fkZIe+lTz0cN/5dc+1D19e2RazW/41utmqri
	Z4ZPb+HfIMi81F2Ptc9lc6Xfq1tRu0qZ9/9Vb3TXiliR+ClyQsj0r53CjakxW5OVpp7ba7Vc
	XD+6Y97eK1v++xf7bOAVPMYnPmmiEktxRqKhFnNRcSIAkMLVCSYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWy7bCSnK5cXGSawbvLVhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro/nZP/aCKdEVC061MjYwnvXoYuTkkBAw
	kZi85jVrFyMXh5DAbkaJiZePM0MkpCU6DrWyQ9jCEiv/PWeHKPrBKHHszi5WkASbgI7E7xW/
	WEBsEaCi/R2tLCBFzAJ3GCXunn8P1i0sECjx6fJLRhCbRUBVounoYbAGXgE7iWMzDzJCbJCX
	2H/wLDNEXFDi5MwnYDXMQPHmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brJhgWFearlecWJu
	cWleul5yfu4mRnAIa2nsYLw3/5/eIUYmDsZDjBIczEoivL/SI9KEeFMSK6tSi/Lji0pzUosP
	MUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYEqP7N4jP3XS7+jT+uE2a+/1vAr/+Evr
	ouZk10fnnwV/661eM8lt7tXyVTtXdP95tOEGT+oFceaMrw8X5sRPZdASOv5aS2X6k7msK86m
	6nf/X3/7eKZGyt3JNYH+s9ZO5ZhU3+GZcVPqp+EqrdkdBs4HOoQ85TYbyGXLzMsxOLiicXbH
	5I8bt2Qea++ddmCye1SS+lfhb1uC38R2iF//UfNebneGtVvTocqzUy3NdZfs8HoodsL7hVdU
	ybx+lidfk8UtAtJbFjWuWh+UfVli4yOjfVtmLThw7rfLT6c/zoIyPYFdK8VORH9ft/DF3hVz
	tjy816jRdY/7+v3d+nevzhQrVnj82cBqt8BHwWt6VpNfKbEUZyQaajEXFScCABQortbQAgAA
X-CMS-MailID: 20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288
References: <CGME20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288@epcas5p3.samsung.com>

Add a test file for hugepage registered buffers, to make sure the
fixed buffer coalescing feature works safe and soundly.

Testcases include read/write with single/multiple/unaligned/non-2MB
hugepage fixed buffers, and also a should-not coalesce case where
buffer is a mixture of different size'd pages.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
Changes since v2:
- Return T_EXIT_SKIP for mmap/posix_memalign failures;
- Rebased to the newest commit;
- Code style issues.
v2: https://lore.kernel.org/io-uring/20240531014131.1441446-1-cliang01.li@samsung.com/T/#t

Changes since v1:
- Added unaligned/non-2MB hugepage/page mixture testcases.
- Rearranged the code.
v1: https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u

 test/Makefile         |   1 +
 test/fixed-hugepage.c | 389 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 390 insertions(+)
 create mode 100644 test/fixed-hugepage.c

diff --git a/test/Makefile b/test/Makefile
index fcf6554..c40d590 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -94,6 +94,7 @@ test_srcs := \
 	file-verify.c \
 	fixed-buf-iter.c \
 	fixed-buf-merge.c \
+	fixed-hugepage.c \
 	fixed-link.c \
 	fixed-reuse.c \
 	fpos.c \
diff --git a/test/fixed-hugepage.c b/test/fixed-hugepage.c
new file mode 100644
index 0000000..396fe43
--- /dev/null
+++ b/test/fixed-hugepage.c
@@ -0,0 +1,389 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test fixed buffers consisting of hugepages.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+/*
+ * Before testing
+ * echo (>=4) > /proc/sys/vm/nr_hugepages
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
+static int open_files(char *fname_in, int *fd_in, int *fd_out)
+{
+	*fd_in = open(fname_in, O_RDONLY, 0644);
+	if (*fd_in < 0) {
+		printf("open %s failed\n", fname_in);
+		return -1;
+	}
+
+	*fd_out = open(OUT_FD, O_RDWR, 0644);
+	if (*fd_out < 0) {
+		printf("open %s failed\n", OUT_FD);
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
+		if (base == MAP_FAILED) {
+			printf("Unable to map hugetlb page. Try increasing the "
+				"value in /proc/sys/vm/nr_hugepages\n");
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
+		printf("Unable to preserve the page mixture memory. "
+			"Try increasing the RLIMIT_MEMLOCK resource limit\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		huge_base = mmap(start, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED, -1, 0);
+		if (huge_base == MAP_FAILED) {
+			printf("Unable to map hugetlb page in the page mixture. "
+				"Try increasing the value in /proc/sys/vm/nr_hugepages\n");
+			unmap(iov, nr_bufs, 0);
+			return -1;
+		}
+
+		small_base = mmap(start + HUGEPAGE_SIZE, small_size, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+		if (small_base == MAP_FAILED) {
+			printf("Unable to map small page in the page mixture. "
+				"Try increasing the RLIMIT_MEMLOCK resource limit\n");
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
+			printf("Unable to allocate mthp pages. "
+				"Try increasing the RLIMIT_MEMLOCK resource limit\n");
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
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, 0))
+		return T_EXIT_SKIP;
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret ? T_EXIT_FAIL : T_EXIT_PASS;
+}
+
+static int test_multi_hugepages(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = 4 * HUGEPAGE_SIZE;
+	int ret;
+
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, 0))
+		return T_EXIT_SKIP;
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret ? T_EXIT_FAIL : T_EXIT_PASS;
+}
+
+static int test_unaligned_hugepage(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = 3 * HUGEPAGE_SIZE;
+	size_t offset = 0x1234;
+	int ret;
+
+	if (mmap_hugebufs(iov, NR_BUFS, buf_size, offset))
+		return T_EXIT_SKIP;
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, offset);
+	return ret ? T_EXIT_FAIL : T_EXIT_PASS;
+}
+
+static int test_multi_unaligned_mthps(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	int ret;
+	size_t buf_size = 3 * MTHP_16KB;
+	size_t offset = 0x1234;
+
+	if (get_mthp_bufs(iov, NR_BUFS, buf_size, MTHP_16KB, offset))
+		return T_EXIT_SKIP;
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	free_bufs(iov, NR_BUFS, offset);
+	return ret ? T_EXIT_FAIL : T_EXIT_PASS;
+}
+
+/* Should not coalesce */
+static int test_page_mixture(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	size_t buf_size = HUGEPAGE_SIZE + MTHP_16KB;
+	int ret;
+
+	if (mmap_mixture(iov, NR_BUFS, buf_size))
+		return T_EXIT_SKIP;
+
+	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
+	unmap(iov, NR_BUFS, 0);
+	return ret ? T_EXIT_FAIL : T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret, fd_in, fd_out;
+	char *fname_in;
+
+	if (argc > 1)
+		fname_in = argv[1];
+	else
+		fname_in = IN_FD;
+
+	if (open_files(fname_in, &fd_in, &fd_out))
+		return T_EXIT_SKIP;
+
+	ret = t_create_ring(8, &ring, 0);
+	if (ret == T_SETUP_SKIP)
+		return T_EXIT_SKIP;
+	else if (ret < 0)
+		return T_EXIT_FAIL;
+
+	ret = test_one_hugepage(&ring, fd_in, fd_out);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test one hugepage failed.\n");
+		return ret;
+	}
+
+	ret = test_multi_hugepages(&ring, fd_in, fd_out);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test multi hugepages failed.\n");
+		return ret;
+	}
+
+	ret = test_unaligned_hugepage(&ring, fd_in, fd_out);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test unaligned hugepage failed.\n");
+		return ret;
+	}
+
+	ret = test_multi_unaligned_mthps(&ring, fd_in, fd_out);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test unaligned multi-size'd THPs failed.\n");
+		return ret;
+	}
+
+	ret = test_page_mixture(&ring, fd_in, fd_out);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test huge small page mixture failed.\n");
+		return ret;
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}

base-commit: 3df984a28a28014a060157d90f3e46e657c04314
-- 
2.34.1


