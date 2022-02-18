Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B254BC0D8
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiBRT63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbiBRT6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:22 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB47326AF1
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:05 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21IB6C0h018136
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=alXhLW7aurhHczIm3IzCj5kJidR1rbjDw8mIZ0YRvcw=;
 b=DHGSK/R4EqPc0NUjFBF6FAlhOwu1u6CCBsgoYKFDVyxj7y1ffyuQjXXki8V2OvUu+UpO
 Paw4O9E47g2vnIaOn0JhgQajgdWgDYsjOeJR0MPvFrGZJlirSJGnAc05A+dUpd+w1MO2
 NwxyI7Cjqnr+lCbbdmzn03vfQ96O0nrVwW8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e9e7xd4ss-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:05 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B5AC3AEB660D; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 08/13] io_uring: add support for async buffered writes
Date:   Fri, 18 Feb 2022 11:57:34 -0800
Message-ID: <20220218195739.585044-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: b8N_gdJtAu5Rkf_pSkWeAM7CYEDb49Jc
X-Proofpoint-GUID: b8N_gdJtAu5Rkf_pSkWeAM7CYEDb49Jc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=962 priorityscore=1501 impostorscore=0
 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180121
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This enables the async buffered writes for block devices in io_uring.
Buffered writes are enabled for blocks that are already in the page
cache or can be acquired with noio.

It is possible that a write request cannot be completely fullfilled
(short write). In that case the request is punted and sent to the io
workers to be completed. Before submitting the request to the io
workers, the request is updated with how much has already been written.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..52bd88908afd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3615,7 +3615,7 @@ static inline int io_iter_do_read(struct io_kiocb *=
req, struct iov_iter *iter)
 		return -EINVAL;
 }
=20
-static bool need_read_all(struct io_kiocb *req)
+static bool need_complete_io(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ISREG ||
 		S_ISBLK(file_inode(req->file)->i_mode);
@@ -3679,7 +3679,7 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	} else if (ret =3D=3D -EIOCBQUEUED) {
 		goto out_free;
 	} else if (ret =3D=3D req->result || ret <=3D 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
@@ -3777,9 +3777,10 @@ static int io_write(struct io_kiocb *req, unsigned=
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
@@ -3831,6 +3832,24 @@ static int io_write(struct io_kiocb *req, unsigned=
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

