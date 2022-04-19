Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4163507B71
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346200AbiDSU7e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357858AbiDSU7c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672414132B
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:49 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdvqb011512
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NieqABC7vftvASe+WZ9VaBf8IuGXEV6i7rwPfdNLQeE=;
 b=ZpiuyM18Vmg9qLilyGINvfSbGiW//Ti/39Aipe+rOya6Lzn9FxIYD0t75m253lop9xC3
 wMQQLOQfJ7zfSfBa132XWUgGcJ/tpz2MGRR+8CfK7j4sBydjUDHmTc/YmoTpbA2WYqD5
 5xAWKvpszH7SquFh9xh7JyeTWRtRzZY5C9Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhjh1pdef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:49 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:48 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 257EDDD45FEF; Tue, 19 Apr 2022 13:56:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 10/11] io_uring: enable CQE32
Date:   Tue, 19 Apr 2022 13:56:23 -0700
Message-ID: <20220419205624.1546079-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: S_879CSawn46qtxtqepndI0PkvOnX6UN
X-Proofpoint-ORIG-GUID: S_879CSawn46qtxtqepndI0PkvOnX6UN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_08,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 366f49969b31..70877f1ca0a9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11731,7 +11731,7 @@ static long io_uring_setup(u32 entries, struct io=
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

