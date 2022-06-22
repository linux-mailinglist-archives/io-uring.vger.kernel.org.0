Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725B3554B87
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350021AbiFVNlA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353545AbiFVNk5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A5B377CD
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:56 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LN9ENv022891
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6/c5dQCW6nE9RcTa+td8fKBuF07l/fZrUsMuqkw23P8=;
 b=G8gKn4EkH/uJo+dtibqIN/iV7Sn7nfh7nyiBosG8jvRNbCh6L9Xe7CemNpschjQl1OBT
 EpAi4qCSw8AvmJt1ezbcUKseyyWtoVIjnOWcZNAlGCV+wDsnswy42qe1eOzR15MfgQL6
 pGPwR5TlzNUhv5H+0sTEN9J/m3EhFTD9Ynk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3guc93rkpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:55 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:54 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 027102013AA3; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 8/8] io_uring: trace task_work_run
Date:   Wed, 22 Jun 2022 06:40:28 -0700
Message-ID: <20220622134028.2013417-9-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rDoDL6_-JHITIycwg4rNxWSjOl9R64Tu
X-Proofpoint-ORIG-GUID: rDoDL6_-JHITIycwg4rNxWSjOl9R64Tu
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

trace task_work_run to help provide stats on how often task work is run
and what batch sizes are coming through.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 19bd7d5ec90c..1b359249e933 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -986,10 +986,12 @@ static void ctx_flush_and_put(struct io_ring_ctx *c=
tx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
=20
-static void handle_tw_list(struct llist_node *node,
-			   struct io_ring_ctx **ctx, bool *locked,
-			   struct llist_node *last)
+static unsigned int handle_tw_list(struct llist_node *node,
+				   struct io_ring_ctx **ctx, bool *locked,
+				   struct llist_node *last)
 {
+	unsigned int count =3D 0;
+
 	while (node !=3D last) {
 		struct llist_node *next =3D node->next;
 		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
@@ -1006,7 +1008,10 @@ static void handle_tw_list(struct llist_node *node=
,
 		}
 		req->io_task_work.func(req, locked);
 		node =3D next;
+		count++;
 	}
+
+	return count;
 }
=20
 /**
@@ -1047,12 +1052,14 @@ void tctx_task_work(struct callback_head *cb)
 						  task_work);
 	struct llist_node fake =3D {};
 	struct llist_node *node =3D io_llist_xchg(&tctx->task_list, &fake);
+	unsigned int loops =3D 1;
+	unsigned int count =3D handle_tw_list(node, &ctx, &uring_locked, NULL);
=20
-	handle_tw_list(node, &ctx, &uring_locked, NULL);
 	node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	while (node !=3D &fake) {
+		loops++;
 		node =3D io_llist_xchg(&tctx->task_list, &fake);
-		handle_tw_list(node, &ctx, &uring_locked, &fake);
+		count +=3D handle_tw_list(node, &ctx, &uring_locked, &fake);
 		node =3D io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	}
=20
@@ -1061,6 +1068,8 @@ void tctx_task_work(struct callback_head *cb)
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

