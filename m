Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65CD4C29DA
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 11:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiBXKu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 05:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiBXKu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 05:50:56 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C1F28F94A
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:50:26 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21O30xEN008706
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:50:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=vNLPZCkEe2yiT8UKpbk10L4X9Ol4BUdALeljxDLFXy0=;
 b=gIHCgxmYEwIQeuI4BRvipJhplFd82QjUROaVHdRDB8K8pwoDrJz2OzzPFYHjmFVVvaPZ
 A/j6i1CyCriPAANO5LlfQrn5pZuHdsO8JpIzSmp1wVp+uipDiRExHo2KhHaLeifxF7El
 vp732jO8xfuXt7+rFljt1WYs5hZtAJ/QHzA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ee1qysvv8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:50:26 -0800
Received: from twshared33860.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 02:50:24 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id D4A484996BB6; Thu, 24 Feb 2022 02:50:20 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] Remove fpos tests without linking
Date:   Thu, 24 Feb 2022 02:50:15 -0800
Message-ID: <20220224105015.1324208-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Pw6uuTTAg_jGDhEvdHIDj1_wA6K1zBwm
X-Proofpoint-ORIG-GUID: Pw6uuTTAg_jGDhEvdHIDj1_wA6K1zBwm
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240063
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

There are still more discussions ([1]) to see how to have consistent
r/w results without link, so do not test these cases.

[1] https://lore.kernel.org/io-uring/568473ab-8cf7-8488-8252-e8a2c0ec586f@k=
ernel.dk

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/fpos.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/test/fpos.c b/test/fpos.c
index 385db63..78a6152 100644
--- a/test/fpos.c
+++ b/test/fpos.c
@@ -40,8 +40,7 @@ static void create_file(const char *file, size_t size)
 	assert(ret =3D=3D size);
 }
=20
-static int test_read(struct io_uring *ring, bool async, bool link,
-		     int blocksize)
+static int test_read(struct io_uring *ring, bool async, int blocksize)
 {
 	int ret, fd, i;
 	bool done =3D false;
@@ -71,7 +70,7 @@ static int test_read(struct io_uring *ring, bool async, b=
ool link,
 			sqe->user_data =3D i;
 			if (async)
 				sqe->flags |=3D IOSQE_ASYNC;
-			if (link && i !=3D QUEUE_SIZE - 1)
+			if (i !=3D QUEUE_SIZE - 1)
 				sqe->flags |=3D IOSQE_IO_LINK;
 		}
 		ret =3D io_uring_submit_and_wait(ring, QUEUE_SIZE);
@@ -124,8 +123,7 @@ static int test_read(struct io_uring *ring, bool async,=
 bool link,
 			ret =3D -1;
 		}
 		current =3D lseek(fd, 0, SEEK_CUR);
-		if (current < expected || (current !=3D expected && link)) {
-			/* accept that with !link current may be > expected */
+		if (current !=3D expected) {
 			fprintf(stderr, "f_pos incorrect, expected %ld have %ld\n",
 					(long) expected, (long) current);
 			ret =3D -1;
@@ -137,8 +135,7 @@ static int test_read(struct io_uring *ring, bool async,=
 bool link,
 }
=20
=20
-static int test_write(struct io_uring *ring, bool async,
-		      bool link, int blocksize)
+static int test_write(struct io_uring *ring, bool async, int blocksize)
 {
 	int ret, fd, i;
 	struct io_uring_sqe *sqe;
@@ -167,7 +164,7 @@ static int test_write(struct io_uring *ring, bool async,
 		sqe->user_data =3D 1;
 		if (async)
 			sqe->flags |=3D IOSQE_ASYNC;
-		if (link && i !=3D QUEUE_SIZE - 1)
+		if (i !=3D QUEUE_SIZE - 1)
 			sqe->flags |=3D IOSQE_IO_LINK;
 	}
 	ret =3D io_uring_submit_and_wait(ring, QUEUE_SIZE);
@@ -236,19 +233,18 @@ int main(int argc, char *argv[])
 		return 1;
 	}
=20
-	for (int test =3D 0; test < 16; test++) {
+	for (int test =3D 0; test < 8; test++) {
 		int async =3D test & 0x01;
-		int link =3D test & 0x02;
-		int write =3D test & 0x04;
-		int blocksize =3D test & 0x08 ? 1 : 7;
+		int write =3D test & 0x02;
+		int blocksize =3D test & 0x04 ? 1 : 7;
=20
 		ret =3D write
-			? test_write(&ring, !!async, !!link, blocksize)
-			: test_read(&ring, !!async, !!link, blocksize);
+			? test_write(&ring, !!async, blocksize)
+			: test_read(&ring, !!async, blocksize);
 		if (ret) {
-			fprintf(stderr, "failed %s async=3D%d link=3D%d blocksize=3D%d\n",
+			fprintf(stderr, "failed %s async=3D%d blocksize=3D%d\n",
 					write ? "write" : "read",
-					async, link, blocksize);
+					async, blocksize);
 			return -1;
 		}
 	}

base-commit: 8a2e43dad6475cfcecf91d79e3c4ed58bb5298e1
--=20
2.30.2

