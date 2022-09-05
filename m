Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C365AD3CF
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiIENZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbiIENZN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:25:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27582494B
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:25:11 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2852gq4U004596
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:25:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=t1Asr9tRDaaI2rFoxKH7e153Co8XTQNQeo+rjD8KwVw=;
 b=MuEs22dEzouCoNSzn7nWCCwsNCs/VdoHg+gp0POQEWdjJM80L3q/8S2u2wjlz1AL/5xK
 +eL32jsgyjwht6FqhzKuK52Tmim5Y8ZpnKzFTL9F6RxhAenDqDLnC5gXIA6K8URv5XVz
 5wit4t0Xm39fnCTYKTkAucaX3eyVqWh9ihU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jc2e8gwm0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:25:10 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:25:09 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 351DF5AC5172; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 05/11] update existing tests for defer taskrun
Date:   Mon, 5 Sep 2022 06:22:52 -0700
Message-ID: <20220905132258.1858915-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Oj7Kn0SmBJG-EBJguMsIH2sOcSh1fWsi
X-Proofpoint-ORIG-GUID: Oj7Kn0SmBJG-EBJguMsIH2sOcSh1fWsi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add defer_taskrun to a few choice tests that can expose some bad
behaviour.
This requires adding some io_uring_get_events calls to make sure deferred
tasks are run

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/eventfd-disable.c     | 33 ++++++++++++++++++++++---
 test/iopoll.c              | 17 +++++++++----
 test/multicqes_drain.c     | 50 +++++++++++++++++++++++++++++++++-----
 test/poll-mshot-overflow.c | 40 +++++++++++++++++++++++++++---
 test/recv-multishot.c      | 33 ++++++++++++++++---------
 test/rsrc_tags.c           | 10 ++++++--
 6 files changed, 152 insertions(+), 31 deletions(-)

diff --git a/test/eventfd-disable.c b/test/eventfd-disable.c
index 2c8cf6dad7c1..162f9f9bc783 100644
--- a/test/eventfd-disable.c
+++ b/test/eventfd-disable.c
@@ -15,7 +15,7 @@
 #include "liburing.h"
 #include "helpers.h"
=20
-int main(int argc, char *argv[])
+static int test(bool defer)
 {
 	struct io_uring_params p =3D {};
 	struct io_uring_sqe *sqe;
@@ -28,8 +28,9 @@ int main(int argc, char *argv[])
 	};
 	int ret, evfd, i;
=20
-	if (argc > 1)
-		return T_EXIT_SKIP;
+	if (defer)
+		p.flags |=3D IORING_SETUP_SINGLE_ISSUER |
+			   IORING_SETUP_DEFER_TASKRUN;
=20
 	ret =3D io_uring_queue_init_params(64, &ring, &p);
 	if (ret) {
@@ -148,5 +149,31 @@ int main(int argc, char *argv[])
 		io_uring_cqe_seen(&ring, cqe);
 	}
=20
+	io_uring_queue_exit(&ring);
+	close(evfd);
 	return T_EXIT_PASS;
 }
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test(false);
+	if (ret !=3D T_EXIT_PASS) {
+		fprintf(stderr, "%s: test(false) failed\n", argv[0]);
+		return ret;
+	}
+
+	if (t_probe_defer_taskrun()) {
+		ret =3D test(true);
+		if (ret !=3D T_EXIT_PASS) {
+			fprintf(stderr, "%s: test(true) failed\n", argv[0]);
+			return ret;
+		}
+	}
+
+	return ret;
+}
diff --git a/test/iopoll.c b/test/iopoll.c
index 91cb71bd2e9c..20f91c7947be 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -274,7 +274,7 @@ ok:
 }
