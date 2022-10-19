Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1586604A12
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiJSO5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 10:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiJSO5c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 10:57:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B487E01D
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:55 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JB1NkT030117
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=RSktfQn2G5dATGu5m9h/eD7c/X+AgN2rZL0KAkf+y8M=;
 b=eoPMdqaSOpz1fxNLWAjJ1oJK+3txInkNtpEBAKz93xfOj1ociCO2Ee0nvDFOIAuvokq9
 VJxAiW03bbVymn9CLPalWFMIXNE0VHhNN0vDDlh4CnflnI5bvgoBTi4g4cM6OAb4Cmih
 GN3v5M6v2Uoo7YL1PXbndzaFs9LGxEiNcIfbRbma3ZIRl7vCmFB4vVjeiEYyTZ8RRnIo
 e87ll/zvuTpHpf3w9KTMNtnxsySlUzIPaVAxFxet+BVlUfVRz88opXl8hs3zrXcqRw7W
 f73hnOvrMOegjz0C6hvMIy0buhFNfOD0LMzkXZGn4zs/LWIVcxJKImJT4pfYPx6U2n0V ww== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kag05t174-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:55 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 07:50:51 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 785667E52F5B; Wed, 19 Oct 2022 07:50:48 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 1/2] fix int shortening bug in io_uring_recvmsg_validate
Date:   Wed, 19 Oct 2022 07:50:41 -0700
Message-ID: <20221019145042.446477-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019145042.446477-1-dylany@meta.com>
References: <20221019145042.446477-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jEnDwoSbgb_kt346Jjapq6STZpny7jx-
X-Proofpoint-GUID: jEnDwoSbgb_kt346Jjapq6STZpny7jx-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix for compilers running with -Wshorten-64-to-32

Fixes: 874406f7fb09 ("add multishot recvmsg API")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 src/include/liburing.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1d049230ddfb..118bba9eea15 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -791,10 +791,9 @@ static inline void io_uring_prep_recv_multishot(stru=
ct io_uring_sqe *sqe,
 static inline struct io_uring_recvmsg_out *
 io_uring_recvmsg_validate(void *buf, int buf_len, struct msghdr *msgh)
 {
-	int header =3D msgh->msg_controllen + msgh->msg_namelen +
+	unsigned long header =3D msgh->msg_controllen + msgh->msg_namelen +
 				sizeof(struct io_uring_recvmsg_out);
-
-	if (buf_len < header)
+	if (buf_len < 0 || (unsigned long)buf_len < header)
 		return NULL;
 	return (struct io_uring_recvmsg_out *)buf;
 }
--=20
2.30.2

