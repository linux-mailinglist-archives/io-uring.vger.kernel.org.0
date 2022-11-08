Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E86208BF
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiKHFFe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKHFFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:33 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106E11A0B
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:32 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7LKsiR007050
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:31 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnnvd7sh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:31 -0800
Received: from twshared15216.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:30 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 2A3CC23B2601D; Mon,  7 Nov 2022 21:05:22 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 11/15] io_uring: Define the zctap iov[] returned to the user.
Date:   Mon, 7 Nov 2022 21:05:17 -0800
Message-ID: <20221108050521.3198458-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wV4jZWWTSTxpsbFxuUy0QmgpJZebFhmO
X-Proofpoint-GUID: wV4jZWWTSTxpsbFxuUy0QmgpJZebFhmO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When performing a ZC receive, instead of returning data directly
to the user, an iov[] structure is returned referencing the data
in user space.

The application locates the base address of the data by performing
address computations on bgid:bid.  The off/len applies to the base
address, resulting in the data segment.

The bgid:bid identifying the buffer should later be placed in the
ifq's fill ring, which returns the buffer back to the kernel.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f65543595d71..88f01bda12be 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -681,6 +681,14 @@ struct io_uring_ifq_req {
 	__u16	resv[2];
 };
 
+struct io_uring_zctap_iov {
+	__u32	off;
+	__u32	len;
+	__u16	bgid;
+	__u16	bid;
+	__u16	resv[2];
+};
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.30.2

