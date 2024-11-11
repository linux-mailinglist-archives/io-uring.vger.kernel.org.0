Return-Path: <io-uring+bounces-4619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C88D89C4E05
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 06:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8977828395B
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 05:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07107208964;
	Tue, 12 Nov 2024 05:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vEsB/sbh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77919207A15
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731387866; cv=none; b=HTmynR+Hakw67IsPV3eTUgtV4EJ2Miwc73Xo7KTxQVne9kq74/0Jc5y7JVSVf+HuTWpLlFa1L+eGuBq7zmaoAwzZIxUSPXiZ+2JRty8VqOJdwKg1VqFpHd+nSwnSxVZcvkEraba8Qkk2ABPhyBndUSWp6DMpRMz+MSx3cNVGR2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731387866; c=relaxed/simple;
	bh=K9Gv3v3Uc6AHETT1xR7ch/v0oKyX3W85GdVQwzAG2r0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=R3F+C8jgUls8yNg4G1ki7sYG/VYBur/+9aF3Y+n627jm6SF7mbvHBp2lMxMq38n6De3gdfgRWSBK8gZ8LZIjNmXkoZddt2E3hsmPkw9mmTOZaUtjBTtCr6tEuJwnNCw5I8K0uXxyS0lu6tGOPGqu1mUwC/MSQIgI0pD8jBVP64k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vEsB/sbh; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241112050421epoutp0430a72bc729922f94a573bd942244b3b6~HIBYjR5id1626816268epoutp04C
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 05:04:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241112050421epoutp0430a72bc729922f94a573bd942244b3b6~HIBYjR5id1626816268epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731387861;
	bh=Rd+2J3oJ1RFd57FvIVu3KfojR2nZ0v+fm0z3RWfr5vQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=vEsB/sbh8ElnfHSLpN36bY9obWL0QxwbG0SCm844VfshBoW0vfNDx+5Me7is2clKE
	 AZ5IBixzB9Qn/qgfqZTTkcPIH+B7FJpuiPAJKQcHyDnE+1SAeLjKASuCQI+7eHuB2G
	 IhlGbQEhcbxrHF7iUQpP+FdvyWS1cSBELhujAAjQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241112050420epcas5p364776bf147a05930e0a6349e8e1fb484~HIBYEaTTe0572605726epcas5p3b;
	Tue, 12 Nov 2024 05:04:20 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XnZ8M2yWGz4x9QD; Tue, 12 Nov
	2024 05:04:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.F0.09800.1D1E2376; Tue, 12 Nov 2024 14:04:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241111123656epcas5p20cac863708cd83d1fdbb523625665273~G6jQl8uM12592225922epcas5p2C;
	Mon, 11 Nov 2024 12:36:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241111123656epsmtrp112b31db35f5c7f16ceffa6ce87659d60~G6jQk5pd01738917389epsmtrp14;
	Mon, 11 Nov 2024 12:36:56 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-e0-6732e1d1b5c6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6D.A6.35203.86AF1376; Mon, 11 Nov 2024 21:36:56 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241111123655epsmtip187b58a3df07ff2e517ed92eb61d2749b~G6jPbwdms0368203682epsmtip1H;
	Mon, 11 Nov 2024 12:36:55 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH liburing] test: add test cases for hybrid iopoll
