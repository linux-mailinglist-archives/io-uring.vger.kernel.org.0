Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5C9613841
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiJaNmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiJaNmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:42:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39EB101F7
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:05 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFZUA018830
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=rVpqmimRUfCaYzvg/AuDtgITqsk42kV7nBaekHqu8To=;
 b=lnDB3t1CXWY91XgaTRqnogzl3cYX1I2UTI+0g84PaDeERhlkndKY1bzBml6rZnc5U35s
 ua2VAVaWEvZarMXh/XLuzTMwakr7veHyy6oScxjjYR4+ZqXt4JVtOq+ZaBu2A1QsuVsQ
 5+dhhf82YaK8oDCDl8VGNi2l9SbW9xEvvPHPcFOl2usiMr7dMvJw+9bsBzfosO6AiRzV
 G62y4GSMHMp6dmtuGtC3+4tmlXs/e17g1aKy0oxbS2tA+FD2sfCydbpW3VmvxjFjevMZ
 2Aovfa3+RrfE+is7Yf7O2/Nq/y2mmtGYl3KM1IGrahgzjcX8fIIc6OtFNDvBSz80Rumr fA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vpwwqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:05 -0700
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:42:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id F08F08A19662; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 11/12] io_uring: read_fixed retarget_rsrc support
Date:   Mon, 31 Oct 2022 06:41:25 -0700
Message-ID: <20221031134126.82928-12-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: pggfCkxQb9r4L-ANEnPAs8tMpj-elT3h
X-Proofpoint-ORIG-GUID: pggfCkxQb9r4L-ANEnPAs8tMpj-elT3h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add can_retarget_rsrc handler for read_fixed

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/opdef.c |  1 +
 io_uring/rw.c    | 15 +++++++++++++++
 io_uring/rw.h    |  1 +
 3 files changed, 17 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 0018fe39cbb5..5159b3abc2b2 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -109,6 +109,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.prep			=3D io_prep_rw,
 		.issue			=3D io_read,
 		.fail			=3D io_rw_fail,
+		.can_retarget_rsrc	=3D io_read_fixed_can_retarget_rsrc,
 	},
 	[IORING_OP_WRITE_FIXED] =3D {
 		.needs_file		=3D 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7618e402dcec..d82fbe074bd9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1082,3 +1082,18 @@ bool io_read_can_retarget_rsrc(struct io_kiocb *re=
q)
=20
 	return true;
 }
+
+bool io_read_fixed_can_retarget_rsrc(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+	u16 index;
+
+	if (unlikely(req->buf_index >=3D ctx->nr_user_bufs))
+		return false;
+
+	index =3D array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+	if (ctx->user_bufs[index] !=3D req->imu)
+		return false;
+
+	return io_read_can_retarget_rsrc(req);
+}
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 715e7249463b..69cbc36560f6 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -23,3 +23,4 @@ int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
 bool io_read_can_retarget_rsrc(struct io_kiocb *req);
+bool io_read_fixed_can_retarget_rsrc(struct io_kiocb *req);
--=20
2.30.2

