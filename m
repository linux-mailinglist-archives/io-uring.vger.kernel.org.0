Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15FD2DA262
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503528AbgLNVKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503700AbgLNVKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKtb6K016151;
        Mon, 14 Dec 2020 21:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=uP7wG1zOyojcpWRB8VTUg3ycJ3ByiArVSx1/XvJzNvQ=;
 b=H594UulFSfdYPK2DCgCWuCWCINA2JWYv6fX0cHH6IjfenQq5ZuUBIKSkBSs/l97x9bdi
 8rxIGcjNWhCfkw0YxQcyOGOSoaYBwe3XEifk0EEigxZenPjVV2OnAMqCKctH495CijqL
 Qgpkw0RdSBe6XEGdpuxGhMZ3GEnhP5XuswZzxwFtJco7HAFjeMvXWq7o0m+J3ciurOLi
 rRPRTXfGjQCTjkLvdR94GT9KULTv+vMeREjDA4o0oSlF1o0OT2IDgtSmznoMLRGFG5o+
 kh0pEq8WAX+5ICPLyPCxs2At+D/ACBix3Y0mFh8GIWwm574cXx65KoEZ5hecCMI9HzLB bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb7p5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKt8Z8132650;
        Mon, 14 Dec 2020 21:09:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35d7em0k08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEL9KAt027037;
        Mon, 14 Dec 2020 21:09:20 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:20 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 3/5] test/buffer-register: add buffer registration test
Date:   Mon, 14 Dec 2020 13:09:09 -0800
Message-Id: <1607980151-18816-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 .gitignore             |   1 +
 test/Makefile          |   2 +
 test/buffer-register.c | 701 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 704 insertions(+)
 create mode 100644 test/buffer-register.c

diff --git a/.gitignore b/.gitignore
index 360064a..9d30cf7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,6 +30,7 @@
 /test/across-fork
 /test/b19062a56726-test
 /test/b5837bd5311d-test
+/test/buffer-register
 /test/ce593a6c480a-test
 /test/close-opath
 /test/config.local
diff --git a/test/Makefile b/test/Makefile
index 6aa1788..293df3d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -29,6 +29,7 @@ test_targets += \
 	across-fork splice \
 	b19062a56726-test \
 	b5837bd5311d-test \
+	buffer-register \
 	ce593a6c480a-test \
 	close-opath \
 	connect \
@@ -151,6 +152,7 @@ test_srcs := \
 	across-fork.c \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
+	buffer-register.c \
 	ce593a6c480a-test.c \
 	close-opath.c \
 	connect.c \
