Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666294E7026
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348165AbiCYJmF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241899AbiCYJmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 05:42:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7FFCFBA0
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:40:31 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22P0IWWL012097
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:40:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=HWQwvUQ2bZu8brDaUT5eCAOQZFXLKcY+qR59TrGVY9U=;
 b=VVpRQFDvnNvfQtOzzJGvAa0uHHFnRQarRTj1Pr8+X3kJYCp9VYEq6BFTKGn+tWcuT6Ux
 NOvFuSoxTY7ya61oVNM3HXhqilKhp7c06tr3U0w6FJI4HraY5QGm8tfUqkW0Z73R9Xw1
 YhzNUfjAeNao07pH7xGe22bls6IMN/cNd2c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0byt2j28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:40:31 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Mar 2022 02:40:29 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 239F16493D76; Fri, 25 Mar 2022 02:40:25 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] Add test for multiple concurrent accepts
Date:   Fri, 25 Mar 2022 02:40:13 -0700
Message-ID: <20220325094013.4132496-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Kvn_bevLjBf5dIMhOU_vZhPlwLypfDI1
X-Proofpoint-ORIG-GUID: Kvn_bevLjBf5dIMhOU_vZhPlwLypfDI1
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tests for accept that queues multiple accepts and then ensures the
correct things happen.

Check that when connections arrive one at a time that only one CQE is
posted (in blocking and nonblocking sockets), as well as make sure that
closing the accept socket & cancellation all work as expected.

This relies on a kernel with [1] for the tests to pass.

[1]: https://lore.kernel.org/io-uring/20220325093755.4123343-1-dylany@fb.co=
m/

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/accept.c | 203 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 144 insertions(+), 59 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index e2c6b51..c591e76 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -59,19 +59,24 @@ static void queue_recv(struct io_uring *ring, int fd, b=
ool fixed)
 		sqe->flags |=3D IOSQE_FIXED_FILE;
 }
=20
-static void queue_accept_conn(struct io_uring *ring, int fd, int fixed_idx)
+static void queue_accept_conn(struct io_uring *ring,
+			      int fd, int fixed_idx,
+			      int count)
 {
 	struct io_uring_sqe *sqe;
 	int ret;
=20
-	sqe =3D io_uring_get_sqe(ring);
-	if (fixed_idx < 0)
-		io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
-	else
-		io_uring_prep_accept_direct(sqe, fd, NULL, NULL, 0, fixed_idx);
+	while (count--) {
+		sqe =3D io_uring_get_sqe(ring);
+		if (fixed_idx < 0)
+			io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+		else
+			io_uring_prep_accept_direct(sqe, fd, NULL, NULL, 0,
+						    fixed_idx);
=20
-	ret =3D io_uring_submit(ring);
-	assert(ret !=3D -1);
+		ret =3D io_uring_submit(ring);
+		assert(ret !=3D -1);
+	}
 }
=20
 static int accept_conn(struct io_uring *ring, int fixed_idx)
@@ -131,18 +136,19 @@ struct accept_test_args {
 	bool fixed;
 	bool nonblock;
 	bool queue_accept_before_connect;
+	int extra_loops;
 };
=20
-static int test(struct io_uring *ring, struct accept_test_args args)
+
+static int test_loop(struct io_uring *ring,
+		     struct accept_test_args args,
+		     int recv_s0,
+		     struct sockaddr_in *addr)
 {
 	struct io_uring_cqe *cqe;
-	struct sockaddr_in addr;
 	uint32_t head, count =3D 0;
 	int ret, p_fd[2], done =3D 0;
-
 	int32_t val;
-	int32_t recv_s0 =3D start_accept_listen(&addr, 0,
-					      args.nonblock ? O_NONBLOCK : 0);
=20
 	p_fd[1] =3D socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
=20
@@ -157,10 +163,7 @@ static int test(struct io_uring *ring, struct accept_t=
est_args args)
 	ret =3D fcntl(p_fd[1], F_SETFL, flags);
 	assert(ret !=3D -1);
=20
-	if (args.queue_accept_before_connect)
-		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1);
-
-	ret =3D connect(p_fd[1], (struct sockaddr*)&addr, sizeof(addr));
+	ret =3D connect(p_fd[1], (struct sockaddr *)addr, sizeof(*addr));
 	assert(ret =3D=3D -1);
=20
 	flags =3D fcntl(p_fd[1], F_GETFL, 0);
@@ -171,7 +174,7 @@ static int test(struct io_uring *ring, struct accept_te=
st_args args)
 	assert(ret !=3D -1);
=20
 	if (!args.queue_accept_before_connect)
-		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1);
+		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1, 1);
=20
 	p_fd[0] =3D accept_conn(ring, args.fixed ? 0 : -1);
 	if (p_fd[0] =3D=3D -EINVAL) {
@@ -219,16 +222,34 @@ out:
 	if (!args.fixed)
 		close(p_fd[0]);
 	close(p_fd[1]);
-	close(recv_s0);
 	return 0;
 err:
 	if (!args.fixed)
 		close(p_fd[0]);
 	close(p_fd[1]);
-	close(recv_s0);
 	return 1;
 }
