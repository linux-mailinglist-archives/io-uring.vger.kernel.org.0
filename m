Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B846D552212
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbiFTQTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbiFTQTM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF876559
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:11 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFICqS016585
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=eA6kBmlIW81fx8OZS/XIKy+cY1/iMZ4EptsHxDsG9xQ=;
 b=p/Cp2f73ldFyAlVdGqJz83U0OndU26HfS54PV8fFW007LG9HYIJDqj1FuqCIp/DCmkTB
 lkzMc2sKXP/KGEc0bqlA8lfkKVwf5QXyazlAm16ikHM6lD8OKW2BXgOnmdnUuZ5ThjUC
 AhtlynxbsTukttTqIfzGjgCuK+562x8RYHQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gsc7wsr0f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:10 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:08 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 824F31EB943C; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 2/8] io_uring: remove __io_req_task_work_add
Date:   Mon, 20 Jun 2022 09:18:55 -0700
Message-ID: <20220620161901.1181971-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: g1p2-t1SjnQTl-BzcLmxLPd4U-jR0gvd
X-Proofpoint-ORIG-GUID: g1p2-t1SjnQTl-BzcLmxLPd4U-jR0gvd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
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

