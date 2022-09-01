Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CC5A9334
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiIAJd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiIAJd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEEF133F1B
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:26 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2811Hd9I000343
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ac2oEHDxsKQWx0CIIypZ0l2ErwqOmMqV+RiizuiRdmE=;
 b=pXahSUJKDhQB3dfR5pQHfIbAwcrwQqV2sUxB0CjYBhcOT8I0lJUbKnmQd29O3gfIZiks
 a5jBf4tuoobo6q3U6oYc3Zwghnk4bbIFkpcanMOrKRVnZdLqMkvddnDMQKyLhXIGEj+U
 iyzBy3o/YxXtCNhaXA5OPJNXOgTTTCuRu3A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j9nks4yt0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:26 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DDF425769407; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 11/12] file-verify test: log if short read
Date:   Thu, 1 Sep 2022 02:33:02 -0700
Message-ID: <20220901093303.1974274-12-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 10BVEPtQEZO_szT1VxdQq15xowscvMXs
X-Proofpoint-ORIG-GUID: 10BVEPtQEZO_szT1VxdQq15xowscvMXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test assumes any success is a full read. If it was a short read the
test would still fail (as verification would fail) but tracking down the
reason can be annoying.
For now we can just log if it's short and fail at that point.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/file-verify.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/test/file-verify.c b/test/file-verify.c
index 595dafd4bd8d..3a395f9dccda 100644
--- a/test/file-verify.c
+++ b/test/file-verify.c
@@ -430,6 +430,10 @@ static int test(struct io_uring *ring, const char *f=
name, int buffered,
 				fprintf(stderr, "bad read %d, read %d\n", cqe->res, i);
 				goto err;
 			}
+			if (cqe->res < CHUNK_SIZE) {
+				fprintf(stderr, "short read %d, read %d\n", cqe->res, i);
+				goto err;
+			}
 			if (cqe->flags & IORING_CQE_F_BUFFER)
 				index =3D cqe->flags >> 16;
 			else
--=20
2.30.2