Date: Mon, 11 Nov 2024 20:36:50 +0800
Message-ID: <20241111123650.1857526-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmhu7Fh0bpBmuf6VrMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj3+Wz
	LAWvSiq+Nn1mb2C8HdHFyMkhIWAi0fehmbGLkYtDSGA3o8TirzNYIZxPjBLzvtyFynxjlDi0
	4zIbTEvH3y6oqr2MEm//fGaCcH4wSmxasZoZpIpNQEli/5YPjCC2iIC2xOvHU1m6GDk4mAWi
	JF6s5QYJCws4SCw90cQOYrMIqErcm/2GCaSEV8Ba4vzWcohd8hKLdywHm8grIChxcuYTFhCb
	GSjevHU2M0TNKXaJxwfEIWwXiUe/r7FA2MISr45vYYewpSRe9rdB2fkSk7+vZ4SwayTWbX4H
	VW8t8e/KHqgrNSXW79KHCMtKTD21jgliLZ9E7+8nTBBxXokd82BsJYklR1ZAjZSQ+D1hESvI
	GAkBD4nlpwxBTCGBWInTPRUTGOVnIfllFpJfZiHsXcDIvIpRMrWgODc9tdi0wDgvtRweqcn5
	uZsYwWlQy3sH46MHH/QOMTJxMB5ilOBgVhLh1fDXTxfiTUmsrEotyo8vKs1JLT7EaAoM34nM
	UqLJ+cBEnFcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA9P2V9ni
	nics83K3cj1QSWRstrmjkXZOp3nDuW33cjkahd2cbxyb2nDCdefJ20zbNVkK1qXf+iS7zF65
	0PpvzWWOT8JXxKzrle8FA3VpRGS+KGz5scem6cK2gMV7lmZ4HHfxqrnbpcpT1BAb2O6kURsu
	Ybb4vGfxyrroDfweURFvSzk+fEyNj9/mJBvAp5a6/8CBhmLX83oaWSueaN/Y1GO76N0D9iyP
	95Neyss8Xba4s2xvhcXb7ctVMudOq9FI3+dXlsliYVHt+eix6oxXPjsFX98PVo1ddlF90lmD
	lTvsJn47FvDnV86XFedYP2eG2BnstVf4d2yCzOLr9SpBD8Kf5abfvtahr3G4Y36oEktxRqKh
	FnNRcSIALbCzRAwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsWy7bCSnG7GL8N0g8UXRCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgyth3+SxLwauSiq9Nn9kbGG9HdDFyckgImEh0/O1i7WLk4hAS2M0osfT8ahaI
	hITEjkd/WCFsYYmV/56zQxR9Y5T48m0HM0iCTUBJYv+WD4xdjBwcIgK6Eo13FUDCzAIxEh/2
	TGAHsYUFHCSWnmgCs1kEVCXuzX7DBFLOK2AtcX5rOcR4eYnFO5aDTeQVEJQ4OfMJC8QYeYnm
	rbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnBYamnuYNy+
	6oPeIUYmDsZDjBIczEoivBr++ulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRm
	p6YWpBbBZJk4OKUamELvaa9rOFzveuH2EoaoY2vsi3dkFMZV6y7ccUJ10navA3O8d0YrXyzS
	r5R9cMmwL7PxyrUVK7/VHWJZ52M/xUDXu2vxlU2PFx7+p7SLSX3VjQyb5VqFu5ctcr+0Yl6W
	0hFBhRcHHSUuK62tLzkSdyEsZI2ZTtDRCY7FWu+j3zeo+jatbhQ+tle3aFbMBtZvpol/oqYp
	qqsHHeNUuJVweFFbblUnv+xKlQT2IBb2Qr9VwoeKG2bOMthyZsGuxH4+1ds3Pp61OZhizLNu
	ar6jx9X3FdI1b3h+eO94lXF03pc8dTO5vXtEPyXo1aYqbnm2VKU+wWvl0+NTnJPOb/+3229/
	54Wj6XdamR1SlAx3nVViKc5INNRiLipOBACASjZIugIAAA==
X-CMS-MailID: 20241111123656epcas5p20cac863708cd83d1fdbb523625665273
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241111123656epcas5p20cac863708cd83d1fdbb523625665273
References: <CGME20241111123656epcas5p20cac863708cd83d1fdbb523625665273@epcas5p2.samsung.com>

Add a test file for hybrid iopoll to make sure it works safe.Testcass
include basic read/write tests, and run in normal iopoll mode and
passthrough mode respectively.

Signed-off-by: hexue <xue01.he@samsung.com>
---
 man/io_uring_setup.2            |  10 +-
 src/include/liburing/io_uring.h |   3 +
 test/Makefile                   |   1 +
 test/iopoll-hybridpoll.c        | 544 ++++++++++++++++++++++++++++++++
 4 files changed, 557 insertions(+), 1 deletion(-)
 create mode 100644 test/iopoll-hybridpoll.c

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 2f87783..8cfafdc 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -78,7 +78,15 @@ in question. For NVMe devices, the nvme driver must be loaded with the
 parameter set to the desired number of polling queues. The polling queues
 will be shared appropriately between the CPUs in the system, if the number
 is less than the number of online CPU threads.
-
+.TP
+.B IORING_SETUP_HYBRID_IOPOLL
+This flag must setup with 
+.B IORING_SETUP_IOPOLL
+flag. hybrid poll is a new
+feature baed on iopoll, this could be a suboptimal solution when running
+on a single thread, it offers higher performance than IRQ and lower CPU
+utilization than polling. Similarly, this feature also requires the devices
+to support polling configuration.
 .TP
 .B IORING_SETUP_SQPOLL
 When this flag is specified, a kernel thread is created to perform
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 20bc570..d16364c 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -200,6 +200,9 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
 
