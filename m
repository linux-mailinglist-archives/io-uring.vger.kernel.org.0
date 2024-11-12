Return-Path: <io-uring+bounces-4621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0718D9C57C3
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 13:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E49A3B2560A
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 11:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E2D2309A9;
	Tue, 12 Nov 2024 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MN7rQ+gY"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0F230996
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 11:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731411879; cv=none; b=pEIIVcBdCaQ/hMI+IR8PjcRdHhJ6/aju0tecKO58ckJjiuonmYpRJaeyXR0+M7XyZn8+ZYrHEGKIUppUFdnKD2NJzLRyClpWInGX3s7k37SJv1+zBzR0E3lilQXi1irDQoNBFuazdeNftUQwA5UAlBv0Eg01cmWYz/CrofI5++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731411879; c=relaxed/simple;
	bh=F7kHYf6fu+cyxIUehtsBvg0YfLnuk5wCawl1rGwZV5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=SeBUSMSCWeJh7R9lkrEH9WC04pHoK3kK+6tNpISV9siQf0fbAGLSSVy3QPYsYMqj5TzFaXXXHgOcYdJZRVcOedOzMGCwdZXAyWYn2wIJmM0rRyqK6phkbeTlrxjppFDdVMbl/XWydngMo+ROXonfBQALZKw44KkUUC1mn8QeaLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MN7rQ+gY; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241112114432epoutp01d84be37d91eed31cc8476d44773323a9~HNezG-kk22541725417epoutp01h
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 11:44:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241112114432epoutp01d84be37d91eed31cc8476d44773323a9~HNezG-kk22541725417epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731411872;
	bh=1youcwBgN2y35DtKyuLU4H3nGnxMLoTkqy7VmAqANXg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MN7rQ+gYaEqZqvvrewqmr6fMiPzOtH1JjZYljPk5coCqa1jpEMWdwsT7lxIuV9lHX
	 4ST9Eab12A0d5XGDLzzJJkRj1e41djGXE8izK+oNchupAomCRZ+ke+7agw6HO/BXdJ
	 SzcFOj4VbdG8/eaE2JsLkyZwLxsbAdOefv/M26qo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241112114432epcas5p4c6f7e09dc4522e48f6654fe081edcbd6~HNeyxoXxV1966219662epcas5p4r;
	Tue, 12 Nov 2024 11:44:32 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xnl270SrVz4x9Q2; Tue, 12 Nov
	2024 11:44:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BB.39.08574.E9F33376; Tue, 12 Nov 2024 20:44:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241112105154epcas5p41d08b07401823566042164b10e3729f8~HMw1ibBi61304413044epcas5p4Y;
	Tue, 12 Nov 2024 10:51:54 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241112105154epsmtrp2b168371b923a0bd2027c73efe5b19155~HMw1h0-2o2739327393epsmtrp2f;
	Tue, 12 Nov 2024 10:51:54 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-f1-67333f9efc7e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.68.18937.A4333376; Tue, 12 Nov 2024 19:51:54 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241112105153epsmtip2953ce55c4e6c581687c8e3c5d59d1f5f~HMw0jQNCY2257222572epsmtip2P;
	Tue, 12 Nov 2024 10:51:53 +0000 (GMT)
