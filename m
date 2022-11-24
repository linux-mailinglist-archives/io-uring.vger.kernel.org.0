Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2B637555
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKXJgz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKXJgq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:46 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE33A125216
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsNZi025297
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=JSS5CL/30b52rzl+j3X2NYB+cHO3TOtfcWoEpuDvd48=;
 b=ZKUHakm7eEjMuGF5u/lHVdFLT8SdKHYZMghKYkLernKohw0Kf15dWhFCTB4VUqq6BUIh
 IIXTlMBhrT6Ht7zr8If9ej8qdWl7kzLdKsv04myCc54DhkKVjUWhmdvpvfR45eaUXYnK
 U3+Eev/RUvrIY5nrn3fLYYZo6JHeCi9ol3MtmpK4a3YsKIWa57gm1mwHmxJM5FoEecib
 LnPNvv1whTETOTHNFcB00q6mDOwplniqzXQkXqNj87u5a3hGZR97ipaF9fBuZExwgvqz
 dmozI2aNLHep7m+q4Ef0TDj8TOCIyx2v734eqfnT3l94/5kDdlb+p5VKs9zpUjklZxXk Hw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0m1a3193-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800
Received: from twshared41876.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:42 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 08955A173A1A; Thu, 24 Nov 2022 01:36:21 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 7/9] io_uring: add lockdep assertion in io_fill_cqe_aux
Date:   Thu, 24 Nov 2022 01:35:57 -0800
Message-ID: <20221124093559.3780686-8-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hp1FH_P30e73qoFkqyQWexkK6L-EYcZj
X-Proofpoint-GUID: hp1FH_P30e73qoFkqyQWexkK6L-EYcZj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
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
index 92a7d6deacb6..e937e5d68b22 100644
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

