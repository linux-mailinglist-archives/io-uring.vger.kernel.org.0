Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB2C558845
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 21:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiFWTCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 15:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiFWTCj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 15:02:39 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF107A1A1
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:08:17 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NHuxk2028971
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:08:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Y55cVOBKiXeRDoBnXl4t1cftHngh7dGKga/NccAHsxM=;
 b=rFK+Q4oEOhnP7rVN1yFE4X7sFKedjbEUzTy7w10spVzTiy1dvL/8F1EF9BSUMMV+CupK
 36UO23QtezPSt57WzyqHfzeUTOBOw86Obgca1i6N2j+QYpA3Gmi5kn0+SVUx9iCueffu
 Ec95wGrKT/HwNCR9+V7LYSOXv5pddSL1wIw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvp68au1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:08:16 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 23 Jun 2022 11:08:14 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7A45910C5DC57; Thu, 23 Jun 2022 10:52:00 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>, <willy@infradead.org>
Subject: [RESEND PATCH v9 06/14] iomap: Return -EAGAIN from iomap_write_iter()
Date:   Thu, 23 Jun 2022 10:51:49 -0700
Message-ID: <20220623175157.1715274-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220623175157.1715274-1-shr@fb.com>
References: <20220623175157.1715274-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: wlJJ6WEbXgTAN-LAJKIC3yjsRNv2jpaU
X-Proofpoint-ORIG-GUID: wlJJ6WEbXgTAN-LAJKIC3yjsRNv2jpaU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_07,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 83cf093fcb92..f2e36240079f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -830,7 +830,13 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		length -=3D status;
 	} while (iov_iter_count(i) && length);
=20
-	return written ? written : status;
+	if (status =3D=3D -EAGAIN) {
+		iov_iter_revert(i, written);
+		return -EAGAIN;
+	}
+	if (written)
+		return written;
+	return status;
 }
=20
 ssize_t
--=20
2.30.2

