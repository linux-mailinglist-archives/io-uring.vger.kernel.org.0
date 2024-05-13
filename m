Return-Path: <io-uring+bounces-1887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 946C98C3D31
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F282827D4
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAD51474BF;
	Mon, 13 May 2024 08:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Yk8h64Rh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FEF1474B8
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715588994; cv=none; b=gtJeIBWL0uHBG+hCpAtIkLYk1gx8Wwwo9jc7UBVk+X86lmaoftU5LPAYCTvGqntZzF0eQWPapNHstJTZDhC6kqr3NsAA3my51idMHybxWJaf1mvGmOJLnkU4As3Q5kPwaXGQEL2twWD4XMebQRryviVexnWhzbQU15yauJvz8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715588994; c=relaxed/simple;
	bh=RsIuGX5WN/HtIDzBQRHz23ESiivoJG7bJjYvkqY+Rvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=is8T/aCr8rTn8qn4YIQnJjAD/8vbXsnYk4VyrqgxH3maeBRfr5ukPtXV0bZfHjjzXoM4dit6m7uLyFa0M/iX2KiIJqCPU2v4sDt3vF6ylEDO8eGlNT8qHbpX4/GquyReXu3UUU1vcH7C3eMQDFmiJngVkj2q5mBlDRf+gQGwHx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Yk8h64Rh; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240513082947epoutp03fd717ae62c14c46eda40acf9f8460c43~O-xgqYlqc2099120991epoutp03Q
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240513082947epoutp03fd717ae62c14c46eda40acf9f8460c43~O-xgqYlqc2099120991epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715588987;
	bh=O5AQlYRpYZGPgRa5PdwrIVzhA8/wXpy8vWaqjRaCDMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yk8h64RhXS1Xeg8y6bPifF+VP/h8TDsDfzJvNlJf/ykMLSz8Rh4jHnsha94G+8f5Z
	 IPUbAPwAHAouVSUip+aQZHqlCdaR7EXb4e+24sDMpc/FUvIqi9s+Er7XLvdoryQQPK
	 VtWNJibNZVPFbWECVd8uEtNn9yoSzA34FiSLsshc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240513082946epcas5p201718fa46699cdfe188994d8c99a9d06~O-xgUxdnJ2028620286epcas5p2T;
	Mon, 13 May 2024 08:29:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VdCMs1K3lz4x9Pr; Mon, 13 May
	2024 08:29:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3F.B3.09666.97FC1466; Mon, 13 May 2024 17:29:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240513082314epcas5p309fa70575596792b5c9923ce76a3778f~O-rzNiBop2725827258epcas5p3e;
	Mon, 13 May 2024 08:23:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240513082314epsmtrp278845615213ca1252df3c529eb31a824~O-rzMygWQ1459414594epsmtrp2J;
	Mon, 13 May 2024 08:23:14 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-e8-6641cf7931f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.7C.08390.2FDC1466; Mon, 13 May 2024 17:23:14 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082313epsmtip20c9e5f86e0da51704fb9ff9c0c9bb9a9~O-ryIsfUZ0931209312epsmtip2a;
	Mon, 13 May 2024 08:23:13 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 5/5] liburing: add test cases for hugepage registered
 buffers
