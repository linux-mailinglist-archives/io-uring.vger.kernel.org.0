Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56882DA261
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503638AbgLNVKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503705AbgLNVKF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKsGL3144080;
        Mon, 14 Dec 2020 21:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=eI5iXikpGBlj4a4D5cQKN24PgGDW+pWgb0/UP2KeNNg=;
 b=y4E3sIuAGJfMA5B5B4N536Pi96VizsDbwCSH8Qu1DhxuSmPQFYShqlo3gx5wXnK6sd5M
 PWV7onuvA6sAlUHXvRMFpE81sqBvL2rK66snG1UVOsgYwJ3Ap0ZyHHJmemmxjgwUDzWe
 NOsyuPuU9h7cKwGJhi2HTGqrWXF/Wk/Gn0AP7gqeHjw3QjtKnkiP8PGAGWrM99e4aoq9
 3zdPmPA0mV1N7ZQyoHaLnC7rnM647s9D/WVkyMMDlr+eM30i9Zy4/E/hBjypa9ZUDDSN
 EANbLlGN+XVkjzkuJY44hAo5Yk5qAPjIrF5aA99ApctKXL4X8Xjq2648WhScaOKzntUr mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9r7h47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKt5xt135886;
        Mon, 14 Dec 2020 21:09:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jq0ppe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEL9LNJ000934;
        Mon, 14 Dec 2020 21:09:21 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:20 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 4/5] test/buffer-update: add buffer registration update test
Date:   Mon, 14 Dec 2020 13:09:10 -0800
Message-Id: <1607980151-18816-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 .gitignore           |   1 +
 test/Makefile        |   2 +
 test/buffer-update.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100644 test/buffer-update.c

diff --git a/.gitignore b/.gitignore
index 9d30cf7..b44560e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,6 +31,7 @@
 /test/b19062a56726-test
 /test/b5837bd5311d-test
 /test/buffer-register
+/test/buffer-update
 /test/ce593a6c480a-test
 /test/close-opath
 /test/config.local
diff --git a/test/Makefile b/test/Makefile
index 293df3d..5cd467c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -30,6 +30,7 @@ test_targets += \
 	b19062a56726-test \
 	b5837bd5311d-test \
 	buffer-register \
+	buffer-update \
 	ce593a6c480a-test \
 	close-opath \
 	connect \
@@ -153,6 +154,7 @@ test_srcs := \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
 	buffer-register.c \
+	buffer-update.c \
 	ce593a6c480a-test.c \
 	close-opath.c \
 	connect.c \
diff --git a/test/buffer-update.c b/test/buffer-update.c
new file mode 100644
index 0000000..5f926aa
--- /dev/null
+++ b/test/buffer-update.c
@@ -0,0 +1,165 @@
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
+#define NBUFS	10
+
+static int pagesize;
+
+static struct iovec *alloc_bufs(int nr_bufs)
+{
+	struct iovec *iovs;
+	void *buf;
+	int i;
+
+	iovs = calloc(nr_bufs, sizeof(struct iovec));
+	if (!iovs) {
+		perror("malloc");
+		return NULL;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		buf = malloc(pagesize);
+		if (!buf) {
+			perror("malloc");
+			iovs = NULL;
+			break;
+		}
+		iovs[i].iov_base = buf;
+		iovs[i].iov_len = pagesize;
+	}
+
+	return iovs;
+}
+
+static void free_bufs(struct iovec *iovs, int nr_bufs)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++)
+		free(iovs[i].iov_base);
+}
+
+static int test_update_multiring(struct io_uring *r1, struct io_uring *r2,
+				 struct io_uring *r3, int do_unreg)
+{
+	struct iovec *iovs, *newiovs;
+
+	iovs = alloc_bufs(NBUFS);
+	newiovs = alloc_bufs(NBUFS);
+
+	if (io_uring_register_buffers(r1, iovs, NBUFS) ||
+	    io_uring_register_buffers(r2, iovs, NBUFS) ||
+	    io_uring_register_buffers(r3, iovs, NBUFS)) {
+		fprintf(stderr, "%s: register buffers failed\n", __FUNCTION__);
+		goto err;
+	}
+
+	if (io_uring_register_buffers_update(r1, 0, newiovs, NBUFS) != NBUFS ||
+	    io_uring_register_buffers_update(r2, 0, newiovs, NBUFS) != NBUFS ||
+	    io_uring_register_buffers_update(r3, 0, newiovs, NBUFS) != NBUFS) {
+		fprintf(stderr, "%s: update buffers failed\n", __FUNCTION__);
+		goto err;
+	}
+
+	if (!do_unreg)
+		goto done;
+
+	if (io_uring_unregister_buffers(r1) ||
+	    io_uring_unregister_buffers(r2) ||
+	    io_uring_unregister_buffers(r3)) {
+		fprintf(stderr, "%s: unregister buffers failed\n",
+			__FUNCTION__);
+		goto err;
+	}
+
+done:
+	free_bufs(iovs, NBUFS);
+	free_bufs(newiovs, NBUFS);
+	return 0;
+err:
+	free_bufs(iovs, NBUFS);
+	free_bufs(newiovs, NBUFS);
+	return 1;
+}
+
+static int test_sqe_update(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec *iovs;
+	int ret;
+
+	iovs = calloc(NBUFS, sizeof(struct iovec));
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_buffers_update(sqe, iovs, NBUFS, 0);
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait: %d\n", ret);
+		return 1;
+	}
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (ret == -EINVAL) {
+		fprintf(stdout, "IORING_OP_BUFFERSS_UPDATE not supported" \
+			", skipping\n");
+		return 0;
+	}
+	return ret != NBUFS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring r1, r2, r3;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	pagesize = getpagesize();
+
+	if (io_uring_queue_init(8, &r1, 0) ||
+	    io_uring_queue_init(8, &r2, 0) ||
+	    io_uring_queue_init(8, &r3, 0)) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_update_multiring(&r1, &r2, &r3, 1);
+	if (ret) {
+		fprintf(stderr, "test_update_multiring w/unreg\n");
+		return ret;
+	}
+
+	ret = test_update_multiring(&r1, &r2, &r3, 0);
+	if (ret) {
+		fprintf(stderr, "test_update_multiring wo/unreg\n");
+		return ret;
+	}
+
+	ret = test_sqe_update(&r1);
+	if (ret) {
+		fprintf(stderr, "test_sqe_update failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

