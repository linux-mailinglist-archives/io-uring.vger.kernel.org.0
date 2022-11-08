Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04308620CB2
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 10:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiKHJx7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 04:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiKHJx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 04:53:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A254713D4A
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 01:53:57 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A85pwqp017006
        for <io-uring@vger.kernel.org>; Tue, 8 Nov 2022 01:53:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=A/O8DBN86Y9lZfEcYDppiozjEhGvHZHUkXwDnZO5ZK8=;
 b=SA8lLEImnAQt4u6VrQYsZr2puhcqwWUSTSYaP1r4Ff0sjh+jvSgD+HmdDDt/HNtaVbZt
 GHq84bP0VbsNVrM7b6AiLwloxmxXewBj2zDgcG/FTOirvjCUzrvukPBx7t3pKGGLLkWY
 e5q1iDmB1z+671qzOqCs5xepbnxXUuPtr3LYt6Dcem+WuZRGqJgETbVhoCtvqtC4kAwi
 X1GG/cunEjiYSLOcTcLA9laOEhqTVFYZxbuWhjZMOhqZvY4SGvYYb49cTHUA75Q3jEWp
 kAnYj6akzk91FC7e5vXFbeoEzYNEM6apU5s7tqD6epC4zNxIcTsLMM+7G0F8WW7HMild /g== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqhba17cs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 01:53:57 -0800
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 01:53:55 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 035E991AC267; Tue,  8 Nov 2022 01:53:48 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing v2] test that unregister_files processes task work
Date:   Tue, 8 Nov 2022 01:53:47 -0800
Message-ID: <20221108095347.3830634-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wDYCHQTOkAgOOB_a-JawPB5CxdtcDOyk
X-Proofpoint-GUID: wDYCHQTOkAgOOB_a-JawPB5CxdtcDOyk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure that unregister_files processes task work from defer_taskrun even
when not explicitly flushed.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---

v2:
 - fix return code when ring init fails

 test/file-register.c | 57 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/test/file-register.c b/test/file-register.c
index 634ef8159cec..975f89d5a94b 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -935,6 +935,55 @@ static int test_zero_range_alloc(struct io_uring *ri=
ng, int fds[2])
 	return 0;
 }
=20
+static int test_defer_taskrun(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int ret, fds[2];
+	char buff =3D 'x';
+
+	ret =3D io_uring_queue_init(8, &ring,
+				  IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SINGLE_ISSUER);
+	if (ret) {
+		fprintf(stderr, "ring init\n");
+		return 1;
+	}
+
+	ret =3D pipe(fds);
+	if (ret) {
+		fprintf(stderr, "bad pipes\n");
+		return 1;
+	}
+
+	ret =3D io_uring_register_files(&ring, &fds[0], 2);
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, 0, &buff, 1, 0);
+	sqe->flags |=3D IOSQE_FIXED_FILE;
+	ret =3D io_uring_submit(&ring);
+	if (ret !=3D 1) {
+		fprintf(stderr, "bad submit\n");
+		return 1;
+	}
+
+	ret =3D write(fds[1], &buff, 1);
+	if (ret !=3D 1) {
+		fprintf(stderr, "bad pipe write\n");
+		return 1;
+	}
+
+	ret =3D io_uring_unregister_files(&ring);
+	if (ret) {
+		fprintf(stderr, "bad unregister %d\n", ret);
+		return 1;
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 static int test_file_alloc_ranges(void)
 {
 	struct io_uring ring;
@@ -1120,5 +1169,13 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
=20
+	if (t_probe_defer_taskrun()) {
+		ret =3D test_defer_taskrun();
+		if (ret) {
+			fprintf(stderr, "test_defer_taskrun failed\n");
+			return T_EXIT_FAIL;
+		}
+	}
+
 	return T_EXIT_PASS;
 }

base-commit: 754bc068ec482c5338a07dd74b7d3892729bb847
--=20
2.30.2

