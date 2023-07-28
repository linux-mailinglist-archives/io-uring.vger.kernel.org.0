Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E027676EA
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjG1UUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjG1UUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 16:20:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477DE4695
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:45 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SK148b005583
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=kJWrtTkStC6cxrlTIyl+TkH/zRRo0Y8FfDLQItMN1pw=;
 b=S6aFzlxqTpjTDSlxeMmrrDOTp/L3GhXwphRMBIU2ZxJwYUA/YeV93tBH99lFqzB1dbun
 acVYJt+rldJSYhO45l5G3njly3e9yjaxW1IalSJNDOwalwsS3qkhRLI+9MKgKZUB2CNx
 wVJ6djLSf1W2CvI3Y/hp6ZZdDk+Y+BmaEpTwmcKmSg+iEevwmXWghQcMoVzIT7O7Y8RV
 0wURBHveBthaO1vk64Wy4jifboyfPeVUIOpxzo4xjkk7e8jm8sYOtTa0RIMmrVNP9hpG
 SuvoURbBolZacf5CAShlbn5N1yiQRtwo0tUQ7/hcMBIsoPSjNprU7r+RMRN6kp1SovCN PQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3s3v48n11j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 13:19:13 -0700
Received: from twshared19625.39.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 13:19:11 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 1C32C1C47B5D5; Fri, 28 Jul 2023 13:15:57 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/3] io_uring: split req prep and submit loops
Date:   Fri, 28 Jul 2023 13:14:48 -0700
Message-ID: <20230728201449.3350962-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728201449.3350962-1-kbusch@meta.com>
References: <20230728201449.3350962-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5il7Z9WEoZJ9fGsefnA23Gsb3v2wQBEV
X-Proofpoint-ORIG-GUID: 5il7Z9WEoZJ9fGsefnA23Gsb3v2wQBEV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Do all the prep work up front, then dispatch all synchronous requests at
once. This will make it easier to count batches for plugging.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/io_uring.c | 26 ++++++++++++++++++--------
 io_uring/slist.h    |  4 ++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 818b2d1661c5e..5434aef0a8ef7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1082,6 +1082,7 @@ static void io_preinit_req(struct io_kiocb *req, st=
ruct io_ring_ctx *ctx)
 	req->ctx =3D ctx;
 	req->link =3D NULL;
 	req->async_data =3D NULL;
+	req->comp_list.next =3D NULL;
 	/* not necessary, but safer to zero */
 	req->cqe.res =3D 0;
 }
@@ -2282,11 +2283,7 @@ static __cold int io_submit_fail_init(const struct=
 io_uring_sqe *sqe,
 static inline void io_submit_sqe(struct io_kiocb *req)
 {
 	trace_io_uring_submit_req(req);
-
-	if (unlikely(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))
-		io_queue_sqe_fallback(req);
-	else
-		io_queue_sqe(req);
+	io_queue_sqe(req);
 }
=20
 static int io_setup_link(struct io_submit_link *link, struct io_kiocb **=
orig)
@@ -2409,6 +2406,9 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 {
 	struct io_submit_link *link =3D &ctx->submit_state.link;
 	unsigned int entries =3D io_sqring_entries(ctx);
+	struct io_wq_work_node *pos, *next;
+	struct io_wq_work_list req_list;
+	struct io_kiocb *req;
 	unsigned int left;
 	int ret, err;
=20
@@ -2419,6 +2419,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
=20
+	INIT_WQ_LIST(&req_list);
 	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
@@ -2437,9 +2438,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsign=
ed int nr)
 		err =3D io_setup_link(link, &req);
 		if (unlikely(err))
 			goto error;
-
-		if (likely(req))
-			io_submit_sqe(req);
+		else if (unlikely(!req))
+			continue;
+		else if (unlikely(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))
+			io_queue_sqe_fallback(req);
+		else
+			wq_list_add_tail(&req->comp_list, &req_list);
 		continue;
 error:
 		/*
@@ -2453,6 +2457,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsign=
ed int nr)
 		}
 	} while (--left);
=20
+	wq_list_for_each_safe(pos, next, &req_list) {
+		req =3D container_of(pos, struct io_kiocb, comp_list);
+		req->comp_list.next =3D NULL;
+		io_submit_sqe(req);
+	}
+
 	if (unlikely(left)) {
 		ret -=3D left;
 		/* try again if it submitted nothing and can't allocate a req */
diff --git a/io_uring/slist.h b/io_uring/slist.h
index 0eb194817242e..93fbb715111ca 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -12,6 +12,10 @@
 #define wq_list_for_each_resume(pos, prv)			\
 	for (; pos; prv =3D pos, pos =3D (pos)->next)
=20
+#define wq_list_for_each_safe(pos, n, head)			\
+	for (pos =3D (head)->first, n =3D pos ? pos->next : NULL;	\
+	     pos; pos =3D n, n =3D pos ? pos->next : NULL)
+
 #define wq_list_empty(list)	(READ_ONCE((list)->first) =3D=3D NULL)
=20
 #define INIT_WQ_LIST(list)	do {				\
--=20
2.34.1

