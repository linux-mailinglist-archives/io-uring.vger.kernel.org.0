Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A41621849
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 16:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiKHPae (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 10:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiKHPaa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 10:30:30 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACD3DE87
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 07:30:24 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A86jPa9019822
        for <io-uring@vger.kernel.org>; Tue, 8 Nov 2022 07:30:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=FxFmoB7+/MIXW+M0JoKQjQ2m4rLd0qta5uWqX8l921E=;
 b=Vk5r+/oGdfilnNXdItH9FTueiuK2SklbC9cPWH16mxq7dZ/4IaFd9sEidL+NcBXhtF0G
 CWteWpo7rG/6qnusgnBwjZIo6arhSpEJKnWlly9f2wSxNhjacjZLehaGEtKFuYBMkjoN
 Rh6b9TrQq6QGxDuZ51NafBg8MHHd5uE+DkSzra9jLQHZYn2GnoQSwvl98mv8aG5dqTSw
 q4t1sV4hn3UWLp+tNTVEH+3+Lj1lzu2XIkaelq4z3PvCMPWYKHVDGDHdjMXxX7Y000Qp
 CdItGgRaJtiCeelTLfyh+T6sfDXxGtD84DmkpU8qqBUTFkvw2y/vWNnRgE4KyPwHoSMD Yg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqj3nkgk6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 07:30:23 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 07:30:22 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C504191E4B4F; Tue,  8 Nov 2022 07:30:17 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH] io_uring: calculate CQEs from the user visible value
Date:   Tue, 8 Nov 2022 07:30:16 -0800
Message-ID: <20221108153016.1854297-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yeydwle9CevjWIVOsQCRCftiZYgso02q
X-Proofpoint-GUID: yeydwle9CevjWIVOsQCRCftiZYgso02q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cqring_wait (and it's wake function io_has_work) used cached_cq_tail i=
n
order to calculate the number of CQEs. cached_cq_tail is set strictly
before the user visible rings->cq.tail

However as far as userspace is concerned,  if io_uring_enter(2) is called
with a minimum number of events, they will verify by checking
rings->cq.tail.

It is therefore possible for io_uring_enter(2) to return early with fewer
events visible to the user.

Instead make the wait functions read from the user visible value, so ther=
e
will be no discrepency.

This is triggered eventually by the following reproducer:

struct io_uring_sqe *sqe;
struct io_uring_cqe *cqe;
unsigned int cqe_ready;
struct io_uring ring;
int ret, i;

ret =3D io_uring_queue_init(N, &ring, 0);
assert(!ret);
while(true) {
	for (i =3D 0; i < N; i++) {
		sqe =3D io_uring_get_sqe(&ring);
		io_uring_prep_nop(sqe);
		sqe->flags |=3D IOSQE_ASYNC;
	}
	ret =3D io_uring_submit(&ring);
	assert(ret =3D=3D N);

	do {
		ret =3D io_uring_wait_cqes(&ring, &cqe, N, NULL, NULL);
	} while(ret =3D=3D -EINTR);
	cqe_ready =3D io_uring_cq_ready(&ring);
	assert(!ret);
	assert(cqe_ready =3D=3D N);
	io_uring_cq_advance(&ring, N);
}

Fixes: ad3eb2c89fb2 ("io_uring: split overflow state into SQ and CQ side"=
)
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac8c488e3077..4a1e482747cc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -176,6 +176,11 @@ static inline unsigned int __io_cqring_events(struct=
 io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
=20
+static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *c=
tx)
+{
+	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
+}
+
 static bool io_match_linked(struct io_kiocb *head)
 {
 	struct io_kiocb *req;
@@ -2315,7 +2320,7 @@ static inline bool io_has_work(struct io_ring_ctx *=
ctx)
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx =3D iowq->ctx;
-	int dist =3D ctx->cached_cq_tail - (int) iowq->cq_tail;
+	int dist =3D READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
=20
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
@@ -2399,7 +2404,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, =
int min_events,
 			return ret;
 		io_cqring_overflow_flush(ctx);
=20
-		if (io_cqring_events(ctx) >=3D min_events)
+		/* if user messes with these they will just get an early return */
+		if (__io_cqring_events_user(ctx) >=3D min_events)
 			return 0;
 	} while (ret > 0);
=20

base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
--=20
2.30.2

