Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37AA56162F
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiF3JVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiF3JVH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:07 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086D735857
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:59 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LasQ021139
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0f4ahnYUt8ydoIxJ6zpxIt7S/r5MsLBAmpBaN1S109s=;
 b=crXECv0gQkxAWtMWm5+fiRSas1oCR8tohOZNoDt5P1jGZR9Rzta/Jo2zqP7Ly6X6VqEZ
 5XtANItKvsXVt6DsY7d4XLsn6Vv4YQg7iNEPVO5kdGaOacfZ56moWsVR0zS+eVUbDXkC
 HsfCcAl8l0tum1okoAVppI3tt5oEqPfnFQI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0dgqs9bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:20:57 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:20:56 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B3B08259A04D; Thu, 30 Jun 2022 02:14:23 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 liburing 2/7] add IORING_RECV_MULTISHOT to io_uring.h
Date:   Thu, 30 Jun 2022 02:14:17 -0700
Message-ID: <20220630091422.1463570-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091422.1463570-1-dylany@fb.com>
References: <20220630091422.1463570-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nYE2n4dLR1FwExaQEYAZdpPKQBMYD5U5
X-Proofpoint-GUID: nYE2n4dLR1FwExaQEYAZdpPKQBMYD5U5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

copy relevant part from include/uapi/linux/io_uring.h from
for-5.20/io_uring branch

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 0fd1f98..de42c54 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -244,8 +244,13 @@ enum io_uring_op {
  *				or receive and arm poll if that yields an
  *				-EAGAIN result, arm poll upfront and skip
  *				the initial transfer attempt.
+ *
+ * IORING_RECV_MULTISHOT	Multishot recv. Sets IORING_CQE_F_MORE if
+ *				the handler will continue to report
+ *				CQEs on behalf of the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
+#define IORING_RECV_MULTISHOT	(1U << 1)
=20
 /*
  * accept flags stored in sqe->ioprio
--=20
2.30.2

