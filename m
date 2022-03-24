Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AC44E6561
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 15:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351053AbiCXOhh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 10:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351088AbiCXOhg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 10:37:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDC79AE58
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:36:04 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22O8WB21000970
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:36:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VkPJF43yPOIHIIkqjrCBfwXvYiAzmdtPn2mfeEzwxt4=;
 b=Xm/hfdvbVApc6OBjlzG/1KY7ogYOZnu4DHdojqmSK17C4EpEWz8Q6i4XmFoiHCJzw1F/
 6pz2JOnUcrbc5QHkt1I4HcXPbiCoVEFNDoNlLr1m9BZ4CGHL+pgPuFKjtbGmvwntvzwW
 KeNEDfyoHIaauycTAJCv+NEjOJWfffQcG1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0n7a1ty9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:36:03 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 07:36:02 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 1F59F63CB275; Thu, 24 Mar 2022 07:35:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] add tests for nonblocking accept sockets
Date:   Thu, 24 Mar 2022 07:35:47 -0700
Message-ID: <20220324143547.2882041-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: H6xz1i4lKSOcXYtBfeZ61gmsAxDjnlJR
X-Proofpoint-ORIG-GUID: H6xz1i4lKSOcXYtBfeZ61gmsAxDjnlJR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_04,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tests for accept sockets with O_NONBLOCK. Add a test for queueing the
accept both before and after connect(), which tests slightly different
code paths. After connect() has always worked, but before required change=
s
to the kernel.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/accept.c | 132 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 97 insertions(+), 35 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index af2997f..e2c6b51 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -59,27 +59,32 @@ static void queue_recv(struct io_uring *ring, int fd,=
 bool fixed)
 		sqe->flags |=3D IOSQE_FIXED_FILE;
 }
=20
-static int accept_conn(struct io_uring *ring, int fd, bool fixed)
+static void queue_accept_conn(struct io_uring *ring, int fd, int fixed_i=
dx)
 {
 	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
-	int ret, fixed_idx =3D 0;
+	int ret;
=20
 	sqe =3D io_uring_get_sqe(ring);
-	if (!fixed)
+	if (fixed_idx < 0)
 		io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
 	else
 		io_uring_prep_accept_direct(sqe, fd, NULL, NULL, 0, fixed_idx);
=20
 	ret =3D io_uring_submit(ring);
 	assert(ret !=3D -1);
+}
+
+static int accept_conn(struct io_uring *ring, int fixed_idx)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
=20
 	ret =3D io_uring_wait_cqe(ring, &cqe);
 	assert(!ret);
 	ret =3D cqe->res;
 	io_uring_cqe_seen(ring, cqe);
