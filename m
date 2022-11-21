Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FA631E8A
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiKUKgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKUKgR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:36:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24003B10FA
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:13 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2AKMcOkM009034
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=zqE7wnuHH2jfEJzRt8kiWCSTGyh0h4w3yFgaDz5TXDE=;
 b=eQxRUmRo/LQhOxcfhHNmd2ng9Db8+srbsywNDIFJAH8Ul/ETxj4GvAE6Pz+d1mkLPhHC
 mX1kx9JLfc3RFQUbPE9lGItbrF2ibT2rtTFNCBHRLKjFQe+KCHYIld1uHDzIJ6v/pYNf
 X2ma2mfw4VKfW8J3MPMx8D/TVLaY8faAMIknuO4m4vPYy4lA6xuSTKzyYYv1e0tTETbM
 bGp/AG2iOIAvYv0LFpdqg1/XUBWzcOZ7qYZQVZSEnwEAQqOerJ5S1O3D5YFYVjb2L9VC
 1T6e4ctz4IJFczRK3rBdgORytpPC5TkH06uZrCRXhQyQWSJCwQyTzXNT06y+PzvlFuCr Uw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kxuq0c53n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:12 -0800
Received: from twshared3131.02.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:36:11 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DFE649E66F69; Mon, 21 Nov 2022 02:03:54 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 01/10] io_uring: merge io_req_tw_post and io_req_task_complete
Date:   Mon, 21 Nov 2022 02:03:44 -0800
Message-ID: <20221121100353.371865-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HNWlv24yixpnFPj2Y1yuX2HDuFrOUqOM
X-Proofpoint-GUID: HNWlv24yixpnFPj2Y1yuX2HDuFrOUqOM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge these functions that have the same logic

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9e868a83e472..f15aca039db6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1227,15 +1227,18 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	return ret;
 }
=20
-static void io_req_tw_post(struct io_kiocb *req, bool *locked)
+void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	io_req_complete_post(req);
+	if (*locked)
+		io_req_complete_defer(req);
+	else
+		io_req_complete_post(req);
 }
=20
 void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	io_req_set_res(req, res, cflags);
-	req->io_task_work.func =3D io_req_tw_post;
+	req->io_task_work.func =3D io_req_task_complete;
 	io_req_task_work_add(req);
 }
=20
@@ -1464,14 +1467,6 @@ static int io_iopoll_check(struct io_ring_ctx *ctx=
, long min)
 	return ret;
 }
=20
-void io_req_task_complete(struct io_kiocb *req, bool *locked)
-{
-	if (*locked)
-		io_req_complete_defer(req);
-	else
-		io_req_complete_post(req);
-}
-
 /*
  * After the iocb has been issued, it's safe to be found on the poll lis=
t.
  * Adding the kiocb to the list AFTER submission ensures that we don't
--=20
2.30.2

