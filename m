Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC855E659
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347696AbiF1PC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347694AbiF1PCy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:02:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B9B33E9F
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:53 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SEdFhO030169
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GhUO5GqGv+DbKPtClNBIaCznVrmxio+cvLQXkR92xOo=;
 b=P7Zo9DXOH/pSsHHphilUequlMJmNVXTEOODghSi9E/AM2iAY0D/2jtx4h01a+fyRzOZ0
 tiEFWtulHfEsPcW27dlvVSOzKSPwsRrz2M3ZJlRKjMMUtMD60rRTBwyMJe+IQYxynlyt
 EeWEJ+qs9GC8lnCWML3ZY8P5GNSYg/X6tUM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h03kf05qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:52 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:51 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 10BBC244BBD9; Tue, 28 Jun 2022 08:02:38 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 7/8] io_uring: add IORING_RECV_MULTISHOT flag
Date:   Tue, 28 Jun 2022 08:02:27 -0700
Message-ID: <20220628150228.1379645-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150228.1379645-1-dylany@fb.com>
References: <20220628150228.1379645-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZGubI1Skm2MdgQsk4hBtCHz3ztXYZIO8
X-Proofpoint-ORIG-GUID: ZGubI1Skm2MdgQsk4hBtCHz3ztXYZIO8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce multishot recv flag which will be used for multishot
recv/recvmsg

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 09e7c3b13d2d..1e5bdb323184 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -259,8 +259,13 @@ enum io_uring_op {
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

