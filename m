Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FD6635B0F
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiKWLHO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiKWLGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:06:53 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A55CBBC
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:33 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB5BBs011769
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=kf1uoMbGwpTuBYF/6IuVpWIqcEDg7pjfwlKTh2oGRlM=;
 b=lGtEROq3lfPPI1ZfLYqM1NtyadHTUlSX68U3dglvZMEm56djP6iabA7D8AN3sovaojCy
 zp3aiC0wdqmSgASypMHJxzNykwu39vF44jyqbHsb6ROhqUx/3myqP39c7MsD/loVBjjN
 +ASgXpBp+CWzaOCoPAaCoG+1CbL0n4IK2ZDk5JJgwwW1aaDrClj+tqnjc8nHxuPKIxjw
 0q4cRwbSyaZrY15kbV3nNMVarwBL+quoeidJlYAkIxUo9lc8viW1H4xLRIgR+w1tonUM
 3Xy10/aw/7flqEeGutBtdavBnOitjRHOsbqtNkmbZrq8B1soL46IaMhhOzxRND625cbB cQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0m19unef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:32 -0800
Received: from twshared0551.06.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:30 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 808F4A0804B8; Wed, 23 Nov 2022 03:06:26 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 01/13] io_uring: merge io_req_tw_post and io_req_task_complete
Date:   Wed, 23 Nov 2022 03:06:02 -0800
Message-ID: <20221123110614.3297343-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: j1UmGiDJyZxLTCtHpztDbkr0iRltyUbl
X-Proofpoint-GUID: j1UmGiDJyZxLTCtHpztDbkr0iRltyUbl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge these functions that have the same logic

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2260fb7aa7f2..e40d7b3404eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1223,15 +1223,18 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	return ret;
 }
=20
-static void io_req_tw_post(struct io_kiocb *req, bool *locked)
+void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	io_req_complete_post(req);
+	if (*locked)
+		io_req_complete_defer(req);
+	else
+		io_req_complete_post(req);
 }
=20
 void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	io_req_set_res(req, res, cflags);
-	req->io_task_work.func =3D io_req_tw_post;
+	req->io_task_work.func =3D io_req_task_complete;
 	io_req_task_work_add(req);
 }
=20
@@ -1460,14 +1463,6 @@ static int io_iopoll_check(struct io_ring_ctx *ctx=
, long min)
 	return ret;
 }
=20
-void io_req_task_complete(struct io_kiocb *req, bool *locked)
-{
-	if (*locked)
-		io_req_complete_defer(req);
-	else
-		io_req_complete_post(req);
-}
-
 /*
  * After the iocb has been issued, it's safe to be found on the poll lis=
t.
  * Adding the kiocb to the list AFTER submission ensures that we don't
--=20
2.30.2

