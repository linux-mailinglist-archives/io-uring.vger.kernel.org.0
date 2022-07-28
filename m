Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F516583E72
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiG1MQn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiG1MQm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:16:42 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D246DAC
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:16:38 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220728121636epoutp02f99eee71f2715ef3a43f51445a32b42f~F-Vkf9s3u1026010260epoutp02e
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:16:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220728121636epoutp02f99eee71f2715ef3a43f51445a32b42f~F-Vkf9s3u1026010260epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659010597;
        bh=sE/z3xtqwZWTpBcIaTqpG/3Wq00FT35ZieEKsp9umsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns9qDqCD5+LeuEzG5HVEjs8coS4URaOnPxwDCBxYWvXzDQF49CO1DWvkE4ASwrjqp
         dg37Hmf4G1reXa4kDuU7/g46rsHBINt9EJhA31uNlWzakjv59I2z4JaAS4SEDwGOsp
         PD420dD6OKZzBnSd9v8nST5yrfIFZI4Bs5FQ0e/k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220728121635epcas5p49c218d5f2a7b74e3202f0ee476c15bed~F-VjatynS0689006890epcas5p4B;
        Thu, 28 Jul 2022 12:16:35 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LtqPs3LKsz4x9Q0; Thu, 28 Jul
        2022 12:16:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.7C.09639.F1E72E26; Thu, 28 Jul 2022 21:16:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220728093907epcas5p353489ffcc9bed6f3a5c64b4679ad11ee~F9MEbEZuD2636626366epcas5p3C;
        Thu, 28 Jul 2022 09:39:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220728093907epsmtrp175c56156546969e7fe08845060a8721b~F9MEaMIi51674116741epsmtrp1g;
        Thu, 28 Jul 2022 09:39:07 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-3e-62e27e1fd4c5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.56.08905.B3952E26; Thu, 28 Jul 2022 18:39:07 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093906epsmtip18d4c3fe109d2677fe1c391386340963a~F9MDKPecr1442314423epsmtip1O;
        Thu, 28 Jul 2022 09:39:06 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 4/5] test: add io_uring passthrough test
Date:   Thu, 28 Jul 2022 15:03:26 +0530
Message-Id: <20220728093327.32580-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmlq583aMkg8n/jS3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjNO3t7AWrDRvuLqn2amBsY/+l2MHBwSAiYS
        Teecuhi5OIQEdjNKbFt7kwnC+cQo8fLiExYI5xujxLWDD4EcTrCOQ6tesEMk9jJKPOi9C+W0
        Mkncuv0TrIpNQFvi1dsbzCC2iICwxP6OVrA4s0CUxJpXZxlBbGEBF4l/Lx6xgtgsAqoSfZN/
        sIPYvAI2EssfvmKD2CYvsXrDAbA5nAK2Ep8enWAEWSYhsIhd4vzkD6wQRS4Slx4egjpPWOLV
        8S3sELaUxMv+Nig7W2LTw59MEHaBxJEXvcwQtr1E66l+ZlBgMAtoSqzfpQ8RlpWYemodE8TN
        fBK9v59AtfJK7JgHY6tK/L13G2qttMTNd1ehbA+JnYfOsEECZQKjxIc7CxknMMrNQlixgJFx
        FaNkakFxbnpqsWmBcV5qOTzWkvNzNzGCE5SW9w7GRw8+6B1iZOJgPMQowcGsJMKbEH0/SYg3
        JbGyKrUoP76oNCe1+BCjKTAAJzJLiSbnA1NkXkm8oYmlgYmZmZmJpbGZoZI4r9fVTUlCAumJ
        JanZqakFqUUwfUwcnFINTBo7u4VTzVlmxe61fPzAoot50uuT0blZt4oPBCzy4lYNqj5k/W3R
        m+WerRs09jitvHvEWdI/ifNwz9G1nuYP7drC3Dmn5/reak38z7k0s0r68uGeJxoiG+qPJPqt
        Sn/+4avUrCDjPY/W3tv412r7+7lBXx5Fhv89s75pSdpEQ+5Q1R3buDWkZp5z0f3g7ytduyw6
        JUFlyYWPtxWvV87XzZ9Qx6KdcoPP/9iXA62ppvkOjDpHl/n3yC6eXGqr5/tChCn1zrxnS0Il
        fTkM9kuJqKWZyx++UR04ZxmrYeceYz1XoezixXKb+neszf8VeFs5Rfp9TND+W8+7609/s9bt
        7/huer1jTlzLuhNa90XnKLEUZyQaajEXFScCAC9swm7ZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnK515KMkg9//jSzWXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4Mk7e3sBasNG+4uqf
        ZqYGxj/6XYycHBICJhKHVr1g72Lk4hAS2M0o0dd0maWLkQMoIS2xcH0iRI2wxMp/z6Fqmpkk
        3v94wwiSYBPQlnj19gYziC0CVLS/o5UFxGYWiJGYeuQwmC0s4CLx78UjVhCbRUBVom/yD3YQ
        m1fARmL5w1dsEAvkJVZvOAA2h1PAVuLToxNg84WAal5P2s40gZFvASPDKkbJ1ILi3PTcYsMC
        w7zUcr3ixNzi0rx0veT83E2M4ADS0tzBuH3VB71DjEwcjIcYJTiYlUR4E6LvJwnxpiRWVqUW
        5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAxN7IuNWmufLe1Y6X/2OO
        sB5cwJPjWDzl4Fn/7gPakcsZnbKlHK723t+Y6/FvSlTR+5lHDy9Nju1umvT4gPBPm9p7Nq1K
        WWHSMWtajj5ObTuQKhfNrerI5WcVbbDHJfP7J5W/5vqsNnkFItf+RVufqL11a5ro4UMCGmJr
        IpasEOhhm8Tdymb5ei/r25XOWoKxU1JcPwg0MRS8/vCcJXNfx/XrBdeChLrVOe/M+yVb6mkg
        tPhGZcfExd0t3kvKakXPCvzrC3vCWs9psnOPd1HUjdMzBcOn5XxaEn9MqfBGu73w5ehVEkWH
        BILfvozQnWB8T3l7Xu4Hxdurymbudnt5xP3wI5k1c9ouHQv0nftWiaU4I9FQi7moOBEAqVqO
        X48CAAA=
