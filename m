Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD15256160A
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiF3JSo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiF3JSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59292CC8E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:00 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U7So2Q021253
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/R5f40SX0myY+sLsV9T01ncFIwUnVx4ToYywqLxN6Ws=;
 b=lz8+hDIG3yKxbRHH9JBl9qFVUE5ascuStcGl2cMgjKelTrX/1gPBYox5uPiIJR0BprxB
 fYcJybcuTHTL9v3tYT7tVOvKbfax6JYv2QbSUUToWZyBMTBUxo1C5m24ZSHENh/zy9FS
 yM7boLr6Is+vyEPIHUpj6LZlFiN8BNdKEKo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h17fmgg21-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:00 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:16:59 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8B30D2599FCE; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 01/12] io_uring: allow 0 length for buffer select
Date:   Thu, 30 Jun 2022 02:12:20 -0700
Message-ID: <20220630091231.1456789-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: t-HJFQL39WIjDHYTUmUry38Bcw4D3Z34
X-Proofpoint-ORIG-GUID: t-HJFQL39WIjDHYTUmUry38Bcw4D3Z34
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If user gives 0 for length, we can set it from the available buffer size.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8e4f1e8aaf4a..4ed5102461bf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -115,7 +115,7 @@ static void __user *io_provided_buffer_select(struct =
io_kiocb *req, size_t *len,
=20
 		kbuf =3D list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&kbuf->list);
-		if (*len > kbuf->len)
+		if (*len =3D=3D 0 || *len > kbuf->len)
 			*len =3D kbuf->len;
 		req->flags |=3D REQ_F_BUFFER_SELECTED;
 		req->kbuf =3D kbuf;
@@ -145,7 +145,7 @@ static void __user *io_ring_buffer_select(struct io_k=
iocb *req, size_t *len,
 		buf =3D page_address(bl->buf_pages[index]);
 		buf +=3D off;
 	}
-	if (*len > buf->len)
+	if (*len =3D=3D 0 || *len > buf->len)
 		*len =3D buf->len;
 	req->flags |=3D REQ_F_BUFFER_RING;
 	req->buf_list =3D bl;
--=20
2.30.2

