Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA5592F75
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbiHONMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242689AbiHONMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:12:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBD113F5A
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:16 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FA52a9026664
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sJD4jmck0aFShuqJ30TLfae/Y5pb1luGEgmNGitvW6Q=;
 b=YdA41pN/iHBcA7wOYsMpy8FG+Wsm03ZMMvmPpxKW+jrG5ZezL/bavvpXHKJMBjQcrfDf
 RxDnkyoeNHwH9pC6syG9u09+bbbJUrQBftsgBppd1lmGEb01jdtmZW367CAx8xPkUP/z
 XmN0omqiIbUu2UD4ICHZ+o2P8oLPNplRJGU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hym2x0rtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:16 -0700
Received: from twshared1866.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:12:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8576D49B6CAD; Mon, 15 Aug 2022 06:09:14 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 2/7] io_uring: remove unnecessary variable
Date:   Mon, 15 Aug 2022 06:09:06 -0700
Message-ID: <20220815130911.988014-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130911.988014-1-dylany@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VKttmdIt3ugOPoc8vyF004bcf3EhcUna
X-Proofpoint-GUID: VKttmdIt3ugOPoc8vyF004bcf3EhcUna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

'running' is set once and read once, so can easily just remove it

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ab3e3d9e9fcd..1d33b2422f2c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1052,12 +1052,9 @@ void io_req_task_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx =3D req->task->io_uring;
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct llist_node *node;
-	bool running;
-
-	running =3D !llist_add(&req->io_task_work.node, &tctx->task_list);
=20
 	/* task_work already pending, we're done */
-	if (running)
+	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
=20
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
--=20
2.30.2

