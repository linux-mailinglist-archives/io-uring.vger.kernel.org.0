Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48B509C12
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387451AbiDUJT7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387440AbiDUJTw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:52 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945EC24089
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:03 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L7M4sY001875
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=o+BEJzHk53Z2SWPQnNBmJJX4g5pdl6FD6EzyM6ejeDU=;
 b=FCTyzZzxkRgUdu2CKkT1lqxM385q8rqANFfI2jCSJy1xA5kx568x83wPiHoDW2uUdRu8
 e0pNL4XY/uIQIany6u78wOXzqJxoebmgu/aCCiEnIPUR9I0OoDacclvMDyhXPalqb+c4
 iUp2ht/xgy7XqbQc4pshCQZ1y6Sdva/Caf8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhub7eq3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:17:02 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:17:01 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 19B7F7CA7604; Thu, 21 Apr 2022 02:14:02 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 6/6] io_uring: allow NOP opcode in IOPOLL mode
Date:   Thu, 21 Apr 2022 02:13:45 -0700
Message-ID: <20220421091345.2115755-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: urG3mZncmEshCgUxHwQOox4GE2S8F1XU
X-Proofpoint-ORIG-GUID: urG3mZncmEshCgUxHwQOox4GE2S8F1XU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is useful for tests so that IOPOLL can be tested without requiring
files. NOP is acceptable in IOPOLL as it always completes immediately.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e46dc67c917c..a4e42ba708b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4526,11 +4526,6 @@ static int io_splice(struct io_kiocb *req, unsigne=
d int issue_flags)
  */
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx =3D req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	__io_req_complete(req, issue_flags, 0, 0);
 	return 0;
 }
--=20
2.30.2

