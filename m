Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73AB638797
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 11:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKYKeg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 05:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKYKee (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 05:34:34 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E82B42F5C
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:33 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP1torj023634
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=DuCAbePoNtVA9YhQGc2rxpjQN3n4AJ+7V0URsBoLK5c=;
 b=lVZRZFcGVHSbu+NBiIKdfGIAu/GqHiLBqHcmgMQm0MXW8Ape7DVbqrKUEFxPK4GHbDWz
 Ru05ILj4PXs3ZdQjjvsy/5hYWkya7PY8EDNtegqWhdNgNB8K4cnoDpjoAy+bTKWmMrk6
 Om7VvNcvjB/IPnE6ZvxKTFSeAO2EARMuODA7ssFxV8H4nfsDHY6PiuV4OyC7/3pOcNcY
 HklgYXf65HEiqg6xvBQZO0YSNOlxYUkbpAKNkYHxY5XiW2dUaivmqg1jJMJFrKQ2rOOo
 5h+H7Fv56HcHSbzSOXXInZcNNx3X/nw06Jr8ffqWJMysE6rzn65a7dNZmmsl/UDCLgDz eg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m2b2hnq4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:32 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 02:34:31 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 41AACA283ECB; Fri, 25 Nov 2022 02:34:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 3/3] io_uring: Revert "io_uring: io_req_complete_post should defer if available"
Date:   Fri, 25 Nov 2022 02:34:12 -0800
Message-ID: <20221125103412.1425305-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221125103412.1425305-1-dylany@meta.com>
References: <20221125103412.1425305-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: aDxxcv5B4od95rEL0Rb7Z0nOyfvYaf_V
X-Proofpoint-GUID: aDxxcv5B4od95rEL0Rb7Z0nOyfvYaf_V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is not needed, as everywhere that calls io_req_complete_post
already knows it will not be deferring.

This reverts commit 8fa737e0de7d3c4dc3d7cb9a9d9a6362d872c3f3.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c1e84ef84bea..d9c9e347346d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -908,9 +908,7 @@ static void __io_req_complete_post(struct io_kiocb *r=
eq)
=20
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
-		io_req_complete_defer(req);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
+	if (!(issue_flags & IO_URING_F_UNLOCKED) ||
 	    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
 		__io_req_complete_post(req);
 	} else {
--=20
2.30.2

