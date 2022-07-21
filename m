Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB757D0A3
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiGUQES (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGUQES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 12:04:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9D187C1C
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:17 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LEcmva013825
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DtNpDi5UKqYByLOq/5oT4wZ1rIs/3pnf9Krv/bkZsy0=;
 b=TUd7FFDXTwOMeCF3SSTLlrpNT1YZmb7VLrPDi+cKlANy3OltG01aa4ZaxoZF5HB2K6VC
 ghspBZCilLg1Y9XgA9MGFzC0Hho7MblHQ188tZ61nru/GyZINriWcBsDDfBc5WWqsYzd
 9seEO/Xqy+Gv+S5KB/ltLZ3Ls/mURBUurBE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hehn2rjka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:17 -0700
Received: from twshared39111.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:04:16 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C4EB235A05DA; Thu, 21 Jul 2022 09:04:07 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/2] fixup poll-mshot-update
Date:   Thu, 21 Jul 2022 09:04:05 -0700
Message-ID: <20220721160406.1700508-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721160406.1700508-1-dylany@fb.com>
References: <20220721160406.1700508-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _5Qlgbv7imunmtrSThcsBxTsGjQAwprq
X-Proofpoint-ORIG-GUID: _5Qlgbv7imunmtrSThcsBxTsGjQAwprq
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

this test did not notice when poll was cancelled.

update it to notice, and rearm poll

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/poll-mshot-update.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index caedb6fddc4b..e01befcfa7eb 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -75,6 +75,20 @@ static int arm_poll(struct io_uring *ring, int off)
 	return 0;
 }
=20
+static int submit_arm_poll(struct io_uring *ring, int off)
+{
+	int ret;
+
+	ret =3D arm_poll(ring, off);
+	if (ret)
+		return ret;
+
+	ret =3D io_uring_submit(ring);
+	if (ret < 0)
+		return ret;
+	return ret =3D=3D 1 ? 0 : -1;
+}
+
 static int reap_polls(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -106,6 +120,18 @@ static int reap_polls(struct io_uring *ring)
 		off =3D cqe->user_data;
 		if (off =3D=3D 0x12345678)
 			goto seen;
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			/* need to re-arm poll */
+			ret =3D submit_arm_poll(ring, off);
+			if (ret)
+				break;
+			if (cqe->res <=3D 0) {
+				/* retry this one */
+				i--;
+				goto seen;
+			}
+		}
+
 		ret =3D read(p[off].fd[0], &c, 1);
 		if (ret !=3D 1) {
 			if (ret =3D=3D -1 && errno =3D=3D EAGAIN)
--=20
2.30.2

