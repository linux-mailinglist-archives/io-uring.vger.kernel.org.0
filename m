Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D152C50E82E
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbiDYS3L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbiDYS3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:06 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD7F27162
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:00 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP4KM019300
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NXD9KVajxJV9lmS7UhO+CGaB9LHYu9wb8QSJ14OUa9M=;
 b=K4TbR1pGsFxLNw8vTtw9NZtq2sPynvgvz2QHkGA6kSkHEwKK6g3959swPoxYOjJfzOJk
 UrtQC3p1JpvrHdA1udEMoQov+fzJ/xo6zV65egI0wFquz0gF8M94UCF6NGzA59EvwUUH
 ipDPMCA9tCymeYhpcIr+TYUiHlWewcMXXG0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf6v3wh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:59 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:25:58 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 453C6E1F2A61; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 07/12] io_uring: flush completions for CQE32
Date:   Mon, 25 Apr 2022 11:25:25 -0700
Message-ID: <20220425182530.2442911-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 94mqIvuso0DGNCtG_VHE89w9jtVFudD5
X-Proofpoint-ORIG-GUID: 94mqIvuso0DGNCtG_VHE89w9jtVFudD5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

