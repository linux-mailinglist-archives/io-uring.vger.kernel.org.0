Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91251507B8D
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357872AbiDSVBT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 17:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357873AbiDSVBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 17:01:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A4741FAB
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:33 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdrc3024365
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8jpRy6kQLcIknbafc+SAIFA+Mi9hT3ioVifoU7ntq7I=;
 b=fj/1PvBMb44JkKsoqvoC0+QXf+O8wNEwXg9firV8cvId2YSNF+BwJA6Hyec69PjYaArq
 gxMnYiBemhw3VF0b7y+5HjK5Hshn1cZpe6+lHBFzi1svLqi35y9cyqrAyxBWwPmQnOCa
 1IOTVhWHxfNlgJ2ZsGnGnPLN6UmQGp9xZFs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhn4vnr6p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:31 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4D6B5DD46116; Tue, 19 Apr 2022 13:58:26 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/6] liburing: Update io_uring.h with large CQE kernel changes
Date:   Tue, 19 Apr 2022 13:58:12 -0700
Message-ID: <20220419205817.1551377-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205817.1551377-1-shr@fb.com>
References: <20220419205817.1551377-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FJRC_Q5P7wTu_WVyEtf2QIaiJXSeDArx
X-Proofpoint-ORIG-GUID: FJRC_Q5P7wTu_WVyEtf2QIaiJXSeDArx
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

This updates the io_uring.h file with the changes in the kernel.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing/io_uring.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a38a45b..32cb4bf 100644
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
+	struct io_uring_cqe_extra	b[0];
 };
=20
 /*
--=20
2.30.2

