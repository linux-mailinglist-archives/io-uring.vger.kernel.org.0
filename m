Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43109509025
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348424AbiDTTR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358692AbiDTTR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:17:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D59165D7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:10 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILQXv000930
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iP4NK7PknGzhEUhYWPBnltT7ueTaXI7YqhWtCba+Zq8=;
 b=O2hh19dey7myQqL8UId9jTchjV4IeGKpJBMHQi1PyXLsvplomIYvwFW+uWS3UzPjykcg
 dTzVRwoB0QsOWocIQzyTVfq0X6Lc7RSibNeDSEszknrnHSr6+DebsU+/+LhO9vdfXWkG
 iVMTBGdxF59bE1uYp9QQoH20YqRxJ5PtaEs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj36t79ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:09 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:08 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A9C74DE0C412; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 07/12] io_uring: flush completions for CQE32
Date:   Wed, 20 Apr 2022 12:14:46 -0700
Message-ID: <20220420191451.2904439-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: GgF_iHigXR67IaEuiCD8KA_O_Ex_G190
X-Proofpoint-ORIG-GUID: GgF_iHigXR67IaEuiCD8KA_O_Ex_G190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This flushes the completions according to their CQE type: the same
processing is done for the default CQE size, but for large CQE's the
extra1 and extra2 fields are filled in.

Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd352815b9e7..ff6229b6df16 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2877,8 +2877,12 @@ static void __io_submit_flush_completions(struct i=
o_ring_ctx *ctx)
 			struct io_kiocb *req =3D container_of(node, struct io_kiocb,
 						    comp_list);
=20
-			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe_req_filled(ctx, req);
+			if (!(req->flags & REQ_F_CQE_SKIP)) {
+				if (!(ctx->flags & IORING_SETUP_CQE32))
+					__io_fill_cqe_req_filled(ctx, req);
+				else
+					__io_fill_cqe32_req_filled(ctx, req);
+			}
 		}
=20
 		io_commit_cqring(ctx);
--=20
2.30.2

