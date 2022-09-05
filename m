Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A285AD3CC
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiIENZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiIENZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:25:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8717E30
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:25:00 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2858W5Bh015032
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:25:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gnpoJUJbAC5s4BHYrIp+PoxM0NGyFE9ctD+3e4Y/UDY=;
 b=rTDgewyin3nuGPYMWhh/iNI5Pb1beLGHCC9StBym4MXikgF6WLGm2edDTpnhYFPx12kZ
 TrY2/x4XYglZn4JEJ/kH+69pztlZ1lV7FBmgZi53s6u6Re6oHY7GqV5PxbhZqiWEKnWC
 9JIS+WdpNTEbZcNcYovuc+YZZ2uVVEhNn/U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jc684ramf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:25:00 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:24:59 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1A6535AC516B; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 01/11] Copy defer task run definition from kernel
Date:   Mon, 5 Sep 2022 06:22:48 -0700
Message-ID: <20220905132258.1858915-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cLUo1LCJYgGSr9a3VWQhGC-shl_hxwI-
X-Proofpoint-ORIG-GUID: cLUo1LCJYgGSr9a3VWQhGC-shl_hxwI-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
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
index 6b83177fd41d..972b179bc07a 100644
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

