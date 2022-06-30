Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23AE561E2D
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbiF3Ogq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiF3OgZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:36:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A079FDEC4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:28:46 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0Lb9D021189
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=bPDnpzsjwFTLZkeSkyxYeVf2aOBhacGhDG7DTMDzAog=;
 b=Lwr+VWmpnlbwrF3zIac/i4iKAUQKGG/1j8UWAkQaotfGhlSBf+nfK6/DgH9K0dsLLiUD
 7P0nM7FfrijXSsXV3t34hC9k5rEKog0ymuhbObBxJ/usxytNzlRGfeDAEboYuF4Tv1N7
 zo2saPU18vTjYRcLnlK3aEERFIN3lu6z5Zw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0dgqu16f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:28:45 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 07:28:44 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 341AF25C1FC3; Thu, 30 Jun 2022 07:28:14 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] add a test for async reads with buffer_select
Date:   Thu, 30 Jun 2022 07:28:12 -0700
Message-ID: <20220630142812.3212964-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ToCeQTXErmubD62w2TxyepozujWphdIG
X-Proofpoint-GUID: ToCeQTXErmubD62w2TxyepozujWphdIG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_09,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Async reads had a bug with buffer selection.
Add a regression test for this.
It fails without the kernel commit: "io_uring: fix provided buffer import=
"

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/read-write.c | 101 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 6 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index 3951a64..eadeb78 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -428,25 +428,28 @@ static int test_buf_select_short(const char *filena=
me, int nonvec)
 	return ret;
 }
=20
-static int provide_buffers_iovec(struct io_uring *ring, int bgid)
+static int provide_buffers_iovec(struct io_uring *ring, int bgid, int co=
unt)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int i, ret;
=20
-	for (i =3D 0; i < BUFFERS; i++) {
+	if (count <=3D 0)
+		count =3D BUFFERS;
+
+	for (i =3D 0; i < count; i++) {
 		sqe =3D io_uring_get_sqe(ring);
 		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
 						vecs[i].iov_len, 1, bgid, i);
 	}
=20
 	ret =3D io_uring_submit(ring);
-	if (ret !=3D BUFFERS) {
+	if (ret !=3D count) {
 		fprintf(stderr, "submit: %d\n", ret);
 		return -1;
 	}
=20
-	for (i =3D 0; i < BUFFERS; i++) {
+	for (i =3D 0; i < count; i++) {
 		ret =3D io_uring_wait_cqe(ring, &cqe);
 		if (ret) {
 			fprintf(stderr, "wait_cqe=3D%d\n", ret);
@@ -462,6 +465,86 @@ static int provide_buffers_iovec(struct io_uring *ri=
ng, int bgid)
 	return 0;
 }
=20
+static int test_buf_select_pipe(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret, i;
+	int fds[2];
+
+	if (no_buf_select)
+		return 0;
+
+	ret =3D io_uring_queue_init(64, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+
+	ret =3D provide_buffers_iovec(&ring, 0, 4);
+	if (ret) {
+		fprintf(stderr, "provide buffers failed: %d\n", ret);
+		return 1;
+	}
+
+	ret =3D pipe(fds);
+	if (ret) {
+		fprintf(stderr, "pipe failed: %d\n", ret);
+		return 1;
+	}
+
+	for (i =3D 0; i < 5; i++) {
+		sqe =3D io_uring_get_sqe(&ring);
+		io_uring_prep_read(sqe, fds[0], NULL, 1 /* max read 1 per go */, -1);
+		sqe->flags |=3D IOSQE_BUFFER_SELECT;
+		sqe->buf_group =3D 0;
+	}
+	io_uring_submit(&ring);
+
+	ret =3D write(fds[1], "01234", 5);
+	if (ret !=3D 5) {
+		fprintf(stderr, "pipe write failed %d\n", ret);
+		return 1;
+	}
+
+	for (i =3D 0; i < 5; i++) {
+		const char *buff;
+
+		if (io_uring_wait_cqe(&ring, &cqe)) {
+			fprintf(stderr, "bad wait %d\n", i);
+			return 1;
+		}
+		if (i =3D=3D 4) {
+			if (cqe->res !=3D -ENOBUFS) {
+				fprintf(stderr, "expected failure %d\n", cqe->res);
+				return 1;
+			}
+			continue;
+		}
+		if (cqe->res !=3D 1) {
+			fprintf(stderr, "expected read %d\n", cqe->res);
+			return 1;
+		}
+		if (!(cqe->flags & IORING_CQE_F_BUFFER)) {
+			fprintf(stderr, "no buffer %d\n", cqe->res);
+			return 1;
+		}
+		buff =3D vecs[cqe->flags >> 16].iov_base;
+		if (*buff !=3D '0' + i) {
+			fprintf(stderr, "%d: expected %c, got %c\n", i, '0' + i, *buff);
+			return 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 static int test_buf_select(const char *filename, int nonvec)
 {
 	struct io_uring_probe *p;
@@ -497,7 +580,7 @@ static int test_buf_select(const char *filename, int =
nonvec)
 	for (i =3D 0; i < BUFFERS; i++)
 		memset(vecs[i].iov_base, 0x55, vecs[i].iov_len);
=20
-	ret =3D provide_buffers_iovec(&ring, 1);
+	ret =3D provide_buffers_iovec(&ring, 1, -1);
 	if (ret)
 		return ret;
=20
@@ -523,7 +606,7 @@ static int test_rem_buf(int batch, int sqe_flags)
 		return 1;
 	}
=20
-	ret =3D provide_buffers_iovec(&ring, bgid);
+	ret =3D provide_buffers_iovec(&ring, bgid, -1);
 	if (ret)
 		return ret;
=20
@@ -791,6 +874,12 @@ int main(int argc, char *argv[])
 		goto err;
 	}
=20
+	ret =3D test_buf_select_pipe();
+	if (ret) {
+		fprintf(stderr, "test_buf_select_pipe failed\n");
+		goto err;
+	}
+
 	ret =3D test_eventfd_read();
 	if (ret) {
 		fprintf(stderr, "test_eventfd_read failed\n");

base-commit: 70e11b3d79714c287c1a03e96eddd957474901dd
--=20
2.30.2

