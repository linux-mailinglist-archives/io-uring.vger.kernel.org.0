Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0957CDED
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGUOm5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGUOm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:42:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91808688C
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L3weDX007158
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uO0KAPMm6YGt6ajJYA3hrW+Dyimx5K+isJgcvILlXlU=;
 b=n/v5wy/AF5cobS1tWAabgfDUz0B7RK/X708xpdyKhofckscjLoIGCzcvXL0lgc/KMIlH
 rFlhNMK1itKgXq6cs4XExhG0nzZE68h2rUMCmkYdlXOSB0CMkE/wa7xUHN0Hp22nn7SA
 Qq3umto/g7n7t8jq2x1yHQTGLyBxFydLf5w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3heyc8ttcv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:55 -0700
Received: from twshared33626.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 07:42:54 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 709CB3593BA3; Thu, 21 Jul 2022 07:42:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/4] add a test for bad buf_ring register
Date:   Thu, 21 Jul 2022 07:42:26 -0700
Message-ID: <20220721144229.1224141-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721144229.1224141-1-dylany@fb.com>
References: <20220721144229.1224141-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NU4hOaOi2L1D2ENvKUk8lag6IZ0kGa5i
X-Proofpoint-ORIG-GUID: NU4hOaOi2L1D2ENvKUk8lag6IZ0kGa5i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This shows up a kernel panic in v5.19-rc7

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/buf-ring.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/test/buf-ring.c b/test/buf-ring.c
index 5e032663d93b..b17030cbe952 100644
--- a/test/buf-ring.c
+++ b/test/buf-ring.c
@@ -206,6 +206,30 @@ static int test_reg_unreg(int bgid)
 	return 0;
 }
=20
+static int test_bad_reg(int bgid)
+{
+	struct io_uring ring;
+	int ret;
+	struct io_uring_buf_reg reg =3D { };
+
+	ret =3D t_create_ring(1, &ring, 0);
+	if (ret =3D=3D T_SETUP_SKIP)
+		return 0;
+	else if (ret !=3D T_SETUP_OK)
+		return 1;
+
+	reg.ring_addr =3D 4096;
+	reg.ring_entries =3D 32;
+	reg.bgid =3D bgid;
+
+	ret =3D io_uring_register_buf_ring(&ring, &reg, 0);
+	if (!ret)
+		fprintf(stderr, "Buffer ring register worked unexpectedly\n");
+
+	io_uring_queue_exit(&ring);
+	return !ret;
+}
+
 static int test_one_read(int fd, int bgid, struct io_uring *ring)
 {
 	int ret;
@@ -359,6 +383,12 @@ int main(int argc, char *argv[])
 		if (no_buf_ring)
 			break;
=20
+		ret =3D test_bad_reg(bgids[i]);
+		if (ret) {
+			fprintf(stderr, "test_bad_reg failed\n");
+			return T_EXIT_FAIL;
+		}
+
 		ret =3D test_double_reg_unreg(bgids[i]);
 		if (ret) {
 			fprintf(stderr, "test_double_reg_unreg failed\n");
--=20
2.30.2

