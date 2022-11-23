Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44430635B04
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiKWLHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiKWLHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61594F51
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4GC9001713
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=2sN06wr+1KcWtoE/vbRTMxGMhpyxRaDQtzzs4SI6w2E=;
 b=Y/tLe9EC15fLJzoLwa93IuXsSn0Q23rfIrfIxYBo1F1iQ0RtOnpvuAWiA+FPXdaGJxZX
 wO/q7rNkAmzjkaWvIa79B16BjfhSn5jJdiya1m9ZTFB+Fx4EBI9847c7rUMyMzBPpW+I
 ix8pRKi1LP1Zd3WEranh+25m+NoRys9ZaoiN/v9g8KvOk+gb6ELnHZs1KfTHOdNgbSMz
 glFEQ+wQjzOOopSAvKUAT5eXODoGlqzV6b807ot+SI0qWI8vdE0t7cNJedjh1bY55tUD
 XhlU07UdJdOYEpYe40bOMeqCfD682J6bNGaKY8329sSmjz3HVk5dazlRF7BvsQARJFeK FQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0javkw9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:50 -0800
Received: from twshared10308.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:49 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id ECAFCA0804DD; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 11/13] io_uring: add lockdep assertion in io_fill_cqe_aux
Date:   Wed, 23 Nov 2022 03:06:12 -0800
Message-ID: <20221123110614.3297343-12-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KP_DF3J6lA2Qs8nHPeqJ97v92V51cxw_
X-Proofpoint-GUID: KP_DF3J6lA2Qs8nHPeqJ97v92V51cxw_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add an assertion for the completion lock to io_fill_cqe_aux

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 42c7383ead91..6e1139a11fbf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -775,6 +775,8 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, =
u64 user_data, s32 res, u32
 {
 	struct io_uring_cqe *cqe;
=20
+	lockdep_assert_held(&ctx->completion_lock);
+
 	ctx->cq_extra++;
=20
 	/*
--=20
2.30.2

