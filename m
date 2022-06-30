Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA61561B2B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiF3NUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 09:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbiF3NUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 09:20:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE312D1D0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:20:48 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25U0LY6D009535
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:20:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ZfX4dx+zHt+aWKlD2KZYhsibCaLAXeLuK8UfcMVi5VA=;
 b=UrR0gtorEBKBaIo/GYkV5z1yCKX9H9KizbmtWxktyKsnl4TurcOdUdThksAtnKWoK4M5
 AdOJVTHkjyunQ7FgdkaUjn4isFURSXr5pRTuieHdVN/0GD5Qflv31wqQWl9Wsf5MadaK
 L5vnl90yussuvU7GojV6N+yWcIXiUY7LYrg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3h10tfknbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:20:48 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 06:20:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A33BE25B9454; Thu, 30 Jun 2022 06:20:16 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 5.19] io_uring: fix provided buffer import
Date:   Thu, 30 Jun 2022 06:20:06 -0700
Message-ID: <20220630132006.2825668-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: CZsFFWgg_0yqUtc9GlDHnS_sm8C4brgx
X-Proofpoint-ORIG-GUID: CZsFFWgg_0yqUtc9GlDHnS_sm8C4brgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_09,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_import_iovec uses the s pointer, but this was changed immediately
after the iovec was re-imported and so it was imported into the wrong
place.

Change the ordering.

Fixes: 2be2eb02e2f5 ("io_uring: ensure reads re-import for selected buffe=
rs")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ff2cdb425bc..73ae92a62c2c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4314,6 +4314,9 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
+		rw =3D req->async_data;
+		s =3D &rw->s;
+
 		/*
 		 * Safe and required to re-import if we're using provided
 		 * buffers, as we dropped the selected one before retry.
@@ -4324,8 +4327,6 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 				return ret;
 		}
=20
-		rw =3D req->async_data;
-		s =3D &rw->s;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't
--=20
2.30.2

