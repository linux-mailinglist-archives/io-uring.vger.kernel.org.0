Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF99F5812F0
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbiGZMP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiGZMP2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:15:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86D2AC53
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:27 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0osRx003807
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IvHtzsYmeoD7dYs/XROGai/v/J8+kLFHqiY2yDVoe6A=;
 b=knpD8wyBBrS6ISboCRbQ33seCSxkQj+HsTyFISSD6HkAQLX2i8YziKa3ilAmvAZq4e0s
 mGgzmTYPA1d5HhJOIdllkXh8yUy+1bohE2HSXg3RCUYVwoO3rJTx5KJi30Q4jS9ayq40
 Nrb+lj12vdLsceipF2P8IDiC/d5ZDC1dC4U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hj1usm8y9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:26 -0700
Received: from twshared33626.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 05:15:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 175F1397A790; Tue, 26 Jul 2022 05:15:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/5] change io_uring_recvmsg_payload_length return type
Date:   Tue, 26 Jul 2022 05:15:00 -0700
Message-ID: <20220726121502.1958288-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726121502.1958288-1-dylany@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fAhIhW7pVBFrpz4txVGupiTj5RbvK6ul
X-Proofpoint-ORIG-GUID: fAhIhW7pVBFrpz4txVGupiTj5RbvK6ul
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Payloads can not be bigger than UINT_MAX, so no need to force a bigger
type on the caller.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 9e7f06f390be..06f4a50bacb1 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -788,7 +788,7 @@ static inline void *io_uring_recvmsg_payload(struct i=
o_uring_recvmsg_out *o,
 			msgh->msg_namelen + msgh->msg_controllen);
 }
=20
-static inline size_t
+static inline unsigned int
 io_uring_recvmsg_payload_length(struct io_uring_recvmsg_out *o,
 				int buf_len, struct msghdr *msgh)
 {
@@ -796,7 +796,7 @@ io_uring_recvmsg_payload_length(struct io_uring_recvm=
sg_out *o,
=20
 	payload_start =3D (unsigned long) io_uring_recvmsg_payload(o, msgh);
 	payload_end =3D (unsigned long) o + buf_len;
-	return payload_end - payload_start;
+	return (unsigned int) (payload_end - payload_start);
 }
=20
 static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int d=
fd,
--=20
2.30.2

