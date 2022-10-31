Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01215613840
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiJaNmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiJaNmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:42:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABDD10546
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:00 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFZps018814
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=E1UE+ZnF0mN9rIV+saxMrAyTQOyM78gziti+cvX/DRw=;
 b=RCFCN22TywnMLijtreE+zDiz52eOjBPXpK9+CtDmFqgYH6mz58QuPrWo4zEYK+qBKeAD
 0Ly8o5mHFBMX8Kw9aqtnI9vzGcVwXMsCk5I6ap6EzLk+Nr2t7Df6rqOFXFymXTXgX/Qs
 W0wMpL5LQ1y+dhlf/IOerTkX6IZEdkt6W/jlW7KCJmk75qxhOYWpYlvmRRqPKVkEu0ho
 TboXLNEv5a+1yA+9WeJiQPS0+rlNjfI3kFvFg23nn0pIEK+jdFDnIhjRqovRlZLdTv+b
 fqpMIopV1YKqmxUFdy2RwlsLuny9K0QPXufhBbUGaHFId+iqEKGomKHshpONm45+6szz Fg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vpwwp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:59 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:59 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E9F4F8A19660; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 10/12] io_uring: read retarget_rsrc support
Date:   Mon, 31 Oct 2022 06:41:24 -0700
Message-ID: <20221031134126.82928-11-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NX7Zf1TSW4lWC6gK9cA9O2bkyNxPe_gn
X-Proofpoint-ORIG-GUID: NX7Zf1TSW4lWC6gK9cA9O2bkyNxPe_gn
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

Add can_retarget_rsrc handler for read

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/opdef.c |  2 ++
 io_uring/rw.c    | 14 ++++++++++++++
 io_uring/rw.h    |  1 +
 3 files changed, 17 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 7c94f1a4315a..0018fe39cbb5 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -70,6 +70,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.prep_async		=3D io_readv_prep_async,
 		.cleanup		=3D io_readv_writev_cleanup,
 		.fail			=3D io_rw_fail,
+		.can_retarget_rsrc	=3D io_read_can_retarget_rsrc,
 	},
 	[IORING_OP_WRITEV] =3D {
 		.needs_file		=3D 1,
@@ -284,6 +285,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.prep			=3D io_prep_rw,
 		.issue			=3D io_read,
 		.fail			=3D io_rw_fail,
+		.can_retarget_rsrc	=3D io_read_can_retarget_rsrc,
 	},
 	[IORING_OP_WRITE] =3D {
 		.needs_file		=3D 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index bb47cc4da713..7618e402dcec 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1068,3 +1068,17 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool for=
ce_nonspin)
 	io_free_batch_list(ctx, pos);
 	return nr_events;
 }
+
+bool io_read_can_retarget_rsrc(struct io_kiocb *req)
+{
+	struct file *f;
+
+	if (!(req->flags & REQ_F_FIXED_FILE))
+		return true;
+
+	f =3D io_file_peek_fixed(req, req->cqe.fd);
+	if (f !=3D req->file)
+		return false;
+
+	return true;
+}
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3b733f4b610a..715e7249463b 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -22,3 +22,4 @@ int io_write(struct io_kiocb *req, unsigned int issue_f=
lags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
+bool io_read_can_retarget_rsrc(struct io_kiocb *req);
--=20
2.30.2

