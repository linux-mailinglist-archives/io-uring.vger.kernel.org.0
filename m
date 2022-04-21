Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711EB509BED
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiDUJUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387464AbiDUJUl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:20:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A938325E88
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:51 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L8AdKG000913
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iW5NDkEejOpL0nBrmEH9IDfG176DPGk8txa3aDVve88=;
 b=K2qFV8KYIfKlfzrK0bxmDoRM5syBVjGBau7everfxnqORwPHjY+Sec0pbm/rd7BdlkoC
 lY+Sqe+6gmjoLSTV5RvToabpQycZCr3z8TKm0vsI8u0mMTmVnGHrBVe/qggQ22VLpDaO
 kXo9vrXf9kMwo3YjPERITlb/e9oA7w/TwRQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj36tb6v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:51 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:17:50 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 016F77CA7725; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 5/5] overflow: add tests
Date:   Thu, 21 Apr 2022 02:14:27 -0700
Message-ID: <20220421091427.2118151-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091427.2118151-1-dylany@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: LY2_NyNcYU6VQxbVQ741xcFMdzhrghDU
X-Proofpoint-ORIG-GUID: LY2_NyNcYU6VQxbVQ741xcFMdzhrghDU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tests that verify that overflow conditions behave appropriately.
Specifically:
 * if overflow is continually flushed, then CQEs should arrive mostly in
 order to prevent starvation of some completions
 * if CQEs are dropped due to GFP_ATOMIC allocation failures it is
 possible to terminate cleanly. This is not tested by default as it
 requires debug kernel config, and also has system-wide effects

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/cq-overflow.c | 240 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 233 insertions(+), 7 deletions(-)

diff --git a/test/cq-overflow.c b/test/cq-overflow.c
index 057570e..067308a 100644
--- a/test/cq-overflow.c
+++ b/test/cq-overflow.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <assert.h>
=20
 #include "helpers.h"
 #include "liburing.h"
@@ -21,6 +22,32 @@ static struct iovec *vecs;
=20
 #define ENTRIES	8
