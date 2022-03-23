Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193274E5596
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245194AbiCWPqg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243720AbiCWPqf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA649F05
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N5htxH017155
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZJBE8u0mSLycVG+t9V6mCKQWQK21q2GehFRNZ+5RlTc=;
 b=A+SjcR/G/JgWZR6XX1fZS0+RL4cuVEdEtEqIpRV0C3kfmdVc7mRKnphtx/hrej+tRfjT
 9ZogaOth599J2VYxmZzH0xYxUq774dCN/ERenEP+/PMGh2mOfr8f28fyPy/ih44fhJn1
 qsA5iU0ym1MKHhwcvwUXwCgTLd8JeNF1ntU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyc9wu3mv-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:45:03 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id DDA09CA02525; Wed, 23 Mar 2022 08:44:59 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 3/4] liburing: Add helper functions for fgetxattr and getxattr
Date:   Wed, 23 Mar 2022 08:44:56 -0700
Message-ID: <20220323154457.3303391-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
References: <20220323154457.3303391-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nU-jS2w1qMs24OgBMS8JQBpfHA1VIpPX
X-Proofpoint-ORIG-GUID: nU-jS2w1qMs24OgBMS8JQBpfHA1VIpPX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This adds the helper functions for:
- fgetxattr
- getxattr

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0b5dfab..105f5dc 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -729,6 +729,17 @@ static inline void io_uring_prep_msg_ring(struct io_=
uring_sqe *sqe, int fd,
 	sqe->rw_flags =3D flags;
 }
=20
+static inline void io_uring_prep_getxattr(struct io_uring_sqe *sqe,
+					  const char *name,
+					  const char *value,
+					  const char *path,
+					  size_t len)
+{
+	io_uring_prep_rw(IORING_OP_GETXATTR, sqe, 0, name, len, (__u64) value);
+	sqe->addr3 =3D (__u64) path;
+	sqe->xattr_flags =3D 0;
+}
+
 static inline void io_uring_prep_setxattr(struct io_uring_sqe *sqe,
 					  const char *name,
 					  const char *value,
@@ -741,6 +752,16 @@ static inline void io_uring_prep_setxattr(struct io_=
uring_sqe *sqe,
 	sqe->xattr_flags =3D flags;
 }
=20
+static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
+		                           int         fd,
+					   const char *name,
+					   const char *value,
+					   size_t      len)
+{
+	io_uring_prep_rw(IORING_OP_FGETXATTR, sqe, fd, name, len, (__u64) value=
);
+	sqe->xattr_flags =3D 0;
+}
+
 static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
 					   int         fd,
 					   const char *name,
--=20
2.30.2