Date: Tue, 12 Nov 2024 16:14:06 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: hexue <xue01.he@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing] test: add test cases for hybrid iopoll
Message-ID: <20241112104406.2rltxkliwhksn3hw@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241111123650.1857526-1-xue01.he@samsung.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTQ3eevXG6Qd9OS4s5q7YxWqy+289m
	8a71HIvF5V1z2Cy6Lpxic2D12DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RWSaEsMacUKBSQWFyspG9nU5Rf
	WpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd8aH5OWvBpkbGisNdrxkb
	GHtSuhg5OCQETCQOnRLqYuTiEBLYzShxceJ19i5GTiDnE6PE7fPeEAkg+/+LHWwgCZCGufsX
	sUMkdjJKLJzYyQLhPGOU+HZ5Llg7i4CqxJqGVSwgNpuAusSR562MILaIgILE35brzCA2s0Cq
	xPZ578DiwgIuEl1PlzKB2LwCZhLP761lgbAFJU7OfAJmcwrYSFyeOB+sRlRARmLG0q/MIIsl
	BG6xS+x6cJoV4jwXifkXT7JD2MISr45vgbKlJD6/2wv1QrrEj8tPmSDsAonmY/sYIWx7idZT
	/VDHZUi8nHoGKi4rMfXUOiaIOJ9E7+8nUL28EjvmwdhKEu0r50DZEhJ7zzUwQcLXQ2L5KUNI
	APUzSiy/uYppAqP8LCS/zUKyDsK2kuj80MQ6C6idWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz
	01OTTQsM81LL4RGenJ+7iRGcKrVcdjDemP9P7xAjEwfjIUYJDmYlEV4Nf/10Id6UxMqq1KL8
	+KLSnNTiQ4ymwLiayCwlmpwPTNZ5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphak
	FsH0MXFwSjUw3V215dZbH851v8uS0srNck+IcN+z/GKmuPbEQRmhZcr6zy7WOk9xZp0x2dju
	ZMbq/BVb9qyKW7q7UvL2N4573MKZvZkM/MKMTR1bCu/zOPTMkWhoXBK8t0AySzwnZHofV66d
	984uvcuG+34z+v9qD05UX/PSaAFDAue/wFvipxKeVu2csouhRqu34OMZQ26fUw36Kd1bF0vP
	2aUm9yG/i39fkemdtaUTGJh/LN+7eLXJXxO/lSFGOUFHzFnaNzztXHJ579yXBywyk4REWjv3
	vbeZ03iyTufxj6sXumXXXpFKsb5/dO6VQ/M6buwWPFi0v7Hnz704fWOGrDl79zar2QRwPJ/5
	+hxX4/yUhXrblFiKMxINtZiLihMBheaZMx4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSvK6XsXG6wcQWfos5q7YxWqy+289m
	8a71HIvF5V1z2Cy6Lpxic2D12DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx
	9dYM9oIndRXvP/9ibmC8kdjFyMkhIWAiMXf/IvYuRi4OIYHtjBJ/tp9nh0hISJx6uYwRwhaW
	WPnvOVTRE0aJ5zcmsIIkWARUJdY0rGIBsdkE1CWOPG8FaxARUJD423KdGcRmFkiV2D7vHVhc
	WMBFouvpUiYQm1fATOL5vbUsEEP7GSX+nu5mhEgISpyc+YQFotlMYt7mh0CDOIBsaYnl/zhA
	wpwCNhKXJ84HmyMqICMxY+lX5gmMgrOQdM9C0j0LoXsBI/MqRtHUguLc9NzkAkO94sTc4tK8
	dL3k/NxNjODg1grawbhs/V+9Q4xMHIyHGCU4mJVEeDX89dOFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamNKW7NBUeRJ0+MLXDTe2Xz54XfUua+7t6JWh
	Tw47LfRbXvcp6L3ktUrRtUmN/es74kXWiFxq3Fj4ZsnF/KoTfkuDhVfYhNsdcWpWLm4uq73A
	KRRv4xHdul9AmnPrnUZ1LyZWjltsToVqjFEmx3dJzOblUpM63O74P0HeW8tK1EahlVtwwhZV
	5xX/VlbXxgSmb9uaLcZ+9cqKPXdTBPbpZ5oeftDE3pdp2jz9lo3SrYUs1ctnHnLiM9lixbpY
	fcEyVmetLm+tyW9KnfcsX3uv7MTqX44VOZmRqkwaK54cT97euHG97r+H+95xhKfYWkeujEx6
	XNb0W/HDjW2JxcuZllSVpKVN4FtQvcPisiOnEktxRqKhFnNRcSIAVMmByt0CAAA=
X-CMS-MailID: 20241112105154epcas5p41d08b07401823566042164b10e3729f8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c2349_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241111123656epcas5p20cac863708cd83d1fdbb523625665273
References: <CGME20241111123656epcas5p20cac863708cd83d1fdbb523625665273@epcas5p2.samsung.com>
	<20241111123650.1857526-1-xue01.he@samsung.com>