=20
 static int test_io(const char *file, int write, int sqthread, int fixed,
-		   int buf_select)
+		   int buf_select, int defer)
 {
 	struct io_uring ring;
 	int ret, ring_flags =3D IORING_SETUP_IOPOLL;
@@ -282,6 +282,10 @@ static int test_io(const char *file, int write, int =
sqthread, int fixed,
 	if (no_iopoll)
 		return 0;
=20
+	if (defer)
+		ring_flags |=3D IORING_SETUP_SINGLE_ISSUER |
+			      IORING_SETUP_DEFER_TASKRUN;
+
 	ret =3D t_create_ring(64, &ring, ring_flags);
 	if (ret =3D=3D T_SETUP_SKIP)
 		return 0;
@@ -337,19 +341,22 @@ int main(int argc, char *argv[])
=20
 	vecs =3D t_create_buffers(BUFFERS, BS);
=20
-	nr =3D 16;
+	nr =3D 32;
 	if (no_buf_select)
 		nr =3D 8;
+	else if (!t_probe_defer_taskrun())
+		nr =3D 16;
 	for (i =3D 0; i < nr; i++) {
 		int write =3D (i & 1) !=3D 0;
 		int sqthread =3D (i & 2) !=3D 0;
 		int fixed =3D (i & 4) !=3D 0;
 		int buf_select =3D (i & 8) !=3D 0;
+		int defer =3D (i & 16) !=3D 0;
=20
-		ret =3D test_io(fname, write, sqthread, fixed, buf_select);
+		ret =3D test_io(fname, write, sqthread, fixed, buf_select, defer);
 		if (ret) {
-			fprintf(stderr, "test_io failed %d/%d/%d/%d\n",
-				write, sqthread, fixed, buf_select);
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
+				write, sqthread, fixed, buf_select, defer);
 			goto err;
 		}
 		if (no_iopoll)
diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index 6cd03ba5f3f7..f95c4382b3f4 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -233,6 +233,8 @@ static int test_generic_drain(struct io_uring *ring)
=20
 		if (trigger_event(pipes[i]))
 			goto err;
+
+		io_uring_get_events(ring);
 	}
 	sleep(1);
 	i =3D 0;
@@ -246,7 +248,7 @@ static int test_generic_drain(struct io_uring *ring)
 	 * compl_bits is a bit map to record completions.
 	 * eg. sqe[0], sqe[1], sqe[2] fully completed
 	 * then compl_bits is 000...00111b
-	 *=20
+	 *
 	 */
 	unsigned long long compl_bits =3D 0;
 	for (j =3D 0; j < i; j++) {
@@ -295,7 +297,12 @@ static int test_simple_drain(struct io_uring *ring)
 	io_uring_prep_poll_add(sqe[1], pipe2[0], POLLIN);
 	sqe[1]->user_data =3D 1;
=20
-	ret =3D io_uring_submit(ring);
+	/* This test relies on multishot poll to trigger events continually.
+	 * however with IORING_SETUP_DEFER_TASKRUN this will only happen when
+	 * triggered with a get_events. Hence we sprinkle get_events whenever
+	 * there might be work to process in order to get the same result
+	 */
+	ret =3D io_uring_submit_and_get_events(ring);
 	if (ret < 0) {
 		printf("sqe submit failed\n");
 		goto err;
@@ -307,9 +314,11 @@ static int test_simple_drain(struct io_uring *ring)
 	for (i =3D 0; i < 2; i++) {
 		if (trigger_event(pipe1))
 			goto err;
+		io_uring_get_events(ring);
 	}
 	if (trigger_event(pipe2))
 			goto err;
+	io_uring_get_events(ring);
=20
 	for (i =3D 0; i < 2; i++) {
 		sqe[i] =3D io_uring_get_sqe(ring);
@@ -355,15 +364,17 @@ err:
 	return 1;
 }
=20
-int main(int argc, char *argv[])
+static int test(bool defer_taskrun)
 {
 	struct io_uring ring;
 	int i, ret;
+	unsigned int flags =3D 0;
=20
-	if (argc > 1)
-		return T_EXIT_SKIP;
+	if (defer_taskrun)
+		flags =3D IORING_SETUP_SINGLE_ISSUER |
+			IORING_SETUP_DEFER_TASKRUN;
=20
-	ret =3D io_uring_queue_init(1024, &ring, 0);
+	ret =3D io_uring_queue_init(1024, &ring, flags);
 	if (ret) {
 		printf("ring setup failed\n");
 		return T_EXIT_FAIL;
@@ -384,5 +395,32 @@ int main(int argc, char *argv[])
 			return T_EXIT_FAIL;
 		}
 	}
+
+	io_uring_queue_exit(&ring);
+
 	return T_EXIT_PASS;
 }
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test(false);
+	if (ret !=3D T_EXIT_PASS) {
+		fprintf(stderr, "%s: test(false) failed\n", argv[0]);
+		return ret;
+	}
+
+	if (t_probe_defer_taskrun()) {
+		ret =3D test(true);
+		if (ret !=3D T_EXIT_PASS) {
+			fprintf(stderr, "%s: test(true) failed\n", argv[0]);
+			return ret;
+		}
+	}
+
+	return ret;
+}
diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
index 360df65d2b15..431a337f19ae 100644
--- a/test/poll-mshot-overflow.c
+++ b/test/poll-mshot-overflow.c
@@ -42,7 +42,7 @@ int check_final_cqe(struct io_uring *ring)
 	return T_EXIT_PASS;
 }
=20
-int main(int argc, char *argv[])
+static int test(bool defer_taskrun)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -50,9 +50,6 @@ int main(int argc, char *argv[])
 	int pipe1[2];
 	int ret, i;
=20
-	if (argc > 1)
-		return 0;
-
 	if (pipe(pipe1) !=3D 0) {
 		perror("pipe");
 		return T_EXIT_FAIL;
@@ -66,6 +63,10 @@ int main(int argc, char *argv[])
 		.cq_entries =3D 2
 	};
=20
+	if (defer_taskrun)
+		params.flags |=3D IORING_SETUP_SINGLE_ISSUER |
+				IORING_SETUP_DEFER_TASKRUN;
+
 	ret =3D io_uring_queue_init_params(2, &ring, &params);
 	if (ret)
 		return T_EXIT_SKIP;
@@ -113,6 +114,9 @@ int main(int argc, char *argv[])
 		io_uring_cqe_seen(&ring, cqe);
 	}
