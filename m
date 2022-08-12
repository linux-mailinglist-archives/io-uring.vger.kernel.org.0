Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99AB591777
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiHLW47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLW46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:56:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E28195AFF
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:56:58 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27CF7ScT031520
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:56:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=lNezAUv7WCHsX1C/AGGoqibiE8HHJGLoSMIFGTx7aGk=;
 b=CXQb3/aP973fFN1kHM65LugRSp+dm7ejoNFH76Tdxk4xrEmb8FSZWBJrAVzDi5r7y4AT
 LzEyNhdnrV0KxBGVGDhnNIHsDZxCbC60YlNPFhMnyGBh3axHGn3T71Tl3D8JEg7E5XLg
 jWvUE1p6OV/uikcj/5pZU0DD1wYtRRILI3o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hw9geqtkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:56:58 -0700
Received: from twshared20276.35.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 12 Aug 2022 15:56:53 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 6138074B6525; Fri, 12 Aug 2022 15:56:41 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC:     <linux-fsdevel@vger.kernel.org>, Keith Busch <kbusch@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fs: don't randomized kiocb fields
Date:   Fri, 12 Aug 2022 15:56:33 -0700
Message-ID: <20220812225633.3287847-1-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KweBFYznz-35LJy8C0u1Sty2xvq07_hx
X-Proofpoint-GUID: KweBFYznz-35LJy8C0u1Sty2xvq07_hx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_10,2022-08-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

This is a size sensitive structure and randomizing can introduce extra
padding that breaks io_uring's fixed size expectations. There are few
fields here as it is, half of which need a fixed order to optimally
pack, so the randomization isn't providing much.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/fs.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5113f65c786f..9eced4cc286e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -340,17 +340,12 @@ enum rw_hint {
=20
 struct kiocb {
 	struct file		*ki_filp;
-
-	/* The 'ki_filp' pointer is shared in a union for aio */
-	randomized_struct_fields_start
-
 	loff_t			ki_pos;
 	void (*ki_complete)(struct kiocb *iocb, long ret);
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
-	randomized_struct_fields_end
 };
=20
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
--=20
2.30.2