------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c2349_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 11/11/24 08:36PM, hexue wrote:
>Add a test file for hybrid iopoll to make sure it works safe.Testcass
>include basic read/write tests, and run in normal iopoll mode and
>passthrough mode respectively.
>
>Signed-off-by: hexue <xue01.he@samsung.com>
>---
> man/io_uring_setup.2            |  10 +-
> src/include/liburing/io_uring.h |   3 +
> test/Makefile                   |   1 +
i> test/iopoll-hybridpoll.c        | 544 ++++++++++++++++++++++++++++++++
> 4 files changed, 557 insertions(+), 1 deletion(-)
> create mode 100644 test/iopoll-hybridpoll.c
>
>diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
>index 2f87783..8cfafdc 100644
>--- a/man/io_uring_setup.2
>+++ b/man/io_uring_setup.2
>@@ -78,7 +78,15 @@ in question. For NVMe devices, the nvme driver must be loaded with the
> parameter set to the desired number of polling queues. The polling queues
> will be shared appropriately between the CPUs in the system, if the number
> is less than the number of online CPU threads.
>-
>+.TP
>+.B IORING_SETUP_HYBRID_IOPOLL
>+This flag must setup with
s/<must setup with>/<must be used with>

>+.B IORING_SETUP_IOPOLL
>+flag. hybrid poll is a new
s/hybrid/Hybrid
"new" is probably not required here

>+feature baed on iopoll, this could be a suboptimal solution when running
s/baed/based
s/<this could>/<which might>

>+on a single thread, it offers higher performance than IRQ and lower CPU
s/<, it>/<. It>

>+utilization than polling. Similarly, this feature also requires the devices
>+to support polling configuration.
This feature would work if a device doesn't have polled queues,right?
The performance might be suboptimal in that case, but the userspace won't
get any errors.

