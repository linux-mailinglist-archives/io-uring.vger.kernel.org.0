Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7ED495F68
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 14:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbiAUNHI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 08:07:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380549AbiAUNGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jan 2022 08:06:53 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L06XBo010764
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 05:06:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=1DXXF5oMXWXRE35tCOeqMgWYORzjdlF4E+Cbmbq4lDc=;
 b=c7qRJhJjjOCCCAFzOvYKf2YxQ24FZv31NMKneecafKg9HfPdksv9rK1/0ltJa8BxQaRF
 vnbIlGp0bnYdFPSf8j15mLHXD2d6NDKxFnARZtBNHeB7qIP9ms/IzJQ+azOiUwCi2sfJ
 1OcSb00YjpRlCmIiXtJSBoGgSLr3XfCTYV8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0gk2ms-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 05:06:52 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 05:06:51 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 878772C3FB9B; Fri, 21 Jan 2022 05:06:45 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] Add a test that ensures unregistering is reasonably quick
Date:   Fri, 21 Jan 2022 05:06:07 -0800
Message-ID: <20220121130607.3985559-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: g3lH7PALZlz7AHNMpzFJ-JMsYp0f89uT
X-Proofpoint-GUID: g3lH7PALZlz7AHNMpzFJ-JMsYp0f89uT
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There was a bug [1] in io_uring that caused a 1 second delay on shutdown
due to how registered resources were cleaned up. This test exposes the
bug, and verifies that it does not reoccur. While time based tests have
the potential to be flaky, locally with the fix it completes in 5ms, and
so I do not expect this to be a practical problem.

[1]: https://lore.kernel.org/io-uring/20220121123856.3557884-1-dylany@fb.co=
m/T/#u

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/io_uring_register.c | 46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index b8a4ea5..8bf0fd3 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -609,6 +609,50 @@ out:
 	return 0;
 }
=20
+static size_t timeus(struct timespec t)
+{
+	return (size_t)t.tv_sec * 1000000 + t.tv_nsec / 1000;
+}
+
+static int
+test_unregister_speed(void)
+{
+	struct timespec start, end;
+	struct io_uring_params p;
+	int fd, ret;
+	struct iovec iov;
+	size_t diff;
+	void *buf;
+
+	memset(&p, 0, sizeof(p));
+	fd =3D new_io_uring(1, &p);
+
+	buf =3D t_malloc(pagesize);
+	iov.iov_base =3D buf;
+	iov.iov_len =3D pagesize;
+
+	ret =3D __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
+	if (ret) {
+		fprintf(stderr, "error registering buffers\n");
+		goto done;
+	}
+
+	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
+	__sys_io_uring_register(fd, IORING_UNREGISTER_BUFFERS, 0, 0);
+	clock_gettime(CLOCK_MONOTONIC_RAW, &end);
+	diff =3D timeus(end) - timeus(start);
+
+	/* 500ms should be enough to deregister any buffers */
+	ret =3D  diff > 500000 ? -1 : 0;
+
+	fprintf(stderr, "took %lu us to unregister buffers: %s\n",
+		diff, ret ? "FAIL" : "PASS");
+done:
+	free(buf);
+	close(fd);
+	return ret;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -660,6 +704,8 @@ main(int argc, char **argv)
 	/* uring poll on the uring fd */
 	status |=3D test_poll_ringfd();
=20
+	status |=3D test_unregister_speed();
+
 	if (!status)
 		printf("PASS\n");
 	else

base-commit: bbcaabf808b53ef11ad9851c6b968140fb430500
--=20
2.30.2

