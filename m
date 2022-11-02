Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5BB6172D1
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiKBXkL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiKBXjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6CBC747
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:32:51 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVqY8008249
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:32:51 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkrv4wykq-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:32:51 -0700
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:32:50 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 6A7E6235B6171; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 01/15] io_uring: add zctap ifq definition
Date:   Wed, 2 Nov 2022 16:32:30 -0700
Message-ID: <20221102233244.4022405-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oe18uMuBZ4n1z4V8zr1LO9H5yqxKMSyj
X-Proofpoint-GUID: oe18uMuBZ4n1z4V8zr1LO9H5yqxKMSyj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
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