> .TP
> .B IORING_SETUP_SQPOLL
> When this flag is specified, a kernel thread is created to perform
>diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>index 20bc570..d16364c 100644
>--- a/src/include/liburing/io_uring.h
>+++ b/src/include/liburing/io_uring.h
>@@ -200,6 +200,9 @@ enum io_uring_sqe_flags_bit {
>  */
> #define IORING_SETUP_NO_SQARRAY		(1U << 16)
>
>+/* Use hybrid poll in iopoll process */
>+#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
>+
> enum io_uring_op {
> 	IORING_OP_NOP,
> 	IORING_OP_READV,
>diff --git a/test/Makefile b/test/Makefile
>index dfbbcbe..ea9452c 100644
>--- a/test/Makefile
>+++ b/test/Makefile
>@@ -116,6 +116,7 @@ test_srcs := \
> 	iopoll.c \
> 	iopoll-leak.c \
> 	iopoll-overflow.c \
>+	iopoll-hybridpoll.c \
> 	io_uring_enter.c \
> 	io_uring_passthrough.c \
> 	io_uring_register.c \
>diff --git a/test/iopoll-hybridpoll.c b/test/iopoll-hybridpoll.c
>new file mode 100644
>index 0000000..d7c08ae
>--- /dev/null
>+++ b/test/iopoll-hybridpoll.c
>@@ -0,0 +1,544 @@
>+/* SPDX-License-Identifier: MIT */
>+/*
>+ * Description: basic read/write tests with
>+ * hybrid polled IO, include iopoll and io_uring
>+ * passthrough.
>+ */
>+#include <errno.h>
>+#include <stdio.h>
>+#include <unistd.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <fcntl.h>
>+#include <sys/types.h>
>+#include <poll.h>
>+#include <sys/eventfd.h>
>+#include <sys/resource.h>
>+#include "helpers.h"
>+#include "liburing.h"
>+#include "../src/syscall.h"
>+#include "nvme.h"
>+
>+#define FILE_SIZE	(128 * 1024)
>+#define BS		4096
>+#define BUFFERS		(FILE_SIZE / BS)
>+
>+static struct iovec *vecs;
>+static int no_pt, no_iopoll;
>+
>+static int fill_pattern(int tc)
>+{
>+	unsigned int val, *ptr;
>+	int i, j;
>+	int u_in_buf = BS / sizeof(val);
>+
>+	val = (tc / 2) * FILE_SIZE;
>+	for (i = 0; i < BUFFERS; i++) {
>+		ptr = vecs[i].iov_base;
>+		for (j = 0; j < u_in_buf; j++) {
>+			*ptr = val;
>+			val++;
>+			ptr++;
>+		}
>+	}
>+
>+	return 0;
>+}
>+
>+static int verify_buf(int tc, void *buf, off_t off)
>+{
>+	int i, u_in_buf = BS / sizeof(unsigned int);
>+	unsigned int *ptr;
>+
>+	off /= sizeof(unsigned int);
>+	off += (tc / 2) * FILE_SIZE;
>+	ptr = buf;
>+	for (i = 0; i < u_in_buf; i++) {
>+		if (off != *ptr) {
>+			fprintf(stderr, "Found %u, wanted %llu\n", *ptr,
>+					(unsigned long long) off);
>+			return 1;
>+		}
>+		ptr++;
>+		off++;
>+	}
>+
>+	return 0;
>+}
>+
>+static int __test_io_uring_passthrough_io(const char *file, struct io_uring *ring, int tc, int write,
>+		     int sqthread, int fixed, int nonvec)
>+{
>+	struct io_uring_sqe *sqe;
>+	struct io_uring_cqe *cqe;
>+	struct nvme_uring_cmd *cmd;
>+	int open_flags;
>+	int do_fixed;
>+	int i, ret, fd = -1;
>+	off_t offset;
>+	__u64 slba;
>+	__u32 nlb;
>+
>+	if (write)
>+		open_flags = O_WRONLY;
>+	else
>+		open_flags = O_RDONLY;
>+
>+	if (fixed) {
>+		ret = t_register_buffers(ring, vecs, BUFFERS);
>+		if (ret == T_SETUP_SKIP)
>+			return 0;
>+		if (ret != T_SETUP_OK) {
>+			fprintf(stderr, "buffer reg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+
>+	fd = open(file, open_flags);
>+	if (fd < 0) {
>+		if (errno == EACCES || errno == EPERM)
>+			return T_EXIT_SKIP;
>+		perror("file open");
>+		goto err;
>+	}
>+
>+	if (sqthread) {
>+		ret = io_uring_register_files(ring, &fd, 1);
>+		if (ret) {
>+			fprintf(stderr, "file reg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+
>+	if (write)
>+		fill_pattern(tc);
>+
>+	offset = 0;
>+	for (i = 0; i < BUFFERS; i++) {
>+		sqe = io_uring_get_sqe(ring);
>+		if (!sqe) {
>+			fprintf(stderr, "sqe get failed\n");
>+			goto err;
>+		}
>+		if (write) {
>+			int use_fd = fd;
>+
>+			do_fixed = fixed;
>+
>+			if (sqthread)
>+				use_fd = 0;
>+			if (fixed && (i & 1))
>+				do_fixed = 0;
>+			if (do_fixed) {
>+				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
>+								vecs[i].iov_len,
>+								offset, i);
>+				sqe->cmd_op = NVME_URING_CMD_IO;
>+			} else if (nonvec) {
>+				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
>+							vecs[i].iov_len, offset);
>+				sqe->cmd_op = NVME_URING_CMD_IO;
>+			} else {
>+				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
>+								offset);
>+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
>+			}	
>+		} else {
>+			int use_fd = fd;
>+
>+			do_fixed = fixed;
>+
>+			if (sqthread)
>+				use_fd = 0;
>+			if (fixed && (i & 1))
>+				do_fixed = 0;
>+			if (do_fixed) {
>+				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
>+								vecs[i].iov_len,
>+								offset, i);
>+				sqe->cmd_op = NVME_URING_CMD_IO;
>+			} else if (nonvec) {
>+				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
>+							vecs[i].iov_len, offset);
>+				sqe->cmd_op = NVME_URING_CMD_IO;
>+			} else {
>+				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
>+								offset);
>+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
>+			}
>+		}
>+		sqe->opcode = IORING_OP_URING_CMD;
>+		if (do_fixed)
>+			sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
>+		sqe->user_data = ((uint64_t)offset << 32) | i;
>+		if (sqthread)
>+			sqe->flags |= IOSQE_FIXED_FILE;
>+
>+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
>+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
>+
>+		cmd->opcode = write ? nvme_cmd_write : nvme_cmd_read;
>+
>+		slba = offset >> lba_shift;
>+		nlb = (BS >> lba_shift) - 1;
>+
>+		/* cdw10 and cdw11 represent starting lba */
>+		cmd->cdw10 = slba & 0xffffffff;
>+		cmd->cdw11 = slba >> 32;
>+		/* cdw12 represent number of lba's for read/write */
>+		cmd->cdw12 = nlb;
>+		if (do_fixed || nonvec) {
>+			cmd->addr = (__u64)(uintptr_t)vecs[i].iov_base;
>+			cmd->data_len = vecs[i].iov_len;
>+		} else {
>+			cmd->addr = (__u64)(uintptr_t)&vecs[i];
>+			cmd->data_len = 1;
>+		}
>+		cmd->nsid = nsid;
>+
>+		offset += BS;
>+	}
>+
>+	ret = io_uring_submit(ring);
>+	if (ret != BUFFERS) {
>+		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
>+		goto err;
>+	}
>+
>+	for (i = 0; i < BUFFERS; i++) {
>+		ret = io_uring_wait_cqe(ring, &cqe);
>+		if (ret) {
>+			fprintf(stderr, "wait_cqe=%d\n", ret);
>+			goto err;
>+		}
>+		if (cqe->res != 0) {
>+			if (!no_pt) {
>+				no_pt = 1;
>+				goto skip;
>+			}
>+			fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
>+			goto err;
>+		}
>+		io_uring_cqe_seen(ring, cqe);
>+		if (!write) {
>+			int index = cqe->user_data & 0xffffffff;
>+			void *buf = vecs[index].iov_base;
>+			off_t voff = cqe->user_data >> 32;
>+
>+			if (verify_buf(tc, buf, voff))
>+				goto err;
>+		}
>+	}
>+
>+	if (fixed) {
>+		ret = io_uring_unregister_buffers(ring);
>+		if (ret) {
>+			fprintf(stderr, "buffer unreg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+	if (sqthread) {
>+		ret = io_uring_unregister_files(ring);
>+		if (ret) {
>+			fprintf(stderr, "file unreg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+
>+skip:
>+	close(fd);
>+	return 0;
>+err:
>+	if (fd != -1)
>+		close(fd);
>+	return 1;
>+}
>+
>+static int test_io_uring_passthrough(const char *file, int tc, int write, int sqthread,
>+		   int fixed, int nonvec)
>+{
>+	struct io_uring ring;
>+	int ret, ring_flags = 0;
>+
>+	ring_flags |= IORING_SETUP_SQE128;
>+	ring_flags |= IORING_SETUP_CQE32;
>+	ring_flags |= IORING_SETUP_HYBRID_IOPOLL;
>+
>+	if (sqthread)
>+		ring_flags |= IORING_SETUP_SQPOLL;
>+
>+	ret = t_create_ring(64, &ring, ring_flags);
>+	if (ret == T_SETUP_SKIP)
>+		return 0;
>+	if (ret != T_SETUP_OK) {
>+		if (ret == -EINVAL) {
>+			no_pt = 1;
>+			return T_SETUP_SKIP;
>+		}
>+		fprintf(stderr, "ring create failed: %d\n", ret);
>+		return 1;
>+	}
>+
>+	ret = __test_io_uring_passthrough_io(file, &ring, tc, write, sqthread, fixed, nonvec);
>+	io_uring_queue_exit(&ring);
>+
>+	return ret;
>+}
>+
>+static int provide_buffers(struct io_uring *ring)
>+{
>+	struct io_uring_sqe *sqe;
>+	struct io_uring_cqe *cqe;
>+	int ret, i;
>+
>+	for (i = 0; i < BUFFERS; i++) {
>+		sqe = io_uring_get_sqe(ring);
>+		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
>+						vecs[i].iov_len, 1, 1, i);
>+	}
>+
>+	ret = io_uring_submit(ring);
>+	if (ret != BUFFERS) {
>+		fprintf(stderr, "submit: %d\n", ret);
>+		return 1;
>+	}
>+
>+	for (i = 0; i < BUFFERS; i++) {
>+		ret = io_uring_wait_cqe(ring, &cqe);
>+		if (cqe->res < 0) {
>+			fprintf(stderr, "cqe->res=%d\n", cqe->res);
>+			return 1;
>+		}
>+		io_uring_cqe_seen(ring, cqe);
>+	}
>+
>+	return 0;
>+}
>+
>+static int __test_iopoll_io(const char *file, struct io_uring *ring, int write, int sqthread,
>+		     int fixed, int buf_select)
>+{
>+	struct io_uring_sqe *sqe;
>+	struct io_uring_cqe *cqe;
>+	int open_flags;
>+	int i, fd = -1, ret;
>+	off_t offset;
>+
>+	if (buf_select) {
>+		write = 0;
>+		fixed = 0;
>+	}
>+	if (buf_select && provide_buffers(ring))
>+		return 1;
>+
>+	if (write)
>+		open_flags = O_WRONLY;
>+	else
>+		open_flags = O_RDONLY;
>+	open_flags |= O_DIRECT;
>+
>+	if (fixed) {
>+		ret = t_register_buffers(ring, vecs, BUFFERS);
>+		if (ret == T_SETUP_SKIP)
>+			return 0;
>+		if (ret != T_SETUP_OK) {
>+			fprintf(stderr, "buffer reg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+	fd = open(file, open_flags);
>+	if (fd < 0) {
>+		if (errno == EINVAL || errno == EPERM || errno == EACCES)
>+			return 0;
>+		perror("file open");
>+		goto err;
>+	}
>+	if (sqthread) {
>+		ret = io_uring_register_files(ring, &fd, 1);
>+		if (ret) {
>+			fprintf(stderr, "file reg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+
>+	offset = 0;
>+	for (i = 0; i < BUFFERS; i++) {
>+		sqe = io_uring_get_sqe(ring);
>+		if (!sqe) {
>+			fprintf(stderr, "sqe get failed\n");
>+			goto err;
>+		}
>+		offset = BS * (rand() % BUFFERS);
>+		if (write) {
>+			int do_fixed = fixed;
>+			int use_fd = fd;
>+
>+			if (sqthread)
>+				use_fd = 0;
>+			if (fixed && (i & 1))
>+				do_fixed = 0;
>+			if (do_fixed) {
>+				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
>+								vecs[i].iov_len,
>+								offset, i);
>+			} else {
>+				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
>+								offset);
>+			}
>+		} else {
>+			int do_fixed = fixed;
>+			int use_fd = fd;
>+
>+			if (sqthread)
>+				use_fd = 0;
>+			if (fixed && (i & 1))
>+				do_fixed = 0;
>+			if (do_fixed) {
>+				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
>+								vecs[i].iov_len,
>+								offset, i);
>+			} else {
>+				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
>+								offset);
>+			}
>+
>+		}
>+		if (sqthread)
>+			sqe->flags |= IOSQE_FIXED_FILE;
>+		if (buf_select) {
>+			sqe->flags |= IOSQE_BUFFER_SELECT;
>+			sqe->buf_group = buf_select;
>+			sqe->user_data = i;
>+		}
>+	}
>+
>+	ret = io_uring_submit(ring);
>+	if (ret != BUFFERS) {
>+		ret = io_uring_peek_cqe(ring, &cqe);
>+		if (!ret && cqe->res == -EOPNOTSUPP) {
>+			no_iopoll = 1;
>+			io_uring_cqe_seen(ring, cqe);
>+			goto out;
>+		}
>+		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
>+		goto err;
>+	}
>+
>+	for (i = 0; i < BUFFERS; i++) {
>+		ret = io_uring_wait_cqe(ring, &cqe);
>+		if (ret) {
>+			fprintf(stderr, "wait_cqe=%d\n", ret);
>+			goto err;
>+		} else if (cqe->res == -EOPNOTSUPP) {
>+			fprintf(stdout, "File/device/fs doesn't support polled IO\n");
>+			no_iopoll = 1;
>+			goto out;
>+		} else if (cqe->res != BS) {
>+			fprintf(stderr, "cqe res %d, wanted %d\n", cqe->res, BS);
>+			goto err;
>+		}
>+		io_uring_cqe_seen(ring, cqe);
>+	}
>+
>+	if (fixed) {
>+		ret = io_uring_unregister_buffers(ring);
>+		if (ret) {
>+			fprintf(stderr, "buffer unreg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+	if (sqthread) {
>+		ret = io_uring_unregister_files(ring);
>+		if (ret) {
>+			fprintf(stderr, "file unreg failed: %d\n", ret);
>+			goto err;
>+		}
>+	}
>+
>+out:
>+	close(fd);
>+	return 0;
>+err:
>+	if (fd != -1)
>+		close(fd);
>+	return 1;
>+}
>+
>+static int test_iopoll(const char *fname, int write, int sqthread, int fixed,
>+		   int buf_select, int defer)
>+{
>+	struct io_uring ring;
>+	int ret, ring_flags = IORING_SETUP_IOPOLL | IORING_SETUP_HYBRID_IOPOLL;
>+
>+	if (no_iopoll)
>+		return 0;
>+
>+	if (defer)
>+		ring_flags |= IORING_SETUP_SINGLE_ISSUER |
>+			      IORING_SETUP_DEFER_TASKRUN;
>+
>+	ret = t_create_ring(64, &ring, ring_flags);
>+	if (ret == T_SETUP_SKIP)
>+		return 0;
>+	if (ret != T_SETUP_OK) {
>+		fprintf(stderr, "ring create failed: %d\n", ret);
>+		return 1;
>+	}
>+	ret = __test_iopoll_io(fname, &ring, write, sqthread, fixed, buf_select);
>+	io_uring_queue_exit(&ring);
>+	return ret;
>+}
>+
>+int main(int argc, char *argv[])
>+{
>+	int i, ret;
>+	char buf[256];
>+	char *fname;
>+
>+	if (argc > 1) {
>+		fname = argv[1];
>+	} else {
>+		srand((unsigned)time(NULL));
>+		snprintf(buf, sizeof(buf), ".basic-rw-%u-%u",
>+			(unsigned)rand(), (unsigned)getpid());
>+		fname = buf;
>+		t_create_file(fname, FILE_SIZE);
>+	}
>+
>+	vecs = t_create_buffers(BUFFERS, BS);
>+
>+	for (i = 0; i < 16; i++) {
>+		int write = (i & 1) != 0;
>+		int sqthread = (i & 2) != 0;
>+		int fixed = (i & 4) != 0;
>+		int buf_select = (i & 8) != 0;
>+		int defer = (i & 16) != 0;
>+		int nonvec = buf_select;
>+
>+		ret = test_iopoll(fname, write, sqthread, fixed, buf_select, defer);
>+		if (ret) {
>+			fprintf(stderr, "test_iopoll_io failed %d/%d/%d/%d/%d\n",
>+				write, sqthread, fixed, buf_select, defer);
>+			goto err;
>+		}
>+		if (no_iopoll)
>+			break;
>+
>+		ret = test_io_uring_passthrough(fname, i, write, sqthread, fixed, nonvec);
>+		if (no_pt)
>+			break;
>+		if (ret) {
>+			fprintf(stderr, "test_io_uring_passthrough_io failed %d/%d/%d/%d\n",
>+				write, sqthread, fixed, nonvec);
>+			goto err;
>+		}
>+	}
>+
>+	if (fname != argv[1])
>+		unlink(fname);
>+	return ret;
>+err:
>+	if (fname != argv[1])
>+		unlink(fname);
>+	return T_EXIT_FAIL;
>+}

This patch mostly looks fine. But the code here seems to be largely
duplicated from "test/io_uring_passthrough.c" and "test/iopoll.c".
Can we consider adding the hybrid poll test as a part of the existing
tests as it seems that it would only require passing a extra flag
during ring setup.

>-- 
>2.34.1
>

------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c2349_
Content-Type: text/plain; charset="utf-8"


------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c2349_--

