Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA444BF6D2
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 11:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiBVK5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 05:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiBVK5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 05:57:49 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D19F6F9
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:57:23 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21LJ4wDS013675
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:57:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=sy1j14aoslgSCkaWygEi9nLqU8U0pKdBASZmbjW9UEs=;
 b=kyBpJj4sRRQWVY0NrbymOs3xjm/0HtHN3AvmtTshdztcbeOCeOPR54TSzhAazdxvXYqV
 pMZYDm3opmR5EdFRhee3HyTrsW5zNF3YB14GJVrguTF55YVHUFBYJv9lz4m4aUxpHc3/
 zKv4EnirZOwydKluNFXMGPNEXzI0RUPnDjQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ecgjru8sk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:57:22 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 02:57:20 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id B35C647C3FD2; Tue, 22 Feb 2022 02:57:15 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 liburing] Test consistent file position updates
Date:   Tue, 22 Feb 2022 02:57:12 -0800
Message-ID: <20220222105712.3342740-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dsvMa19wLDGJNTKbYArqa7rNzT0b83dK
X-Proofpoint-ORIG-GUID: dsvMa19wLDGJNTKbYArqa7rNzT0b83dK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220064
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

read(2)/write(2) and friends support sequential reads without giving an
explicit offset. The result of these should leave the file with an
incremented offset.

Add tests for both read and write to check that io_uring behaves
consistently in these scenarios. Expect that if you queue many
reads/writes, and set the IOSQE_IO_LINK flag, that they will behave
similarly to calling read(2)/write(2) in sequence.

Set IOSQE_ASYNC as well in a set of tests. This exacerbates the problem b=
y
forcing work to happen in different threads to submission.

Also add tests for not setting IOSQE_IO_LINK, but allow the file offset t=
o
progress past the end of the file.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

v2:
 - fixed a bug in how cqe ordering was processed
 - enforce sequential reads for !IOSQE_IO_LINK

v3:
 - lots of style cleanups
 - do not output on success

test/Makefile |   1 +
 test/fpos.c   | 256 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 257 insertions(+)
 create mode 100644 test/fpos.c

diff --git a/test/Makefile b/test/Makefile
index 1e318f7..f421f53 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -78,6 +78,7 @@ test_srcs :=3D \
 	file-update.c \
 	file-verify.c \
 	fixed-link.c \
+	fpos.c \
 	fsync.c \
 	hardlink.c \
 	io-cancel.c \
