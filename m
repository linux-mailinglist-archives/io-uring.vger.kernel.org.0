Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8475106B9
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245649AbiDZSZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiDZSZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:25:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F8F344F0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:56 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQTe1024657
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RMg/pdGI137a+LXXuDX7KRZzylRtIXCVtW7Xo6wCy4Q=;
 b=ft/0omjhz+rKtOMGxOgk9R++qLcuJqrkyf1PRgStjoaxNHOTIFS7X9CAUTiFqxiIHnSA
 sPkDNXfx7rI/QGt6q81qkrB5UfzSM3Mj8W2tNBRHKTLF+dk0DKjMC1GbYuXLUMIn7Tcp
 bI90EP8XvfmUJ8Zoi6299U2+1LLGH7wQoIU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge0d8w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:56 -0700
Received: from twshared39027.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:54 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 68D55E2E569A; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v4 07/12] io_uring: flush completions for CQE32
Date:   Tue, 26 Apr 2022 11:21:29 -0700
Message-ID: <20220426182134.136504-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 55RGe_tco28Jeff3NteSFwGGdHso5DUY
X-Proofpoint-GUID: 55RGe_tco28Jeff3NteSFwGGdHso5DUY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
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
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 726238dc65dc..68b61d2b356d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2885,8 +2885,12 @@ static void __io_submit_flush_completions(struct i=
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

