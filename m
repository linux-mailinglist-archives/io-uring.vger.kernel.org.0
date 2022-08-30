Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE545A63DC
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 14:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiH3Mur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 08:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiH3Mup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 08:50:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA1B1B83
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:44 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UApFDt031298
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=lQfLjUA9Wxmh/bZU7j4++b28yG85+qr8HmcaqcrdUWQ=;
 b=Pmx1nWnTKZAhrFy2BrOzfCRYXqQTyEFiaNtQ71d/kTQuTUy/vXYOaLccIvlCAsF5W2NE
 EIBlc6oS83MVeYtdYZyV142dxePLMul1XbOMdBStkLOJ4pqu5Hyc4WzhVuECd2zKBnI3
 yucn6E6yLmgnAGo2lMEJpdrLyR33pwX2xT4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j9h5dghxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:43 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:50:41 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E369155BF50C; Tue, 30 Aug 2022 05:50:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v4 2/7] io_uring: introduce io_has_work
Date:   Tue, 30 Aug 2022 05:50:08 -0700
Message-ID: <20220830125013.570060-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830125013.570060-1-dylany@fb.com>
References: <20220830125013.570060-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WwGLPEx3hEUYwL0plp2O1ESJeJvbCsnd
X-Proofpoint-ORIG-GUID: WwGLPEx3hEUYwL0plp2O1ESJeJvbCsnd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_07,2022-08-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This will be used later to know if the ring has outstanding work. Right
now just if there is overflow CQEs to copy to the main CQE ring, but late=
r
will include deferred tasks

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 41eaf5ec70df..7998dc23360f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2145,6 +2145,11 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 };
=20
+static inline bool io_has_work(struct io_ring_ctx *ctx)
+{
+	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
+}
+
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx =3D iowq->ctx;
@@ -2163,13 +2168,13 @@ static int io_wake_function(struct wait_queue_ent=
ry *curr, unsigned int mode,
 {
 	struct io_wait_queue *iowq =3D container_of(curr, struct io_wait_queue,
 							wq);
+	struct io_ring_ctx *ctx =3D iowq->ctx;
=20
 	/*
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) ||
-	    test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &iowq->ctx->check_cq))
+	if (io_should_wake(iowq) || io_has_work(ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2505,8 +2510,8 @@ static __poll_t io_uring_poll(struct file *file, po=
ll_table *wait)
 	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
 	 * pushs them to do the flush.
 	 */
-	if (io_cqring_events(ctx) ||
-	    test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
+
+	if (io_cqring_events(ctx) || io_has_work(ctx))
 		mask |=3D EPOLLIN | EPOLLRDNORM;
=20
 	return mask;
--=20
2.30.2

