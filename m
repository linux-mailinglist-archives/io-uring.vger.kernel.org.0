Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E493637689
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 11:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKXKbD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 05:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKXKbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 05:31:00 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5F3C4C3C
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:59 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANNUJqP005994
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=ZA8S52yrV1LkZmwK5xhYciZX9lpikAkTtp6zVIawG70=;
 b=cstox6/HA7mCSuJI+4lPEyhf9NFZtrZPUlKjTkdbWhoVYwfDWQ9E9VgRhpdtImx9ak10
 JWdxre2dcH3cBeSmneeSUxDhlxwQLMiFUyxiMBOkrx+PR46MZaP9A/9XeNg+bTMEZlFc
 qvBOQojLMF9HwF1tWQH/KExXL/LGvyRzh4BdZR2sNMAfcMVBa/5PImTlRJweunwl3PAI
 5gv4qK6bkGIpWYmcfRFetvCUX5YYWiNLnAGpkS5hzy59eheHo3rC5PAiHc6z+B4qhuoe
 R+Jr3biSlwuacdBJ13WN/f5ycrS1IOZymbpe/Jgu306+w3SV6sqH5M8Rh7RW2xka/L+w +w== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1w88tyhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:59 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 02:30:58 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 65CD3A17DB93; Thu, 24 Nov 2022 02:30:43 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 2/2] add a test for multishot downgrading
Date:   Thu, 24 Nov 2022 02:30:42 -0800
Message-ID: <20221124103042.4129289-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124103042.4129289-1-dylany@meta.com>
References: <20221124103042.4129289-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W1X3TLkTbpEadrdnF3fZ76GtuzMzwJvt
X-Proofpoint-GUID: W1X3TLkTbpEadrdnF3fZ76GtuzMzwJvt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the poll overflows we expect multishot poll to eventually downgrade to
single shot. Also the ordering of CQE's must be consistent, so check that=
.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/poll-mshot-overflow.c | 105 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
index 431a337f19ae..0dc8ee5eb6f8 100644
--- a/test/poll-mshot-overflow.c
+++ b/test/poll-mshot-overflow.c
@@ -137,20 +137,123 @@ static int test(bool defer_taskrun)
 	return ret;
 }
=20
+static int test_downgrade(bool support_defer)
+{
+	struct io_uring_cqe cqes[128];
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int fds[2];
+	int ret, i, cqe_count, tmp =3D 0, more_cqe_count;
+
+	if (pipe(fds) !=3D 0) {
+		perror("pipe");
+		return -1;
+	}
+
+	struct io_uring_params params =3D {
+		.flags =3D IORING_SETUP_CQSIZE,
+		.cq_entries =3D 2
+	};
+
+	ret =3D io_uring_queue_init_params(2, &ring, &params);
+	if (ret) {
+		fprintf(stderr, "queue init: %d\n", ret);
+		return -1;
+	}
+
+	sqe =3D io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_poll_multishot(sqe, fds[0], POLLIN);
+	io_uring_sqe_set_data64(sqe, 1);
+	io_uring_submit(&ring);
+
+	for (i =3D 0; i < 8; i++) {
+		ret =3D write(fds[1], &tmp, sizeof(tmp));
+		if (ret !=3D sizeof(tmp)) {
+			perror("write");
+			return -1;
+		}
+		ret =3D read(fds[0], &tmp, sizeof(tmp));
+		if (ret !=3D sizeof(tmp)) {
+			perror("read");
+			return -1;
+		}
+	}
+
+	cqe_count =3D 0;
+	while (!io_uring_peek_cqe(&ring, &cqe)) {
+		cqes[cqe_count++] =3D *cqe;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	/* Some kernels might allow overflows to poll,
+	 * but if they didn't it should stop the MORE flag
+	 */
+	if (cqe_count < 3) {
+		fprintf(stderr, "too few cqes: %d\n", cqe_count);
+		return -1;
+	} else if (cqe_count =3D=3D 8) {
+		more_cqe_count =3D cqe_count;
+		/* downgrade only available since support_defer */
+		if (support_defer) {
+			fprintf(stderr, "did not downgrade on overflow\n");
+			return -1;
+		}
+	} else {
+		more_cqe_count =3D cqe_count - 1;
+		cqe =3D &cqes[cqe_count - 1];
+		if (cqe->flags & IORING_CQE_F_MORE) {
+			fprintf(stderr, "incorrect MORE flag %x\n", cqe->flags);
+			return -1;
+		}
+	}
+
+	for (i =3D 0; i < more_cqe_count; i++) {
+		cqe =3D &cqes[i];
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			fprintf(stderr, "missing MORE flag\n");
+			return -1;
+		}
+		if (cqe->res < 0) {
+			fprintf(stderr, "bad res: %d\n", cqe->res);
+			return -1;
+		}
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
+	bool support_defer;
=20
 	if (argc > 1)
 		return T_EXIT_SKIP;
=20
+	support_defer =3D t_probe_defer_taskrun();
+	ret =3D test_downgrade(support_defer);
+	if (ret) {
+		fprintf(stderr, "%s: test_downgrade(%d) failed\n", argv[0], support_de=
fer);
+		return T_EXIT_FAIL;
+	}
+
 	ret =3D test(false);
+	if (ret =3D=3D T_EXIT_SKIP)
+		return ret;
 	if (ret !=3D T_EXIT_PASS) {
 		fprintf(stderr, "%s: test(false) failed\n", argv[0]);
 		return ret;
 	}
=20
-	if (t_probe_defer_taskrun()) {
+	if (support_defer) {
 		ret =3D test(true);
 		if (ret !=3D T_EXIT_PASS) {
 			fprintf(stderr, "%s: test(true) failed\n", argv[0]);
--=20
2.30.2