+/* Use hybrid poll in iopoll process */
+#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/test/Makefile b/test/Makefile
index dfbbcbe..ea9452c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -116,6 +116,7 @@ test_srcs := \
 	iopoll.c \
 	iopoll-leak.c \
 	iopoll-overflow.c \
+	iopoll-hybridpoll.c \
 	io_uring_enter.c \
 	io_uring_passthrough.c \
 	io_uring_register.c \
diff --git a/test/iopoll-hybridpoll.c b/test/iopoll-hybridpoll.c
new file mode 100644
index 0000000..d7c08ae
--- /dev/null
+++ b/test/iopoll-hybridpoll.c
@@ -0,0 +1,544 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: basic read/write tests with 
+ * hybrid polled IO, include iopoll and io_uring
+ * passthrough.
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <poll.h>
+#include <sys/eventfd.h>
+#include <sys/resource.h>
+#include "helpers.h"
+#include "liburing.h"
+#include "../src/syscall.h"
+#include "nvme.h"
+
+#define FILE_SIZE	(128 * 1024)
+#define BS		4096
+#define BUFFERS		(FILE_SIZE / BS)
+
+static struct iovec *vecs;
+static int no_pt, no_iopoll;
+
+static int fill_pattern(int tc)
+{
+	unsigned int val, *ptr;
+	int i, j;
+	int u_in_buf = BS / sizeof(val);
+
+	val = (tc / 2) * FILE_SIZE;
+	for (i = 0; i < BUFFERS; i++) {
+		ptr = vecs[i].iov_base;
+		for (j = 0; j < u_in_buf; j++) {
+			*ptr = val;
+			val++;
+			ptr++;
+		}
+	}
+
+	return 0;
+}
+
+static int verify_buf(int tc, void *buf, off_t off)
+{
+	int i, u_in_buf = BS / sizeof(unsigned int);
+	unsigned int *ptr;
+
+	off /= sizeof(unsigned int);
+	off += (tc / 2) * FILE_SIZE;
+	ptr = buf;
+	for (i = 0; i < u_in_buf; i++) {
+		if (off != *ptr) {
+			fprintf(stderr, "Found %u, wanted %llu\n", *ptr,
+					(unsigned long long) off);
+			return 1;
+		}
+		ptr++;
+		off++;
+	}
+
+	return 0;
+}
+
+static int __test_io_uring_passthrough_io(const char *file, struct io_uring *ring, int tc, int write,
+		     int sqthread, int fixed, int nonvec)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct nvme_uring_cmd *cmd;
+	int open_flags;
+	int do_fixed;
+	int i, ret, fd = -1;
+	off_t offset;
+	__u64 slba;
+	__u32 nlb;
+
+	if (write)
+		open_flags = O_WRONLY;
+	else
+		open_flags = O_RDONLY;
+
+	if (fixed) {
+		ret = t_register_buffers(ring, vecs, BUFFERS);
+		if (ret == T_SETUP_SKIP)
+			return 0;
+		if (ret != T_SETUP_OK) {
+			fprintf(stderr, "buffer reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		if (errno == EACCES || errno == EPERM)
+			return T_EXIT_SKIP;
+		perror("file open");
+		goto err;
+	}
+
+	if (sqthread) {
+		ret = io_uring_register_files(ring, &fd, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	if (write)
+		fill_pattern(tc);
+
+	offset = 0;
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "sqe get failed\n");
+			goto err;
+		}
+		if (write) {
+			int use_fd = fd;
+
+			do_fixed = fixed;
+
+			if (sqthread)
+				use_fd = 0;
+			if (fixed && (i & 1))
+				do_fixed = 0;
+			if (do_fixed) {
+				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
+								vecs[i].iov_len,
+								offset, i);
+				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else if (nonvec) {
+				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
+							vecs[i].iov_len, offset);
+				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else {
+				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
+								offset);
+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+			}	
+		} else {
+			int use_fd = fd;
+
+			do_fixed = fixed;
+
+			if (sqthread)
+				use_fd = 0;
+			if (fixed && (i & 1))
+				do_fixed = 0;
+			if (do_fixed) {
+				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
+								vecs[i].iov_len,
+								offset, i);
+				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else if (nonvec) {
+				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
+							vecs[i].iov_len, offset);
+				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else {
+				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
+								offset);
+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+			}
+		}
+		sqe->opcode = IORING_OP_URING_CMD;
+		if (do_fixed)
+			sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
+		sqe->user_data = ((uint64_t)offset << 32) | i;
+		if (sqthread)
+			sqe->flags |= IOSQE_FIXED_FILE;
+
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+		cmd->opcode = write ? nvme_cmd_write : nvme_cmd_read;
+
+		slba = offset >> lba_shift;
+		nlb = (BS >> lba_shift) - 1;
+
+		/* cdw10 and cdw11 represent starting lba */
+		cmd->cdw10 = slba & 0xffffffff;
+		cmd->cdw11 = slba >> 32;
+		/* cdw12 represent number of lba's for read/write */
+		cmd->cdw12 = nlb;
+		if (do_fixed || nonvec) {
+			cmd->addr = (__u64)(uintptr_t)vecs[i].iov_base;
+			cmd->data_len = vecs[i].iov_len;
+		} else {
+			cmd->addr = (__u64)(uintptr_t)&vecs[i];
+			cmd->data_len = 1;
+		}
+		cmd->nsid = nsid;
+
+		offset += BS;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != BUFFERS) {
+		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
+		goto err;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			goto err;
+		}
+		if (cqe->res != 0) {
+			if (!no_pt) {
+				no_pt = 1;
+				goto skip;
+			}
+			fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+		if (!write) {
+			int index = cqe->user_data & 0xffffffff;
+			void *buf = vecs[index].iov_base;
+			off_t voff = cqe->user_data >> 32;
+
+			if (verify_buf(tc, buf, voff))
+				goto err;
+		}
+	}
+
+	if (fixed) {
+		ret = io_uring_unregister_buffers(ring);
+		if (ret) {
+			fprintf(stderr, "buffer unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+	if (sqthread) {
+		ret = io_uring_unregister_files(ring);
+		if (ret) {
+			fprintf(stderr, "file unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+skip:
+	close(fd);
+	return 0;
+err:
+	if (fd != -1)
+		close(fd);
+	return 1;
+}
+
+static int test_io_uring_passthrough(const char *file, int tc, int write, int sqthread,
+		   int fixed, int nonvec)
+{
+	struct io_uring ring;
+	int ret, ring_flags = 0;
+
+	ring_flags |= IORING_SETUP_SQE128;
+	ring_flags |= IORING_SETUP_CQE32;
+	ring_flags |= IORING_SETUP_HYBRID_IOPOLL;
+
+	if (sqthread)
+		ring_flags |= IORING_SETUP_SQPOLL;
+
+	ret = t_create_ring(64, &ring, ring_flags);
+	if (ret == T_SETUP_SKIP)
+		return 0;
+	if (ret != T_SETUP_OK) {
+		if (ret == -EINVAL) {
+			no_pt = 1;
+			return T_SETUP_SKIP;
+		}
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = __test_io_uring_passthrough_io(file, &ring, tc, write, sqthread, fixed, nonvec);
+	io_uring_queue_exit(&ring);
+
+	return ret;
+}
+
+static int provide_buffers(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, i;
+
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
+						vecs[i].iov_len, 1, 1, i);
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != BUFFERS) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (cqe->res < 0) {
+			fprintf(stderr, "cqe->res=%d\n", cqe->res);
+			return 1;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+static int __test_iopoll_io(const char *file, struct io_uring *ring, int write, int sqthread,
+		     int fixed, int buf_select)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int open_flags;
+	int i, fd = -1, ret;
+	off_t offset;
+
+	if (buf_select) {
+		write = 0;
+		fixed = 0;
+	}
+	if (buf_select && provide_buffers(ring))
+		return 1;
+
+	if (write)
+		open_flags = O_WRONLY;
+	else
+		open_flags = O_RDONLY;
+	open_flags |= O_DIRECT;
+
+	if (fixed) {
+		ret = t_register_buffers(ring, vecs, BUFFERS);
+		if (ret == T_SETUP_SKIP)
+			return 0;
+		if (ret != T_SETUP_OK) {
+			fprintf(stderr, "buffer reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+	fd = open(file, open_flags);
+	if (fd < 0) {
+		if (errno == EINVAL || errno == EPERM || errno == EACCES)
+			return 0;
+		perror("file open");
+		goto err;
+	}
+	if (sqthread) {
+		ret = io_uring_register_files(ring, &fd, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	offset = 0;
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "sqe get failed\n");
+			goto err;
+		}
+		offset = BS * (rand() % BUFFERS);
+		if (write) {
+			int do_fixed = fixed;
+			int use_fd = fd;
+
+			if (sqthread)
+				use_fd = 0;
+			if (fixed && (i & 1))
+				do_fixed = 0;
+			if (do_fixed) {
+				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
+								vecs[i].iov_len,
+								offset, i);
+			} else {
+				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
+								offset);
+			}
+		} else {
+			int do_fixed = fixed;
+			int use_fd = fd;
+
+			if (sqthread)
+				use_fd = 0;
+			if (fixed && (i & 1))
+				do_fixed = 0;
+			if (do_fixed) {
+				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
+								vecs[i].iov_len,
+								offset, i);
+			} else {
+				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
+								offset);
+			}
+
+		}
+		if (sqthread)
+			sqe->flags |= IOSQE_FIXED_FILE;
+		if (buf_select) {
+			sqe->flags |= IOSQE_BUFFER_SELECT;
+			sqe->buf_group = buf_select;
+			sqe->user_data = i;
+		}
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != BUFFERS) {
+		ret = io_uring_peek_cqe(ring, &cqe);
+		if (!ret && cqe->res == -EOPNOTSUPP) {
+			no_iopoll = 1;
+			io_uring_cqe_seen(ring, cqe);
+			goto out;
+		}
+		fprintf(stderr, "submit got %d, wanted %d\n", ret, BUFFERS);
+		goto err;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			goto err;
+		} else if (cqe->res == -EOPNOTSUPP) {
+			fprintf(stdout, "File/device/fs doesn't support polled IO\n");
+			no_iopoll = 1;
+			goto out;
+		} else if (cqe->res != BS) {
+			fprintf(stderr, "cqe res %d, wanted %d\n", cqe->res, BS);
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (fixed) {
+		ret = io_uring_unregister_buffers(ring);
+		if (ret) {
+			fprintf(stderr, "buffer unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+	if (sqthread) {
+		ret = io_uring_unregister_files(ring);
+		if (ret) {
+			fprintf(stderr, "file unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+out:
+	close(fd);
+	return 0;
+err:
+	if (fd != -1)
+		close(fd);
+	return 1;
+}
+
+static int test_iopoll(const char *fname, int write, int sqthread, int fixed,
+		   int buf_select, int defer)
+{
+	struct io_uring ring;
+	int ret, ring_flags = IORING_SETUP_IOPOLL | IORING_SETUP_HYBRID_IOPOLL;
+
+	if (no_iopoll)
+		return 0;
+
+	if (defer)
+		ring_flags |= IORING_SETUP_SINGLE_ISSUER |
+			      IORING_SETUP_DEFER_TASKRUN;
+
+	ret = t_create_ring(64, &ring, ring_flags);
+	if (ret == T_SETUP_SKIP)
+		return 0;
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	ret = __test_iopoll_io(fname, &ring, write, sqthread, fixed, buf_select);
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, ret;
+	char buf[256];
+	char *fname;
+
+	if (argc > 1) {
+		fname = argv[1];
+	} else {
+		srand((unsigned)time(NULL));
+		snprintf(buf, sizeof(buf), ".basic-rw-%u-%u",
+			(unsigned)rand(), (unsigned)getpid());
+		fname = buf;
+		t_create_file(fname, FILE_SIZE);
+	}
+
+	vecs = t_create_buffers(BUFFERS, BS);
+
+	for (i = 0; i < 16; i++) {
+		int write = (i & 1) != 0;
+		int sqthread = (i & 2) != 0;
+		int fixed = (i & 4) != 0;
+		int buf_select = (i & 8) != 0;
+		int defer = (i & 16) != 0;
+		int nonvec = buf_select;
+
+		ret = test_iopoll(fname, write, sqthread, fixed, buf_select, defer);
+		if (ret) {
+			fprintf(stderr, "test_iopoll_io failed %d/%d/%d/%d/%d\n",
+				write, sqthread, fixed, buf_select, defer);
+			goto err;
+		}
+		if (no_iopoll)
+			break;
+
+		ret = test_io_uring_passthrough(fname, i, write, sqthread, fixed, nonvec);
+		if (no_pt)
+			break;
+		if (ret) {
+			fprintf(stderr, "test_io_uring_passthrough_io failed %d/%d/%d/%d\n",
+				write, sqthread, fixed, nonvec);
+			goto err;
+		}
+	}
+
+	if (fname != argv[1])
+		unlink(fname);
+	return ret;
+err:
+	if (fname != argv[1])
+		unlink(fname);
+	return T_EXIT_FAIL;
+}
-- 
2.34.1


