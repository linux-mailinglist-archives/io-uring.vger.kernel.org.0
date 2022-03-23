Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A184E559B
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiCWPqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245212AbiCWPqp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5890F4B86F
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:15 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N6wu7B008909
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3TvNj5Voh3/vGY/Sfzxm8kJh6bA7uXvQaU1ccWyo0Wg=;
 b=ay91Fp17HnYvtd5ir1awJWgyLbi6YmScugRPSDbcvjYonii6yR77rqaGODjCxk/1S7/G
 X7YhHRgFMFs9MHLqYVutt1EgTrapVLQaeYJ3uLoTFCWk6JH2IxjAcwhnXLUq0ETR00PD
 5ulQfwcyKv4m5VAAfVWxI0qXoISZGn9W+sA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyj5t88kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:14 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:45:13 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E441BCA02527; Wed, 23 Mar 2022 08:44:59 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 4/4] liburing: Add new test program to verify xattr support
Date:   Wed, 23 Mar 2022 08:44:57 -0700
Message-ID: <20220323154457.3303391-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
References: <20220323154457.3303391-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rPPAm-cdlnzU0fGLpurI-wkqEU175Qh0
X-Proofpoint-ORIG-GUID: rPPAm-cdlnzU0fGLpurI-wkqEU175Qh0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 84c23c8..a4a7caf 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -154,6 +154,7 @@ test_srcs :=3D \
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

