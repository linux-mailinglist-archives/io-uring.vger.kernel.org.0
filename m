Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2108B588FED
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiHCP6M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 11:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238280AbiHCP6J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 11:58:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FB1140C2
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 08:58:05 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273F8ndQ013271
        for <io-uring@vger.kernel.org>; Wed, 3 Aug 2022 08:58:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=K/3EqNk8VN8+3bG/l1A60EAM+vUy7eOyb2tH6RrRZYE=;
 b=gm2+XP+77LBrPDEMLFdgi19b/eet5aHY/tZzc6YqZGEswsASvfyfin78Ljljbc4FXakK
 76zYPqIH5nI5OziVMoC1S2nzL2A4JqMdJKDQrmv0h9wCJixwJ+suMHnkpz3iIauhZEAS
 trvUt4Kapoioy61tQD14s1b8Nrl+TgBTQhg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hq2bq1ny2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 08:58:04 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 08:58:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DE23E4008CDA; Wed,  3 Aug 2022 08:57:54 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] io_uring-udp: make more obvious what kernel version is required
Date:   Wed, 3 Aug 2022 08:57:41 -0700
Message-ID: <20220803155741.3668818-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fs_OFPfxvZlwe55M2nC7uxHNauOSEYuf
X-Proofpoint-GUID: fs_OFPfxvZlwe55M2nC7uxHNauOSEYuf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_04,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This example uses some of the latest kernel features, which can be
confusing. Make this clear in the error messages from these features that
a latest kernel version is required.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 examples/io_uring-udp.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/examples/io_uring-udp.c b/examples/io_uring-udp.c
index b4ef0a301963..a07c3e2a6f20 100644
--- a/examples/io_uring-udp.c
+++ b/examples/io_uring-udp.c
@@ -73,7 +73,9 @@ static int setup_buffer_pool(struct ctx *ctx)
=20
 	ret =3D io_uring_register_buf_ring(&ctx->ring, &reg, 0);
 	if (ret) {
-		fprintf(stderr, "buf_ring init: %s\n", strerror(-ret));
+		fprintf(stderr, "buf_ring init failed: %s\n"
+				"NB This requires a kernel version >=3D 6.0\n",
+				strerror(-ret));
 		return ret;
 	}
=20
@@ -98,7 +100,9 @@ static int setup_context(struct ctx *ctx)
=20
 	ret =3D io_uring_queue_init_params(QD, &ctx->ring, &params);
 	if (ret < 0) {
-		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		fprintf(stderr, "queue_init failed: %s\n"
+				"NB: This requires a kernel version >=3D 6.0\n",
+				strerror(-ret));
 		return ret;
 	}
=20
@@ -237,7 +241,10 @@ static int process_cqe_recv(struct ctx *ctx, struct =
io_uring_cqe *cqe,
 		return 0;
=20
 	if (!(cqe->flags & IORING_CQE_F_BUFFER) || cqe->res < 0) {
-		fprintf(stderr, "bad res %d\n", cqe->res);
+		fprintf(stderr, "recv cqe bad res %d\n", cqe->res);
+		if (cqe->res =3D=3D -EFAULT || cqe->res =3D=3D -EINVAL)
+			fprintf(stderr,
+				"NB: This requires a kernel version >=3D 6.0\n");
 		return -1;
 	}
 	idx =3D cqe->flags >> 16;

base-commit: 840d0a5d38f3f63ea7b3741c3e201485c6671015
--=20
2.30.2

