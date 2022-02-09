Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270864AFCEE
	for <lists+io-uring@lfdr.de>; Wed,  9 Feb 2022 20:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiBITIv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 14:08:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiBITIv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 14:08:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C125DC03326A
        for <io-uring@vger.kernel.org>; Wed,  9 Feb 2022 11:08:43 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219HJdwc009741
        for <io-uring@vger.kernel.org>; Wed, 9 Feb 2022 11:07:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=WYVDjuqn73Ft+OW5mmD+2Ooo41C6lDiv34Tz5DlnpIw=;
 b=g329miOGGa6qh513aqtAQ2UD5Vb9+yY0xt3GLc4vWD46KpinAbN5bueAQRz5l062P4hV
 DwMXn0w7XDmSua50omRB06lQbwJ3v7nmL5HrlA2/ANRZ9w92Q/A1xj8YKFmSi4w/u03u
 C3BN62e2AhI8SA+aQEcKQiOFM7t50Sq8kqk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e467353u6-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 09 Feb 2022 11:07:13 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 11:07:11 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C39EDA85562B; Wed,  9 Feb 2022 11:04:31 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v1] liburing: add test for stable statx api
Date:   Wed, 9 Feb 2022 11:04:30 -0800
Message-ID: <20220209190430.2378305-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6uy2PljoUzzu5PZ4gdjaYspAzk7Z-ENY
X-Proofpoint-ORIG-GUID: 6uy2PljoUzzu5PZ4gdjaYspAzk7Z-ENY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_10,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=912 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090101
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds a test for the statx api to verify that io-uring statx api is
stable.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/statx.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/test/statx.c b/test/statx.c
index c0f9e9c..61268d4 100644
--- a/test/statx.c
+++ b/test/statx.c
@@ -77,6 +77,61 @@ err:
 	return -1;
 }
=20
+static int test_statx_stable(struct io_uring *ring, const char *path)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct statx x1, x2;
+	char path1[PATH_MAX];
+	char path2[PATH_MAX];
+	int ret =3D -1;
+
+	strcpy(path2, path);
+	strcpy(path1, path);
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_statx(sqe, -1, path1, 0, STATX_ALL, &x1);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+	memset(path1, 0, sizeof(path1));
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+
+	ret =3D cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (ret) {
+		fprintf(stderr, "statx res =3D %d\n", ret);
+		goto err;
+	}
+
+	ret =3D do_statx(-1, path2, 0, STATX_ALL, &x2);
+	if (ret < 0)
+		return statx_syscall_supported();
+
+	if (memcmp(&x1, &x2, sizeof(x1))) {
+		fprintf(stderr, "Miscompare between io_uring and statx\n");
+		goto err;
+	}
+
+	ret =3D 0;
+
+err:
+	return ret;
+}
+
 static int test_statx_fd(struct io_uring *ring, const char *path)
 {
 	struct io_uring_cqe *cqe;
@@ -156,6 +211,16 @@ int main(int argc, char *argv[])
 		goto err;
 	}
=20
+	ret =3D test_statx_stable(&ring, fname);
+	if (ret) {
+		if (ret =3D=3D -EINVAL) {
+			fprintf(stdout, "statx not supported, skipping\n");
+			goto done;
+		}
+		fprintf(stderr, "test_statx_loop failed: %d\n", ret);
+		goto err;
+	}
+
 	ret =3D test_statx_fd(&ring, fname);
 	if (ret) {
 		fprintf(stderr, "test_statx_fd failed: %d\n", ret);

base-commit: d9b0a424471f5c584f1d3f370e1746925733c01a
--=20
2.30.2

