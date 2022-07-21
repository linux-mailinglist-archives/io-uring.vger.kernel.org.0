Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2171557C978
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 13:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiGULBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 07:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiGULBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 07:01:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B902845F74
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 04:01:53 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KNbEdY013264
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 04:01:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=whhVqzSY/LO0DewExHF2H+9BIsdCKVF/W1wqXDtU4vs=;
 b=aOrzG39w4NaSTRfYdS5WVdJ58/ibpbAC10EsBdP7vKiNUo3KZgm4uyqWGDD+YQoXEy6E
 MQLNJ71I8/UUnWl+JNIxr0HGwmqybXX3mg1J2GzdWSd7g9S8gGS9Aazaa07fPG97STSh
 n9untC5VdaxOZ1z4FAKRVi2N4tEwbNaCQ/8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3he8wys17h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 04:01:53 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 04:01:51 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 6E24D3572D41; Thu, 21 Jul 2022 04:01:37 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>,
        Dipanjan Das <mail.dipanjan.das@gmail.com>
Subject: [PATCH] io_uring: fix free of unallocated buffer list
Date:   Thu, 21 Jul 2022 04:01:15 -0700
Message-ID: <20220721110115.3964104-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yrnYIFCtk_60DNjWDsrbhv4KSRNQeTNl
X-Proofpoint-GUID: yrnYIFCtk_60DNjWDsrbhv4KSRNQeTNl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_14,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

in the error path of io_register_pbuf_ring, only free bl if it was
allocated.

Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buff=
ers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..2b7bb62c7805 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -12931,7 +12931,7 @@ static int io_register_pbuf_ring(struct io_ring_c=
tx *ctx, void __user *arg)
 {
 	struct io_uring_buf_ring *br;
 	struct io_uring_buf_reg reg;
-	struct io_buffer_list *bl;
+	struct io_buffer_list *bl, *free_bl =3D NULL;
 	struct page **pages;
 	int nr_pages;
=20
@@ -12963,7 +12963,7 @@ static int io_register_pbuf_ring(struct io_ring_c=
tx *ctx, void __user *arg)
 		if (bl->buf_nr_pages || !list_empty(&bl->buf_list))
 			return -EEXIST;
 	} else {
-		bl =3D kzalloc(sizeof(*bl), GFP_KERNEL);
+		free_bl =3D bl =3D kzalloc(sizeof(*bl), GFP_KERNEL);
 		if (!bl)
 			return -ENOMEM;
 	}
@@ -12972,7 +12972,7 @@ static int io_register_pbuf_ring(struct io_ring_c=
tx *ctx, void __user *arg)
 			     struct_size(br, bufs, reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
-		kfree(bl);
+		kfree(free_bl);
 		return PTR_ERR(pages);
 	}
=20

base-commit: ff6992735ade75aae3e35d16b17da1008d753d28
--=20
2.30.2

