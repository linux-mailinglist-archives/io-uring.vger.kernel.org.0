Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC355EBF9F
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 12:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiI0KWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 06:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiI0KWN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 06:22:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B95D433E
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:12 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28R8ISFd010377
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5VfTKNo6pHrMDAVVR8PUNFNokr5Q9UuzBp+c10LH5/I=;
 b=LV1CFcsSMQt69m8O/jiK4W6cjJq3z1XghkT9dxuJWyEiD22tp+qulh6KbLWX+UbGYudM
 divOEoHXGG4ka/YjsOhgh2Y+JN+484efJz23RECqYQczFVhmk0xg8a7j5gJt6GUDilfl
 c+GchGYyNDDKYLRQ7If1DrWWuYOUSTJa6NA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3juwhv8ku8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:11 -0700
Received: from twshared8247.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 03:22:09 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 203DD6B9F4C8; Tue, 27 Sep 2022 03:22:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 1/3] handle single issuer task registration at ring creation
Date:   Tue, 27 Sep 2022 03:22:00 -0700
Message-ID: <20220927102202.69069-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927102202.69069-1-dylany@fb.com>
References: <20220927102202.69069-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PmSJ18Rz1nZ-QCE-FZJ76g2a8fw8wqOq
X-Proofpoint-ORIG-GUID: PmSJ18Rz1nZ-QCE-FZJ76g2a8fw8wqOq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_03,2022-09-22_02,2022-06-22_01
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
 man/io_uring_setup.2 | 18 +++++++++---------
 test/defer-taskrun.c |  8 ++++++--
 test/single-issuer.c | 34 ++++++++++++++++++++++++++--------
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index fb1f90dc2ebc..502a803d2308 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -241,22 +241,22 @@ only the
 passthrough command for NVMe passthrough needs this. Available since 5.1=
9.
 .TP
 .B IORING_SETUP_SINGLE_ISSUER
-A hint to the kernel that only a single task can submit requests, which =
is used
-for internal optimisations. The kernel enforces the rule, which only aff=
ects
-.I
-io_uring_enter(2)
-calls submitting requests and will fail them with
+A hint to the kernel that only a single task (or thread) will submit req=
uests, which is
+used for internal optimisations. The submission task is either the task =
that created the
+ring, or if
+.B IORING_SETUP_R_DISABLED
+is specified then it is the task that enables the ring through
+.BR io_uring_register (2) .
+The kernel enforces this rule, failing requests with
 .B -EEXIST
 if the restriction is violated.
-The submitter task may differ from the task that created the ring.
 Note that when
 .B IORING_SETUP_SQPOLL
 is set it is considered that the polling task is doing all submissions
 on behalf of the userspace and so it always complies with the rule disre=
garding
 how many userspace tasks do
-.I
-io_uring_enter(2).
-Available since 5.20.
+.BR io_uring_enter(2).
+Available since 6.0.
 .TP
 .B IORING_SETUP_DEFER_TASKRUN
 By default, io_uring will process all outstanding work at the end of any=
 system
diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index c6e0ea0d6c99..9283f2866c6b 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -123,6 +123,7 @@ void *thread(void *t)
 {
 	struct thread_data *td =3D t;
=20
+	io_uring_enable_rings(&td->ring);
 	io_uring_prep_read(io_uring_get_sqe(&td->ring), td->efd, td->buff, size=
of(td->buff), 0);
 	io_uring_submit(&td->ring);
=20
@@ -138,11 +139,12 @@ static int test_thread_shutdown(void)
 	uint64_t val =3D 1;
=20
 	ret =3D io_uring_queue_init(8, &td.ring, IORING_SETUP_SINGLE_ISSUER |
-					       IORING_SETUP_DEFER_TASKRUN);
+					       IORING_SETUP_DEFER_TASKRUN |
+					       IORING_SETUP_R_DISABLED);
 	if (ret)
 		return ret;
=20
-	CHECK(io_uring_get_events(&td.ring) =3D=3D -EEXIST);
+	CHECK(io_uring_get_events(&td.ring) =3D=3D -EBADFD);
=20
 	td.efd =3D eventfd(0, 0);
 	CHECK(td.efd >=3D 0);
@@ -150,6 +152,8 @@ static int test_thread_shutdown(void)
 	CHECK(pthread_create(&t1, NULL, thread, &td) =3D=3D 0);
 	CHECK(pthread_join(t1, NULL) =3D=3D 0);
=20
+	CHECK(io_uring_get_events(&td.ring) =3D=3D -EEXIST);
+
 	CHECK(write(td.efd, &val, sizeof(val)) =3D=3D sizeof(val));
 	CHECK(io_uring_wait_cqe(&td.ring, &cqe) =3D=3D -EEXIST);
=20
diff --git a/test/single-issuer.c b/test/single-issuer.c
index 29830f1af998..1d13f47202f8 100644
--- a/test/single-issuer.c
+++ b/test/single-issuer.c
@@ -96,30 +96,48 @@ int main(int argc, char *argv[])
 	if (!fork_t()) {
 		ret =3D try_submit(&ring);
 		if (ret !=3D -EEXIST)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
+			fprintf(stderr, "1: not owner child could submit %i\n", ret);
 		return ret !=3D -EEXIST;
 	}
 	wait_child_t();
 	io_uring_queue_exit(&ring);
=20
 	/* test that the first submitter but not creator can submit */
-	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_R_DISABLED);
 	if (ret)
 		error(1, ret, "ring init (2) %i", ret);
=20
 	if (!fork_t()) {
+		io_uring_enable_rings(&ring);
 		ret =3D try_submit(&ring);
 		if (ret)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
+			fprintf(stderr, "2: not owner child could submit %i\n", ret);
 		return !!ret;
 	}
 	wait_child_t();
 	io_uring_queue_exit(&ring);
=20
+	/* test that only the first enabler can submit */
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_R_DISABLED);
+	if (ret)
+		error(1, ret, "ring init (3) %i", ret);
+
+	io_uring_enable_rings(&ring);
+	if (!fork_t()) {
+		ret =3D try_submit(&ring);
+		if (ret !=3D -EEXIST)
+			fprintf(stderr, "3: not owner child could submit %i\n", ret);
+		return ret !=3D -EEXIST;
+	}
+	wait_child_t();
+	io_uring_queue_exit(&ring);
+
 	/* test that anyone can submit to a SQPOLL|SINGLE_ISSUER ring */
 	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER|IORING=
_SETUP_SQPOLL);
 	if (ret)
-		error(1, ret, "ring init (3) %i", ret);
+		error(1, ret, "ring init (4) %i", ret);
=20
 	ret =3D try_submit(&ring);
 	if (ret) {
@@ -139,13 +157,13 @@ int main(int argc, char *argv[])
 	/* test that IORING_ENTER_REGISTERED_RING doesn't break anything */
 	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
 	if (ret)
-		error(1, ret, "ring init (4) %i", ret);
+		error(1, ret, "ring init (5) %i", ret);
=20
 	if (!fork_t()) {
 		ret =3D try_submit(&ring);
-		if (ret)
-			fprintf(stderr, "not owner child could submit %i\n", ret);
-		return !!ret;
+		if (ret !=3D -EEXIST)
+			fprintf(stderr, "4: not owner child could submit %i\n", ret);
+		return ret !=3D -EEXIST;
 	}
 	wait_child_t();
 	io_uring_queue_exit(&ring);
--=20
2.30.2

