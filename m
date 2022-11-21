Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD45631E9A
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiKUKmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKUKmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:42:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC4BAFE73
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:05 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKNUqfi027349
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=fSLTEJetbWr2pbtuuZssjhD39zwbW2dgI2JxFNwjEkk=;
 b=M+N7ML8yT95cGOnRt79lueyS5NX+zTSKdBof+bK6UAjyTe/KJ/sXj/Q1MobOEiRr05CV
 pMETGe4jwcAQYesyoQn2uCStlcMFCMv38PsX/Z3n+fMEL3MLqMmc/6C69h7Cts36h5gd
 Uf7WcGgw6WB6XKyDrQsudkCMhy//jVn4aMlHrQNDwPgft/DZOwF0hnPQwTtc4L9dVx81
 hBEZFg8VYYdkSC+9t3b5f2Zh9YrwsH/SdqN3HHzANFP/ZpjVg3Cpm5pr3Er/cSoWcFkc
 4LLNxdZz1//99N0DN22tUW7wWkhvi2zuZs3GfT+qzFS5lcQJ00qpe5S2ooNRoEfbThej xQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxubu435t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:04 -0800
Received: from twshared3131.02.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:42:03 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C6C849E66F70; Mon, 21 Nov 2022 02:03:55 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 04/10] io_uring: lock on remove in io_apoll_task_func
Date:   Mon, 21 Nov 2022 02:03:47 -0800
Message-ID: <20221121100353.371865-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: HlxjMDcGpPcRKW7ZpksaLayt6FX4D-WW
X-Proofpoint-ORIG-GUID: HlxjMDcGpPcRKW7ZpksaLayt6FX4D-WW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
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
index d9bd18e3a603..03946f46dadc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -878,14 +878,14 @@ static inline void io_req_prep_failed(struct io_kio=
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
index ee3139947fcc..1daf236513cc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -29,7 +29,7 @@ bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
-void io_req_post_failed(struct io_kiocb *req, s32 res);
+void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index e0a4faa010b3..2b77d18a67a7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -296,15 +296,16 @@ static void io_apoll_task_func(struct io_kiocb *req=
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

