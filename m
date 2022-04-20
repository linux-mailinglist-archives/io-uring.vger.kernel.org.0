Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7950902C
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381676AbiDTTS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378958AbiDTTSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:21 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4991D0C1
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:33 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILPoS001812
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CmUL7L0wUmPH9ExGou5CbXAYIHkHld5hamewMXNELNo=;
 b=RPWSKbmltNxxdaGrX2BhbvVpGwGMKYNl2xUUy56F5yPeD+7Wzu1TLSE24x7zSfW4OC+4
 0g6L40dl+sm/zjbXa6zr6hGMQSGAlwHUyQJ+FXKow7w0bpYCfoKBAuS2XooIFPrX/Q/Q
 LJbr/YTnL8GVWuhougkX0V6nwVRsluxjvuc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhub7as5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:33 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:32 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 53632DE0C4B3; Wed, 20 Apr 2022 12:15:27 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 1/6] liburing: Update io_uring.h with large CQE kernel changes
Date:   Wed, 20 Apr 2022 12:15:19 -0700
Message-ID: <20220420191524.2906409-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191524.2906409-1-shr@fb.com>
References: <20220420191524.2906409-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5bDhZTUDCCD3KkWTcYgSUOjZdMGCkaIf
X-Proofpoint-ORIG-GUID: 5bDhZTUDCCD3KkWTcYgSUOjZdMGCkaIf
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

This updates the io_uring.h file with the changes in the kernel.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing/io_uring.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a38a45b..cad0b32 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -113,6 +113,7 @@ enum {
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
 #define IORING_SETUP_SQE128	(1U << 8)	/* SQEs are 128b */
+#define IORING_SETUP_CQE32	(1U << 9)	/* CQEs are 32b */
=20
 enum {
 	IORING_OP_NOP,
@@ -198,6 +199,12 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
=20
+/* Extra padding for large CQEs. */
+struct io_uring_cqe_extra {
+	__u64	extra1;
+	__u64	extra2;
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -205,6 +212,12 @@ struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
+
+	/*
+	 * If the ring is initialized wit IORING_SETUP_CQE32, then this field
+	 * contains 16-bytes of padding, doubling the size fo the CQE.
+	 */
+	struct io_uring_cqe_extra	b[];
 };
=20
 /*
--=20
2.30.2

