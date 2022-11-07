Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5615C61F3BF
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiKGMxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiKGMxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:53:02 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8954D1C11D
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:53:01 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wx9O015361
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:53:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=Y5ewqsdmJVnyuEp1zWhiQ6qxliIutqIHhbKITNnyLWE=;
 b=des6QnKBx2SkEv2XRaqMsMIF5mcF2U23AY2A0vQiZprQcC5cyakFx7viV2bjD9fe2TQD
 lPGtHzCxIAF/rhAsbO5xd+ipim68/ZIBKan0u/ZemlFckWJEAVK1mNVjtc0bBeUWuqel
 btr3ihG1XW/Kp+dMAOVn4JY7hPw2Fhlje7GgpfSpKvj2vhuy0wG+uzoNatk7UGoRRKE9
 E1M9FOD3YmFsI6eGVqqy4UnMNYRxgERDQonE7VQAf/0JO2KLAH06k0TeJSwlR+uex0Kt
 +aiI2ixxNZRzGNcgfcKYQHfissojKZlJ8ppn0rW/ypIEZz/9rb3t3SKu3K8FR9pagjIP jA== 
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnbynjc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:53:00 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:53:00 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 435FD90D69E9; Mon,  7 Nov 2022 04:52:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 2/4] io_uring: revert "io_uring: fix multishot poll on overflow"
Date:   Mon, 7 Nov 2022 04:52:34 -0800
Message-ID: <20221107125236.260132-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107125236.260132-1-dylany@meta.com>
References: <20221107125236.260132-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kPMM-zb5d2FB0Jm-Fgt18SnQz_Unqif1
X-Proofpoint-GUID: kPMM-zb5d2FB0Jm-Fgt18SnQz_Unqif1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_05,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is no longer needed after commit aa1df3a360a0 ("io_uring: fix CQE
reordering"), since all reordering is now taken care of.

This reverts commit a2da676376fe ("io_uring: fix multishot poll on
overflow").

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/poll.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 589b60fc740a..e1b8652b670f 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -244,10 +244,8 @@ static int io_poll_check_events(struct io_kiocb *req=
, bool *locked)
 						    req->apoll_events);
=20
 			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
-					     mask, IORING_CQE_F_MORE, false)) {
-				io_req_set_res(req, mask, 0);
-				return IOU_POLL_REMOVE_POLL_USE_RES;
-			}
+					     mask, IORING_CQE_F_MORE, true))
+				return -ECANCELED;
 		} else {
 			ret =3D io_poll_issue(req, locked);
 			if (ret =3D=3D IOU_STOP_MULTISHOT)
--=20
2.30.2

