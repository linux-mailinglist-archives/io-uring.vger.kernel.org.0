Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3298E56160B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiF3JSo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbiF3JSG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404652E093
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:02 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LffP010125
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=SdW4wVZNo3Qp5TN8YXy0QPxjj9g/Gcv3VdgPGQjq61c=;
 b=Qgfmn4ov32UcWuHtbt5Y83qjLJmhz1nd/HsUtH/IqPOU/nAL0e+NSlO6qJF9il7d4B6L
 7Peaffv7E+iYhQ4xR/nAi7WZjK4CGxdzW1ShuP0OoNb4NFxKet1ymIdJmI6zCPoO+cT1
 O/cS9lIl/aqE88IwHLmvZwP45yR3XL8yNas= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0tdsd0yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:01 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:00 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 935A62599FD0; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 02/12] io_uring: restore bgid in io_put_kbuf
Date:   Thu, 30 Jun 2022 02:12:21 -0700
Message-ID: <20220630091231.1456789-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: CIj6MNZ_OQOGb38cAN15a_yJ_7pF6NfE
X-Proofpoint-GUID: CIj6MNZ_OQOGb38cAN15a_yJ_7pF6NfE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Attempt to restore bgid. This is needed when recycling unused buffers as
the next time around it will want the correct bgid.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/kbuf.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 3d48f1ab5439..d9adedac5e9d 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -96,16 +96,21 @@ static inline void io_kbuf_recycle(struct io_kiocb *r=
eq, unsigned issue_flags)
 static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
 					      struct list_head *list)
 {
+	unsigned int ret =3D IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQ=
E_BUFFER_SHIFT);
+
 	if (req->flags & REQ_F_BUFFER_RING) {
-		if (req->buf_list)
+		if (req->buf_list) {
+			req->buf_index =3D req->buf_list->bgid;
 			req->buf_list->head++;
+		}
 		req->flags &=3D ~REQ_F_BUFFER_RING;
 	} else {
+		req->buf_index =3D req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
 		req->flags &=3D ~REQ_F_BUFFER_SELECTED;
 	}
=20
-	return IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT=
);
+	return ret;
 }
=20
 static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
--=20
2.30.2

