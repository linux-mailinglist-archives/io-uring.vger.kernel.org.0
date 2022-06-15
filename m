Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D0D54C2C1
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbiFOHkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiFOHki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 03:40:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358B93D1E0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:38 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EMd0XE027877
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=175Xlw5nZBZMaFJnRs3OwQdAZIElid6toa3Qhp+RnSU=;
 b=Mcs56JapWYRzmAzXi9X9z5RWdgZUsrNug+pfQN1zG9rTyMGZnE4kUDg3DVuCJX8zjsK1
 bX5F4secyMn1QxNuOTwMghKCcTDUJGyXJzvY/TsVIGpxP1MAE7IcSRK4cKvBOm7ea4kh
 jfwddrVwoIXAhtR725OOqFRCUViO0bcQ0Vc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gpu2vdskh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:37 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 15 Jun 2022 00:40:35 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id F30DC1AEE454; Wed, 15 Jun 2022 00:40:29 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/2] Revert "buf-ring: add tests that cycle through the provided buffer ring"
Date:   Wed, 15 Jun 2022 00:40:25 -0700
Message-ID: <20220615074025.124322-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220615074025.124322-1-dylany@fb.com>
References: <20220615074025.124322-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OaUWYmHdBi7-arV6KO3NqysGECjLWsvP
X-Proofpoint-GUID: OaUWYmHdBi7-arV6KO3NqysGECjLWsvP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 01e0120220e489f147fd4e91d1bde5393f14b4ff.

"io_uring: add buffer selection support to IORING_OP_NOP" has been
reverted from 5.19, which this relies on

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/buf-ring.c | 133 ------------------------------------------------
 1 file changed, 133 deletions(-)

diff --git a/test/buf-ring.c b/test/buf-ring.c
index 2fcc360..5fd1e53 100644
--- a/test/buf-ring.c
+++ b/test/buf-ring.c
@@ -206,134 +206,9 @@ static int test_reg_unreg(int bgid)
 	return 0;
 }
=20
-static int test_one_nop(int bgid, struct io_uring *ring)
-{
-	int ret;
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-
-	sqe =3D io_uring_get_sqe(ring);
-	if (!sqe) {
-		fprintf(stderr, "get sqe failed\n");
-		return -1;
-	}
-
-	io_uring_prep_nop(sqe);
-	sqe->flags |=3D IOSQE_BUFFER_SELECT;
-	sqe->buf_group =3D bgid;
-	ret =3D io_uring_submit(ring);
-	if (ret <=3D 0) {
-		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		ret =3D -1;
-		goto out;
-	}
-
-	ret =3D io_uring_wait_cqe(ring, &cqe);
-	if (ret < 0) {
-		fprintf(stderr, "wait completion %d\n", ret);
-		ret =3D -1;
-		goto out;
-	}
-
-	if (cqe->res =3D=3D -ENOBUFS) {
-		ret =3D cqe->res;
-		goto out;
-	}
-
-	if (cqe->res !=3D 0) {
-		fprintf(stderr, "nop result %d\n", ret);
-		ret =3D -1;
-		goto out;
-	}
-
-	ret =3D cqe->flags >> 16;
-
-out:
-	io_uring_cqe_seen(ring, cqe);
-	return ret;
-}
-
-static int test_running(int bgid, int entries, int loops)
-{
-	struct io_uring_buf_reg reg =3D { };
-	struct io_uring ring;
-	void *ptr;
-	int ret;
-	int ring_size =3D (entries * sizeof(struct io_uring_buf) + 4095) & (~40=
95);
-	int ring_mask =3D io_uring_buf_ring_mask(entries);
-
-	int loop, idx;
-	bool *buffers;
-	struct io_uring_buf_ring *br;
-
-	ret =3D t_create_ring(1, &ring, 0);
-	if (ret =3D=3D T_SETUP_SKIP)
-		return 0;
-	else if (ret !=3D T_SETUP_OK)
-		return 1;
-
-	if (posix_memalign(&ptr, 4096, ring_size))
-		return 1;
-
-	br =3D (struct io_uring_buf_ring *)ptr;
-	io_uring_buf_ring_init(br);
-
-	buffers =3D malloc(sizeof(bool) * entries);
-	if (!buffers)
-		return 1;
-
-	reg.ring_addr =3D (unsigned long) ptr;
-	reg.ring_entries =3D entries;
-	reg.bgid =3D bgid;
-
-	ret =3D io_uring_register_buf_ring(&ring, &reg, 0);
-	if (ret) {
-		/* by now should have checked if this is supported or not */
-		fprintf(stderr, "Buffer ring register failed %d\n", ret);
-		return 1;
-	}
-
-	for (loop =3D 0; loop < loops; loop++) {
-		memset(buffers, 0, sizeof(bool) * entries);
-		for (idx =3D 0; idx < entries; idx++)
-			io_uring_buf_ring_add(br, ptr, 1, idx, ring_mask, idx);
-		io_uring_buf_ring_advance(br, entries);
-
-		for (idx =3D 0; idx < entries; idx++) {
-			ret =3D test_one_nop(bgid, &ring);
-			if (ret < 0) {
-				fprintf(stderr, "bad run %d/%d =3D %d\n", loop, idx, ret);
-				return ret;
-			}
-			if (buffers[ret]) {
-				fprintf(stderr, "reused buffer %d/%d =3D %d!\n", loop, idx, ret);
-				return 1;
-			}
-			buffers[ret] =3D true;
-		}
-		ret =3D test_one_nop(bgid, &ring);
-		if (ret !=3D -ENOBUFS) {
-			fprintf(stderr, "expected enobufs run %d =3D %d\n", loop, ret);
-			return 1;
-		}
-
-	}
-
-	ret =3D io_uring_unregister_buf_ring(&ring, bgid);
-	if (ret) {
-		fprintf(stderr, "Buffer ring register failed %d\n", ret);
-		return 1;
-	}
-
-	io_uring_queue_exit(&ring);
-	free(buffers);
-	return 0;
-}
-
 int main(int argc, char *argv[])
 {
 	int bgids[] =3D { 1, 127, -1 };
-	int entries[] =3D {1, 32768, 4096, -1 };
 	int ret, i;
=20
 	if (argc > 1)
@@ -367,13 +242,5 @@ int main(int argc, char *argv[])
 		}
 	}
=20
-	for (i =3D 0; !no_buf_ring && entries[i] !=3D -1; i++) {
-		ret =3D test_running(2, entries[i], 3);
-		if (ret) {
-			fprintf(stderr, "test_running(%d) failed\n", entries[i]);
-			return 1;
-		}
-	}
-
 	return 0;
 }
--=20
2.30.2

