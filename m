Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D0552218
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiFTQTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiFTQTY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:24 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089C21A079
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:23 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFIAGJ016442
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gdDiKZO74VvW5YoKTuOAJvH4IJ8UP+lNhAJrGuxZPzM=;
 b=Ao60o2MMBj1bx6jiw95x6gqfilpdHRKtoAvJQI412KzWOmQ+VXVvlZG7Gk4kF/JmckAJ
 xyIqtt79a6ZxdEMX2kF/7OTIKWLmDKu7qzXsN/3gWp2J3k+vRoaJXvczt9GsTFbxAxzF
 AwE8NW24GArKvcVhpTUS1PbXaIKth3crKiU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gsc7wsr21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:23 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:21 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B6DAB1EB9449; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 8/8] io_uring: trace task_work_run
Date:   Mon, 20 Jun 2022 09:19:01 -0700
Message-ID: <20220620161901.1181971-9-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZrilpEW3HriJ5BN_-Dj78FUgiqHlDq4a
X-Proofpoint-ORIG-GUID: ZrilpEW3HriJ5BN_-Dj78FUgiqHlDq4a
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

trace task_work_run to help provide stats on how often task work is run
and what batch sizes are coming through.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0b4d3eb06d16..8cf868315008 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -987,10 +987,12 @@ static void ctx_flush_and_put(struct io_ring_ctx *c=
tx, bool *locked)
 }
=20
=20
-static void handle_tw_list(struct llist_node *node,
-			   struct io_ring_ctx **ctx, bool *locked,
-			   struct llist_node *fake)
+static unsigned int handle_tw_list(struct llist_node *node,
+				   struct io_ring_ctx **ctx, bool *locked,
+				   struct llist_node *fake)
 {
+	unsigned int count =3D 0;
+
 	while (node && node !=3D fake) {
 		struct llist_node *next =3D node->next;
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
@@ -1051,12 +1053,14 @@ void tctx_task_work(struct callback_head *cb)
 						  task_work);
 	struct llist_node fake =3D {};
 	struct llist_node *node =3D io_llist_xchg(&tctx->task_list, &fake);
+	unsigned int loops =3D 1;
+	unsigned int count =3D handle_tw_list(node, &ctx, &uring_locked, &fake)=
;
=20
-	handle_tw_list(node, &ctx, &uring_locked, &fake);
 	node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	while (node !=3D &fake) {
+		loops++;
 		node =3D io_llist_xchg(&tctx->task_list, &fake);
-		handle_tw_list(node, &ctx, &uring_locked, &fake);
+		count +=3D handle_tw_list(node, &ctx, &uring_locked, &fake);
 		node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	}
=20
@@ -1065,6 +1069,8 @@ void tctx_task_work(struct callback_head *cb)
 	/* relaxed read is enough as only the task itself sets ->in_idle */
 	if (unlikely(atomic_read(&tctx->in_idle)))
 		io_uring_drop_tctx_refs(current);
+
+	trace_io_uring_task_work_run(tctx, count, loops);
 }
=20
 void io_req_task_work_add(struct io_kiocb *req)
--=20
2.30.2