=20
+	/* make sure everything is processed */
+	io_uring_get_events(&ring);
+
 	/* now remove the poll */
 	sqe =3D io_uring_get_sqe(&ring);
 	io_uring_prep_poll_remove(sqe, 1);
@@ -126,5 +130,33 @@ int main(int argc, char *argv[])
=20
 	ret =3D check_final_cqe(&ring);
=20
+	close(pipe1[0]);
+	close(pipe1[1]);
+	io_uring_queue_exit(&ring);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test(false);
+	if (ret !=3D T_EXIT_PASS) {
+		fprintf(stderr, "%s: test(false) failed\n", argv[0]);
+		return ret;
+	}
+
+	if (t_probe_defer_taskrun()) {
+		ret =3D test(true);
+		if (ret !=3D T_EXIT_PASS) {
+			fprintf(stderr, "%s: test(true) failed\n", argv[0]);
+			return ret;
+		}
+	}
+
 	return ret;
 }
diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index a322e4317232..1a041f8e865a 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -29,6 +29,7 @@ struct args {
 	bool wait_each;
 	bool recvmsg;
 	enum early_error_t early_error;
+	bool defer;
 };
=20
 static int check_sockaddr(struct sockaddr_in *in)
@@ -76,19 +77,22 @@ static int test(struct args *args)
 		.tv_sec =3D 1,
 	};
 	struct msghdr msg;
+	struct io_uring_params params =3D { };
+	int n_sqe =3D 32;
=20
 	memset(recv_buffs, 0, sizeof(recv_buffs));
=20
-	if (args->early_error =3D=3D ERROR_EARLY_OVERFLOW) {
-		struct io_uring_params params =3D {
-			.flags =3D IORING_SETUP_CQSIZE,
-			.cq_entries =3D N_CQE_OVERFLOW
-		};
+	if (args->defer)
+		params.flags |=3D IORING_SETUP_SINGLE_ISSUER |
+				IORING_SETUP_DEFER_TASKRUN;
=20
-		ret =3D io_uring_queue_init_params(N_CQE_OVERFLOW, &ring, &params);
-	} else {
-		ret =3D io_uring_queue_init(32, &ring, 0);
+	if (args->early_error =3D=3D ERROR_EARLY_OVERFLOW) {
+		params.flags |=3D IORING_SETUP_CQSIZE;
+		params.cq_entries =3D N_CQE_OVERFLOW;
+		n_sqe =3D N_CQE_OVERFLOW;
 	}
+
+	ret =3D io_uring_queue_init_params(n_sqe, &ring, &params);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
 		return ret;
@@ -457,23 +461,30 @@ int main(int argc, char *argv[])
 	int ret;
 	int loop;
 	int early_error =3D 0;
+	bool has_defer;
=20
 	if (argc > 1)
 		return T_EXIT_SKIP;
=20
-	for (loop =3D 0; loop < 8; loop++) {
+	has_defer =3D t_probe_defer_taskrun();
+
+	for (loop =3D 0; loop < 16; loop++) {
 		struct args a =3D {
 			.stream =3D loop & 0x01,
 			.wait_each =3D loop & 0x2,
 			.recvmsg =3D loop & 0x04,
+			.defer =3D loop & 0x08,
 		};
+		if (a.defer && !has_defer)
+			continue;
 		for (early_error =3D 0; early_error < ERROR_EARLY_LAST; early_error++)=
 {
 			a.early_error =3D (enum early_error_t)early_error;
 			ret =3D test(&a);
 			if (ret) {
 				fprintf(stderr,
-					"test stream=3D%d wait_each=3D%d recvmsg=3D%d early_error=3D%d fail=
ed\n",
-					a.stream, a.wait_each, a.recvmsg, a.early_error);
+					"test stream=3D%d wait_each=3D%d recvmsg=3D%d early_error=3D%d "
+					" defer=3D%d failed\n",
+					a.stream, a.wait_each, a.recvmsg, a.early_error, a.defer);
 				return T_EXIT_FAIL;
 			}
 			if (no_recv_mshot)
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index 22370644b200..047e844acfbd 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -401,7 +401,8 @@ static int test_notag(void)
=20
 int main(int argc, char *argv[])
 {
-	int ring_flags[] =3D {0, IORING_SETUP_IOPOLL, IORING_SETUP_SQPOLL};
+	int ring_flags[] =3D {0, IORING_SETUP_IOPOLL, IORING_SETUP_SQPOLL,
+			    IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN};
 	int i, ret;
=20
 	if (argc > 1)
@@ -423,7 +424,12 @@ int main(int argc, char *argv[])
 	}
=20
 	for (i =3D 0; i < sizeof(ring_flags) / sizeof(ring_flags[0]); i++) {
-		ret =3D test_files(ring_flags[i]);
+		int flag =3D ring_flags[i];
+
+		if (flag & IORING_SETUP_DEFER_TASKRUN && !t_probe_defer_taskrun())
+			continue;
+
+		ret =3D test_files(flag);
 		if (ret) {
 			printf("test_tag failed, type %i\n", i);
 			return ret;
--=20
2.30.2

