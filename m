Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E6635B14
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiKWLHl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbiKWLHH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:07 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD2F20B
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4GP9001733
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=SPE3OypV1PIZXo3fdcwq8SDYDd8wDO+IXZtK61ofzVA=;
 b=IuWwxo8Jj3Bo6nB+eOU6/OwoTIExkGgNUiPWrIk1Vhuw+04rolMEqjnioLMmxkWPRQzM
 l9StjHzgF2CCxG7F7LQ9B7uePn2k2cnMxWoYvskwQMVMBcF+eMzZkcbx/CEeGWQ4uhDS
 lGBSe7OG1By85gNzFEzHYlgB385jpCrLa3HUZAtmuztfa5EOh33UCCZYsv+CyfXHMcU2
 em1n7zGHtBsMbgDhydHO9PKk48ISa+//l2yEHXkA6Wu02t2NDjMwVkgu3dM3rgtFTnrK
 JvJp3p0WHaSlBdikHb1VLA+zKET3ND+G9AKEdfCR4yAddPUFYlgbK0hIcAIfsMAq3bGS kQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0javkw99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:49 -0800
Received: from twshared10308.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:48 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 81F2FA0804D2; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 06/13] io_uring: simplify io_issue_sqe
Date:   Wed, 23 Nov 2022 03:06:07 -0800
Message-ID: <20221123110614.3297343-7-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mlhsMtwr7LFLUAiYBQyaRsokI8ilF6nj
X-Proofpoint-GUID: mlhsMtwr7LFLUAiYBQyaRsokI8ilF6nj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_issue_sqe can reuse __io_req_complete for completion logic

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5a620001df2e..912f6fefc665 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1738,12 +1738,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	if (creds)
 		revert_creds(creds);
=20
-	if (ret =3D=3D IOU_OK) {
-		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-			io_req_complete_defer(req);
-		else
-			io_req_complete_post(req);
-	} else if (ret !=3D IOU_ISSUE_SKIP_COMPLETE)
+	if (ret =3D=3D IOU_OK)
+		__io_req_complete(req, issue_flags);
+	else if (ret !=3D IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
=20
 	/* If the op doesn't have a file, we're not polling for it */
--=20
2.30.2

