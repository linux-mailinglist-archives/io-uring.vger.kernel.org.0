Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C530567E2C8
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 12:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjA0LL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 06:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjA0LL6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 06:11:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DCA5AB41
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:57 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R8D3Xx024286
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=j+T2de/rQ1tKJORsJG3n8q8AhcOofqpPkUtnpca9BnU=;
 b=a99+vAedfQxWwnulTigbS0KStJWcaEie1TzIHgjH87J4LCVLmnLO7IfJYaoyfB/YmR0h
 LjYS1+JI3j41MlHjzJkgo3fDeg5jY8QbKGwnyOFsVD0alBeB5D1N5iD+zTOYD101QIOk
 wj3SLVS95n49+ngN5/a9Xof6w9MWkX0vsDBV7+birAWHj5wB2zpNBc0AyX80O+Pp3WH0
 cP462KN4v8KRoFHyo0ua9CDv0X2pEw+KDgOJoI5SkV6ZyE09HjgdrncdGqMxLNWz4Aq0
 2DeDbeFv1g5giL4T0VbP16MAskv5kDTjACNZ5txnHS88vdx1VMKH/a2WLZw4GYz7cEyP yg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nc35x2mca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:57 -0800
Received: from twshared9608.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 03:11:54 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EFC57EA01684; Fri, 27 Jan 2023 03:11:44 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 1/2] add a test using drain with IORING_SETUP_DEFER_TASKRUN
Date:   Fri, 27 Jan 2023 03:11:32 -0800
Message-ID: <20230127111133.2551653-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127111133.2551653-1-dylany@meta.com>
References: <20230127111133.2551653-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xT-hKq117UZaXbuTD7WKXs4JEVCc0W-Q
X-Proofpoint-GUID: xT-hKq117UZaXbuTD7WKXs4JEVCc0W-Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_06,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This exposes a bug in the kernels handling of drain on an empty ring.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/defer-taskrun.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index 624285ec9582..a013cfdf02d9 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -283,6 +283,45 @@ static int test_ring_shutdown(void)
 	return 0;
 }
=20
+static int test_drain(void)
+{
+	struct io_uring ring;
+	int ret, i, fd[2];
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec iovecs[128];
+	char buff[ARRAY_SIZE(iovecs)];
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN |
+					    IORING_SETUP_TASKRUN_FLAG);
+	CHECK(!ret);
+
+	for (i =3D 0; i < ARRAY_SIZE(iovecs); i++) {
+		iovecs[i].iov_base =3D &buff[i];
+		iovecs[i].iov_len =3D 1;
+	}
+
+	ret =3D t_create_socket_pair(fd, true);
+	CHECK(!ret);
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_writev(sqe, fd[1], &iovecs[0], ARRAY_SIZE(iovecs), 0);
+	sqe->flags |=3D IOSQE_IO_DRAIN;
+	io_uring_submit(&ring);
+
+	for (i =3D 0; i < ARRAY_SIZE(iovecs); i++)
+		iovecs[i].iov_base =3D NULL;
+
+	CHECK(io_uring_wait_cqe(&ring, &cqe) =3D=3D 0);
+	CHECK(cqe->res =3D=3D 128);
+
+	close(fd[0]);
+	close(fd[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -332,5 +371,11 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
=20
+	ret =3D test_drain();
+	if (ret) {
+		fprintf(stderr, "test_drain failed\n");
+		return T_EXIT_FAIL;
+	}
+
 	return T_EXIT_PASS;
 }
--=20
2.30.2

