Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6801856C017
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiGHSSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiGHSSu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:18:50 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF7823B8
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:18:48 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HAbBV027511
        for <io-uring@vger.kernel.org>; Fri, 8 Jul 2022 11:18:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BEbVfYQJEMiim0GXf7aBYrR5C7mCIEETD+2C6oxId7g=;
 b=bUPWD2miMXG2Ym9JflugIDh6CwZypaDzxYUxMjP3yOCNzCgfZpLW9+38SdFsRi9CNu6C
 C6lbX9nF3LQvy8PBg2HOvsiqVATiFLT97izcZqSzEFTfgCD1N3/bJQuS/9o87fYm0crT
 6GEIdiiueVxr0PyfnIgecjir2hF6IU66jYs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h6eg1ky56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:18:47 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:18:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 209F22B9EC1E; Fri,  8 Jul 2022 11:18:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 1/4] io_uring: fix multishot ending when not polled
Date:   Fri, 8 Jul 2022 11:18:35 -0700
Message-ID: <20220708181838.1495428-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708181838.1495428-1-dylany@fb.com>
References: <20220708181838.1495428-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: t7ZSTwRN_iTuP_dpz7fhUV1Ej-Vq1y_7
X-Proofpoint-GUID: t7ZSTwRN_iTuP_dpz7fhUV1Ej-Vq1y_7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_14,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If multishot is not actually polling then return IOU_OK rather than the
result.
If the result was > 0 this will confuse things further up the callstack
which expect a return <=3D 0.

Fixes: 1300ebb20286 ("io_uring: multishot recv")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index ba7e94ff287c..188edbed1eb7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -508,6 +508,8 @@ static inline bool io_recv_finish(struct io_kiocb *re=
q, int *ret, unsigned int c
=20
 	if (req->flags & REQ_F_POLLED)
 		*ret =3D IOU_STOP_MULTISHOT;
+	else
+		*ret =3D IOU_OK;
 	return true;
 }
=20
--=20
2.30.2

