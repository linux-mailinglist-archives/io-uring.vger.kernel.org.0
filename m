Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53895106C0
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243211AbiDZSZx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347111AbiDZSZw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:25:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF92B4617A
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:44 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23QGQWd1018967
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jmkHh/i4uZeHbZmpAKg64jisvPxACaXJJmozZ8mdyuU=;
 b=HyLcUEoknysznSJYVW4tmcFThBza1UpOfPszofPMrZYv/qwkLN7GGRYAvD5zVf4ZvMAR
 2VGXeNEGPB8tMp76dBnS4tN9EluFGTN+VQ/el9ODikUS5amlClzruIDWQLrhLYKv2iv4
 7dHpv/ggVUfOsqikYqsS8AbTWc/oCetMEsc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fmd4rv7pk-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:22:44 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:44 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 45941E2E568E; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 01/12] io_uring: support CQE32 in io_uring_cqe
Date:   Tue, 26 Apr 2022 11:21:23 -0700
Message-ID: <20220426182134.136504-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bq-kw7DvDR0ISYEibA0HXE6SJCv8hDdm
X-Proofpoint-GUID: bq-kw7DvDR0ISYEibA0HXE6SJCv8hDdm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the big_cqe array to the struct io_uring_cqe to support large
CQE's.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index ee677dbd6a6d..7020a434e3b1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -111,6 +111,7 @@ enum {
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
 #define IORING_SETUP_SQE128	(1U << 8)	/* SQEs are 128b */
+#define IORING_SETUP_CQE32	(1U << 9)	/* CQEs are 32b */
=20
 enum {
 	IORING_OP_NOP,
@@ -208,6 +209,12 @@ struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
+
+	/*
+	 * If the ring is initialized with IORING_SETUP_CQE32, then this field
+	 * contains 16-bytes of padding, doubling the size of the CQE.
+	 */
+	__u64 big_cqe[];
 };
=20
 /*
--=20
2.30.2

