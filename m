Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3E657AFB6
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiGTEK0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTEKZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:10:25 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE0250721
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:10:24 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220720041022epoutp04efa9605992cc664d9e4ed4d93c74af63~DbivvCaWB0335303353epoutp045
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:10:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220720041022epoutp04efa9605992cc664d9e4ed4d93c74af63~DbivvCaWB0335303353epoutp045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290222;
        bh=9bXRCeJaPpH6G1/gAYRWb2N6jVpde/QgWluyBHJHwIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMo+cMavQ7v78+0pPTra21Qg86p0v84nFiWCeu1byxVPXhrLWPrDfHCjuBXpSVLcX
         xJmFejMbvvYoHtaMx4tOVLJEsx4Cv4EDFtX5Ehx5w9QEDWY0rc43PdAXK3RyFoGfAr
         /6e4R8sYhWSDxsHLxjYRtD5kXvzmLlGsO5TnyKEA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220720041022epcas5p282c1d02ab035ec90698a6fc141ad1c66~DbiveVQFT1619516195epcas5p2W;
        Wed, 20 Jul 2022 04:10:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lnj0W6LLdz4x9Px; Wed, 20 Jul
        2022 04:10:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.AA.09639.82087D26; Wed, 20 Jul 2022 13:10:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220719135836epcas5p3f28b20cab964ced538d5a7fdfe367bb4~DP7DgaOdl2074120741epcas5p3K;
        Tue, 19 Jul 2022 13:58:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220719135836epsmtrp21d4ba601f29470ec5f10f380ee620405~DP7DfqY7C1903019030epsmtrp24;
        Tue, 19 Jul 2022 13:58:36 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-2c-62d780282fc2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.3D.08802.C88B6D26; Tue, 19 Jul 2022 22:58:36 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135835epsmtip12c66f8e0eff39b8ba893d5d4c607441c~DP7CVr1pk2149321493epsmtip1d;
        Tue, 19 Jul 2022 13:58:35 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 4/5] test: add io_uring passthrough test
