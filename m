Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115CF509029
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381596AbiDTTSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381670AbiDTTSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BB564D3
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:14 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23KILSNv020512
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VemR0WO+/pgq/+U6vroDGgctNvMNr6/jNDvp7ns7jZ0=;
 b=SVFsQWJ+NgJ5u1E++DRx7FJ5waQeFB0ZDafNdbz1n/7jjTJwhPL9BOOLJaM6BK07KqRw
 dZOf/Q0VP8Dxa+FH9MXkSR/5EmoR0BiOfNVsVWniYD2rQnHZPBe3UVJTKJEbYQp/MR42
 qO4YEkb06YMMXvWr1JkVTxpVkUJL1hlOw6o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fhn4j4en4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:14 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:12 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C0CAFDE0C41A; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 11/12] io_uring: enable CQE32
Date:   Wed, 20 Apr 2022 12:14:50 -0700
Message-ID: <20220420191451.2904439-12-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 977Or9dA_0bLbO4lAbRcJSaU8s-vGfg_
X-Proofpoint-ORIG-GUID: 977Or9dA_0bLbO4lAbRcJSaU8s-vGfg_
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

This enables large CQE's in the uring setup.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a5fbad91800c..8bdf253b9462 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11742,7 +11742,7 @@ static long io_uring_setup(u32 entries, struct io=
_uring_params __user *params)
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
-			IORING_SETUP_SQE128))
+			IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
 		return -EINVAL;
=20
 	return  io_uring_create(entries, &p, params);
--=20
2.30.2