diff --git a/test/buffer-register.c b/test/buffer-register.c
new file mode 100644
index 0000000..35176a1
--- /dev/null
+++ b/test/buffer-register.c
@@ -0,0 +1,701 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various buffer registration tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+static int pagesize;
+
+static void free_bufs(struct iovec *iovs, int nr_bufs)
+{
+	int i;
+
+	if (!iovs)
+		return;
+
+	for (i = 0; i < nr_bufs; i++)
+		if (iovs[i].iov_base)
+			free(iovs[i].iov_base);
+
+	free(iovs);
+}
+
+static struct iovec *alloc_bufs(int nr_bufs, int extra)
+{
+	struct iovec *iovs;
+	void *buf;
+	int i;
+
+	iovs = calloc(nr_bufs + extra, sizeof(struct iovec));
+	if (!iovs) {
+		perror("malloc");
+		return NULL;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		buf = malloc(pagesize);
+		if (!buf) {
+			perror("malloc");
+			break;
+		}
+		iovs[i].iov_base = buf;
+		iovs[i].iov_len = pagesize;
+	}
+
+	/* extra buffers already set to zero */
+
+	if (i < nr_bufs) {
+		free_bufs(iovs, nr_bufs);
+		iovs = NULL;
+	}
+
+	return iovs;
+}
+
+static int test_shrink(struct io_uring *ring)
+{
+	int ret, off;
+	struct iovec *iovs, iov = {0};
+
+	iovs = alloc_bufs(50, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 50);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	off = 0;
+	do {
+		ret = io_uring_register_buffers_update(ring, off, &iov, 1);
+		if (ret != 1) {
+			if (off == 50 && ret == -EINVAL)
+				break;
+			fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__,
+				ret);
+			break;
+		}
+		off++;
+	} while (1);
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 50);
+	return 0;
+err:
+	free_bufs(iovs, 50);
+	return 1;
+}
+
+static int test_grow(struct io_uring *ring)
+{
+	int ret, off, i;
+	struct iovec *iovs, *ups = NULL;
+
+	iovs = alloc_bufs(50, 250);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 300);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(250, 0);
+	if (!ups)
+		goto err;
+	i = 0;
+	off = 50;
+	do {
+		ret = io_uring_register_buffers_update(ring, off, ups + i, 1);
+		if (ret != 1) {
+			if (off == 300 && ret == -EINVAL)
+				break;
+			fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__,
+				ret);
+			break;
+		}
+		if (off >= 300) {
+			fprintf(stderr, "%s: Succeeded beyond end-of-list?\n",
+				__FUNCTION__);
+			goto err;
+		}
+		off++;
+		i++;
+	} while (1);
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 300);
+	free_bufs(ups, 250);
+	return 0;
+err:
+	free_bufs(iovs, 300);
+	free_bufs(ups, 250);
+	return 1;
+}
+
+static int test_replace_all(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(0, 100);
+
+	ret = io_uring_register_buffers_update(ring, 0, ups, 100);
+	if (ret != 100) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 100);
+	return 1;
+}
+
+static int test_replace(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(10, 0);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 90, ups, 10);
+	if (ret != 10) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 10);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 10);
+	return 1;
+}
+
+static int test_removals(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(0, 10);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 50, ups, 10);
+	if (ret != 10) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 0);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 0);
+	return 1;
+}
+
+static int test_additions(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 100);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 200);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(2, 0);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 100, ups, 2);
+	if (ret != 2) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 2);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 2);
+	return 1;
+}
+
+static int test_sparse(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(100, 100);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 200);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	return 1;
+}
+
+static int test_basic_many(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(1024, 0);
+	ret = io_uring_register_buffers(ring, iovs, 768);
+	if (ret) {
+		fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 1024);
+	return 0;
+err:
+	free_bufs(iovs, 1024);
+	return 1;
+}
+
+static int test_basic(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	return 1;
+}
+
+/*
+ * Register 0 buffers, but reserve space for 10.  Then add one buffer.
+ */
+static int test_zero(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(0, 10);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 10);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(1, 0);
+	if (!ups)
+		return 1;
+	ret = io_uring_register_buffers_update(ring, 0, ups, 1);
+	if (ret != 1) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 0);
+	free_bufs(ups, 1);
+	return 0;
+err:
+	free_bufs(iovs, 0);
+	free_bufs(ups, 1);
+	return 1;
+}
+
+static int test_fixed_read_write(struct io_uring *ring, int fd,
+				 struct iovec *iovs, int index)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec *iov;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	iov = &iovs[index];
+	io_uring_prep_write_fixed(sqe, fd, iov->iov_base, iov->iov_len, 0,
+				  index);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__,
+			ret);
+		return 1;
+	}
+	if (cqe->res != pagesize) {
+		fprintf(stderr, "%s: write cqe->res=%d\n", __FUNCTION__,
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	iov = &iovs[index + 1];
+	io_uring_prep_read_fixed(sqe, fd, iov->iov_base, iov->iov_len, 0,
+				  index + 1);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__,
+			ret);
+		return 1;
+	}
+	if (cqe->res != pagesize) {
+		fprintf(stderr, "%s: read cqe->res=%d\n", __FUNCTION__,
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return 0;
+}
+
+/*
+ * Register 1k of sparse buffers, update one at a random spot, then do some
+ * file IO to verify it works.
+ */
+static int test_huge(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret, fd;
+
+	iovs = alloc_bufs(0, UIO_MAXIOV);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, UIO_MAXIOV);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	fd = open(".reg.768", O_RDWR | O_CREAT, 0644);
+	if (fd < 0) {
+		fprintf(stderr, "%s: open=%d\n", __FUNCTION__, errno);
+		goto err;
+	}
+
+	ups = alloc_bufs(2, 0);
+	if (!ups) {
+		fprintf(stderr, "%s: malloc=%d\n", __FUNCTION__, errno);
+		goto err;
+	}
+	memset(ups[0].iov_base, 0x5a, pagesize);
+
+	ret = io_uring_register_buffers_update(ring, 768, ups, 2);
+	if (ret != 2) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	iovs[768].iov_base = ups[0].iov_base;
+	iovs[768].iov_len = pagesize;
+	iovs[769].iov_base = ups[1].iov_base;
+	iovs[769].iov_len = pagesize;
+
+	if (test_fixed_read_write(ring, fd, iovs, 768))
+		goto err;
+
+	if (memcmp(ups[0].iov_base, ups[1].iov_base, pagesize)) {
+		fprintf(stderr, "%s: data mismatch\n", __FUNCTION__);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	if (fd != -1) {
+		close(fd);
+		unlink(".reg.768");
+	}
+	free_bufs(iovs, 0);
+	free_bufs(ups, 2);
+	return 0;
+err:
+	free_bufs(iovs, 0);
+	free_bufs(ups, 2);
+	return 1;
+}
+
+static int test_sparse_updates(void)
+{
+	struct iovec *iovs, *ups = NULL;
+	struct io_uring ring;
+	int ret, i;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return ret;
+	}
+
+	iovs = alloc_bufs(0, 256);
+
+	ret = io_uring_register_buffers(&ring, iovs, 256);
+	if (ret) {
+		fprintf(stderr, "buffer_register: %d\n", ret);
+		return ret;
+	}
+
+	ups = alloc_bufs(1, 0);
+	for (i = 0; i < 256; i++) {
+		ret = io_uring_register_buffers_update(&ring, i, ups, 1);
+		if (ret != 1) {
+			fprintf(stderr, "buffer_update: %d\n", ret);
+			return ret;
+		}
+	}
+	io_uring_unregister_buffers(&ring);
+
+	for (i = 0; i < 256; i++)
+		iovs[i] = ups[0];
+
+	ret = io_uring_register_buffers(&ring, iovs, 256);
+	if (ret) {
+		fprintf(stderr, "buffer_register: %d\n", ret);
+		return ret;
+	}
+
+	free_bufs(ups, 1);
+	ups = alloc_bufs(0, 1);
+	for (i = 0; i < 256; i++) {
+		ret = io_uring_register_buffers_update(&ring, i, ups, 1);
+		if (ret != 1) {
+			fprintf(stderr, "buffer_update: %d\n", ret);
+			goto done;
+		}
+	}
+	ret = 0;
+done:
+	free_bufs(ups, 0);
+	io_uring_unregister_buffers(&ring);
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	pagesize = getpagesize();
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_basic(&ring);
+	if (ret) {
+		printf("test_basic failed\n");
+		return ret;
+	}
+
+	ret = test_basic_many(&ring);
+	if (ret) {
+		printf("test_basic_many failed\n");
+		return ret;
+	}
+
+	ret = test_sparse(&ring);
+	if (ret) {
+		printf("test_sparse failed\n");
+		return ret;
+	}
+
+	ret = test_additions(&ring);
+	if (ret) {
+		printf("test_additions failed\n");
+		return ret;
+	}
+
+	ret = test_removals(&ring);
+	if (ret) {
+		printf("test_removals failed\n");
+		return ret;
+	}
+
+	ret = test_replace(&ring);
+	if (ret) {
+		printf("test_replace failed\n");
+		return ret;
+	}
+
+	ret = test_replace_all(&ring);
+	if (ret) {
+		printf("test_replace_all failed\n");
+		return ret;
+	}
+
+	ret = test_grow(&ring);
+	if (ret) {
+		printf("test_grow failed\n");
+		return ret;
+	}
+
+	ret = test_shrink(&ring);
+	if (ret) {
+		printf("test_shrink failed\n");
+		return ret;
+	}
+
+	ret = test_zero(&ring);
+	if (ret) {
+		printf("test_zero failed\n");
+		return ret;
+	}
+
+	ret = test_huge(&ring);
+	if (ret) {
+		printf("test_huge failed\n");
+		return ret;
+	}
+
+	ret = test_sparse_updates();
+	if (ret) {
+		printf("test_sparse_updates failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

