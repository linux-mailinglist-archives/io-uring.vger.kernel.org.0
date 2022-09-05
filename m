Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB795AD3DD
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiIEN11 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiIEN1Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:27:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5A049B61
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:27:24 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 284MVFAl022261
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ac2oEHDxsKQWx0CIIypZ0l2ErwqOmMqV+RiizuiRdmE=;
 b=MDSkCcvSsxMY+pdt8AI2IokOlh/B+WtQIZTETAhHDm+dD9UbBGe+GHqgozJj6dOVgpf4
 6IGLDeTOexO17KV7rNSpQa8fU42Jvb61hdoKDjuW1yIig85+kY0IiiNlrqp9++v56dKU
 8JoNs5eeXrU8cOk+Mlm0wfx78X0a1BESOvk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jcgaeegwy-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:27:24 -0700
Received: from twshared3888.09.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:27:22 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 5E5D85AC517F; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 11/11] file-verify test: log if short read
Date:   Mon, 5 Sep 2022 06:22:58 -0700
Message-ID: <20220905132258.1858915-12-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XlFvKfp6LSywIuJWRirHbYlh7iSzC5DR
X-Proofpoint-GUID: XlFvKfp6LSywIuJWRirHbYlh7iSzC5DR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
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