=20
-	if (fixed) {
+	if (fixed_idx >=3D 0) {
 		if (ret > 0) {
 			close(ret);
 			return -EINVAL;
@@ -90,11 +95,13 @@ static int accept_conn(struct io_uring *ring, int fd,=
 bool fixed)
 	return ret;
 }
=20
-static int start_accept_listen(struct sockaddr_in *addr, int port_off)
+static int start_accept_listen(struct sockaddr_in *addr, int port_off,
+			       int extra_flags)
 {
 	int fd, ret;
=20
-	fd =3D socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
+	fd =3D socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC | extra_flags,
+		    IPPROTO_TCP);
=20
 	int32_t val =3D 1;
 	ret =3D setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
@@ -119,14 +126,23 @@ static int start_accept_listen(struct sockaddr_in *=
addr, int port_off)
 	return fd;
 }
=20
-static int test(struct io_uring *ring, int accept_should_error, bool fix=
ed)
+struct accept_test_args {
+	int accept_should_error;
+	bool fixed;
+	bool nonblock;
+	bool queue_accept_before_connect;
+};
+
+static int test(struct io_uring *ring, struct accept_test_args args)
 {
 	struct io_uring_cqe *cqe;
 	struct sockaddr_in addr;
 	uint32_t head, count =3D 0;
 	int ret, p_fd[2], done =3D 0;
=20
-	int32_t val, recv_s0 =3D start_accept_listen(&addr, 0);
+	int32_t val;
+	int32_t recv_s0 =3D start_accept_listen(&addr, 0,
+					      args.nonblock ? O_NONBLOCK : 0);
=20
 	p_fd[1] =3D socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
=20
@@ -141,6 +157,9 @@ static int test(struct io_uring *ring, int accept_sho=
uld_error, bool fixed)
 	ret =3D fcntl(p_fd[1], F_SETFL, flags);
 	assert(ret !=3D -1);
=20
+	if (args.queue_accept_before_connect)
+		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1);
+
 	ret =3D connect(p_fd[1], (struct sockaddr*)&addr, sizeof(addr));
 	assert(ret =3D=3D -1);
=20
@@ -151,18 +170,21 @@ static int test(struct io_uring *ring, int accept_s=
hould_error, bool fixed)
 	ret =3D fcntl(p_fd[1], F_SETFL, flags);
 	assert(ret !=3D -1);
=20
-	p_fd[0] =3D accept_conn(ring, recv_s0, fixed);
+	if (!args.queue_accept_before_connect)
+		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1);
+
+	p_fd[0] =3D accept_conn(ring, args.fixed ? 0 : -1);
 	if (p_fd[0] =3D=3D -EINVAL) {
-		if (accept_should_error)
+		if (args.accept_should_error)
 			goto out;
-		if (fixed)
+		if (args.fixed)
 			fprintf(stdout, "Fixed accept not supported, skipping\n");
 		else
 			fprintf(stdout, "Accept not supported, skipping\n");
 		no_accept =3D 1;
 		goto out;
 	} else if (p_fd[0] < 0) {
-		if (accept_should_error &&
+		if (args.accept_should_error &&
 		    (p_fd[0] =3D=3D -EBADF || p_fd[0] =3D=3D -EINVAL))
 			goto out;
 		fprintf(stderr, "Accept got %d\n", p_fd[0]);
@@ -170,7 +192,7 @@ static int test(struct io_uring *ring, int accept_sho=
uld_error, bool fixed)
 	}
=20
 	queue_send(ring, p_fd[1]);
-	queue_recv(ring, p_fd[0], fixed);
+	queue_recv(ring, p_fd[0], args.fixed);
=20
 	ret =3D io_uring_submit_and_wait(ring, 2);
 	assert(ret !=3D -1);
@@ -194,13 +216,13 @@ static int test(struct io_uring *ring, int accept_s=
hould_error, bool fixed)
 	}
=20
 out:
-	if (!fixed)
+	if (!args.fixed)
 		close(p_fd[0]);
 	close(p_fd[1]);
 	close(recv_s0);
 	return 0;
 err:
-	if (!fixed)
+	if (!args.fixed)
 		close(p_fd[0]);
 	close(p_fd[1]);
 	close(recv_s0);
@@ -222,7 +244,7 @@ static int test_accept_pending_on_exit(void)
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >=3D 0);
=20
-	fd =3D start_accept_listen(NULL, 0);
+	fd =3D start_accept_listen(NULL, 0, 0);
=20
 	sqe =3D io_uring_get_sqe(&m_io_uring);
 	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
@@ -242,7 +264,7 @@ static int test_accept_pending_on_exit(void)
 /*
  * Test issue many accepts and see if we handle cancellation on exit
  */
-static int test_accept_many(unsigned nr, unsigned usecs)
+static int test_accept_many(unsigned nr, unsigned usecs, bool nonblock)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_cqe *cqe;
@@ -270,7 +292,8 @@ static int test_accept_many(unsigned nr, unsigned use=
cs)
 	fds =3D t_calloc(nr, sizeof(int));
=20
 	for (i =3D 0; i < nr; i++)
