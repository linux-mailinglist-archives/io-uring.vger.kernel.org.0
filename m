Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7586E552216
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiFTQTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiFTQTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA86192BA
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:18 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFINdq010802
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5INWRad9XhLdGso3ul6etZ2pEm2o7UAnJaQDFkzYueo=;
 b=HqmLbMwxYHLgKU5xpX+UiLh6FlrFkTgWK4BpV6ddJ7DBxA5gDZC4zGMcTLc8RQ1O6LD6
 5Isaj0Du3kmDotq2M7703SwpkkmCQB7Fp2Q8LQtT1bBSUaOYpGok4Pc7r6oT4G0x3Fjt
 R01oBu+WGnHwQrWGoMg+RpnHBJFCApcExCM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gsarpa2cd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:18 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:17 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 99B441EB9442; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 5/8] io_uring: batch task_work
Date:   Mon, 20 Jun 2022 09:18:58 -0700
Message-ID: <20220620161901.1181971-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cbHq1S7aYCkGCPTueWB_5_hnZduVeVPH
X-Proofpoint-ORIG-GUID: cbHq1S7aYCkGCPTueWB_5_hnZduVeVPH
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

Batching task work up is an important performance optimisation, as
task_work_add is expensive.

In order to keep the semantics replace the task_list with a fake node
while processing the old list, and then do a cmpxchg at the end to see if
there is more work.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eb29e3f7da5c..0b4d3eb06d16 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -988,9 +988,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ct=
x, bool *locked)
=20
=20
 static void handle_tw_list(struct llist_node *node,
-			   struct io_ring_ctx **ctx, bool *locked)
+			   struct io_ring_ctx **ctx, bool *locked,
+			   struct llist_node *fake)
 {
-	do {
+	while (node && node !=3D fake) {
 		struct llist_node *next =3D node->next;
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1006,7 +1007,10 @@ static void handle_tw_list(struct llist_node *node=
,
 		}
 		req->io_task_work.func(req, locked);
 		node =3D next;
-	} while (node);
+		count++;
+	}
+
+	return count;
 }
=20
 /**
@@ -1045,11 +1049,15 @@ void tctx_task_work(struct callback_head *cb)
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
+	handle_tw_list(node, &ctx, &uring_locked, &fake);
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

