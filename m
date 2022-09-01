Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377A65A932D
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiIAJdS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiIAJdR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92AA132EF6
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:15 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2812ajMR006574
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=el3PAq0zZyu9B1yqAdpkQoG3SjxFno8haAGM3mtUbJQ=;
 b=QdW4nYRTsVqPpf5znjq//iks0P9HUHUHIjVBgYKsLW6o4O+AVy6YHHVNY8iSLvbUyVK8
 7ceTpmgyJA60cjeQe1+bJJsgbXirWo4AiZK7cqKiAW9vySX2dMt7Sm1eaT9h+HsZBywT
 3/QFzrnuIEre7pv3QKErViI+FjeyXwBQzX0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jam3v9jym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:15 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 9A39957693F0; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 01/12] Copy defer task run definition from kernel
Date:   Thu, 1 Sep 2022 02:32:52 -0700
Message-ID: <20220901093303.1974274-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dAdKzbFsfLIjM-XZsZ5m0_96YH0fMbyx
X-Proofpoint-ORIG-GUID: dAdKzbFsfLIjM-XZsZ5m0_96YH0fMbyx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Copy the flag from upstream

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing/io_uring.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 9e0b5c8d92ce..48e5c70e0baf 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -157,6 +157,13 @@ enum {
  */
 #define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
=20
+/*
+ * Defer running task work to get events.
+ * Rather than running bits of task work whenever the task transitions
+ * try to do it just before it is needed.
+ */
+#define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
--=20
2.30.2

