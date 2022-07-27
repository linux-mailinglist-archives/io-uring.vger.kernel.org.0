Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2A583294
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 20:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiG0S7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 14:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiG0S7O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 14:59:14 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3816F7CF
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:10:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220727180957epoutp01975cf68b2cbb9f043c295cac717caa61~Fwgyw0Dq_0571905719epoutp01w
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 18:09:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220727180957epoutp01975cf68b2cbb9f043c295cac717caa61~Fwgyw0Dq_0571905719epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658945397;
        bh=z93PsV4jdFI8Frz9jZLGquALLSOtUMkoEUTY/kGl/pw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OyPSUkrsZD1/6eMgHlM1m+iKAm8Z28R7hGfY0+nJwdUdQYhZoKfs710EzKGhWnFhR
         b4zsuO3sVzRKnwvLgqcxZHHwOg3B0A86TNDhSmoFIP88Nxy1Cz78dpZlTCok1TwKms
         bt4FajaqhEWRHnmU83Vh/TIvFiIhinfrnezsXaQ4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220727180956epcas5p31a39a8e95469d1c8d27ae8118c0433ca~FwgyRLstx2553625536epcas5p3E;
        Wed, 27 Jul 2022 18:09:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LtMJ226Rgz4x9Pp; Wed, 27 Jul
        2022 18:09:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.49.09566.27F71E26; Thu, 28 Jul 2022 03:09:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220727180953epcas5p2258e4614579c545b361aed53ba99af35~FwgvBcK-V2403824038epcas5p2u;
        Wed, 27 Jul 2022 18:09:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220727180953epsmtrp25a3830e71cfb66b48a523cb8fa095b0f~Fwgu-7rcA2827228272epsmtrp2M;
        Wed, 27 Jul 2022 18:09:53 +0000 (GMT)
X-AuditID: b6c32a4a-ba3ff7000000255e-a9-62e17f72328c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.AE.08802.17F71E26; Thu, 28 Jul 2022 03:09:53 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220727180952epsmtip1db34badb7cf79396944a6a67fa1934fd~FwguXOoxR2159221592epsmtip1k;
        Wed, 27 Jul 2022 18:09:52 +0000 (GMT)
Date:   Wed, 27 Jul 2022 23:34:26 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing v2 4/5] test: add io_uring passthrough test
Message-ID: <20220727180426.GA13647@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220726105230.12025-5-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmpm5R/cMkg+u/OS3WXPnNbrH6bj+b
        xbvWcywOzB6Xz5Z69G1ZxejxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGt6uT2Aou6FVcP7WGrYFxtUoXIweHhICJxMETEl2M
        XBxCArsZJTrb7jBBOJ8YJXpffWODcD4zSjyePA3I4QTr2Lv7BiNEYhejxNUFF5ghnGeMEs/m
        bGAHqWIRUJVYdPc7C8gONgFNiQuTS0FMESBz3gcWkApmAV2J5Xseg9nCAh4S7YdvMoGU8ALF
        V2xRBgnzCghKnJz5BKyEU8BW4sOWLUwgtqiAssSBbcfBDpUQOMUu0X+rhQXiNheJVw92MkPY
        whKvjm9hh7ClJD6/2wt1f7LEpZnnmCDsEonHew5C2fYSraf6mSFuy5BYePUEG4TNJ9H7+wkT
        JLR4JTrahCDKFSXuTXrKCmGLSzycsQTK9pA4u+0QNBAPM0rsvbaWcQKj3Cwk/8xCsgLCtpLo
        /NDEOgtoBbOAtMTyfxwQpqbE+l36CxhZVzFKphYU56anFpsWGOWllsNjODk/dxMjON1pee1g
        fPjgg94hRiYOxkOMEhzMSiK8CdH3k4R4UxIrq1KL8uOLSnNSiw8xmgIjZyKzlGhyPjDh5pXE
        G5pYGpiYmZmZWBqbGSqJ83pd3ZQkJJCeWJKanZpakFoE08fEwSnVwKQ0aQG7yNTFl/ykfscc
        WXr54GWVedqXE9949ivXffC+rcBlPbWg9NWVuml5M62FruQolE/zkXrt1HxbmOFC6ESX84qF
        8mKzncT1Jwn53pdybXhVu+ZT15dQmSeHjb0vxJ6vlVPi+m4W9SDWW8PZ2YVFVuSm4+ToCoEI
        IebfN6MMVIUv7WXjLshn4IlePyNNObItRm/LjUquRZP9NecrRrMlzLCvkxc6Z3Lkf8tOu12m
        r3Lm7PnXxXOoXtFlcu+1ff1aKmq2LQWPc3d+y8x0WNEScvVvq+Zqi61bCq8Vhqmn+d+Nc8xq
        36WlusPumrPpauVtFkcT4ydd38tXv9HRa+urnntrt1tMDfu5uLlXiaU4I9FQi7moOBEAkf2d
        CwAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnG5h/cMkg6/PRS3WXPnNbrH6bj+b
        xbvWcywOzB6Xz5Z69G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bD1e1MBU06FRc+XWZsYPyu
        2MXIySEhYCKxd/cNxi5GLg4hgR2MEpc2H2GFSIhLNF/7wQ5hC0us/PecHaLoCaPE44VbmEAS
        LAKqEovufmfpYuTgYBPQlLgwuRTEFAEy531gAalgFtCVWL7nMZgtLOAh0X74JhNICS9QfMUW
        ZYiJhxkleha9ZwSp4RUQlDg58wlUr5nEvM0PmUHqmQWkJZb/4wAJcwrYSnzYAnGAqICyxIFt
        x5kmMArOQtI9C0n3LITuBYzMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxggNYS2sH
        455VH/QOMTJxMB5ilOBgVhLhTYi+nyTEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTE
        ktTs1NSC1CKYLBMHp1QDU79vp5Wmzq0eqUpm5UN1/x5kXOtv6JiXU3Au/dcBkw8R79ZvKVi4
        dFa5l6tso+hh0diodUdEasLn6ay4y+v+sWhqzzbJ5Xwfdju+ZbLq5vvE+G5J3ESu0qmTOcKy
        rA0/sh6I2sHSwK9Z1KK2yuOd5MsQ35aUeAszHUHLd5smGMe9alM6v+PX1S9rbt+VPdceeXbN
        JFXlYn/H8pU6YTunzz/o5eyzT/mr9cvy/hVcTSvMXWZHqSxUk5XZHDWvUfBzgMqzj0fs0g4v
        eiaufuzjqf8fxZnC9IU3qrqxM3CcKve6p898dF+kWtjrsqjVkUvYD8bNDVp07bPGv91bzfuX
        r+0OCVyw40Z5X6nUZ7XXSizFGYmGWsxFxYkAMrIzrc8CAAA=
