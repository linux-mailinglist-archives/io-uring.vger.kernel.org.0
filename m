Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D3957CDEE
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiGUOnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGUOm7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:42:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF75F8688C
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:58 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LCAf5T023800
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FPASyAN564D/lc/S3W9vE3+3soN/s8+Q9bnq2cCVTTw=;
 b=kux8e5k4tWwKtFTa6SKgr+ff/1DtScpbzPRqWN3KC6j8ddCRRyF1UmZ3VhIeq9YtFABM
 T0WOQLKmKJt88ozTXzgmk+k9AQAgpTpUUYMFnDmFDGll6OKJz8qftGI4l1Tp9Gqh5b4U
 hCM3XAThKXXDXMtxBz6LU9iFckXb9d4qQBQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hf6jjrvbw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:58 -0700
Received: from twshared39111.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 07:42:56 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 74C223593BA9; Thu, 21 Jul 2022 07:42:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/4] Copy IORING_SETUP_SINGLE_ISSUER into io_uring.h
Date:   Thu, 21 Jul 2022 07:42:27 -0700
Message-ID: <20220721144229.1224141-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721144229.1224141-1-dylany@fb.com>
References: <20220721144229.1224141-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PAHkGvztSOfyupAaKBckJxTfH2obTcS1
X-Proofpoint-ORIG-GUID: PAHkGvztSOfyupAaKBckJxTfH2obTcS1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Copy from the 5.20 tree IORING_SETUP_SINGLE_ISSUER which is queued up.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 51126c4f6fd5..99e6963f3ff9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -134,6 +134,10 @@ enum {
=20
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
=20
 enum io_uring_op {
 	IORING_OP_NOP,
--=20
2.30.2

