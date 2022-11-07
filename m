Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC161F3C0
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiKGMxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiKGMxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:53:02 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C7D1C131
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:53:01 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wKAe013036
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:53:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=dI01kHpT6Bh8dsXyPB9VqjlwwDSWMFy9A1u+I4SG6ss=;
 b=MKc4OFTwPQBfkyTTVwKtc7lx8zLmHRhaxsfIPhKtuet5l4I0iUZaqta3iAk96BjQmXDB
 Fkat6WPlaL71Ygs7W3Q/Flw+JvzM8xr6kju48KWQpTG8jQjDMeFWl8Q+Aoytt4agXTQl
 DuPq76tDQfhITgWV4fuv8wyhclueef56XB+LK/c/5xwXSli6XdiVvtU51Kx+8cTziXvR
 d6Xwu5grayfHyknjCBzooGm53GUUV+5YNSxcymIwoTA+7DUIz/W1Hga6+owFTc66a48o
 +QCrGh0yy4aH/HbUPLoX9QrksR+rs/dpQoh2WV6IAM/9V6YFdrlM95HfEPmVruKmzu5l iw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnbynjc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:53:00 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:53:00 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 3C4B790D69E5; Mon,  7 Nov 2022 04:52:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 1/4] io_uring: revert "io_uring fix multishot accept ordering"
Date:   Mon, 7 Nov 2022 04:52:33 -0800
Message-ID: <20221107125236.260132-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107125236.260132-1-dylany@meta.com>
References: <20221107125236.260132-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nCqOuxIrMqNcun9tVOdwu4Z8sWL9CbTY
X-Proofpoint-GUID: nCqOuxIrMqNcun9tVOdwu4Z8sWL9CbTY
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

This reverts commit cbd25748545c ("io_uring: fix multishot accept
ordering").

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/net.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9a07e79cc0e6..0d77ddcce0af 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1325,14 +1325,11 @@ int io_accept(struct io_kiocb *req, unsigned int =
issue_flags)
 		return IOU_OK;
 	}
=20
-	if (ret >=3D 0 &&
-	    io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, fa=
lse))
+	if (ret < 0)
+		return ret;
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, tr=
ue))
 		goto retry;
-
-	io_req_set_res(req, ret, 0);
-	if (req->flags & REQ_F_POLLED)
-		return IOU_STOP_MULTISHOT;
-	return IOU_OK;
+	return -ECANCELED;
 }
=20
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
--=20
2.30.2

