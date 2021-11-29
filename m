Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C236462489
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhK2WU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:20:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46812 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231760AbhK2WSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:18:24 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1ATIlLIG000914
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DjB9HhFKf26LPUPorAuWBYNYWuf5Y1Zpi9offJyJVWQ=;
 b=RhUroSuYVRXQEHnHyoAFNZvbVsLUYrR7YSw6nlqWv/9lA5HBCkKshXx997LffljkwJAs
 useZ+f3GOPkWiofP9wNXrhtsVQqDnnToVMO1zoXuFNsSToGJrvEk7gwE7MLbpGKbjpi9
 F2tQSZ5OW+Wd5y2AYgQSyWAvTKumfVKhDbM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3cms5jx6nq-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:05 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:15:04 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 0BEF57101D25; Mon, 29 Nov 2021 14:15:01 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 4/4] liburing: Add new test program to verify xattr support
Date:   Mon, 29 Nov 2021 14:14:58 -0800
Message-ID: <20211129221458.2546542-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221458.2546542-1-shr@fb.com>
References: <20211129221458.2546542-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: l3bOmQX_LjR1VumuGg2h5g75PxPVFlnE
X-Proofpoint-GUID: l3bOmQX_LjR1VumuGg2h5g75PxPVFlnE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This adds a new test program to test the xattr support:
- fgetxattr
- fsetxattr
- getxattr
- setxattr

It also includes test cases for failure conditions and
for passing in an invalid sqe. The test case for checking
of invalid SQE, must be enabled by defining
DESTRUCTIVE_TESTING.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/Makefile |   1 +
 test/xattr.c  | 425 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 426 insertions(+)
 create mode 100644 test/xattr.c

diff --git a/test/Makefile b/test/Makefile
index c09078a..aa2da4e 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -147,6 +147,7 @@ test_srcs :=3D \
 	timeout-overflow.c \
 	unlink.c \
 	wakeup-hang.c \
+	xattr.c \
 	skip-cqe.c \
 	# EOL
