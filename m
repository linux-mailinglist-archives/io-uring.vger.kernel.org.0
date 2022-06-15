Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B2C54C2BF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 09:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242430AbiFOHkh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 03:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241752AbiFOHkf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 03:40:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E383F301
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:33 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25EMd2ST030873
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=te+lnOFgmJ4BxB+gi4p/hpPyHW7pyIcntp5tb4M1n50=;
 b=LaEJ7mHx+HTJGsLy11yySxvXRU8ukr8fEKxWVSRN5YJ9eD01LT8vN2bdWiqbi7j399Jp
 GwKtSsr9GpTOiy59gs2CWzSj9fxJGsGGR1GutemrrEo65aZK2HlbmSr/DQ2a2aP67Ftb
 pycCEWdMnqhkLc3pf7V0uUx/2ajRzSz1x54= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gpr0dxqs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:40:32 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 15 Jun 2022 00:40:31 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 3FED41AEE441; Wed, 15 Jun 2022 00:40:28 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/2] Revert "test/buf-ring: ensure cqe isn't used uninitialized"
Date:   Wed, 15 Jun 2022 00:40:24 -0700
Message-ID: <20220615074025.124322-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220615074025.124322-1-dylany@fb.com>
References: <20220615074025.124322-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0XYDtZe6ybEMzz77d8E11ROtJsEBXUWo
X-Proofpoint-GUID: 0XYDtZe6ybEMzz77d8E11ROtJsEBXUWo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit d6f9e02f9c6a777010824341f14c994b11dfc8b1.

"io_uring: add buffer selection support to IORING_OP_NOP" has been
reverted from 5.19, which this relies on

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/buf-ring.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/test/buf-ring.c b/test/buf-ring.c
index af1cac8..2fcc360 100644
--- a/test/buf-ring.c
+++ b/test/buf-ring.c
@@ -234,19 +234,22 @@ static int test_one_nop(int bgid, struct io_uring *=
ring)
 		ret =3D -1;
 		goto out;
 	}
-	ret =3D cqe->res;
-	io_uring_cqe_seen(ring, cqe);
=20
-	if (ret =3D=3D -ENOBUFS)
-		return ret;
+	if (cqe->res =3D=3D -ENOBUFS) {
+		ret =3D cqe->res;
+		goto out;
+	}
=20
-	if (ret !=3D 0) {
+	if (cqe->res !=3D 0) {
 		fprintf(stderr, "nop result %d\n", ret);
-		return -1;
+		ret =3D -1;
+		goto out;
 	}
=20
 	ret =3D cqe->flags >> 16;
+
 out:
+	io_uring_cqe_seen(ring, cqe);
 	return ret;
 }
=20
--=20
2.30.2