-		fds[i] =3D start_accept_listen(NULL, i);
+		fds[i] =3D start_accept_listen(NULL, i,
+					     nonblock ? O_NONBLOCK : 0);
=20
 	for (i =3D 0; i < nr; i++) {
 		sqe =3D io_uring_get_sqe(&m_io_uring);
@@ -286,12 +309,15 @@ static int test_accept_many(unsigned nr, unsigned u=
secs)
 	for (i =3D 0; i < nr; i++) {
 		if (io_uring_peek_cqe(&m_io_uring, &cqe))
 			break;
-		if (cqe->res !=3D -ECANCELED) {
-			fprintf(stderr, "Expected cqe to be cancelled\n");
-			goto err;
+		if (cqe->res !=3D -ECANCELED &&
+		    !(cqe->res =3D=3D -EAGAIN && nonblock)) {
+			fprintf(stderr, "Expected cqe to be cancelled %d\n", cqe->res);
+			ret =3D 1;
+			goto out;
 		}
 		io_uring_cqe_seen(&m_io_uring, cqe);
 	}
+	ret =3D 0;
 out:
 	rlim.rlim_cur =3D cur_lim;
 	if (setrlimit(RLIMIT_NPROC, &rlim) < 0) {
@@ -301,10 +327,7 @@ out:
=20
 	free(fds);
 	io_uring_queue_exit(&m_io_uring);
-	return 0;
-err:
-	ret =3D 1;
-	goto out;
+	return ret;
 }
=20
 static int test_accept_cancel(unsigned usecs)
@@ -317,7 +340,7 @@ static int test_accept_cancel(unsigned usecs)
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >=3D 0);
=20
-	fd =3D start_accept_listen(NULL, 0);
+	fd =3D start_accept_listen(NULL, 0, 0);
=20
 	sqe =3D io_uring_get_sqe(&m_io_uring);
 	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
@@ -372,10 +395,27 @@ static int test_accept(void)
 {
 	struct io_uring m_io_uring;
 	int ret;
+	struct accept_test_args args =3D { };
=20
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >=3D 0);
-	ret =3D test(&m_io_uring, 0, false);
+	ret =3D test(&m_io_uring, args);
+	io_uring_queue_exit(&m_io_uring);
+	return ret;
+}
+
+static int test_accept_nonblock(bool queue_before_connect)
+{
+	struct io_uring m_io_uring;
+	int ret;
+	struct accept_test_args args =3D {
+		.nonblock =3D true,
+		.queue_accept_before_connect =3D queue_before_connect
+	};
+
+	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
+	assert(ret >=3D 0);
+	ret =3D test(&m_io_uring, args);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
@@ -384,12 +424,15 @@ static int test_accept_fixed(void)
 {
 	struct io_uring m_io_uring;
 	int ret, fd =3D -1;
+	struct accept_test_args args =3D {
+		.fixed =3D true
+	};
=20
 	ret =3D io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >=3D 0);
 	ret =3D io_uring_register_files(&m_io_uring, &fd, 1);
 	assert(ret =3D=3D 0);
-	ret =3D test(&m_io_uring, 0, true);
+	ret =3D test(&m_io_uring, args);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
@@ -398,7 +441,8 @@ static int test_accept_sqpoll(void)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_params p =3D { };
-	int ret, should_fail;
+	int ret;
+	struct accept_test_args args =3D { };
=20
 	p.flags =3D IORING_SETUP_SQPOLL;
 	ret =3D t_create_ring_params(32, &m_io_uring, &p);
@@ -407,11 +451,11 @@ static int test_accept_sqpoll(void)
 	else if (ret < 0)
 		return ret;
=20
-	should_fail =3D 1;
+	args.accept_should_error =3D 1;
 	if (p.features & IORING_FEAT_SQPOLL_NONFIXED)
-		should_fail =3D 0;
+		args.accept_should_error =3D 0;
=20
-	ret =3D test(&m_io_uring, should_fail, false);
+	ret =3D test(&m_io_uring, args);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
@@ -431,6 +475,18 @@ int main(int argc, char *argv[])
 	if (no_accept)
 		return 0;
=20
+	ret =3D test_accept_nonblock(false);
+	if (ret) {
+		fprintf(stderr, "test_accept_nonblock failed\n");
+		return ret;
+	}
+
+	ret =3D test_accept_nonblock(true);
+	if (ret) {
+		fprintf(stderr, "test_accept_nonblock(queue_before) failed\n");
+		return ret;
+	}
+
 	ret =3D test_accept_fixed();
 	if (ret) {
 		fprintf(stderr, "test_accept_fixed failed\n");
@@ -455,18 +511,24 @@ int main(int argc, char *argv[])
 		return ret;
 	}
=20
-	ret =3D test_accept_many(128, 0);
+	ret =3D test_accept_many(128, 0, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_many failed\n");
 		return ret;
 	}
=20
-	ret =3D test_accept_many(128, 100000);
+	ret =3D test_accept_many(128, 100000, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_many failed\n");
 		return ret;
 	}
=20
+	ret =3D test_accept_many(128, 0, true);
+	if (ret) {
+		fprintf(stderr, "test_accept_many nonblocking failed\n");
+		return ret;
+	}
+
 	ret =3D test_accept_pending_on_exit();
 	if (ret) {
 		fprintf(stderr, "test_accept_pending_on_exit failed\n");

base-commit: 68c8759abcbff6262e7aa758beec3c9f5696ee46
--=20
2.30.2