=20
diff --git a/test/xattr.c b/test/xattr.c
new file mode 100644
index 0000000..017017e
--- /dev/null
+++ b/test/xattr.c
@@ -0,0 +1,425 @@
+#include <assert.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+/* Define constants. */
+#define XATTR_SIZE  255
+#define QUEUE_DEPTH 32
+
+#define FILENAME    "xattr.test"
+#define KEY1        "user.val1"
+#define KEY2        "user.val2"
+#define VALUE1      "value1"
+#define VALUE2      "value2-a-lot-longer"
+
+
+/* Call fsetxattr. */
+int io_uring_fsetxattr(struct io_uring *ring,
+		       int              fd,
+		       const char      *name,
+		       const void      *value,
+		       size_t           size,
+		       int              flags)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "Error cannot get sqe\n");
+		return -1;
+	}
+
+	io_uring_prep_fsetxattr(sqe, fd, name, value, flags, size);
+
+	ret =3D io_uring_submit(ring);
+	if (ret !=3D 1) {
+		fprintf(stderr, "Error io_uring_submit_and_wait: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "Error io_uring_wait_cqe: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+
+	return ret;
+}
+
+/* Submit fgetxattr request. */
+int io_uring_fgetxattr(struct io_uring *ring,
+		       int              fd,
+		       const char      *name,
+		       void            *value,
+		       size_t           size)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "Error cannot get sqe\n");
+		return -1;
+	}
+
+	io_uring_prep_fgetxattr(sqe, fd, name, value, size);
+
+	ret =3D io_uring_submit(ring);
+	if (ret !=3D 1) {
+		fprintf(stderr, "Error io_uring_submit_and_wait: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "Error io_uring_wait_cqe: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D cqe->res;
+	if (ret =3D=3D -1) {
+		fprintf(stderr, "Error couldn'tget value\n");
+		return -1;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+/* Call setxattr. */
+int io_uring_setxattr(struct io_uring *ring,
+		      const char      *path,
+		      const char      *name,
+		      const void      *value,
+		      size_t           size,
+		      int              flags)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "Error cannot get sqe\n");
+		return -1;
+	}
+
+	io_uring_prep_setxattr(sqe, name, value, path, flags, size);
+
+	ret =3D io_uring_submit_and_wait(ring, 1);
+	if (ret !=3D 1) {
+		fprintf(stderr, "Error io_uring_submit_and_wait: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "Error io_uring_wait_cqe: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+
+	return ret;
+}
+
+/* Submit getxattr request. */
+int io_uring_getxattr(struct io_uring *ring,
+		      const char      *path,
+		      const char      *name,
+		      void            *value,
+		      size_t           size)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "Error cannot get sqe\n");
+		return -1;
+	}
+
+	io_uring_prep_getxattr(sqe, name, value, path, size);
+
+	ret =3D io_uring_submit(ring);
+	if (ret !=3D 1) {
+		fprintf(stderr, "Error io_uring_submit_and_wait: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "Error io_uring_wait_cqe: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D cqe->res;
+	if (ret =3D=3D -1) {
+		fprintf(stderr, "Error couldn'tget value\n");
+		return -1;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+/* Test driver for fsetxattr and fgetxattr. */
+int test_fxattr(void)
+{
+	int rc =3D 0;
+	size_t value_len;
+	struct io_uring ring;
+	char value[XATTR_SIZE];
+
+	/* Init io-uring queue. */
+	int ret =3D io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return -1;
+	}
+
+	/* Create the test file. */
+	int fd =3D open(FILENAME, O_CREAT | O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "Error: cannot open file: ret=3D%d\n", fd);
+		return -1;
+	}
+
+	/* Test writing attributes. */
+	if (io_uring_fsetxattr(&ring, fd, KEY1, VALUE1, strlen(VALUE1), 0) =3D=3D=
 -1) {
+		fprintf(stderr, "Error fsetxattr cannot write key1\n");
+		rc =3D -1;
+		goto Exit;
+	}
+
+	if (io_uring_fsetxattr(&ring, fd, KEY2, VALUE2, strlen(VALUE2), 0) =3D=3D=
 -1) {
+		fprintf(stderr, "Error fsetxattr cannot write key1\n");
+		rc =3D -1;
+		goto Exit;
+	}
+
+	/* Test reading attributes. */
+	value_len =3D io_uring_fgetxattr(&ring, fd, KEY1, value, XATTR_SIZE);
+	if (value_len !=3D strlen(value) || strncmp(value, VALUE1, value_len)) =
{
+		fprintf(stderr, "Error: fgetxattr expectd value: %s, returned value: %=
s\n", VALUE1, value);
+		rc =3D -1;
+		goto Exit;
+	}
+
+	value_len =3D io_uring_fgetxattr(&ring, fd, KEY2, value, XATTR_SIZE);
+	if (value_len !=3D strlen(value)|| strncmp(value, VALUE2, value_len)) {
+		fprintf(stderr, "Error: fgetxattr expectd value: %s, returned value: %=
s\n", VALUE2, value);
+		rc =3D -1;
+		goto Exit;
+	}
+
+	/* Cleanup. */
+Exit:
+	close(fd);
+	unlink(FILENAME);
+
+	io_uring_queue_exit(&ring);
+
+	return rc;
+}
+
+/* Test driver for setxattr and getxattr. */
+int test_xattr(void)
+{
+	int rc =3D 0;
+	int value_len;
+	struct io_uring ring;
+	char value[XATTR_SIZE];
+
+	/* Init io-uring queue. */
+	int ret =3D io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return -1;
+	}
+
+	/* Create the test file. */
+	t_create_file(FILENAME, 0);
+
+	/* Test writing attributes. */
+	if (io_uring_setxattr(&ring, FILENAME, KEY1, VALUE1, strlen(VALUE1), 0)=
 =3D=3D -1) {
+		fprintf(stderr, "Error setxattr cannot write key1\n");
+		rc =3D -1;
+		goto Exit;
+	}
+
+	if (io_uring_setxattr(&ring, FILENAME, KEY2, VALUE2, strlen(VALUE2), 0)=
 =3D=3D -1) {
+		fprintf(stderr, "Error setxattr cannot write key1\n");
+		rc =3D -1;
+		goto Exit;
+	}
+
+	/* Test reading attributes. */
+	value_len =3D io_uring_getxattr(&ring, FILENAME, KEY1, value, XATTR_SIZ=
E);
+	if (value_len !=3D strlen(VALUE1) || strncmp(value, VALUE1, value_len))=
 {
+		fprintf(stderr, "Error: getxattr expectd value: %s, returned value: %s=
\n", VALUE1, value);
+		rc =3D -1;
+		goto Exit;
+	}
+
+	value_len =3D io_uring_getxattr(&ring, FILENAME, KEY2, value, XATTR_SIZ=
E);
+	if (value_len !=3D strlen(VALUE2) || strncmp(value, VALUE2, value_len))=
 {
+		fprintf(stderr, "Error: getxattr expectd value: %s, returned value: %s=
\n", VALUE2, value);
+		rc =3D -1;
+		goto Exit;
+	}
+
+	/* Cleanup. */
+Exit:
+	io_uring_queue_exit(&ring);
+	unlink(FILENAME);
+
+	return rc;
+}
+
+/* Test driver for failure cases of fsetxattr and fgetxattr. */
+int test_failure_fxattr(void)
+{
+	int rc =3D 0;
+	struct io_uring ring;
+	char value[XATTR_SIZE];
+
+	/* Init io-uring queue. */
+	int ret =3D io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return -1;
+	}
+
+	/* Create the test file. */
+	int fd =3D open(FILENAME, O_CREAT | O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "Error: cannot open file: ret=3D%d\n", fd);
+		return -1;
+	}
+
+	/* Test writing attributes. */
+	assert(io_uring_fsetxattr(&ring, -1, KEY1, VALUE1, strlen(VALUE1), 0) <=
 0);
+	assert(io_uring_fsetxattr(&ring, fd, NULL, VALUE1, strlen(VALUE1), 0) <=
 0);
+	assert(io_uring_fsetxattr(&ring, fd, KEY1, NULL,   strlen(VALUE1), 0) <=
 0);
+	assert(io_uring_fsetxattr(&ring, fd, KEY1, VALUE1, 0,              0) =3D=
=3D 0);
+	assert(io_uring_fsetxattr(&ring, fd, KEY1, VALUE1, -1,             0) <=
 0);
+
+	/* Test reading attributes. */
+	assert(io_uring_fgetxattr(&ring, -1, KEY1, value, XATTR_SIZE) < 0);
+	assert(io_uring_fgetxattr(&ring, fd, NULL, value, XATTR_SIZE) < 0);
+	assert(io_uring_fgetxattr(&ring, fd, KEY1, value, 0)          =3D=3D 0)=
;
+
+	/* Cleanup. */
+	close(fd);
+	unlink(FILENAME);
+
+	io_uring_queue_exit(&ring);
+
+	return rc;
+}
+
+
+/* Test driver for failure cases for setxattr and getxattr. */
+int test_failure_xattr(void)
+{
+	int rc =3D 0;
+	struct io_uring ring;
+	char value[XATTR_SIZE];
+
+	/* Init io-uring queue. */
+	int ret =3D io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return -1;
+	}
+
+	/* Create the test file. */
+	t_create_file(FILENAME, 0);
+
+	/* Test writing attributes. */
+	assert(io_uring_setxattr(&ring, "complete garbage", KEY1, VALUE1, strle=
n(VALUE1), 0) < 0);
+	assert(io_uring_setxattr(&ring, NULL,     KEY1, VALUE1, strlen(VALUE1),=
 0) < 0);
+	assert(io_uring_setxattr(&ring, FILENAME, NULL, VALUE1, strlen(VALUE1),=
 0) < 0);
+	assert(io_uring_setxattr(&ring, FILENAME, KEY1, NULL,   strlen(VALUE1),=
 0) < 0);
+	assert(io_uring_setxattr(&ring, FILENAME, KEY1, VALUE1, 0,             =
 0) =3D=3D 0);
+
+	/* Test reading attributes. */
+	assert(io_uring_getxattr(&ring, "complete garbage", KEY1, value, XATTR_=
SIZE) < 0);
+	assert(io_uring_getxattr(&ring, NULL,     KEY1, value, XATTR_SIZE) < 0)=
;
+	assert(io_uring_getxattr(&ring, FILENAME, NULL, value, XATTR_SIZE) < 0)=
;
+	assert(io_uring_getxattr(&ring, FILENAME, KEY1, NULL,  XATTR_SIZE) =3D=3D=
 0);
+	assert(io_uring_getxattr(&ring, FILENAME, KEY1, value, 0)          =3D=3D=
 0);
+
+	/* Cleanup. */
+	io_uring_queue_exit(&ring);
+	unlink(FILENAME);
+
+	return rc;
+}
+
+/* Test for invalid SQE, this will cause a segmentation fault if enabled=
. */
+int test_invalid_sqe(void)
+{
+#ifdef DESTRUCTIVE_TEST
+	struct io_uring_sqe *sqe =3D NULL;
+	struct io_uring_cqe *cqe =3D NULL;
+	struct io_uring ring;
+
+	/* Init io-uring queue. */
+	int ret =3D io_uring_queue_init(QUEUE_DEPTH, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return -1;
+	}
+
+	/* Pass invalid SQE. */
+	io_uring_prep_setxattr(sqe, FILENAME, KEY1, VALUE1, strlen(VALUE1), 0);
+
+	ret =3D io_uring_submit(&ring);
+	if (ret !=3D 1) {
+		fprintf(stderr, "Error io_uring_submit_and_wait: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "Error io_uring_wait_cqe: ret=3D%d\n", ret);
+		return -1;
+	}
+
+	ret =3D cqe->res;
+	io_uring_cqe_seen(&ring, cqe);
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
+/* Test driver. */
+int main(int argc, char **argv) {
+	if (test_fxattr()
+		|| test_xattr()
+	    || test_failure_fxattr()
+		|| test_failure_xattr()
+	    || test_invalid_sqe())
+		return EXIT_FAILURE;
+
+	return EXIT_SUCCESS;
+}
--=20
2.30.2