Date:   Tue, 19 Jul 2022 19:22:33 +0530
Message-Id: <20220719135234.14039-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7bCmhq5Gw/Ukg+dXBCzWXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDUq2yYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGyzat
        gt0OFXMWvmdqYHxs0MXIwSEhYCJxandGFyMnh5DAbkaJF8dcuxi5gOxPjBKzl65khXA+M0pM
        vrONDabh+ARViPguRonjP5vZIJxWJokn134xg4xiE9CWePX2BpgtIiAssb+jlQWkiFmgnVHi
        w4Ij7CAJYQFHiVmfb7CB2CwCqhIfzn9gAbF5BWwkll45yQhiSwjIS6zecABsEKeArcSH7S+Z
        QQZJCBxil1g//TgLRJGLROfP/cwQtrDEq+Nb2CFsKYnP7/ayQdjZEpse/mSCsAskjrzohaq3
        l2g91c8M8hqzgKbE+l36EGFZiamn1oGVMwvwSfT+fgLVyiuxYx6MrSrx995tqBOkJW6+uwpl
        e0gsPvOQCRIqExgleg+uZ5rAKDcLYcUCRsZVjJKpBcW56anFpgXGeanl8DhLzs/dxAhOYlre
        OxgfPfigd4iRiYPxEKMEB7OSCO/TwutJQrwpiZVVqUX58UWlOanFhxhNgQE4kVlKNDkfmEbz
        SuINTSwNTMzMzEwsjc0MlcR5va5uShISSE8sSc1OTS1ILYLpY+LglGpgkla5zPedhfHVksAb
        8Yf3ljmlnNgnGeXSoWG5ecbd73uzV6z9udd7hXiXxXG9iMeNIp7aTtvvz97Q6Zm7xXdfwBXF
        nqWtx2JuutZ90RFX8lS2SXu+/v43sw/p/xOafpzSb9GfvehB29TusywSYg93HJxmpnskf3rA
        nyc5x3T+1PTNkFnn0uqrorSwUvL9jpjole5fLm891LJiY1dIa7KY4euLoavnO7AFb4hl17sc
        5bpkygWf0Kdlr6Yve8f49efRGbsXtplMyplX5LRgou7z3cuX5J0/szu7cGvflXezfhbYnFf+
        7/x/yct6qYcm0w6nV0h9XLCjVT/tZKHjrl+hyx/sN02pbji49vCnyF0TLv5SYinOSDTUYi4q
        TgQAtRYNf+sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42LZdlhJTrdnx7Ukg2UdqhZrrvxmt1h9t5/N
        4t62X2wW71rPsVgc/f+WzeL2pOksDmwel8+Weqzd+4LRo2/LKkaPo/sXsXl83iQXwBrFZZOS
        mpNZllqkb5fAlfGyTatgt0PFnIXvmRoYHxt0MXJwSAiYSByfoNrFyMUhJLCDUeJHx0E2iLi0
        xML1iV2MnECmsMTKf8/ZQWwhgWYmieapqSA2m4C2xKu3N5hBbBGgmv0drSwgc5gFehklVv4/
        wgSSEBZwlJj1+QYbiM0ioCrx4fwHFhCbV8BGYumVk4wQC+QlVm84ADaIU8BW4sP2l8wQy2wk
        vt2ZyT6BkW8BI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgINPS2sG4Z9UHvUOM
        TByMhxglOJiVRHhFai8nCfGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1
        CCbLxMEp1cAkl7fDp+WHpYYc25/dOSKdP5mvhUyQfx6Sqfx9RtrdptZy6eXnNaUllzXNSjd6
        ePKU3RG3+2cr3nff7ncvOq9WGv9ZhsvG7sUjE8spz/L8r+w6I+p54+nT/aFS+3dumq1x6Em9
        4e9vP7MUpxgzty7s2tKRfCzF6Hdw5+TZ/2v5p8clffwXWFS9oHzlwuOnFnZLrXumsTNpZSHj
        E9Ofi3ffvuLzvLHPOLtub46G+kKZRSuUJvAf5rR/0vt9/6R/YorKhyInc2eGPL4/Y7PMp8ZX
        EfeeVOndMX55KCb/UW/TCsVzk+OuTTrycvqFF/NVUnueSE6a3XlMI4vxwfaovdknZfs99v8t
        M890fv3/49EKeyWW4oxEQy3mouJEAPgILP6hAgAA
X-CMS-MailID: 20220719135836epcas5p3f28b20cab964ced538d5a7fdfe367bb4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135836epcas5p3f28b20cab964ced538d5a7fdfe367bb4
References: <20220719135234.14039-1-ankit.kumar@samsung.com>
        <CGME20220719135836epcas5p3f28b20cab964ced538d5a7fdfe367bb4@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a way to test uring passthrough commands, which was added
with 5.19 kernel. This requires nvme-ns character device (/dev/ngXnY)
as filename argument. It runs a combination of read/write tests with
sqthread poll, vectored and non-vectored commands, fixed I/O buffers.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 test/Makefile               |   1 +
 test/io_uring_passthrough.c | 319 ++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+)
 create mode 100644 test/io_uring_passthrough.c

diff --git a/test/Makefile b/test/Makefile
index 45674c3..8cafcfd 100644
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
index 0000000..2e2b806
--- /dev/null
+++ b/test/io_uring_passthrough.c
@@ -0,0 +1,319 @@
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
+		/* 80 bytes for NVMe uring passthrough command */
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
+	if (argc < 2) {
+		printf("%s: requires NVMe character device\n", argv[0]);
+		return T_EXIT_SKIP;
+	}
+
+	fname = argv[1];
+	ret = fio_nvme_get_info(fname);
+
+	if (ret) {
+		fprintf(stderr, "failed to fetch device info: %d\n", ret);
+		goto err;
+	}
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

