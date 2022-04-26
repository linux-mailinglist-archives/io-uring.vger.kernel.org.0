Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41855106BF
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiDZSZr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243582AbiDZSZq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:25:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DDA3914F
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:37 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23QGQSgg018712
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uBdzkvaCLmn9yKhjHEXYQLl+RFSjNoMs4ahMQdDpwec=;
 b=N/30elj8ZNOErAs+22zzoA/IcVCRU6lBBD7XZOGYMwINWVTPSvT0zQlyRWth5XDHwM96
 TsdBERB6alf3eE7U9dDflYWltWJRYZzB95B722MsTt3h+e6JMe/Iaehzey+vsmXAxDL0
 kWDPkNTOpX5fGG3m1lbmILC27sWbz7AtFB0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rv7n5-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:36 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub202.TheFacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:22:30 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:56 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7FDA5E2E56A2; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 11/12] io_uring: enable CQE32
Date:   Tue, 26 Apr 2022 11:21:33 -0700
Message-ID: <20220426182134.136504-12-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6XLH-TrEboCINoHm-3Hvr6bctn8w8TXX
X-Proofpoint-GUID: 6XLH-TrEboCINoHm-3Hvr6bctn8w8TXX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1b84204b0ab..caeddcf8a61c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11752,7 +11752,7 @@ static long io_uring_setup(u32 entries, struct io=
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

