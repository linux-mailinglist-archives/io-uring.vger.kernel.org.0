Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11957D0A1
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGUQEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 12:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGUQEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 12:04:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A5C58876
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LF1San005785
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hB7hrsIwKUiiM+hcXpPwrwCuXz+erNPf3fgsJU38bOw=;
 b=PAvuCHdZRe8YnI0IT/m//ZSk5tBJ1BcqGnYgCSY/HuEqa9BpEFziQR7tLF6hVGghTOWm
 l/hrCyBeBsHUHyyc2ZkdfXY1G9dcTNOLxFsFBzCk6kI4ZP/X3hZ3Lu17Mam35LlPLM8j
 Ds9qc9prVbZUdw4kYFI0Z/Of/Yd9VYNMJW8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hes8vd6jx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:14 -0700
Received: from twshared7556.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:04:12 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DF48735A05E2; Thu, 21 Jul 2022 09:04:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/2] test: have poll-mshot-update run with both big and small cqe
Date:   Thu, 21 Jul 2022 09:04:06 -0700
Message-ID: <20220721160406.1700508-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721160406.1700508-1-dylany@fb.com>
References: <20220721160406.1700508-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: j7j0rR3eJkJygzUdeHVx72QwOIcPa9-r
X-Proofpoint-ORIG-GUID: j7j0rR3eJkJygzUdeHVx72QwOIcPa9-r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Run the test twice, with and without overflow to make sure more codepaths
are tested.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/poll-mshot-update.c | 90 +++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 33 deletions(-)

diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index e01befcfa7eb..eeb725437cc8 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -213,52 +213,23 @@ static int arm_polls(struct io_uring *ring)
 	return 0;
 }
=20
-int main(int argc, char *argv[])
+static int run(int cqe)
 {
 	struct io_uring ring;
 	struct io_uring_params params =3D { };
-	struct rlimit rlim;
 	pthread_t thread;
 	int i, j, ret;
=20
-	if (argc > 1)
-		return 0;
-
-	ret =3D has_poll_update();
-	if (ret < 0) {
-		fprintf(stderr, "poll update check failed %i\n", ret);
-		return -1;
-	} else if (!ret) {
-		fprintf(stderr, "no poll update, skip\n");
-		return 0;
-	}
-
-	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0) {
-		perror("getrlimit");
-		goto err_noring;
-	}
-
-	if (rlim.rlim_cur < (2 * NFILES + 5)) {
-		rlim.rlim_cur =3D (2 * NFILES + 5);
-		rlim.rlim_max =3D rlim.rlim_cur;
-		if (setrlimit(RLIMIT_NOFILE, &rlim) < 0) {
-			if (errno =3D=3D EPERM)
-				goto err_nofail;
-			perror("setrlimit");
-			goto err_noring;
-		}
-	}
-
 	for (i =3D 0; i < NFILES; i++) {
 		if (pipe(p[i].fd) < 0) {
 			perror("pipe");
-			goto err_noring;
+			return 1;
 		}
 		fcntl(p[i].fd[0], F_SETFL, O_NONBLOCK);
 	}
=20
 	params.flags =3D IORING_SETUP_CQSIZE;
-	params.cq_entries =3D 4096;
+	params.cq_entries =3D cqe;
 	ret =3D io_uring_queue_init_params(RING_SIZE, &ring, &params);
 	if (ret) {
 		if (ret =3D=3D -EINVAL) {
@@ -286,10 +257,63 @@ int main(int argc, char *argv[])
 	}
=20
 	io_uring_queue_exit(&ring);
+	for (i =3D 0; i < NFILES; i++) {
+		close(p[i].fd[0]);
+		close(p[i].fd[1]);
+	}
 	return 0;
 err:
 	io_uring_queue_exit(&ring);
-err_noring:
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct rlimit rlim;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret =3D has_poll_update();
+	if (ret < 0) {
+		fprintf(stderr, "poll update check failed %i\n", ret);
+		return -1;
+	} else if (!ret) {
+		fprintf(stderr, "no poll update, skip\n");
+		return 0;
+	}
+
+	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0) {
+		perror("getrlimit");
+		goto err;
+	}
+
+	if (rlim.rlim_cur < (2 * NFILES + 5)) {
+		rlim.rlim_cur =3D (2 * NFILES + 5);
+		rlim.rlim_max =3D rlim.rlim_cur;
+		if (setrlimit(RLIMIT_NOFILE, &rlim) < 0) {
+			if (errno =3D=3D EPERM)
+				goto err_nofail;
+			perror("setrlimit");
+			goto err;
+		}
+	}
+
+	ret =3D run(1024);
+	if (ret) {
+		fprintf(stderr, "run(1024) failed\n");
+		goto err;
+	}
+
+	ret =3D run(8192);
+	if (ret) {
+		fprintf(stderr, "run(8192) failed\n");
+		goto err;
+	}
+
+	return 0;
+err:
 	fprintf(stderr, "poll-many failed\n");
 	return 1;
 err_nofail:
--=20
2.30.2

