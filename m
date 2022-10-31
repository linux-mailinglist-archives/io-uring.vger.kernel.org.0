Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E1E61383C
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiJaNly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiJaNlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E11A101F8
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:50 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFTRR018759
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=Qn4wARsGh2Mg7RlnCWciVHBGx4+K0kHQUHRPbd2VLCM=;
 b=FTnWfvelVgBuzb5rmotyXeG41ESFvzR6E5ElafgLiJPcW54uDmWgjazBtTctLBdAQ7zR
 FU17FfHHgVUrIOVF9t7LNF3U/qj+vkCm+XaeODGvV8fhr5YP8QRi94m/yJhMdYLZRDB5
 ZQKYzksEKNZyaQ23YEhPewSle+m4gsdYFeFzcEjRcHbMlTv7MIS7X1+u+t5jf8oANLk7
 B8fbxJbVEuX85+rUnFKrlM7HaeWoieeKfENJBeeWKFh1w9NOz9OZr57VJH3sebPBOrb/
 9DyJh8ir520QcYe7Rgk8zwyOXgujeXZ5VA/kEzhf1J58UFXusxHUIie9sA2ZWJpvPya3 RQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vpwwm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:50 -0700
Received: from twshared5476.02.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:49 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C9F018A19656; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 06/12] io_uring: add fixed file peeking function
Date:   Mon, 31 Oct 2022 06:41:20 -0700
Message-ID: <20221031134126.82928-7-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: tPod9XXRaYxNv_si4UQQgtGn5NMOPvTp
X-Proofpoint-ORIG-GUID: tPod9XXRaYxNv_si4UQQgtGn5NMOPvTp
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

Add a helper function to grab the fixed file at a given offset. Will be
useful for retarget op handlers.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 26 ++++++++++++++++++++------
 io_uring/io_uring.h |  1 +
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 32eb305c4ce7..a052653fc65e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1841,6 +1841,23 @@ void io_wq_submit_work(struct io_wq_work *work)
 		io_req_task_queue_fail(req, ret);
 }
=20
+static unsigned long __io_file_peek_fixed(struct io_kiocb *req, int fd)
+	__must_hold(&req->ctx->uring_lock)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+
+	if (unlikely((unsigned int)fd >=3D ctx->nr_user_files))
+		return 0;
+	fd =3D array_index_nospec(fd, ctx->nr_user_files);
+	return io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+}
+
+struct file *io_file_peek_fixed(struct io_kiocb *req, int fd)
+	__must_hold(&req->ctx->uring_lock)
+{
+	return (struct file *) (__io_file_peek_fixed(req, fd) & FFS_MASK);
+}
+
 inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 				      unsigned int issue_flags)
 {
@@ -1849,17 +1866,14 @@ inline struct file *io_file_get_fixed(struct io_k=
iocb *req, int fd,
 	unsigned long file_ptr;
=20
 	io_ring_submit_lock(ctx, issue_flags);
-
-	if (unlikely((unsigned int)fd >=3D ctx->nr_user_files))
-		goto out;
-	fd =3D array_index_nospec(fd, ctx->nr_user_files);
-	file_ptr =3D io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+	file_ptr =3D __io_file_peek_fixed(req, fd);
 	file =3D (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &=3D ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |=3D (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx, 0);
-out:
+	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
+
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ef77d2aa3172..781471bfba12 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -44,6 +44,7 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned=
 long len, int *npages);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
+struct file *io_file_peek_fixed(struct io_kiocb *req, int fd);
=20
 static inline bool io_req_ffs_set(struct io_kiocb *req)
 {
--=20
2.30.2

