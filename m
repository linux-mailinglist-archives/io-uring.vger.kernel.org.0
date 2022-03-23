Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECAF4E5597
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243720AbiCWPqg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiCWPqf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F383349F14
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NBci81002255
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5OxMbtjoMFz+sJsY5IU0t9bx8+m33hP5mPOOVF9w3kg=;
 b=ZK7ob2xr9Jwkg7RHs1wAeEI0k2XpIX9ns5UV6UPNeRIXjegAxWlzvZBqgDcWMnrABxFs
 ozFb40eJCtBPWj+W14N4VrIPkBhdX3ZihN/SxiMQbEyXc4BiODMWHfNXUB/64DkZGBLb
 kVyOJLiN6VYONt3VG5+jliZDvnblVF5XuhE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f02uvsr5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:05 -0700
Received: from twshared10432.40.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:45:04 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D752ACA02523; Wed, 23 Mar 2022 08:44:59 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 2/4] liburing: add helper functions for setxattr and fsetxattr
Date:   Wed, 23 Mar 2022 08:44:55 -0700
Message-ID: <20220323154457.3303391-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
References: <20220323154457.3303391-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: a2z2Ajq05N-6CQrr0l2tu9FZXgeJzEoE
X-Proofpoint-GUID: a2z2Ajq05N-6CQrr0l2tu9FZXgeJzEoE
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
- fsetxattr
- setxattr

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 949a351..0b5dfab 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -729,6 +729,29 @@ static inline void io_uring_prep_msg_ring(struct io_=
uring_sqe *sqe, int fd,
 	sqe->rw_flags =3D flags;
 }
=20
+static inline void io_uring_prep_setxattr(struct io_uring_sqe *sqe,
+					  const char *name,
+					  const char *value,
+					  const char *path,
+					  int flags,
+					  size_t len)
+{
+	io_uring_prep_rw(IORING_OP_SETXATTR, sqe, 0, name, len, (__u64) value);
+	sqe->addr3 =3D (__u64) path;
+	sqe->xattr_flags =3D flags;
+}
+
+static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
+					   int         fd,
+					   const char *name,
+					   const char *value,
+					   int         flags,
+					   size_t      len)
+{
+	io_uring_prep_rw(IORING_OP_FSETXATTR, sqe, fd, name, len, (__u64) value=
);
+	sqe->xattr_flags =3D flags;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist=
 in
  * the SQ ring
--=20
2.30.2