X-CMS-MailID: 20220727180953epcas5p2258e4614579c545b361aed53ba99af35
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_21039_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105816epcas5p3365fed54f9ba20518dd8019a50c6c27c@epcas5p3.samsung.com>
        <20220726105230.12025-5-ankit.kumar@samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_21039_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jul 26, 2022 at 04:22:29PM +0530, Ankit Kumar wrote:
>Add a way to test uring passthrough commands, which was added
>with 5.19 kernel. This requires nvme-ns character device (/dev/ngXnY)
>as filename argument. It runs a combination of read/write tests with
>sqthread poll, vectored and non-vectored commands, fixed I/O buffers.
>
>Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>---
> test/Makefile               |   1 +
> test/io_uring_passthrough.c | 319 ++++++++++++++++++++++++++++++++++++
> 2 files changed, 320 insertions(+)
> create mode 100644 test/io_uring_passthrough.c
>
>diff --git a/test/Makefile b/test/Makefile
>index a36ddb3..418c11c 100644
>--- a/test/Makefile
>+++ b/test/Makefile
>@@ -90,6 +90,7 @@ test_srcs := \
> 	io-cancel.c \
> 	iopoll.c \
> 	io_uring_enter.c \
>+	io_uring_passthrough.c \
> 	io_uring_register.c \
> 	io_uring_setup.c \
> 	lfs-openat.c \
>diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
>new file mode 100644
>index 0000000..2e2b806
>--- /dev/null
>+++ b/test/io_uring_passthrough.c
>@@ -0,0 +1,319 @@
>+/* SPDX-License-Identifier: MIT */
>+/*
>+ * Description: basic read/write tests for io_uring passthrough commands
>+ */
>+#include <errno.h>
>+#include <stdio.h>
>+#include <unistd.h>
>+#include <stdlib.h>
>+#include <string.h>
>+
>+#include "helpers.h"
>+#include "liburing.h"
>+#include "nvme.h"
>+
>+#define FILE_SIZE	(256 * 1024)
>+#define BS		8192
>+#define BUFFERS		(FILE_SIZE / BS)
>+
>+static struct iovec *vecs;
>+
>+/*
>+ * Each offset in the file has the ((test_case / 2) * FILE_SIZE)
>+ * + (offset / sizeof(int)) stored for every
>+ * sizeof(int) address.
>+ */
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
>+			fprintf(stderr, "Found %u, wanted %lu\n", *ptr, off);
>+			return 1;
>+		}
>+		ptr++;
>+		off++;
>+	}
>+
>+	return 0;
>+}
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
>+static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
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
>+#ifdef VERBOSE
>+	fprintf(stdout, "%s: start %d/%d/%d/%d: ", __FUNCTION__, read,
>+							sqthread, fixed,
>+							nonvec);
>+#endif
>+	if (read)
>+		open_flags = O_RDONLY;
>+	else
>+		open_flags = O_WRONLY;
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
>+	if (!read)
>+		fill_pattern(tc);
>+
>+	offset = 0;
>+	for (i = 0; i < BUFFERS; i++) {
>+		sqe = io_uring_get_sqe(ring);
>+		if (!sqe) {
>+			fprintf(stderr, "sqe get failed\n");
>+			goto err;
>+		}
>+		if (read) {
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
>+		}
>+		sqe->opcode = IORING_OP_URING_CMD;
>+		sqe->user_data = ((uint64_t)offset << 32) | i;
>+		if (sqthread)
>+			sqe->flags |= IOSQE_FIXED_FILE;
>+
>+		/* 80 bytes for NVMe uring passthrough command */
>+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
>+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));

The above 80 bytes commment does not serve much purpose since
you are using sizeof(struct nvme_uring_cmd) anyway and do not use the
magic number. Moreover actual size is 72 bytes. But this is a nit and
things look fine to me, so -

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_21039_
Content-Type: text/plain; charset="utf-8"


------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_21039_--
