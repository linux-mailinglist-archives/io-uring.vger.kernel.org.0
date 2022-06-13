Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31F1548438
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 12:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiFMKMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 06:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiFMKMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 06:12:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E462118
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:13 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25CMw8Pu015303
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FEJ9cV9D2JqkfKjBRINWLlNmpSiGIlxGX0X5mdkJGvM=;
 b=jvtWBzKS4KNB0N/SAAask6NogC3tT09v+bLqmfaz8DhRXDala4mfpK0/x9D73w6AeeeL
 Dyb6itZSpvnX0U6wk29DJByXl6IDLjHFn9hhvZNXjzjjECNcFBZczuL7kLEBnMNl9z1U
 S2zoKNany7kowepq2jJ/TM1p5JJteFAAPFA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmrvuyckb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:12 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 03:12:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1C4D21992ADF; Mon, 13 Jun 2022 03:12:04 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/3] io_uring: fix index calculation
Date:   Mon, 13 Jun 2022 03:11:55 -0700
Message-ID: <20220613101157.3687-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613101157.3687-1-dylany@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oxXYp8-UK769HmjVXmbZ9q0VhWGscUuL
X-Proofpoint-GUID: oxXYp8-UK769HmjVXmbZ9q0VhWGscUuL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When indexing into a provided buffer ring, do not subtract 1 from the
index.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buff=
ers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aab4182fd89..9cf9aff51b70 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3888,7 +3888,7 @@ static void __user *io_ring_buffer_select(struct io=
_kiocb *req, size_t *len,
 		buf =3D &br->bufs[head];
 	} else {
 		int off =3D head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
-		int index =3D head / IO_BUFFER_LIST_BUF_PER_PAGE - 1;
+		int index =3D head / IO_BUFFER_LIST_BUF_PER_PAGE;
 		buf =3D page_address(bl->buf_pages[index]);
 		buf +=3D off;
 	}
--=20
2.30.2

