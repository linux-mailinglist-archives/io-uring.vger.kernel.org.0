Return-Path: <io-uring+bounces-1898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAA48C4C09
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528DD2866F8
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 05:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539A014A84;
	Tue, 14 May 2024 05:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MHNu4jg0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA1918026
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 05:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665451; cv=none; b=qjeS9/UI1A22KOYAtjw8lWGY6GmurU5r7+VGgcyeYL85FEAce4ysool2OiR5UzuK0ZFLZpSvMrvw/ybIZJhagkVH9Nz6CikC8C5S5saNiPee8zzTOpvReUNoYa+l036U5vFlFxRM8R6dC+S0AMPj4oRztSXa8jShz+UW+9UE4KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665451; c=relaxed/simple;
	bh=RsIuGX5WN/HtIDzBQRHz23ESiivoJG7bJjYvkqY+Rvg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Chu3reAcu/AtztlOOzxLrdRwLG9vWpiS8m99FN4EyPf2e5ydh1LiY1pvB5UqoUFwyw9sEl7s2JJMn0Es93GwThsiaMWia5uiWWrEks3J5H4rxi/N6eBnam/uPGQbEBWeXJoW2TWJ4kExL9rXcxtM07qCBp+en8kByq4TQqK+T+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MHNu4jg0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240514054400epoutp04e1bd0b35aa0df9323313c7415f04e7f7~PRKC0gqpk0188701887epoutp049
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 05:44:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240514054400epoutp04e1bd0b35aa0df9323313c7415f04e7f7~PRKC0gqpk0188701887epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715665440;
	bh=O5AQlYRpYZGPgRa5PdwrIVzhA8/wXpy8vWaqjRaCDMk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=MHNu4jg0OBwYIALJBhcEnTI5hCf0e1XRLBP6YpuxsVCi+uMMxj4d9JL6X7skbuZx0
	 4XwG2UCg/CwSlbSmyCJRtYm9balFxLih9UXWM9KRnoknT+CJ+7jG/qq+HKgWQe4Fsj
	 nc43U05Uss3Oinl+9T6MY8WhX/3HgmYQJpzOsJug=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240514054359epcas5p34ad2efa092e040326c62557c99cd643e~PRKCaFwH42581725817epcas5p3Q;
	Tue, 14 May 2024 05:43:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vdlf56Rc8z4x9Q1; Tue, 14 May
	2024 05:43:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C6.6E.09688.91AF2466; Tue, 14 May 2024 14:43:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240514051349epcas5p45ec62c06d60fb5759c73596d9fbee7e8~PQvspfH5S2708827088epcas5p4H;
	Tue, 14 May 2024 05:13:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240514051349epsmtrp2163c973050d3fa75af95f4df2390799b~PQvsojUgV1257812578epsmtrp29;
	Tue, 14 May 2024 05:13:49 +0000 (GMT)
X-AuditID: b6c32a4a-837fa700000025d8-e5-6642fa19c6d3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A7.EA.08924.D03F2466; Tue, 14 May 2024 14:13:49 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514051348epsmtip2e88d36e9f1c0756634bfbe1760af209a~PQvrhyK1P0259402594epsmtip2T;
	Tue, 14 May 2024 05:13:48 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH liburing] test: add test cases for hugepage registered
 buffers
