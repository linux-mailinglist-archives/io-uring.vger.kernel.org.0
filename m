Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3F4BC0CA
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiBRT6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiBRT6V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:21 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BBF15A3A
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:03 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IGbsWL004398
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=XFSnjQc0lxUFxFW6WH9BEHHNV+K91S6aCM8WNgx+bZM=;
 b=QFmzyw1WGU1KRMyZQIdpVkgMVfC/1sfITRThCI/I7Li261IumteN1aIgEjGpayoPjl0s
 Sl0jh4Lw7inEF4U9Vs94LCvhW2RAZJwUd0Xt3uAsYHIlt3pU2arTtSpzTMkBStFD4cYq
 GpnCLjzPDrTJAnX/FYFAcPGzqOnMVBJZR94= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea2j0nb8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:03 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:01 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id AFE5FAEB660B; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 07/13] fs: add support for async buffered writes
Date:   Fri, 18 Feb 2022 11:57:33 -0800
Message-ID: <20220218195739.585044-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SGgrS_azOfuG73Vy-4Ue29fA4bSgOthd
X-Proofpoint-GUID: SGgrS_azOfuG73Vy-4Ue29fA4bSgOthd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=781 suspectscore=0
 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180122
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for the AOP_FLAGS_BUF_WASYNC flag to the fs layer. If
a page that is required for writing is not in the page cache, it returns
EAGAIN instead of ENOMEM.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ae588ae4b1c1..58331ef214b9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2062,6 +2062,7 @@ int __block_write_begin_int(struct folio *folio, lo=
ff_t pos, unsigned len,
 			*wait_bh++=3Dbh;
 		}
 	}
+
 	/*
 	 * If we issued read requests - let them complete.
 	 */
@@ -2141,8 +2142,11 @@ int block_write_begin(struct address_space *mappin=
g, loff_t pos, unsigned len,
 		gfp =3D GFP_ATOMIC | __GFP_NOWARN;
=20
 	page =3D grab_cache_page_write_begin(mapping, index, flags);
-	if (!page)
+	if (!page) {
+		if (no_wait)
+			return -EAGAIN;
 		return -ENOMEM;
+	}
=20
 	status =3D __block_write_begin_int(page_folio(page), pos, len, get_bloc=
k, NULL, gfp);
 	if (unlikely(status)) {
--=20
2.30.2

