Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA0D50E829
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiDYS37 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244394AbiDYS35 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C893926AE5
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:52 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23PHP4Oa021805
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=84jxjQFHweu2/0BDllf9O1WwUpCMC5n8UnW0XSiwytU=;
 b=k7LzBmcQZbi58eMuc+nYV++gLVFHPrwY3wlo+iMJUIQGworpL57hWaJXeOdMHplJprDY
 akAntc0d8EWYWNA3APWUrlCalyOGeKpEVGmuTGd/jI2fsnRDoN7pV2S3ZkC8RdXnvw+6
 cCwGmVlJlcFhFtflOq8SkpD94RZDTZH6QPw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rmaj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:51 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:26:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A223AE1F2B2D; Mon, 25 Apr 2022 11:26:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 1/6] liburing: Update io_uring.h with large CQE kernel changes
Date:   Mon, 25 Apr 2022 11:26:34 -0700
Message-ID: <20220425182639.2446370-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182639.2446370-1-shr@fb.com>
References: <20220425182639.2446370-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: K0hUnpQHkEOk2IYeB9OcaPOaTY8wouYv
X-Proofpoint-GUID: K0hUnpQHkEOk2IYeB9OcaPOaTY8wouYv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 src/include/liburing/io_uring.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index a38a45b..95e6a43 100644
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
@@ -205,6 +206,12 @@ struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
+
+	/*
+	 * If the ring is initialized wit IORING_SETUP_CQE32, then this field
+	 * contains 16-bytes of padding, doubling the size fo the CQE.
+	 */
+	__u64 big_cqe[];
 };
=20
 /*
--=20
2.30.2