X-CMS-MailID: 20220728093907epcas5p353489ffcc9bed6f3a5c64b4679ad11ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093907epcas5p353489ffcc9bed6f3a5c64b4679ad11ee
References: <20220728093327.32580-1-ankit.kumar@samsung.com>
        <CGME20220728093907epcas5p353489ffcc9bed6f3a5c64b4679ad11ee@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a way to test uring passthrough commands, which was added
with 5.19 kernel. This requires nvme-ns character device (/dev/ngXnY)
as filename argument. It runs a combination of read/write tests with
sqthread poll, vectored and non-vectored commands, fixed I/O buffers.

Tested-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 test/Makefile               |   1 +
 test/io_uring_passthrough.c | 314 ++++++++++++++++++++++++++++++++++++
 2 files changed, 315 insertions(+)
 create mode 100644 test/io_uring_passthrough.c

diff --git a/test/Makefile b/test/Makefile
index a36ddb3..418c11c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -90,6 +90,7 @@ test_srcs := \
 	io-cancel.c \
 	iopoll.c \
 	io_uring_enter.c \
+	io_uring_passthrough.c \
 	io_uring_register.c \
 	io_uring_setup.c \
 	lfs-openat.c \
diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
new file mode 100644
index 0000000..03043b7
--- /dev/null
+++ b/test/io_uring_passthrough.c
@@ -0,0 +1,314 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: basic read/write tests for io_uring passthrough commands
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "nvme.h"
+
+#define FILE_SIZE	(256 * 1024)
+#define BS		8192
+#define BUFFERS		(FILE_SIZE / BS)
+
+static struct iovec *vecs;
+
+/*
+ * Each offset in the file has the ((test_case / 2) * FILE_SIZE)
+ * + (offset / sizeof(int)) stored for every
+ * sizeof(int) address.
+ */
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
+			fprintf(stderr, "Found %u, wanted %lu\n", *ptr, off);
+			return 1;
+		}
+		ptr++;
+		off++;
+	}
+
+	return 0;
+}
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
+static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
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
+#ifdef VERBOSE
+	fprintf(stdout, "%s: start %d/%d/%d/%d: ", __FUNCTION__, read,
+							sqthread, fixed,
+							nonvec);
+#endif
+	if (read)
+		open_flags = O_RDONLY;
+	else
+		open_flags = O_WRONLY;
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
+	if (!read)
+		fill_pattern(tc);
+
+	offset = 0;
+	for (i = 0; i < BUFFERS; i++) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "sqe get failed\n");
+			goto err;
+		}
+		if (read) {
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
+		}
+		sqe->opcode = IORING_OP_URING_CMD;
+		sqe->user_data = ((uint64_t)offset << 32) | i;
+		if (sqthread)
+			sqe->flags |= IOSQE_FIXED_FILE;
+
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+		cmd->opcode = read ? nvme_cmd_read : nvme_cmd_write;
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
+			fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
+			goto err;
+		}
+		io_uring_cqe_seen(ring, cqe);
+		if (read) {
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
+	close(fd);
+#ifdef VERBOSE
+	fprintf(stdout, "PASS\n");
+#endif
+	return 0;
+err:
+#ifdef VERBOSE
+	fprintf(stderr, "FAILED\n");
+#endif
+	if (fd != -1)
+		close(fd);
+	return 1;
+}
+
+static int test_io(const char *file, int tc, int read, int sqthread,
+		   int fixed, int nonvec)
+{
+	struct io_uring ring;
+	int ret, ring_flags = 0;
+
+	ring_flags |= IORING_SETUP_SQE128;
+	ring_flags |= IORING_SETUP_CQE32;
+
+	if (sqthread)
+		ring_flags |= IORING_SETUP_SQPOLL;
+
+	ret = t_create_ring(64, &ring, ring_flags);
+	if (ret == T_SETUP_SKIP)
+		return 0;
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = __test_io(file, &ring, tc, read, sqthread, fixed, nonvec);
+	io_uring_queue_exit(&ring);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, ret;
+	char *fname;
+
+	if (argc < 2)
+		return T_EXIT_SKIP;
+
+	fname = argv[1];
+	ret = nvme_get_info(fname);
+
+	if (ret)
+		return T_EXIT_SKIP;
+
+	vecs = t_create_buffers(BUFFERS, BS);
+
+	for (i = 0; i < 16; i++) {
+		int read = (i & 1) != 0;
+		int sqthread = (i & 2) != 0;
+		int fixed = (i & 4) != 0;
+		int nonvec = (i & 8) != 0;
+
+		ret = test_io(fname, i, read, sqthread, fixed, nonvec);
+		if (ret) {
+			fprintf(stderr, "test_io failed %d/%d/%d/%d\n",
+				read, sqthread, fixed, nonvec);
+			goto err;
+		}
+	}
+
+	return T_EXIT_PASS;
+err:
+	return T_EXIT_FAIL;
+}
-- 
2.17.1

