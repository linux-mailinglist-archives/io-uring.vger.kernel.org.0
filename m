Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7510B603331
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJRTQW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJRTQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3A65FF7A
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:17 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IHUTU2005878
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:16 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k9tpedhhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:16 -0700
Received: from twshared9269.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:14 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 753A0227F052F; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 11/13] io_uring: Define the zctap iov[] returned to the user.
Date:   Tue, 18 Oct 2022 12:16:00 -0700
Message-ID: <20221018191602.2112515-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zpyF1UvBcmju2_llljHGXuyVOwximc3Y
X-Proofpoint-GUID: zpyF1UvBcmju2_llljHGXuyVOwximc3Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
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
index d406d21e8c38..c50c63053f13 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -681,6 +681,14 @@ struct io_uring_ifq_req {
 	__u16	__pad[2];
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

