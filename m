Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EC3635B0A
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiKWLHd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiKWLHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:03 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CF33F077
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:44 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4PXq007756
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=pfgkninkean9r6uL5du/awvzK1aW9ARm3AW/GquuILQ=;
 b=jC6RRrlMvD/tBtkeheiO/fvMjiuKsJBT6Ys34tTCD5W0yNyF1yFNPIzM6fMUsWB3Vno9
 ahcX0TyHWX6A8ep2FYgat7CJqZ/quXUjuAs/mpkmpcyWzpuhC8FWERt7oc2DU4dYGOMU
 DfMQJiHx2tn0ffDBqCx1VhNBOtJLT9MJltoLUrjY1o5I/tbwHDx+jEfJTPqCLXBf1Eg0
 bZ3M7GqYgc//2Xu3dlCQ6rybsiZlIzEGWNPyniTVTEdoWHhutXdOFN2hwdU9Xr5GycT7
 wtRxDSUWK+X3ZlZN0jmbfCGTxYEjbig/5qQrcGmK2WTAIBnk+oPyXL2rYZpuAX8fiHZY iQ== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m17esbjnq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:43 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:42 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0FA7AA0804BF; Wed, 23 Nov 2022 03:06:26 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 04/13] io_uring: lock on remove in io_apoll_task_func
Date:   Wed, 23 Nov 2022 03:06:05 -0800
Message-ID: <20221123110614.3297343-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: plmTKqt8W2bY1k81VIdMxCVbVA55k4-q
X-Proofpoint-ORIG-GUID: plmTKqt8W2bY1k81VIdMxCVbVA55k4-q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows using io_req_defer_failed rather than post in all cases. The
alternative would be to branch based on *locked and decide whether to pos=
t
or defer the completion.
However all of the non-error paths in io_poll_check_events that do not do
not return IOU_POLL_NO_ACTION end up locking anyway, and locking here doe=
s
reduce the logic complexity, so  it seems reasonable to lock always and
then also defer the completion on failure always.

This also means that only io_req_defer_failed needs exporting from
io_uring.h

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/io_uring.h | 2 +-
 io_uring/poll.c     | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e23adb7b0c5..5a620001df2e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -874,14 +874,14 @@ static inline void io_req_prep_failed(struct io_kio=
cb *req, s32 res)
 		def->fail(req);
 }
=20
-static void io_req_defer_failed(struct io_kiocb *req, s32 res)
+void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
 	io_req_prep_failed(req, res);
 	io_req_complete_defer(req);
 }
=20
-void io_req_post_failed(struct io_kiocb *req, s32 res)
+static void io_req_post_failed(struct io_kiocb *req, s32 res)
 {
 	io_req_prep_failed(req, res);
 	io_req_complete_post(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4d2d0926a42b..ffab0d2d33c0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -30,7 +30,7 @@ bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
-void io_req_post_failed(struct io_kiocb *req, s32 res);
+void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index ceb8255b54eb..4bd43e6f5b72 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -308,15 +308,16 @@ static void io_apoll_task_func(struct io_kiocb *req=
, bool *locked)
 	if (ret =3D=3D IOU_POLL_NO_ACTION)
 		return;
=20
+	io_tw_lock(req->ctx, locked);
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, locked);
=20
 	if (ret =3D=3D IOU_POLL_REMOVE_POLL_USE_RES)
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 	else if (ret =3D=3D IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
-		io_req_post_failed(req, ret);
+		io_req_defer_failed(req, ret);
 }
=20
 static void __io_poll_execute(struct io_kiocb *req, int mask)
--=20
2.30.2