diff --git a/test/fpos.c b/test/fpos.c
new file mode 100644
index 0000000..40df613
--- /dev/null
+++ b/test/fpos.c
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring fpos handling
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <assert.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+#define FILE_SIZE 5000
+#define QUEUE_SIZE 2048
+
+static void create_file(const char *file, size_t size)
+{
+	ssize_t ret;
+	char *buf;
+	size_t idx;
+	int fd;
+
+	buf =3D t_malloc(size);
+	for (idx =3D 0; idx < size; ++idx) {
+		/* write 0 or 1 */
+		buf[idx] =3D (unsigned char)(idx & 0x01);
+	}
+
+	fd =3D open(file, O_WRONLY | O_CREAT, 0644);
+	assert(fd >=3D 0);
+
+	ret =3D write(fd, buf, size);
+	fsync(fd);
+	close(fd);
+	free(buf);
+	assert(ret =3D=3D size);
+}
+
+static int test_read(struct io_uring *ring, bool async, bool link,
+		     int blocksize)
+{
+	int ret, fd, i;
+	bool done =3D false;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	loff_t current, expected =3D 0;
+	int count_ok;
+	int count_0 =3D 0, count_1 =3D 0;
+	unsigned char buff[QUEUE_SIZE * blocksize];
+	unsigned char reordered[QUEUE_SIZE * blocksize];
+
+	create_file(".test_fpos_read", FILE_SIZE);
+	fd =3D open(".test_fpos_read", O_RDONLY);
+	unlink(".test_fpos_read");
+	assert(fd >=3D 0);
+
+	while (!done) {
+		for (i =3D 0; i < QUEUE_SIZE; ++i) {
+			sqe =3D io_uring_get_sqe(ring);
+			if (!sqe) {
+				fprintf(stderr, "no sqe\n");
+				return -1;
+			}
+			io_uring_prep_read(sqe, fd,
+					buff + i * blocksize,
+					blocksize, -1);
+			sqe->user_data =3D i;
+			if (async)
+				sqe->flags |=3D IOSQE_ASYNC;
+			if (link && i !=3D QUEUE_SIZE - 1)
+				sqe->flags |=3D IOSQE_IO_LINK;
+		}
+		ret =3D io_uring_submit_and_wait(ring, QUEUE_SIZE);
+		if (ret !=3D QUEUE_SIZE) {
+			fprintf(stderr, "submit failed: %d\n", ret);
+			return 1;
+		}
+		count_ok  =3D 0;
+		for (i =3D 0; i < QUEUE_SIZE; ++i) {
+			int res;
+
+			ret =3D io_uring_peek_cqe(ring, &cqe);
+			if (ret) {
+				fprintf(stderr, "peek failed: %d\n", ret);
+				return ret;
+			}
+			assert(cqe->user_data < QUEUE_SIZE);
+			memcpy(reordered + count_ok,
+				buff + cqe->user_data * blocksize, blocksize);
+			res =3D cqe->res;
+			io_uring_cqe_seen(ring, cqe);
+			if (res =3D=3D 0) {
+				done =3D true;
+			} else if (res =3D=3D -ECANCELED) {
+				/* cancelled, probably ok */
+			} else if (res < 0 || res > blocksize) {
+				fprintf(stderr, "bad read: %d\n", res);
+				return -1;
+			} else {
+				expected +=3D res;
+				count_ok +=3D res;
+			}
+		}
+		ret =3D 0;
+		for (i =3D 0; i < count_ok; i++) {
+			if (reordered[i] =3D=3D 1) {
+				count_1++;
+			} else if (reordered[i] =3D=3D 0) {
+				count_0++;
+			} else {
+				fprintf(stderr, "odd read %d\n",
+						(int)reordered[i]);
+				ret =3D -1;
+				break;
+			}
+		}
+		if (labs(count_1 - count_0) > 1) {
+			fprintf(stderr, "inconsistent reads, got 0s:%d 1s:%d\n",
+					count_0, count_1);
+			ret =3D -1;
+		}
+		current =3D lseek(fd, 0, SEEK_CUR);
+		if (current < expected || (current !=3D expected && link)) {
+			/* accept that with !link current may be > expected */
+			fprintf(stderr, "f_pos incorrect, expected %ld have %ld\n",
+					expected, current);
+			ret =3D -1;
+		}
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+
+static int test_write(struct io_uring *ring, bool async,
+		      bool link, int blocksize)
+{
+	int ret, fd, i;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	bool fail =3D false;
+	loff_t current;
+	char data[blocksize+1];
+	char readbuff[QUEUE_SIZE*blocksize+1];
+
+	fd =3D open(".test_fpos_write", O_RDWR | O_CREAT, 0644);
+	unlink(".test_fpos_write");
+	assert(fd >=3D 0);
+
+	for (i =3D 0; i < blocksize; i++)
+		data[i] =3D 'A' + i;
+
+	data[blocksize] =3D '\0';
+
+	for (i =3D 0; i < QUEUE_SIZE; ++i) {
+		sqe =3D io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "no sqe\n");
+			return -1;
+		}
+		io_uring_prep_write(sqe, fd, data + (i % blocksize), 1, -1);
+		sqe->user_data =3D 1;
+		if (async)
+			sqe->flags |=3D IOSQE_ASYNC;
+		if (link && i !=3D QUEUE_SIZE - 1)
+			sqe->flags |=3D IOSQE_IO_LINK;
+	}
+	ret =3D io_uring_submit_and_wait(ring, QUEUE_SIZE);
+	if (ret !=3D QUEUE_SIZE) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		return 1;
+	}
+	for (i =3D 0; i < QUEUE_SIZE; ++i) {
+		int res;
+
+		ret =3D io_uring_peek_cqe(ring, &cqe);
+		res =3D cqe->res;
+		if (ret) {
+			fprintf(stderr, "peek failed: %d\n", ret);
+			return ret;
+		}
+		io_uring_cqe_seen(ring, cqe);
+		if (!fail && res !=3D 1) {
+			fprintf(stderr, "bad result %d\n", res);
+			fail =3D true;
+		}
+	}
+	current =3D lseek(fd, 0, SEEK_CUR);
+	if (current !=3D QUEUE_SIZE) {
+		fprintf(stderr, "f_pos incorrect, expected %ld have %d\n",
+				current, QUEUE_SIZE);
+		fail =3D true;
+	}
+	current =3D lseek(fd, 0, SEEK_SET);
+	if (current !=3D 0) {
+		perror("seek to start");
+		return -1;
+	}
+	ret =3D read(fd, readbuff, QUEUE_SIZE);
+	if (ret !=3D QUEUE_SIZE) {
+		fprintf(stderr, "did not write enough: %d\n", ret);
+		return -1;
+	}
+	i =3D 0;
+	while (i < QUEUE_SIZE - blocksize) {
+		if (strncmp(readbuff + i, data, blocksize)) {
+			char bad[QUEUE_SIZE+1];
+
+			memcpy(bad, readbuff + i, blocksize);
+			bad[blocksize] =3D '\0';
+			fprintf(stderr, "unexpected data %s\n", bad);
+			fail =3D true;
+		}
+		i +=3D blocksize;
+	}
+
+	return fail ? -1 : 0;
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
+	ret =3D io_uring_queue_init(QUEUE_SIZE, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	for (int test =3D 0; test < 16; test++) {
+		int async =3D test & 0x01;
+		int link =3D test & 0x02;
+		int write =3D test & 0x04;
+		int blocksize =3D test & 0x08 ? 1 : 7;
+
+		ret =3D write
+			? test_write(&ring, !!async, !!link, blocksize)
+			: test_read(&ring, !!async, !!link, blocksize);
+		if (ret) {
+			fprintf(stderr, "failed %s async=3D%d link=3D%d blocksize=3D%d\n",
+					write ? "write" : "read",
+					async, link, blocksize);
+			return -1;
+		}
+	}
+	return 0;
+}

base-commit: 20bb37e0f828909742f845b8113b2bb7e1065cd1
--=20
2.30.2