=20
+static int test(struct io_uring *ring, struct accept_test_args args)
+{
+	struct sockaddr_in addr;
+	int ret =3D 0;
+	int loop;
+	int32_t recv_s0 =3D start_accept_listen(&addr, 0,
+					      args.nonblock ? O_NONBLOCK : 0);
+	if (args.queue_accept_before_connect)
+		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1,
+				  1 + args.extra_loops);
+	for (loop =3D 0; loop < 1 + args.extra_loops; loop++) {
+		ret =3D test_loop(ring, args, recv_s0, &addr);
+		if (ret)
+			break;
+	}
+
+	close(recv_s0);
+	return ret;
+}
+
 static void sig_alrm(int sig)
 {
 	exit(0);
@@ -261,10 +282,17 @@ static int test_accept_pending_on_exit(void)
 	return 0;
 }
=20
+struct test_accept_many_args {
+	unsigned int usecs;
+	bool nonblock;
+	bool single_sock;
+	bool close_fds;
+};
+
 /*
  * Test issue many accepts and see if we handle cancellation on exit
  */
-static int test_accept_many(unsigned nr, unsigned usecs, bool nonblock)
+static int test_accept_many(struct test_accept_many_args args)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_cqe *cqe;
@@ -272,6 +300,8 @@ static int test_accept_many(unsigned nr, unsigned usecs=
, bool nonblock)
 	unsigned long cur_lim;
 	struct rlimit rlim;
 	int *fds, i, ret;
+	unsigned int nr =3D 128;
+	int nr_socks =3D args.single_sock ? 1 : nr;
=20
 	if (getrlimit(RLIMIT_NPROC, &rlim) < 0) {
 		perror("getrlimit");
@@ -289,28 +319,32 @@ static int test_accept_many(unsigned nr, unsigned use=
cs, bool nonblock)
 	ret =3D io_uring_queue_init(2 * nr, &m_io_uring, 0);
 	assert(ret >=3D 0);
=20
-	fds =3D t_calloc(nr, sizeof(int));
+	fds =3D t_calloc(nr_socks, sizeof(int));
=20
-	for (i =3D 0; i < nr; i++)
+	for (i =3D 0; i < nr_socks; i++)
 		fds[i] =3D start_accept_listen(NULL, i,
-					     nonblock ? O_NONBLOCK : 0);
+					     args.nonblock ? O_NONBLOCK : 0);
=20
 	for (i =3D 0; i < nr; i++) {
+		int sock_idx =3D args.single_sock ? 0 : i;
 		sqe =3D io_uring_get_sqe(&m_io_uring);
-		io_uring_prep_accept(sqe, fds[i], NULL, NULL, 0);
+		io_uring_prep_accept(sqe, fds[sock_idx], NULL, NULL, 0);
 		sqe->user_data =3D 1 + i;
 		ret =3D io_uring_submit(&m_io_uring);
 		assert(ret =3D=3D 1);
 	}
