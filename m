Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC67058125A
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiGZLvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiGZLvY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:51:24 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A0932ED1
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:51:21 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220726115120epoutp04f2bd0dc85582b2df4a084879497d7f2b~FXs7QGTf83212932129epoutp04i
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:51:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220726115120epoutp04f2bd0dc85582b2df4a084879497d7f2b~FXs7QGTf83212932129epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836280;
        bh=kx85pLS45GqWj2EfzdAuR6iDYDiGVWfmEvcTBt7REaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vu+HWC+09Dj3TkiN3NGENw0e4gZOP2TSkMVE6xIfOTs3iPgOTDnAWZ4pMqP22rO6g
         5INYvj2hA/dLleyZbX/4b5PtrpRXQeEETrj3Qtd7xn5Ib9Y9zprPySzSVTzeZX3Fua
         CJp1GWZy98RhIawJzQ17tt0/3axmV0rnK6nViJ8g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220726115119epcas5p38a9a9c61c64c78d4121cf8c0d8281583~FXs6phRkW3057330573epcas5p31;
        Tue, 26 Jul 2022 11:51:19 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LsZxc4HkKz4x9Q0; Tue, 26 Jul
        2022 11:51:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.E9.09639.135DFD26; Tue, 26 Jul 2022 20:51:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c~FW_ml1qfp2226722267epcas5p3W;
        Tue, 26 Jul 2022 10:58:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220726105816epsmtrp271e819bf9253d5cf0c708b35dd8b50f7~FW_mkvMI93043430434epsmtrp2a;
        Tue, 26 Jul 2022 10:58:16 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-26-62dfd531dfb1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.6E.08802.8C8CFD26; Tue, 26 Jul 2022 19:58:16 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105816epsmtip157fcf9dbb6646880d7ab204b8b580bbb~FW_l1Cbdh2376423764epsmtip1E;
        Tue, 26 Jul 2022 10:58:15 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 4/5] test: add io_uring passthrough test
Date:   Tue, 26 Jul 2022 16:22:29 +0530
Message-Id: <20220726105230.12025-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmlq7h1ftJBge/q1isufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGf8nN3OUrDboeLT9E62BsbHBl2MnBwSAiYS
        J0+2MHYxcnEICexmlNjReo4JwvnEKNE0czUrhPOZUWJ932RWmJa9F/uYIRK7GCXaFp9iB0kI
        CbQySTz5BjaXTUBb4tXbG8wgtoiAsMT+jlYWEJtZIEpizauzjCC2sICLRMPSZWwgNouAqsSp
        Y1vA4rwCNhKfenZALZOXWL3hANgcTgFbiaaXU8AukhBYxC7x8OcOJogiF4kZk46zQdjCEq+O
        b2GHsKUkPr/bCxXPltj08CdUfYHEkRe9zBC2vUTrqX4gmwPoOE2J9bv0IcKyElNPrWOCuJlP
        ovf3E6hWXokd82BsVYm/926zQNjSEjffXYWyPSTObjsEDcYJjBIH7yxmmcAoNwthxQJGxlWM
        kqkFxbnpqcWmBcZ5qeXwWEvOz93ECE5QWt47GB89+KB3iJGJg/EQowQHs5IIb0L0/SQh3pTE
        yqrUovz4otKc1OJDjKbAAJzILCWanA9MkXkl8YYmlgYmZmZmJpbGZoZK4rxeVzclCQmkJ5ak
        ZqemFqQWwfQxcXBKNTBxiP/Nmuu8YtMbF2NNlovrRZ5xdf/NkTjLJl++0Uduu3WdzHfvwxeT
        VoeH8uw7IL0qRLr4rSlL69bbta9OlFycJPxzzuxvKsmqjPv/+TwOd5rF4pJyOdvrHtu8q0tm
        f0hhDV+tsPWg4TSZWMnTy003XeRdler6pnA7b890u2kiLN8zQ75wLRXz3bTpCcvWZ+4lGjWn
        jk4I4Zl8svLMg8BDaQ4Ks38J37m2o2edyT2+3K87u83P6rK7NuyQ+toqLbT8r/DTyXJ+K7/7
        fVh57vln+4/f1M13xKxuWiodXSP454/DvJ8Knh7fbOwULZWX1UipX8l9Iedmsv3sVsnONdvO
        mbzXEw/wkFlwsdW37HqIEktxRqKhFnNRcSIAdcymRdkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnO6JE/eTDM73alusufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZfyc3c5SsNuh4tP0
        TrYGxscGXYycHBICJhJ7L/YxdzFycQgJ7GCUeH98CZDDAZSQlli4PhGiRlhi5b/n7BA1zUwS
        n6a3sYMk2AS0JV69vcEMYosAFe3vaGUBsZkFYiSmHjkMZgsLuEg0LF3GBmKzCKhKnDq2hRHE
        5hWwkfjUs4MVYoG8xOoNB8DmcArYSjS9nAIWFwKq+XvoGNsERr4FjAyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCA0hLawfjnlUf9A4xMnEwHmKU4GBWEuFNiL6fJMSbklhZlVqU
        H19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANTp+eMs9/1Y1PihBr7Z20N
        UenYp3I98Lq9w+vj5qtOb0tTnJ9QrpzT/OzX6hY1LenYp+Iz0i5EPVt6hsPH68rb/3fW3zd3
        E3vzd0uBwwEp994W55NBJ+ULJdJOGfaE1Yt7GYhfcVVpebDUcJfWfIEvTMdYnqRVcFVoCXlp
        lSie37jix262R/nnHzCdr/5gPkOEPdBqytHPYRnJZ6MmOnza+n8u96H0LbIu0yQrlJeeeRuV
        +DzVc3dbcsCNhft/MXM7n/HOjrztUprmdt9vzfSKCdMZK3xc6wI/Knbes576Ry1Bl+3r3HXf
        vB3D0t8xih56m9rRrtp+aEnhV3bORcqn/l+q2vD/6PKb60RiJj1WYinOSDTUYi4qTgQAK9P7
        Vo8CAAA=
X-CMS-MailID: 20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

