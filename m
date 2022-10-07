Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD1C5F7F96
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJGVR2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJGVR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223312A40E
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:16 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297KDnos003038
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k2ty5gd3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:15 -0700
Received: from twshared0933.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:14 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 4B98F21DAFD98; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 1/9] io_uring: add zctap ifq definition
Date:   Fri, 7 Oct 2022 14:17:05 -0700
Message-ID: <20221007211713.170714-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jMoJY2rUacZYXCLue-3KK5xMkTxvbJkG
X-Proofpoint-GUID: jMoJY2rUacZYXCLue-3KK5xMkTxvbJkG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
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

Add structure definition for io_zctap_ifq for use by lower level
networking hooks.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring_types.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..680fbf1f34e7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -323,6 +323,7 @@ struct io_ring_ctx {
 	struct io_mapped_ubuf		*dummy_ubuf;
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
+	struct xarray			zctap_ifq_xa;
 
 	struct delayed_work		rsrc_put_work;
 	struct llist_head		rsrc_put_llist;
@@ -578,4 +579,12 @@ struct io_overflow_cqe {
 	struct io_uring_cqe cqe;
 };
 
+struct io_zctap_ifq {
+	struct net_device	*dev;
+	struct io_ring_ctx	*ctx;
+	u16			queue_id;
+	u16			id;
+	u16			fill_bgid;
+};
+
 #endif
-- 
2.30.2

