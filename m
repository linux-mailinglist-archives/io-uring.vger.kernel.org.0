Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDDD561611
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiF3JSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiF3JSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84333120C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:10 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0Ledj012196
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+0Viti/Lgm2xoCVdQjJwJa+NK6eCEzeJyRPNqdMmNDg=;
 b=prhhmv0LOnWucJSZKOQerVGhZ1ZPW2qyHpwy747Hsc0ZdAP7hseNp431MuM85svtCU5A
 dlb6mkh7YQd1Xrwpm8Xq7JOAKL0fcR/LEHTFIjN3ZzQareYh1ya8s5mDJeNCMgd0U0cz
 /AQdBadAGxzMUDfS8vevE3Gc53+ok/i0b9U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0rk5wwys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:10 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub103.TheFacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:10 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:09 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C6CC12599FDF; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 09/12] io_uring: fix multishot accept ordering
Date:   Thu, 30 Jun 2022 02:12:28 -0700
Message-ID: <20220630091231.1456789-10-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Lhd3RtPnhDIzi0eIoIisCNOxxaoxkxLF
X-Proofpoint-GUID: Lhd3RtPnhDIzi0eIoIisCNOxxaoxkxLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Similar to multishot poll, drop multishot accept when CQE overflow occurs=
.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c3600814b308..75761f48c959 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -656,11 +656,14 @@ int io_accept(struct io_kiocb *req, unsigned int is=
sue_flags)
 		return IOU_OK;
 	}
=20
-	if (ret < 0)
-		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, tr=
ue))
+	if (ret >=3D 0 &&
+	    io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, fa=
lse))
 		goto retry;
-	return -ECANCELED;
+
+	io_req_set_res(req, ret, 0);
+	if (req->flags & REQ_F_POLLED)
+		return IOU_STOP_MULTISHOT;
+	return IOU_OK;
 }
=20
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
--=20
2.30.2

