Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD0E6208BD
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKHFFe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiKHFFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:32 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FB5A46D
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:31 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7LKuTM007143
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:31 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnnvd7sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:31 -0800
Received: from twshared15216.17.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:29 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D7EA823B26007; Mon,  7 Nov 2022 21:05:21 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 01/15] io_uring: add zctap ifq definition
Date:   Mon, 7 Nov 2022 21:05:07 -0800
Message-ID: <20221108050521.3198458-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LKbGQUHGlTmEspEhgr2x2_80HYuwLtXZ
X-Proofpoint-GUID: LKbGQUHGlTmEspEhgr2x2_80HYuwLtXZ
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

Add structure definition for io_zctap_ifq for use by lower level
networking hooks.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring_types.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f5b687a787a3..39f20344d578 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -322,6 +322,7 @@ struct io_ring_ctx {
 	struct io_mapped_ubuf		*dummy_ubuf;
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
+	struct io_zctap_ifq		*zctap_ifq;
 
 	struct delayed_work		rsrc_put_work;
 	struct llist_head		rsrc_put_llist;
@@ -577,4 +578,14 @@ struct io_overflow_cqe {
 	struct io_uring_cqe cqe;
 };
 
+struct io_zctap_ifq {
+	struct net_device	*dev;
+	struct io_ring_ctx	*ctx;
+	void			*region;
+	struct ubuf_info	*uarg;
+	u16			queue_id;
+	u16			id;
+	u16			fill_bgid;
+};
+
 #endif
-- 
2.30.2

