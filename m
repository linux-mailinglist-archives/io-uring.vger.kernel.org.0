Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4D15EAC69
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiIZQZd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 12:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiIZQZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 12:25:05 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACF415A23
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QEkvah030359
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=U1X2deYCznWfYeH2ELATLj6Mttpb2cNoeV62gmKj8SA=;
 b=GNp8huoOr2H9UzoOGsOqINEuiwTy//scsJc2vNV9bZzpbUMOl2UhHnA9l22foHtmzcfg
 qlyLlhHmVCLRmKfYUSX/htGgILt8hzajdi6wNml9fvUM1zAFjFO6rdDZdb4hu8xr9nAO
 yjhtxu24U9vUb2YWY6b+EiICgPU6B6govng= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jsyn03h06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:23 -0700
Received: from twshared14494.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:14:22 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id ABA976AF7F4A; Mon, 26 Sep 2022 08:14:17 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/2] handle single issuer task registration at ring creation
Date:   Mon, 26 Sep 2022 08:14:11 -0700
Message-ID: <20220926151412.2515493-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926151412.2515493-1-dylany@fb.com>
References: <20220926151412.2515493-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uUYUnd8sndoS0O14WmDlYgAN5SghXAYG
X-Proofpoint-ORIG-GUID: uUYUnd8sndoS0O14WmDlYgAN5SghXAYG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_SETUP_SINGLE_ISSUER now registers the task at ring creation, so
update the tests and documentation to reflect this.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_setup.2 |  8 ++++----
 test/defer-taskrun.c | 12 ++++--------
 test/single-issuer.c | 14 +++++++-------
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index fb1f90dc2ebc..afeee858c458 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -241,14 +241,14 @@ only the
 passthrough command for NVMe passthrough needs this. Available since 5.1=
9.
 .TP
 .B IORING_SETUP_SINGLE_ISSUER
-A hint to the kernel that only a single task can submit requests, which =
is used
-for internal optimisations. The kernel enforces the rule, which only aff=
ects
+A hint to the kernel that only a single task (or thread) will submit req=
uests, which is
+used for internal optimisations. This task must be the one that created =
the ring, and
+the kernel enforces this rule. This only affects
 .I
 io_uring_enter(2)
 calls submitting requests and will fail them with
 .B -EEXIST
 if the restriction is violated.
-The submitter task may differ from the task that created the ring.
 Note that when
 .B IORING_SETUP_SQPOLL
 is set it is considered that the polling task is doing all submissions
@@ -256,7 +256,7 @@ on behalf of the userspace and so it always complies =
with the rule disregarding
 how many userspace tasks do
 .I
 io_uring_enter(2).
-Available since 5.20.
+Available since 6.0.
 .TP
 .B IORING_SETUP_DEFER_TASKRUN
 By default, io_uring will process all outstanding work at the end of any=
 system
diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index c6e0ea0d6c99..2c4ed6df37d3 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -123,6 +123,9 @@ void *thread(void *t)
 {
 	struct thread_data *td =3D t;
=20
+	assert(io_uring_queue_init(8, &td->ring, IORING_SETUP_SINGLE_ISSUER |
+					IORING_SETUP_DEFER_TASKRUN) =3D=3D 0);
+
 	io_uring_prep_read(io_uring_get_sqe(&td->ring), td->efd, td->buff, size=
of(td->buff), 0);
 	io_uring_submit(&td->ring);
=20
@@ -132,23 +135,16 @@ void *thread(void *t)
 static int test_thread_shutdown(void)
 {
 	pthread_t t1;
-	int ret;
 	struct thread_data td;
 	struct io_uring_cqe *cqe;
 	uint64_t val =3D 1;
=20
-	ret =3D io_uring_queue_init(8, &td.ring, IORING_SETUP_SINGLE_ISSUER |
-					       IORING_SETUP_DEFER_TASKRUN);
-	if (ret)
-		return ret;
-
-	CHECK(io_uring_get_events(&td.ring) =3D=3D -EEXIST);
-
 	td.efd =3D eventfd(0, 0);
 	CHECK(td.efd >=3D 0);
=20
 	CHECK(pthread_create(&t1, NULL, thread, &td) =3D=3D 0);
 	CHECK(pthread_join(t1, NULL) =3D=3D 0);
+	CHECK(io_uring_get_events(&td.ring) =3D=3D -EEXIST);
=20
 	CHECK(write(td.efd, &val, sizeof(val)) =3D=3D sizeof(val));
 	CHECK(io_uring_wait_cqe(&td.ring, &cqe) =3D=3D -EEXIST);
diff --git a/test/single-issuer.c b/test/single-issuer.c
index 29830f1af998..55af98f300aa 100644
--- a/test/single-issuer.c
+++ b/test/single-issuer.c
@@ -96,7 +96,7 @@ int main(int argc, char *argv[])
 	if (!fork_t()) {
 		ret =3D try_submit(&ring);
 		if (ret !=3D -EEXIST)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
+			fprintf(stderr, "1: not owner child could submit %i\n", ret);
 		return ret !=3D -EEXIST;
 	}
 	wait_child_t();
@@ -109,9 +109,9 @@ int main(int argc, char *argv[])
=20
 	if (!fork_t()) {
 		ret =3D try_submit(&ring);
-		if (ret)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
-		return !!ret;
+		if (ret !=3D -EEXIST)
+			fprintf(stderr, "2: not owner child could submit %i\n", ret);
+		return ret !=3D -EEXIST;
 	}
 	wait_child_t();
 	io_uring_queue_exit(&ring);
@@ -143,9 +143,9 @@ int main(int argc, char *argv[])
=20
 	if (!fork_t()) {
 		ret =3D try_submit(&ring);
-		if (ret)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
-		return !!ret;
+		if (ret !=3D -EEXIST)
+			fprintf(stderr, "3: not owner child could submit %i\n", ret);
+		return ret !=3D -EEXIST;
 	}
 	wait_child_t();
 	io_uring_queue_exit(&ring);
--=20
2.30.2

