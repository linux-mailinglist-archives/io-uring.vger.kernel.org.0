Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050CC52F33C
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352928AbiETShx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347970AbiETShu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95969195BFF
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:49 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSUY8023563
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fdXvE+WWGkZbdDWaaWcycrFeF07NZ6/Rt8YdakSfT7c=;
 b=Tt5lHOjJNVkIS4uCIUASb50t7kdLJEYq39f8aS7Kd7BjvzyFlnPDFCyONQ/SgWl+LNtl
 aVgWGF6qI83wP8Lalp4X2OCnPOeoLkhExkXBHvX8OmB7OrDK8hOBqXSNZHbmKfZeK1+G
 R2ByHDAco573YRxstlhZ2KUbQcZzze94jNg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g604bnbux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:48 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub202.TheFacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:48 -0700
Received: from twshared6696.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:47 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A87FEF5E5B3B; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 13/17] io_uring: Add support for async buffered writes
Date:   Fri, 20 May 2022 11:36:42 -0700
Message-ID: <20220520183646.2002023-14-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hmI2mX5hC-1jF4UMQOmiaBS-_yZM5XHI
X-Proofpoint-GUID: hmI2mX5hC-1jF4UMQOmiaBS-_yZM5XHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This enables the async buffered writes for the filesystems that support
async buffered writes in io-uring. Buffered writes are enabled for
blocks that are already in the page cache or can be acquired with noio.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91de361ea9ab..f3aaac286509 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3746,7 +3746,7 @@ static inline int io_iter_do_read(struct io_kiocb *=
req, struct iov_iter *iter)
 		return -EINVAL;
 }
=20
-static bool need_read_all(struct io_kiocb *req)
+static bool need_complete_io(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ISREG ||
 		S_ISBLK(file_inode(req->file)->i_mode);
@@ -3875,7 +3875,7 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	} else if (ret =3D=3D -EIOCBQUEUED) {
 		goto out_free;
 	} else if (ret =3D=3D req->result || ret <=3D 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
@@ -3971,9 +3971,10 @@ static int io_write(struct io_kiocb *req, unsigned=
 int issue_flags)
 		if (unlikely(!io_file_supports_nowait(req)))
 			goto copy_iov;
=20
-		/* file path doesn't support NOWAIT for non-direct_IO */
-		if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
-		    (req->flags & REQ_F_ISREG))
+		/* File path supports NOWAIT for non-direct_IO only for block devices.=
 */
+		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
+			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
+			(req->flags & REQ_F_ISREG))
 			goto copy_iov;
=20
 		kiocb->ki_flags |=3D IOCB_NOWAIT;
@@ -4027,6 +4028,24 @@ static int io_write(struct io_kiocb *req, unsigned=
 int issue_flags)
 		/* IOPOLL retry should happen for io-wq threads */
 		if (ret2 =3D=3D -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto copy_iov;
+
+		if (ret2 !=3D req->result && ret2 >=3D 0 && need_complete_io(req)) {
+			struct io_async_rw *rw;
+
+			/* This is a partial write. The file pos has already been
+			 * updated, setup the async struct to complete the request
+			 * in the worker. Also update bytes_done to account for
+			 * the bytes already written.
+			 */
+			iov_iter_save_state(&s->iter, &s->iter_state);
+			ret =3D io_setup_async_rw(req, iovec, s, true);
+
+			rw =3D req->async_data;
+			if (rw)
+				rw->bytes_done +=3D ret2;
+
+			return ret ? ret : -EAGAIN;
+		}
 done:
 		kiocb_done(req, ret2, issue_flags);
 	} else {
--=20
2.30.2

