Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077715A9332
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiIAJd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiIAJd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D31314E4
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:25 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2811Hd9D000343
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fz5pnw/sUz497BcBgEqTIuHhjU7Ehd04Bem7rgx4F+I=;
 b=YFlp/MidoMTi8aCb228/gD3KeU/dZG/vcigUncaSReDKIMcMU08uSfiI6UF7DGv0ACLw
 yO+B/X5wL//19tWMMpAjyiw869+RRJoTTVxGeIy/NxtKTNbmuYxCXJYtGm14GAsAyPTy
 EXpeayEodPSioLrg7w5GQcCMcbEfcVZKIzQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j9nks4yt0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:24 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:22 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D5AB35769404; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 10/12] overflow: add tests
Date:   Thu, 1 Sep 2022 02:33:01 -0700
Message-ID: <20220901093303.1974274-11-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xEXYuPl9j0TsXA_M_Ea38AEoKEsfrA6-
X-Proofpoint-ORIG-GUID: xEXYuPl9j0TsXA_M_Ea38AEoKEsfrA6-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 test/cq-overflow.c | 243 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 236 insertions(+), 7 deletions(-)

diff --git a/test/cq-overflow.c b/test/cq-overflow.c
index 312b414b2a79..1087eefaacf0 100644
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
@@ -104,8 +132,8 @@ static int test_io(const char *file, unsigned long us=
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
@@ -113,7 +141,10 @@ reap_it:
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
@@ -133,7 +164,7 @@ reap_it:
 		goto err;
 	}
=20
-	if (!nodrop) {
+	if (!nodrop || cqe_dropped) {
 		*drops =3D *ring.cq.koverflow;
 	} else if (*ring.cq.koverflow) {
 		fprintf(stderr, "Found %u overflows\n", *ring.cq.koverflow);
@@ -154,18 +185,29 @@ static int reap_events(struct io_uring *ring, unsig=
ned nr_events, int do_wait)
 {
 	struct io_uring_cqe *cqe;
 	int i, ret =3D 0, seq =3D 0;
+	unsigned int start_overflow =3D *ring->cq.koverflow;
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
@@ -242,19 +284,206 @@ err:
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
+static int test_overflow_handling(bool batch, int cqe_multiple, bool pol=
l,
+				  bool defer)
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
+	if (defer)
+		p.flags |=3D IORING_SETUP_SINGLE_ISSUER |
+			   IORING_SETUP_DEFER_TASKRUN;
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
+			ret =3D io_uring_get_events(&ring);
+			if (ret !=3D 0) {
+				fprintf(stderr,
+					"io_uring_get_events returned %d\n",
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
+		ret =3D io_uring_get_events(&ring);
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
+			fprintf(stderr, "bad completion size %d %d\n",
+				completions[i], completions[i - 1]);
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
+	bool can_defer;
=20
 	if (argc > 1)
 		return T_EXIT_SKIP;
=20
+	can_defer =3D t_probe_defer_taskrun();
+	for (i =3D 0; i < 16; i++) {
+		bool batch =3D i & 1;
+		int mult =3D (i & 2) ? 1 : 2;
+		bool poll =3D i & 4;
+		bool defer =3D i & 8;
+
+		if (defer && !can_defer)
+			continue;
+
+		ret =3D test_overflow_handling(batch, mult, poll, defer);
+		if (ret) {
+			fprintf(stderr, "test_overflow_handling("
+				"batch=3D%d, mult=3D%d, poll=3D%d, defer=3D%d) failed\n",
+				batch, mult, poll, defer);
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

