Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34011554B80
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiFVNkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiFVNkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55E4BC2E
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:48 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LN961r010960
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=eA6kBmlIW81fx8OZS/XIKy+cY1/iMZ4EptsHxDsG9xQ=;
 b=DkF/kX6A4fk2X47FkeL2Hi22lj+Jkk6FEzrcAlpUBLyPZkaSi6MIjgwUqAHYSfPk+yiN
 LzNvZRb43ZLHALFyo8Gdhz2Z03UjD/Wh/Pkn/QncGtVD2TtfIXGRH14boK0DMnE1FjA1
 YWkjVZiWuyA60VyRSEq5+uMslROfPC4zlIs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gtveudhaf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:48 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 998CC2013A9B; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 2/8] io_uring: remove __io_req_task_work_add
Date:   Wed, 22 Jun 2022 06:40:22 -0700
Message-ID: <20220622134028.2013417-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YwbWdsLXDVS0QuXC_ouJwWMnF0aupzhB
X-Proofpoint-GUID: YwbWdsLXDVS0QuXC_ouJwWMnF0aupzhB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-22_04,2022-06-22_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

this is no longer needed as there is only one caller

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cc524d33748d..e1523b62103b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1040,9 +1040,9 @@ void tctx_task_work(struct callback_head *cb)
 		io_uring_drop_tctx_refs(current);
 }
=20
-static void __io_req_task_work_add(struct io_kiocb *req,
-				   struct io_uring_task *tctx)
+void io_req_task_work_add(struct io_kiocb *req)
 {
+	struct io_uring_task *tctx =3D req->task->io_uring;
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct io_wq_work_node *node;
 	unsigned long flags;
@@ -1080,13 +1080,6 @@ static void __io_req_task_work_add(struct io_kiocb=
 *req,
 	}
 }
=20
-void io_req_task_work_add(struct io_kiocb *req)
-{
-	struct io_uring_task *tctx =3D req->task->io_uring;
-
-	__io_req_task_work_add(req, tctx);
-}
-
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
 {
 	io_req_complete_post(req);
--=20
2.30.2

