Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF66554B85
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355344AbiFVNk6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348395AbiFVNk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7550237001
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LN961u010960
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bmPHvTjl4RotnIUNL794zwd+hTGmYmt9ko27Je6TCsI=;
 b=KSkAv9aw719P/b0V8P7J5wdTKS2JkbYX+MAvM3n97z0n6lgnW5jRhRlXCmwuIs8uMl1I
 Yafpvy1699ZXeJjIo+FGPrx/WDk/b7B65Q3nE7UDmhCSt6vuIbjng306RvFRKpDuB9Gq
 +k0xWjMbxaJs8sTz5sDHF+cAVV1rtRfSN18= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gtveudhaf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:54 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:48 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C30742013A9E; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 5/8] io_uring: batch task_work
Date:   Wed, 22 Jun 2022 06:40:25 -0700
Message-ID: <20220622134028.2013417-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gvdUplRREJTri-_YL-z2pNxHxZzHA8bZ
X-Proofpoint-GUID: gvdUplRREJTri-_YL-z2pNxHxZzHA8bZ
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

Batching task work up is an important performance optimisation, as
task_work_add is expensive.

In order to keep the semantics replace the task_list with a fake node
while processing the old list, and then do a cmpxchg at the end to see if
there is more work.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eb29e3f7da5c..19bd7d5ec90c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -986,11 +986,11 @@ static void ctx_flush_and_put(struct io_ring_ctx *c=
tx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
=20
-
 static void handle_tw_list(struct llist_node *node,
-			   struct io_ring_ctx **ctx, bool *locked)
+			   struct io_ring_ctx **ctx, bool *locked,
+			   struct llist_node *last)
 {
-	do {
+	while (node !=3D last) {
 		struct llist_node *next =3D node->next;
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1006,7 +1006,7 @@ static void handle_tw_list(struct llist_node *node,
 		}
 		req->io_task_work.func(req, locked);
 		node =3D next;
-	} while (node);
+	}
 }
=20
 /**
@@ -1045,11 +1045,15 @@ void tctx_task_work(struct callback_head *cb)
 	struct io_ring_ctx *ctx =3D NULL;
 	struct io_uring_task *tctx =3D container_of(cb, struct io_uring_task,
 						  task_work);
-	struct llist_node *node =3D llist_del_all(&tctx->task_list);
-
-	if (node) {
-		handle_tw_list(node, &ctx, &uring_locked);
-		cond_resched();
+	struct llist_node fake =3D {};
+	struct llist_node *node =3D io_llist_xchg(&tctx->task_list, &fake);
+
+	handle_tw_list(node, &ctx, &uring_locked, NULL);
+	node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
+	while (node !=3D &fake) {
+		node =3D io_llist_xchg(&tctx->task_list, &fake);
+		handle_tw_list(node, &ctx, &uring_locked, &fake);
+		node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	}
=20
 	ctx_flush_and_put(ctx, &uring_locked);
--=20
2.30.2