Date: Mon, 13 May 2024 16:23:00 +0800
Message-Id: <20240513082300.515905-6-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmpm7lecc0g80fWC3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITtj9qyFjAVbjSrurn7A1MD4QL2LkZNDQsBEYs3Hc8wgtpDAbkaJQxeLIOxP
	jBK/N0p3MXIB2d8YJbrnT2OCaeh4NJ8FIrGXUaLv/zRGiI5fjBI901JBbDYBHYnfK36xgNgi
	AtoSrx9PBWtgFljCKLGrczlYg7BAkMTKM4vZQGwWAVWJSf+/gJ3BK2ArsfDlJFaIbfIS+w+e
	BYtzCthJ7NzzB6pGUOLkzCdgC5iBapq3zmYGWSAh8JNd4mDjDzaIZheJCyf3sEDYwhKvjm9h
	h7ClJD6/2wtUwwFkF0ssWycH0dvCKPH+3RxGiBpriX9XQHo5gBZoSqzfpQ8RlpWYemodE8Re
	Pone30+gocIrsWMejK0qceHgNqhV0hJrJ2xlhrA9JN4sugsNuYmMEqs/nWSfwKgwC8k/s5D8
	Mwth9QJG5lWMkqkFxbnpqcWmBYZ5qeXwSE7Oz93ECE6hWp47GO8++KB3iJGJg/EQowQHs5II
	r0OhfZoQb0piZVVqUX58UWlOavEhRlNggE9klhJNzgcm8bySeEMTSwMTMzMzE0tjM0Mlcd7X
	rXNThATSE0tSs1NTC1KLYPqYODilGpj4bihtuvFjw5SG5UV8YQFFelpfcmx3Cs196D/zgvGn
	W7MC/zdIHFTj/vHK96vYrM2uIbGijcLOmu3d/Mab/O4dXvz4q0Don6mbpOv/PvpkeDPmwaeJ
	SxTjKw90PgjQb7wpKfJTx++F3TvuuTI/vYXsHx7bdeHwtUydiOvbQoVuXrqx55a6oVXg50sN
	e7d++W31npt5goinuI5RxtGkPFl5fia3F4+Fn95MWyfxeUu6cdzb1i0tzg+3rFqfF8uhKyGz
	JI6x4n+w16IFWzjMzk+Z9cm5afvRF5wNFx1ONm3p/fD81+e3tx7d/ugZ55G56lnTEWWf3K33
	fIrNrcM+l845ohCb9n2m82rJmNd82vdmK7EUZyQaajEXFScCABGgs0YqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO6ns45pBu0r9S3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTF71kLGgq1GFXdXP2BqYHyg3sXIySEhYCLR8Wg+
	SxcjF4eQwG5GiUP3V7JDJKQlOg61QtnCEiv/PWeHKPrBKLHh9GMmkASbgI7E7xW/gLo5OEQE
	dCUa7yqA1DALrGKUuPq+nRWkRlggQOLMiXksIDaLgKrEpP9fmEFsXgFbiYUvJ7FCLJCX2H/w
	LFicU8BOYueeP2C2EFDNqcOb2SDqBSVOznwCNocZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQ
	nJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERzmWlo7GPes+qB3iJGJg/EQowQHs5IIr0OhfZoQ
	b0piZVVqUX58UWlOavEhRmkOFiVx3m+ve1OEBNITS1KzU1MLUotgskwcnFINTFwqQcdPx0+e
	v8uckelm2F/2hRzc8lWr35RpKNh17fvFfX+hgfbkjTYtH0uvVK5rlgpjfJUSP/V2UpZg+Gul
	i1z8LQLLn/1Iy5HQXDdjGrME94SZJlf438QtYtQsvzPjgtukKsbFtgKOYXOd8g/d4nr0Tqjo
	wvNrFSuXdN8M19IXWjBt+dwpZw777P94NHim5SrVtvqI6qqYl2/5dzxVaPtxVYn9uzlb1I0r
	LidKH8967pLx2zb0ue/Wv29WJC9N+SXb+Or84mW9xqd7zNqrXr0zuVK2blU3m42O8+LHFzfF
	9Vw93bcv7CLnRGf5tMvCcnO23vjJK2aqzb/64KOFeS2fsj5e5E25NP1Qi8sfm3wlluKMREMt
	5qLiRACb0a8e4gIAAA==
X-CMS-MailID: 20240513082314epcas5p309fa70575596792b5c9923ce76a3778f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082314epcas5p309fa70575596792b5c9923ce76a3778f
References: <20240513082300.515905-1-cliang01.li@samsung.com>
	<CGME20240513082314epcas5p309fa70575596792b5c9923ce76a3778f@epcas5p3.samsung.com>

Add a test file for hugepage registered buffers, to make sure the
fixed buffer coalescing feature works safe and soundly.

