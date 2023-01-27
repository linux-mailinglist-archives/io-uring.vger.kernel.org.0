Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B032B67E2C7
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 12:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjA0LL5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 06:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjA0LL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 06:11:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6841E40BE8
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:54 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RB4Tgm019928
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=AHBZwh9GWpFUht/SNK2qAXMuzUD9D5NQ3XI3a5b6N20=;
 b=Js0LTDlBbpaYUA1zsSu1XAzh3uoVgDH6A38zxJMtRlRoSqJuSl+ucP7KzDNCya4LPRNl
 9G2HF1qLLWXu/ZBTJkV1saX33f7gJ11NS1qHY3tNw4tMGxecsFJ16hMOWZlHcSRxNgRK
 42MLEzTFKUSFGjvnm6mLjF0c7FCzRgIgdITx1LnL2sOGuxfdlxEKTEMnvwYy55RVIG/Q
 O+9LDXAlhm7xkJWEsMYlMunTU26OGYUkHvrGmpBi1w1mCwgtZ8NhP1Ejp5Lxvgtz6Ecm
 BM6kpHLoRxBLMqxsc+P7BQvCBa57JLb69DiaeGixU0cO1b/Z92ttHLimw/pE5/EQXq3M 0Q== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nb7mbvr29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:54 -0800
Received: from twshared5320.05.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 03:11:53 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A6E56EA0168A; Fri, 27 Jan 2023 03:11:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 2/2] run link_drain test with defer_taskrun too
Date:   Fri, 27 Jan 2023 03:11:33 -0800
Message-ID: <20230127111133.2551653-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127111133.2551653-1-dylany@meta.com>
References: <20230127111133.2551653-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: YrYBvyguGD8OSv-exErGdL86ZjsGpSLV
X-Proofpoint-ORIG-GUID: YrYBvyguGD8OSv-exErGdL86ZjsGpSLV
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

Defer_taskrun seems to expose odd codepaths, so also run link_drain tests
using it.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/link_drain.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/test/link_drain.c b/test/link_drain.c
index 1a50c10d181d..86b0aa8db7fe 100644
--- a/test/link_drain.c
+++ b/test/link_drain.c
@@ -198,15 +198,17 @@ err:
=20
 }
=20
-int main(int argc, char *argv[])
+static int test_drain(bool defer)
 {
 	struct io_uring ring;
 	int i, ret;
+	unsigned int flags =3D 0;
=20
-	if (argc > 1)
-		return 0;
+	if (defer)
+		flags =3D IORING_SETUP_SINGLE_ISSUER |
+			IORING_SETUP_DEFER_TASKRUN;
=20
-	ret =3D io_uring_queue_init(100, &ring, 0);
+	ret =3D io_uring_queue_init(100, &ring, flags);
 	if (ret) {
 		printf("ring setup failed\n");
 		return 1;
@@ -227,3 +229,27 @@ int main(int argc, char *argv[])
=20
 	return ret;
 }
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test_drain(false);
+	if (ret) {
+		fprintf(stderr, "test_drain(false) failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	if (t_probe_defer_taskrun()) {
+		ret =3D test_drain(true);
+		if (ret) {
+			fprintf(stderr, "test_drain(true) failed\n");
+			return T_EXIT_FAIL;
+		}
+	}
+
+	return T_EXIT_PASS;
+}
--=20
2.30.2

