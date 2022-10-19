Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35F1604BC5
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 17:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJSPjy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 11:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiJSPjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 11:39:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4019E033
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 08:35:40 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29J3pPqT030718
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 08:12:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=KgF9aEzQqyB98FNrrI36bFwoTwssNDTibbiRcHxWjt4=;
 b=lbUGHWjOAIMDHkcJJu3EW192e+XpvdeQRECaSDKWiNXW12t79c6gK+H1mv+XRv4zRT+B
 Ici+HOfhib9qdS8BGD7s6rqryaN4dxSo7pXTgexbN3+oChVhAteBvyEQ9mHoAvCNPWpV
 E7pFtChu/o/2ZV97ZmK0jo8m/pwbyEzYX2Z1a8VAyAxfITMyGu4BzEdNjnXr+3thhnY6
 zc49Di7Im46d+a+8gcVqDbgRqZGr1IPAVMWIKX86cx3dkcVkX18nyoYCJhHIqOL7UeI4
 /LRil9HPkjUvqHENNuIq0CBimYhiIfsRM7Bd0ugMnC4JyKbOjrNISpmeA8SL4gV7ZOjg Rw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ka9pmw7by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 08:12:57 -0700
Received: from twshared9269.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 08:12:55 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 608357E52F5F; Wed, 19 Oct 2022 07:50:49 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 2/2] fix len type of fgettxattr etc
Date:   Wed, 19 Oct 2022 07:50:42 -0700
Message-ID: <20221019145042.446477-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019145042.446477-1-dylany@meta.com>
References: <20221019145042.446477-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: kQ0Pmthl812pwJjwoeOeeaIxYgTBy9wv
X-Proofpoint-ORIG-GUID: kQ0Pmthl812pwJjwoeOeeaIxYgTBy9wv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The size_t len was passed to an unsigned int directly.
Take an unsigned int instead which is what is expected by io_uring_prep_r=
w

Fixes: 73849e908ce0 ("liburing: Add helper functions for fgetxattr and ge=
txattr")
Fixes: 72f55e271377 ("liburing: add helper functions for setxattr and fse=
txattr")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 src/include/liburing.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 118bba9eea15..780a19ccb1d9 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -991,7 +991,7 @@ static inline void io_uring_prep_getxattr(struct io_u=
ring_sqe *sqe,
 					  const char *name,
 					  char *value,
 					  const char *path,
-					  size_t len)
+					  unsigned int len)
 {
 	io_uring_prep_rw(IORING_OP_GETXATTR, sqe, 0, name, len,
 				(__u64) (uintptr_t) value);
@@ -1004,7 +1004,7 @@ static inline void io_uring_prep_setxattr(struct io=
_uring_sqe *sqe,
 					  const char *value,
 					  const char *path,
 					  int flags,
-					  size_t len)
+					  unsigned int len)
 {
 	io_uring_prep_rw(IORING_OP_SETXATTR, sqe, 0, name, len,
 				(__u64) (uintptr_t) value);
@@ -1013,10 +1013,10 @@ static inline void io_uring_prep_setxattr(struct =
io_uring_sqe *sqe,
 }
=20
 static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
-		                           int         fd,
+					   int fd,
 					   const char *name,
 					   char *value,
-					   size_t      len)
+					   unsigned int len)
 {
 	io_uring_prep_rw(IORING_OP_FGETXATTR, sqe, fd, name, len,
 				(__u64) (uintptr_t) value);
@@ -1024,11 +1024,11 @@ static inline void io_uring_prep_fgetxattr(struct=
 io_uring_sqe *sqe,
 }
=20
 static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
-					   int         fd,
-					   const char *name,
-					   const char *value,
-					   int         flags,
-					   size_t      len)
+					   int		fd,
+					   const char	*name,
+					   const char	*value,
+					   int		flags,
+					   unsigned int len)
 {
 	io_uring_prep_rw(IORING_OP_FSETXATTR, sqe, fd, name, len,
 				(__u64) (uintptr_t) value);
--=20
2.30.2

