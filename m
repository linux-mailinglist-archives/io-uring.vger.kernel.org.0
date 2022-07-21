Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A457CDF1
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiGUOnI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiGUOnG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:43:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD386C06
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:43:06 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26KNbDLA007622
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:43:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jHUAHgrEJ+nfgklTktgy3xNwfDMFkupd5aO5OfmBe78=;
 b=TniFPUrqSQs2U26rj3szl6KdXJ58UoU9Heq1Wp2fYV2p41uzdZLrcxJ0NQya4qw7Hiy4
 JRPoF1MA1D0Xr8kG3452+UubOTXCBC/3X+uVZvhxR63zYdu/uBjmL+VexdJX99Mnn24u
 udnXI6k62VfoTtX936yAhJyI2yJ7O/DUkZw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hek9pqex7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:43:05 -0700
Received: from twshared39111.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 07:43:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8318D3593BAD; Thu, 21 Jul 2022 07:42:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 4/4] skip poll-mshot-overflow on old kernels
Date:   Thu, 21 Jul 2022 07:42:29 -0700
Message-ID: <20220721144229.1224141-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721144229.1224141-1-dylany@fb.com>
References: <20220721144229.1224141-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rIMu2JxUr8UDb4X8o2Y3fdzfgzkPwmZ-
X-Proofpoint-ORIG-GUID: rIMu2JxUr8UDb4X8o2Y3fdzfgzkPwmZ-
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

Older kernels have slightly different behaviour, so rather skip the test
on them.

Reported-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/poll-mshot-overflow.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
index 17039f585a77..360df65d2b15 100644
--- a/test/poll-mshot-overflow.c
+++ b/test/poll-mshot-overflow.c
@@ -59,15 +59,16 @@ int main(int argc, char *argv[])
 	}
=20
 	struct io_uring_params params =3D {
-		.flags =3D IORING_SETUP_CQSIZE,
+		/* cheat using SINGLE_ISSUER existence to know if this behaviour
+		 * is updated
+		 */
+		.flags =3D IORING_SETUP_CQSIZE | IORING_SETUP_SINGLE_ISSUER,
 		.cq_entries =3D 2
 	};
=20
 	ret =3D io_uring_queue_init_params(2, &ring, &params);
-	if (ret) {
-		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
+	if (ret)
+		return T_EXIT_SKIP;
=20
 	sqe =3D io_uring_get_sqe(&ring);
 	if (!sqe) {
--=20
2.30.2