=20
-	if (usecs)
-		usleep(usecs);
+	if (args.usecs)
+		usleep(args.usecs);
+
+	if (args.close_fds)
+		for (i =3D 0; i < nr_socks; i++)
+			close(fds[i]);
=20
 	for (i =3D 0; i < nr; i++) {
 		if (io_uring_peek_cqe(&m_io_uring, &cqe))
 			break;
-		if (cqe->res !=3D -ECANCELED &&
-		    !(cqe->res =3D=3D -EAGAIN && nonblock)) {
+		if (cqe->res !=3D -ECANCELED) {
 			fprintf(stderr, "Expected cqe to be cancelled %d\n", cqe->res);
 			ret =3D 1;
 			goto out;
@@ -330,7 +364,7 @@ out:
 	return ret;
 }
=20
-static int test_accept_cancel(unsigned usecs)
+static int test_accept_cancel(unsigned usecs, unsigned int nr)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_cqe *cqe;
@@ -342,22 +376,25 @@ static int test_accept_cancel(unsigned usecs)
=20
 	fd =3D start_accept_listen(NULL, 0, 0);
=20
-	sqe =3D io_uring_get_sqe(&m_io_uring);
-	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
-	sqe->user_data =3D 1;
-	ret =3D io_uring_submit(&m_io_uring);
-	assert(ret =3D=3D 1);
+	for (i =3D 1; i <=3D nr; i++) {
+		sqe =3D io_uring_get_sqe(&m_io_uring);
+		io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+		sqe->user_data =3D i;
+		ret =3D io_uring_submit(&m_io_uring);
+		assert(ret =3D=3D 1);
+	}
=20
 	if (usecs)
 		usleep(usecs);
=20
-	sqe =3D io_uring_get_sqe(&m_io_uring);
-	io_uring_prep_cancel(sqe, 1, 0);
-	sqe->user_data =3D 2;
-	ret =3D io_uring_submit(&m_io_uring);
-	assert(ret =3D=3D 1);
-
-	for (i =3D 0; i < 2; i++) {
+	for (i =3D 1; i <=3D nr; i++) {
+		sqe =3D io_uring_get_sqe(&m_io_uring);
+		io_uring_prep_cancel(sqe, i, 0);
+		sqe->user_data =3D nr + i;
+		ret =3D io_uring_submit(&m_io_uring);
+		assert(ret =3D=3D 1);
+	}
+	for (i =3D 0; i < nr * 2; i++) {
 		ret =3D io_uring_wait_cqe(&m_io_uring, &cqe);
 		assert(!ret);
 		/*
@@ -370,12 +407,15 @@ static int test_accept_cancel(unsigned usecs)
 		 *    should get '-EALREADY' for the cancel request and
 		 *    '-EINTR' for the accept request.
 		 */
-		if (cqe->user_data =3D=3D 1) {
+		if (cqe->user_data =3D=3D 0) {
+			fprintf(stderr, "unexpected 0 user data\n");
+			goto err;
+		} else if (cqe->user_data <=3D nr) {
 			if (cqe->res !=3D -EINTR && cqe->res !=3D -ECANCELED) {
 				fprintf(stderr, "Cancelled accept got %d\n", cqe->res);
 				goto err;
 			}
-		} else if (cqe->user_data =3D=3D 2) {
+		} else if (cqe->user_data <=3D nr * 2) {
 			if (cqe->res !=3D -EALREADY && cqe->res !=3D 0) {
 				fprintf(stderr, "Cancel got %d\n", cqe->res);
 				goto err;
@@ -391,11 +431,14 @@ err:
 	return 1;
 }
=20
-static int test_accept(void)
+static int test_accept(int count, bool before)
 {
 	struct io_uring m_io_uring;
 	int ret;
-	struct accept_test_args args =3D { };
+	struct accept_test_args args =3D {
+		.queue_accept_before_connect =3D before,
+		.extra_loops =3D count - 1
+	};
=20
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >=3D 0);
@@ -404,13 +447,14 @@ static int test_accept(void)
 	return ret;
 }
=20
-static int test_accept_nonblock(bool queue_before_connect)
+static int test_accept_nonblock(bool queue_before_connect, int count)
 {
 	struct io_uring m_io_uring;
 	int ret;
 	struct accept_test_args args =3D {
 		.nonblock =3D true,
-		.queue_accept_before_connect =3D queue_before_connect
+		.queue_accept_before_connect =3D queue_before_connect,
+		.extra_loops =3D count - 1
 	};
=20
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
@@ -467,7 +511,7 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
=20
-	ret =3D test_accept();
+	ret =3D test_accept(1, false);
 	if (ret) {
 		fprintf(stderr, "test_accept failed\n");
 		return ret;
@@ -475,15 +519,33 @@ int main(int argc, char *argv[])
 	if (no_accept)
 		return 0;
=20
-	ret =3D test_accept_nonblock(false);
+	ret =3D test_accept(2, false);
+	if (ret) {
+		fprintf(stderr, "test_accept(2) failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept(2, true);
+	if (ret) {
+		fprintf(stderr, "test_accept(2, true) failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_nonblock(false, 1);
 	if (ret) {
 		fprintf(stderr, "test_accept_nonblock failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_nonblock(true);
+	ret =3D test_accept_nonblock(true, 1);
+	if (ret) {
+		fprintf(stderr, "test_accept_nonblock(before, 1) failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_nonblock(true, 3);
 	if (ret) {
-		fprintf(stderr, "test_accept_nonblock(queue_before) failed\n");
+		fprintf(stderr, "test_accept_nonblock(before,3) failed\n");
 		return ret;
 	}
=20
@@ -499,33 +561,56 @@ int main(int argc, char *argv[])
 		return ret;
 	}
=20
-	ret =3D test_accept_cancel(0);
+	ret =3D test_accept_cancel(0, 1);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel nodelay failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_cancel(10000);
+	ret =3D test_accept_cancel(10000, 1);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel delay failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_many(128, 0, false);
+	ret =3D test_accept_cancel(0, 4);
 	if (ret) {
-		fprintf(stderr, "test_accept_many failed\n");
+		fprintf(stderr, "test_accept_cancel nodelay failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_cancel(10000, 4);
+	if (ret) {
+		fprintf(stderr, "test_accept_cancel delay failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_many(128, 100000, false);
+	ret =3D test_accept_many((struct test_accept_many_args) {});
 	if (ret) {
 		fprintf(stderr, "test_accept_many failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_many(128, 0, true);
+	ret =3D test_accept_many((struct test_accept_many_args) {
+				.usecs =3D 100000 });
+	if (ret) {
+		fprintf(stderr, "test_accept_many(sleep) failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_many((struct test_accept_many_args) {
+				.nonblock =3D true });
+	if (ret) {
+		fprintf(stderr, "test_accept_many(nonblock) failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_many((struct test_accept_many_args) {
+				.nonblock =3D true,
+				.single_sock =3D true,
+				.close_fds =3D true });
 	if (ret) {
-		fprintf(stderr, "test_accept_many nonblocking failed\n");
+		fprintf(stderr, "test_accept_many(nonblock,close) failed\n");
 		return ret;
 	}
=20

base-commit: 7a3a27b6a384f51b67f7e7086f47cf552fa70dc4
--=20
2.30.2