Testcases include reading/writing with single/multiple hugepage buffers.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 test/Makefile         |   1 +
 test/fixed-hugepage.c | 236 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 237 insertions(+)
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
index 0000000..4fe45a2
--- /dev/null
+++ b/test/fixed-hugepage.c
@@ -0,0 +1,236 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test fixed buffers consisting of hugepages.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define PAGE_SIZE	4096
+#define HUGEPAGE_SIZE	(512 * PAGE_SIZE)
+#define NR_BUFS		1
+#define IN_FD		"/dev/urandom"
+#define OUT_FD		"/dev/zero"
+
+static int open_files(int *fd_in, int *fd_out)
+{
+	*fd_in = open(IN_FD, O_RDONLY, 0644);
+	if (*fd_in < 0) {
+		perror("open in");
+		return 1;
+	}
+
+	*fd_out = open(OUT_FD, O_RDWR, 0644);
+	if (*fd_out < 0) {
+		perror("open out");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int mmap_hugebufs(struct iovec *iov, int nr_bufs, size_t buf_size)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++) {
+		void *base = NULL;
+
+		base = mmap(NULL, buf_size, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+		if (!base || base == MAP_FAILED) {
+			fprintf(stderr, "Error in mmapping the %dth buffer", i);
+			return 1;
+		}
+
+		iov[i].iov_base = base;
+		iov[i].iov_len = buf_size;
+		memset(iov[i].iov_base, 0, buf_size);
+	}
+
+	return 0;
+}
+
+static int do_read(struct io_uring *ring, int fd, struct iovec *iov,
+				int nr_bufs, size_t buf_size)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int i, ret;
+
+	for (i = 0; i < nr_bufs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "Could not get SQE.\n");
+			return 1;
+		}
+
+		io_uring_prep_read_fixed(sqe, fd, iov[i].iov_base, buf_size, 0, i);
+		io_uring_submit(ring);
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "Error waiting for completion: %s\n", strerror(-ret));
+			return 1;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "Error in async operation: %s\n", strerror(-cqe->res));
+			return 1;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int do_write(struct io_uring *ring, int fd, struct iovec *iov,
+				int nr_bufs, size_t buf_size)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int i, ret;
+
+	for (i = 0; i < nr_bufs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "Could not get SQE.\n");
+			return 1;
+		}
+
+		io_uring_prep_write_fixed(sqe, fd, iov[i].iov_base, buf_size, 0, i);
+		io_uring_submit(ring);
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "Error waiting for completion: %s\n", strerror(-ret));
+			return 1;
+		}
+
+		if (cqe->res < 0) {
+			fprintf(stderr, "Error in async operation: %s\n", strerror(-cqe->res));
+			return 1;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int test_one_hugepage(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	int ret;
+	size_t buf_size = HUGEPAGE_SIZE;
+
+	ret = mmap_hugebufs(iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "Buffer allocating for one hugepage failed.");
+		return 1;
+	}
+
+	ret = io_uring_register_buffers(ring, iov, NR_BUFS);
+	if (ret) {
+		fprintf(stderr, "Error registering buffers for one hugepage test: %s", strerror(-ret));
+		return 1;
+	}
+
+	ret = do_read(ring, fd_in, iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "One hugepage read test failed");
+		return ret;
+	}
+
+	ret = do_write(ring, fd_out, iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "One hugepages write test failed");
+		return ret;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "Error unregistering buffers for one hugepage test: %s", strerror(-ret));
+		return 1;
+	}
+
+	return 0;
+}
+
+static int test_multi_hugepages(struct io_uring *ring, int fd_in, int fd_out)
+{
+	struct iovec iov[NR_BUFS];
+	int ret;
+	size_t buf_size = 4 * HUGEPAGE_SIZE;
+
+	ret = mmap_hugebufs(iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "mmap multi hugepages failed.");
+		return 1;
+	}
+
+	ret = io_uring_register_buffers(ring, iov, NR_BUFS);
+	if (ret) {
+		fprintf(stderr, "Error registering buffers for multi hugepages test: %s", strerror(-ret));
+		return 1;
+	}
+
+	ret = do_read(ring, fd_in, iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "multi hugepages read test failed");
+		return ret;
+	}
+
+	ret = do_write(ring, fd_out, iov, NR_BUFS, buf_size);
+	if (ret) {
+		fprintf(stderr, "multi hugepages write test failed");
+		return ret;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "Error unregistering buffers for multi hugepages test: %s", strerror(-ret));
+		return 1;
+	}
+
+	return 0;
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
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}

base-commit: 23b43f44f882e48a725ad87f8f22722c40743dec
-- 
2.34.1


