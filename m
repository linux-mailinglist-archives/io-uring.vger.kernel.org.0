Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6EB4BA566
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 17:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbiBQQHF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 11:07:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242696AbiBQQHE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 11:07:04 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A4DFF2
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 08:06:47 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HG6ZDi005167
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 08:06:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=YeLOXw9Wiba0lwpK8UOEOvL2wthy0zXejg1QXt4c9fE=;
 b=XjxxjGA9lYkDHzLSL3r4CZKRrG4EmLJtK/KXA4O+dx5c5PmvD5Ah32BvbWJmdZ0YmqE4
 C2MCB/ZGdBTOHYU+Re47qIX4W1Az6MWPmd02rAXm2sBbT2I+hdj72ND+wC0bPY5GxT9D
 s3/jc04N3QBnEitFZZUEaBVglMmFk8k3j1c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e92mq931q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 08:06:47 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 08:06:46 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 66ED74396AD8; Thu, 17 Feb 2022 08:04:26 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] Test consistent file position updates
Date:   Thu, 17 Feb 2022 08:04:24 -0800
Message-ID: <20220217160424.2557809-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 69zR7eLOyz91Qem7Qxoi_Z1aD1L1e318
X-Proofpoint-ORIG-GUID: 69zR7eLOyz91Qem7Qxoi_Z1aD1L1e318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202170073
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Also add tests for not setting IOSQE_IO_LINK, but do not treat these
results as errors. It is not clear to me what the outcome of many
overlapping read(2) should be in io_uring. In the read(2) etc calls a loc=
k
is taken on the file preventing concurrent accesses - but I am not
convinced this should happen in the io_uring case.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile |   1 +
 test/fpos.c   | 254 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 255 insertions(+)
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
index 0000000..42b0617
--- /dev/null
+++ b/test/fpos.c
@@ -0,0 +1,254 @@
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
+#define FILE_SIZE 10000
+#define QUEUE_SIZE 1024
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
+static int test_read(struct io_uring *ring, bool async, bool link)
+{
+	int ret, fd, i;
+	bool done =3D false;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	loff_t current, expected =3D 0;
+	int count_ok;
+	int count_0 =3D 0, count_1 =3D 0;
+	unsigned char buff[QUEUE_SIZE];
+
+	create_file(".test_read", FILE_SIZE);
+	fd =3D open(".test_read", O_RDONLY);
+	unlink(".test_read");
+	assert(fd >=3D 0);
+
+	while (!done) {
+		for (i =3D 0; i < QUEUE_SIZE; ++i) {
+			sqe =3D io_uring_get_sqe(ring);
+			if (!sqe) {
+				fprintf(stderr, "no sqe\n");
+				return -1;
+			}
+			io_uring_prep_read(sqe, fd, buff + i, 1, -1);
+			sqe->user_data =3D 1;
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
+			res =3D cqe->res;
+			io_uring_cqe_seen(ring, cqe);
+			if (res =3D=3D 0) {
+				done =3D true;
+			} else if (done) {
+				continue;
+			} else if (res < 0 || res !=3D 1) {
+				fprintf(stderr, "bad read: %d\n", cqe->res);
+				return -1;
+			} else {
+				++expected;
+				++count_ok;
+			}
+		}
+		ret =3D 0;
+		for (i =3D 0; i < count_ok; i++) {
+			if (buff[i] =3D=3D 1) {
+				count_1++;
+			} else if (buff[i] =3D=3D 0) {
+				count_0++;
+			} else {
+				fprintf(stderr, "odd read %d\n", (int)buff[i]);
+				ret =3D -1;
+				break;
+			}
+		}
+		if (labs(count_1 - count_0) > 1) {
+			fprintf(stderr, "inconsistent reads, got 0s:%d 1s:%d\n",
+				count_0, count_1);
+			ret =3D -1;
+		}
+		current =3D lseek(fd, 0, SEEK_CUR);
+		if (current !=3D expected) {
+			fprintf(stderr,
+				"f_pos incorrect, expected %ld have %ld\n",
+				expected,
+				current);
+			ret =3D -1;
+		}
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+
+static int test_write(struct io_uring *ring, bool async, bool link)
+{
+	int ret, fd, i;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	bool fail =3D false;
+	loff_t current;
+	const char *data =3D "ABCD";
+	int const n_data =3D strlen(data);
+	char readbuff[QUEUE_SIZE+1];
+
+	fd =3D open(".test_write", O_RDWR | O_CREAT, 0644);
+	unlink(".test_write");
+	assert(fd >=3D 0);
+
+	for (i =3D 0; i < QUEUE_SIZE; ++i) {
+		sqe =3D io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "no sqe\n");
+			return -1;
+		}
+		io_uring_prep_write(sqe, fd, data + (i % n_data), 1, -1);
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
+		fprintf(stderr,
+			"f_pos incorrect, expected %ld have %d\n",
+			current,
+			QUEUE_SIZE);
+		fail =3D true;
+	}
+	current =3D lseek(fd, 0, SEEK_SET);
+	if (current !=3D 0) {
+		perror("seek to start");
+		return -1;
+	}
+	ret =3D read(fd, readbuff, QUEUE_SIZE);
+	if (ret !=3D QUEUE_SIZE) {
+		fprintf(stderr, "did not read enough: %d\n", ret);
+		return -1;
+	}
+	i =3D 0;
+	while (i < QUEUE_SIZE - n_data) {
+		if (strncmp(readbuff + i, data, n_data)) {
+			char bad[QUEUE_SIZE+1];
+
+			memcpy(bad, readbuff + i, n_data);
+			bad[n_data] =3D '\0';
+			fail =3D true;
+			fprintf(stderr, "unexpected data %s\n", bad);
+		}
+		i +=3D n_data;
+	}
+
+	return fail ? -1 : 0;
+}
+
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+	int failed =3D 0;
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
+	for (int async =3D 0; async < 2; async++) {
+	for (int link =3D 0; link < 2; link++) {
+	for (int write =3D 0; write < 2; write++) {
+		fprintf(stderr, "*********\n");
+		ret =3D write
+			? test_write(&ring, !!async, !!link)
+			: test_read(&ring, !!async, !!link);
+		fprintf(stderr, "test %s async=3D%d link=3D%d:\t%s\n",
+			write ? "write":"read",
+			async, link, ret ? "failed" : "passed");
+
+		if (!link && ret) {
+			/* right now this doesn't actually work, and it
+			 * is still unclear if it should
+			 */
+			fprintf(stderr, "ignoring !link failure\n");
+		} else if (ret) {
+			failed =3D 1;
+		}
+	}
+	}
+	}
+	return failed ? -1 : 0;
+}

base-commit: 20bb37e0f828909742f845b8113b2bb7e1065cd1
--=20
2.30.2