=20
+/*
+ * io_uring has rare cases where CQEs are lost.
+ * This happens when there is no space in the CQ ring, and also there is=
 no
+ * GFP_ATOMIC memory available. In reality this probably means that the =
process
+ * is about to be killed as many other things might start failing, but w=
e still
+ * want to test that liburing and the kernel deal with this properly. Th=
e fault
+ * injection framework allows us to test this scenario. Unfortunately th=
is
+ * requires some system wide changes and so we do not enable this by def=
ault.
+ * The tests in this file should work in both cases (where overflows are=
 queued
+ * and where they are dropped) on recent kernels.
+ *
+ * In order to test dropped CQEs you should enable fault injection in th=
e kernel
+ * config:
+ *
+ * CONFIG_FAULT_INJECTION=3Dy
+ * CONFIG_FAILSLAB=3Dy
+ * CONFIG_FAULT_INJECTION_DEBUG_FS=3Dy
+ *
+ * and then run the test as follows:
+ * echo Y > /sys/kernel/debug/failslab/task-filter
+ * echo 100 > /sys/kernel/debug/failslab/probability
+ * echo 0 > /sys/kernel/debug/failslab/verbose
+ * echo 100000 > /sys/kernel/debug/failslab/times
+ * bash -c "echo 1 > /proc/self/make-it-fail && exec ./cq-overflow.t"
+ */
+
 static int test_io(const char *file, unsigned long usecs, unsigned *drop=
s, int fault)
 {
 	struct io_uring_sqe *sqe;
@@ -29,6 +56,7 @@ static int test_io(const char *file, unsigned long usec=
s, unsigned *drops, int f
 	unsigned reaped, total;
 	struct io_uring ring;
 	int nodrop, i, fd, ret;
+	bool cqe_dropped =3D false;
=20
 	fd =3D open(file, O_RDONLY | O_DIRECT);
 	if (fd < 0) {
@@ -103,8 +131,8 @@ static int test_io(const char *file, unsigned long us=
ecs, unsigned *drops, int f
 reap_it:
 	reaped =3D 0;
 	do {
-		if (nodrop) {
-			/* nodrop should never lose events */
+		if (nodrop && !cqe_dropped) {
+			/* nodrop should never lose events unless cqe_dropped */
 			if (reaped =3D=3D total)
 				break;
 		} else {
@@ -112,7 +140,10 @@ reap_it:
 				break;
 		}
 		ret =3D io_uring_wait_cqe(&ring, &cqe);
-		if (ret) {
+		if (nodrop && ret =3D=3D -EBADR) {
+			cqe_dropped =3D true;
+			continue;
+		} else if (ret) {
 			fprintf(stderr, "wait_cqe=3D%d\n", ret);
 			goto err;
 		}
@@ -132,7 +163,7 @@ reap_it:
 		goto err;
 	}
=20
-	if (!nodrop) {
+	if (!nodrop || cqe_dropped) {
 		*drops =3D *ring.cq.koverflow;
 	} else if (*ring.cq.koverflow) {
 		fprintf(stderr, "Found %u overflows\n", *ring.cq.koverflow);
@@ -153,18 +184,31 @@ static int reap_events(struct io_uring *ring, unsig=
ned nr_events, int do_wait)
 {
 	struct io_uring_cqe *cqe;
 	int i, ret =3D 0, seq =3D 0;
+	unsigned int start_overflow =3D *ring->cq.koverflow;
+	unsigned int drop_count =3D 0;
+	bool dropped =3D false;
=20
 	for (i =3D 0; i < nr_events; i++) {
 		if (do_wait)
 			ret =3D io_uring_wait_cqe(ring, &cqe);
 		else
 			ret =3D io_uring_peek_cqe(ring, &cqe);
-		if (ret) {
+		if (do_wait && ret =3D=3D -EBADR) {
+			unsigned int this_drop =3D *ring->cq.koverflow -
+				start_overflow;
+
+			dropped =3D true;
+			drop_count +=3D this_drop;
+			start_overflow =3D *ring->cq.koverflow;
+			assert(this_drop > 0);
+			i +=3D (this_drop - 1);
+			continue;
+		} else if (ret) {
 			if (ret !=3D -EAGAIN)
 				fprintf(stderr, "cqe peek failed: %d\n", ret);
 			break;
 		}
-		if (cqe->user_data !=3D seq) {
+		if (!dropped && cqe->user_data !=3D seq) {
 			fprintf(stderr, "cqe sequence out-of-order\n");
 			fprintf(stderr, "got %d, wanted %d\n", (int) cqe->user_data,
 					seq);
@@ -241,19 +285,201 @@ err:
 	return 1;
 }
=20
+
+static void submit_one_nop(struct io_uring *ring, int ud)
+{
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	assert(sqe);
+	io_uring_prep_nop(sqe);
+	sqe->user_data =3D ud;
+	ret =3D io_uring_submit(ring);
+	assert(ret =3D=3D 1);
+}
+
+/*
+ * Create an overflow condition and ensure that SQEs are still processed
+ */
+static int test_overflow_handling(
+	bool batch,
+	int cqe_multiple,
+	bool poll)
+{
+	struct io_uring ring;
+	struct io_uring_params p;
+	int ret, i, j, ud, cqe_count;
+	unsigned int count;
+	int const N =3D 8;
+	int const LOOPS =3D 128;
+	int const QUEUE_LENGTH =3D 1024;
+	int completions[N];
+	int queue[QUEUE_LENGTH];
+	int queued =3D 0;
+	int outstanding =3D 0;
+	bool cqe_dropped =3D false;
+
+	memset(&completions, 0, sizeof(int) * N);
+	memset(&p, 0, sizeof(p));
+	p.cq_entries =3D 2 * cqe_multiple;
+	p.flags |=3D IORING_SETUP_CQSIZE;
+
+	if (poll)
+		p.flags |=3D IORING_SETUP_IOPOLL;
+
+	ret =3D io_uring_queue_init_params(2, &ring, &p);
+	if (ret) {
+		fprintf(stderr, "io_uring_queue_init failed %d\n", ret);
+		return 1;
+	}
+
+	assert(p.cq_entries < N);
+	/* submit N SQEs, some should overflow */
+	for (i =3D 0; i < N; i++) {
+		submit_one_nop(&ring, i);
+		outstanding++;
+	}
+
+	for (i =3D 0; i < LOOPS; i++) {
+		struct io_uring_cqe *cqes[N];
+
+		if (io_uring_cq_has_overflow(&ring)) {
+			/*
+			 * Flush any overflowed CQEs and process those. Actively
+			 * flush these to make sure CQEs arrive in vague order
+			 * of being sent.
+			 */
+			ret =3D io_uring_flush_overflow(&ring);
+			if (ret !=3D 0) {
+				fprintf(stderr,
+					"io_uring_flush_overflow returned %d\n",
+					ret);
+				goto err;
+			}
+		} else if (!cqe_dropped) {
+			for (j =3D 0; j < queued; j++) {
+				submit_one_nop(&ring, queue[j]);
+				outstanding++;
+			}
+			queued =3D 0;
+		}
+
+		/* We have lost some random cqes, stop if no remaining. */
+		if (cqe_dropped && outstanding =3D=3D *ring.cq.koverflow)
+			break;
+
+		ret =3D io_uring_wait_cqe(&ring, &cqes[0]);
+		if (ret =3D=3D -EBADR) {
+			cqe_dropped =3D true;
+			fprintf(stderr, "CQE dropped\n");
+			continue;
+		} else if (ret !=3D 0) {
+			fprintf(stderr, "io_uring_wait_cqes failed %d\n", ret);
+			goto err;
+		}
+		cqe_count =3D 1;
+		if (batch) {
+			ret =3D io_uring_peek_batch_cqe(&ring, &cqes[0], 2);
+			if (ret < 0) {
+				fprintf(stderr,
+					"io_uring_peek_batch_cqe failed %d\n",
+					ret);
+				goto err;
+			}
+			cqe_count =3D ret;
+		}
+		for (j =3D 0; j < cqe_count; j++) {
+			assert(cqes[j]->user_data < N);
+			ud =3D cqes[j]->user_data;
+			completions[ud]++;
+			assert(queued < QUEUE_LENGTH);
+			queue[queued++] =3D (int)ud;
+		}
+		io_uring_cq_advance(&ring, cqe_count);
+		outstanding -=3D cqe_count;
+	}
+
+	/* See if there were any drops by flushing the CQ ring *and* overflow *=
/
+	do {
+		struct io_uring_cqe *cqe;
+
+		ret =3D io_uring_flush_overflow(&ring);
+		if (ret < 0) {
+			if (ret =3D=3D -EBADR) {
+				fprintf(stderr, "CQE dropped\n");
+				cqe_dropped =3D true;
+				break;
+			}
+			goto err;
+		}
+		if (outstanding && !io_uring_cq_ready(&ring))
+			ret =3D io_uring_wait_cqe_timeout(&ring, &cqe, NULL);
+
+		if (ret && ret !=3D -ETIME) {
+			if (ret =3D=3D -EBADR) {
+				fprintf(stderr, "CQE dropped\n");
+				cqe_dropped =3D true;
+				break;
+			}
+			fprintf(stderr, "wait_cqe_timeout =3D %d\n", ret);
+			goto err;
+		}
+		count =3D io_uring_cq_ready(&ring);
+		io_uring_cq_advance(&ring, count);
+		outstanding -=3D count;
+	} while (count);
+
+	io_uring_queue_exit(&ring);
+
+	/* Make sure that completions come back in the same order they were
+	 * sent. If they come back unfairly then this will concentrate on a
+	 * couple of indices.
+	 */
+	for (i =3D 1; !cqe_dropped && i < N; i++) {
+		if (abs(completions[i] - completions[i - 1]) > 1) {
+			fprintf(
+				stderr,
+				"bad completion size %d %d\n",
+				completions[i],
+				completions[i - 1]);
+			goto err;
+		}
+	}
+	return 0;
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
+
 int main(int argc, char *argv[])
 {
 	const char *fname =3D ".cq-overflow";
 	unsigned iters, drops;
 	unsigned long usecs;
 	int ret;
+	int i;
=20
 	if (argc > 1)
 		return 0;
=20
+	for (i =3D 0; i < 8; i++) {
+		bool batch =3D i & 1;
+		int mult =3D (i & 2) ? 1 : 2;
+		bool poll =3D i & 4;
+
+		ret =3D test_overflow_handling(batch, mult, poll);
+		if (ret) {
+			fprintf(stderr, "test_overflow_handling("
+				"batch=3D%d, mult=3D%d, poll=3D%d) failed\n",
+				batch, mult, poll);
+			goto err;
+		}
+	}
+
 	ret =3D test_overflow();
 	if (ret) {
-		printf("test_overflow failed\n");
+		fprintf(stderr, "test_overflow failed\n");
 		return ret;
 	}
=20
--=20
2.30.2