Date: Tue, 14 May 2024 13:13:43 +0800
Message-Id: <20240514051343.582556-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTS1fyl1OawfpLfBZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ0xe9ZCxoKtRhV3Vz9gamB8oN7FyMkhIWAisW/XEeYuRi4OIYHdjBIfD72E
	cj4xSuw4dJoRpEpI4BujxOMjJTAds7/MY4co2sso8fzNciaIol+MEld/GYHYbAI6Er9X/GIB
	sUUEtCVeP57KAtLALLCEUWJX53KwqcICARI3f+wHa2YRUJWYvG8nK4jNK2ArMXvKBXaIbfIS
	+w+eZYaIC0qcnPkEbCgzULx562ywUyUErrFLbO2ayAzR4CLRvn8GK4QtLPHq+BaoQVISn9/t
	Zeti5ACyiyWWrZOD6G1hlHj/bg4jRI21xL8re1hAapgFNCXW79KHCMtKTD21jgliL59E7+8n
	TBBxXokd82BsVYkLB7dBrZKWWDthK9Q5HhLrDhxigQRQrMTsmdPYJjDKz0Lyziwk78xC2LyA
	kXkVo2RqQXFuemqxaYFRXmo5PGKT83M3MYJTpZbXDsaHDz7oHWJk4mA8xCjBwawkwutQaJ8m
	xJuSWFmVWpQfX1Sak1p8iNEUGMYTmaVEk/OByTqvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB
	9MSS1OzU1ILUIpg+Jg5OqQam9YKxaXLNboptP80c65gOlT0ozTu2V/fnnFV5wdGPBY0fd4gl
	XH0m/7D92LmCd8FPMg5Xnpy3v3bCa66HkpZ2kQ+MzeSqXTpzNvVcnz4lTGPtwyOhmieOXXFb
	eOv67Fwhn7jgUzlvZH40Wv14XvYz71SjwfTelr11J7W5lk1z6raZ9WrujxkPs7ddZVFycGJ7
	bVzePfPCDd3MOrn23fkBJVefdGw5bXYgt2DFGsvc0rDoC0WsV2dbf9mm+aO8N+bQi6zFR2/k
	sqVqMGt/mVL0VaF1zrorMrMOTWJ1jP+Xmp9/LkhfKz0xbPJZztWzpP76ylbOfpgiUaFs/7XL
	tUng4f2V8183ZQsLe16ax2CgxFKckWioxVxUnAgAWBnHNB4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvC7vZ6c0g0svxSzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTF71kLGgq1GFXdXP2BqYHyg3sXIySEhYCIx+8s8
	9i5GLg4hgd2MElt/drFAJKQlOg61skPYwhIr/z0Hs4UEfjBKLN2QBGKzCehI/F7xC6ieg0NE
	QFei8a4CyBxmgVWMElfft7OC1AgL+ElMv3cRzGYRUJWYvG8nmM0rYCsxe8oFqPnyEvsPnmWG
	iAtKnJz5BOwGZqB489bZzBMY+WYhSc1CklrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10v
	OT93EyM4aLU0dzBuX/VB7xAjEwfjIUYJDmYlEV6HQvs0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rziL3pThATSE0tSs1NTC1KLYLJMHJxSDUy5pftnpk2+0eHWkyK9i/80v33D5vTfouoc79Oe
	GGWxBr4LYvStPWx8dJnVC505wrc/q6olT3pV5cigMn3/LR2HJfzesQkhmeWaxRHiyQIPel5E
	L3ribnTNWufsklXinT/Kr0Xtb7xpeI+dt9J7LWuUKW9KbsMxQ8HVG9ncsvuWp5Tc3VBn92fD
	zwXfrunPWKf305zp3+HLR05saNut1WzpyirHqsIwO7bn2+/16b6zvFsWd5cpxv9Q82G/8vHq
	5caLPLdSey6wc3qdm7vtnzTXmgJjb5GWJ1bSOTe3VJY/bL6UtU5FLq5FV9V2YtIjsxcbNz0z
	qtS6dFXm1Myb62cWnOUSZJYqSvf+M/1NnhJLcUaioRZzUXEiAI776/TJAgAA
X-CMS-MailID: 20240514051349epcas5p45ec62c06d60fb5759c73596d9fbee7e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514051349epcas5p45ec62c06d60fb5759c73596d9fbee7e8
References: <CGME20240514051349epcas5p45ec62c06d60fb5759c73596d9fbee7e8@epcas5p4.samsung.com>

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


