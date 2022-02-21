Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C514BE9DC
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377508AbiBUORs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 09:17:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377520AbiBUORq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 09:17:46 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9950B1EAF8
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21L4KJ8f014222
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Fz7oKYENs0XPhuxwK1aReWcUz58BgCYUiYpPETqigJE=;
 b=H/HxMYnFyy6XrSdiPH2pDJB9JPa2ZfPXZ3YLsyUIdJWnz8bwY6bAPR80cpkLXIOgbg77
 PCnf5Mz1MDgxC3mmhVFXzL1zVn0+aBG2fxrDPrIDFk9qFLTVgCv7EisMBQDgSjv0JX3s
 8ZW18y5Tu/DibL3ZX2mFF0BweySDS5EqQJI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eaxhx98eg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800
Received: from twshared33860.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 06:17:22 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id C40B146F093A; Mon, 21 Feb 2022 06:17:17 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Date:   Mon, 21 Feb 2022 06:16:49 -0800
Message-ID: <20220221141649.624233-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221141649.624233-1-dylany@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0QW6jRMg0oeLqcv4E0uo3H3FFuuVa4RL
X-Proofpoint-GUID: 0QW6jRMg0oeLqcv4E0uo3H3FFuuVa4RL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=699
 suspectscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210086
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In read/write ops, preincrement f_pos when no offset is specified, and
then attempt fix up the position after IO completes if it completed less
than expected. This fixes the problem where multiple queued up IO will al=
l
obtain the same f_pos, and so perform the same read/write.

This is still not as consistent as sync r/w, as it is able to advance the
file offset past the end of the file. It seems it would be quite a
performance hit to work around this limitation - such as by keeping track
of concurrent operations - and the downside does not seem to be too
problematic.

The attempt to fix up the f_pos after will at least mean that in situatio=
ns
where a single operation is run, then the position will be consistent.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 81 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 68 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index abd8c739988e..a951d0754899 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3066,21 +3066,71 @@ static inline void io_rw_done(struct kiocb *kiocb=
, ssize_t ret)
 	}
 }
=20
-static inline loff_t*
-io_kiocb_update_pos(struct io_kiocb *req, struct kiocb *kiocb)
+static inline bool
+io_kiocb_update_pos(struct io_kiocb *req, struct kiocb *kiocb,
+		loff_t **ppos, u64 expected, bool force_nonblock)
 {
 	bool is_stream =3D req->file->f_mode & FMODE_STREAM;
 	if (kiocb->ki_pos =3D=3D -1) {
 		if (!is_stream) {
-			req->flags |=3D REQ_F_CUR_POS;
+			*ppos =3D &kiocb->ki_pos;
+			WARN_ON(req->flags & REQ_F_CUR_POS);
+			if (req->file->f_mode & FMODE_ATOMIC_POS) {
+				if (force_nonblock) {
+					if (!mutex_trylock(&req->file->f_pos_lock))
+						return true;
+				} else {
+					mutex_lock(&req->file->f_pos_lock);
+				}
+			}
 			kiocb->ki_pos =3D req->file->f_pos;
-			return &kiocb->ki_pos;
+			req->flags |=3D REQ_F_CUR_POS;
+			req->file->f_pos +=3D expected;
+			if (req->file->f_mode & FMODE_ATOMIC_POS)
+				mutex_unlock(&req->file->f_pos_lock);
+			return false;
 		} else {
 			kiocb->ki_pos =3D 0;
-			return NULL;
+			*ppos =3D NULL;
+			return false;
 		}
 	}
-	return is_stream ? NULL : &kiocb->ki_pos;
+	*ppos =3D is_stream ? NULL : &kiocb->ki_pos;
+	return false;
+}
+
+static inline void
+io_kiocb_done_pos(struct io_kiocb *req, struct kiocb *kiocb, u64 actual)
+{
+	u64 expected;
+
+	if (likely(!(req->flags & REQ_F_CUR_POS)))
+		return;
+
+	expected =3D req->rw.len;
+	if (actual >=3D expected)
+		return;
+
+	/*
+	 * It's not definitely safe to lock here, and the assumption is,
+	 * that if we cannot lock the position that it will be changing,
+	 * and if it will be changing - then we can't update it anyway
+	 */
+	if (req->file->f_mode & FMODE_ATOMIC_POS
+		&& !mutex_trylock(&req->file->f_pos_lock))
+		return;
+
+	/*
+	 * now we want to move the pointer, but only if everything is consisten=
t
+	 * with how we left it originally
+	 */
+	if (req->file->f_pos =3D=3D kiocb->ki_pos + (expected - actual))
+		req->file->f_pos =3D kiocb->ki_pos;
+
+	/* else something else messed with f_pos and we can't do anything */
+
+	if (req->file->f_mode & FMODE_ATOMIC_POS)
+		mutex_unlock(&req->file->f_pos_lock);
 }
=20
 static void kiocb_done(struct io_kiocb *req, ssize_t ret,
@@ -3096,8 +3146,7 @@ static void kiocb_done(struct io_kiocb *req, ssize_=
t ret,
 			ret +=3D io->bytes_done;
 	}
=20
-	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos =3D req->rw.kiocb.ki_pos;
+	io_kiocb_done_pos(req, &req->rw.kiocb, ret >=3D 0 ? ret : 0);
 	if (ret >=3D 0 && (req->rw.kiocb.ki_complete =3D=3D io_complete_rw))
 		__io_complete_rw(req, ret, issue_flags);
 	else
@@ -3662,21 +3711,23 @@ static int io_read(struct io_kiocb *req, unsigned=
 int issue_flags)
=20
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req) ||
+				io_kiocb_update_pos(req, kiocb, &ppos,
+						req->rw.len, true))) {
 			ret =3D io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
 		kiocb->ki_flags |=3D IOCB_NOWAIT;
 	} else {
+		io_kiocb_update_pos(req, kiocb, &ppos, req->rw.len, false);
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	ppos =3D io_kiocb_update_pos(req, kiocb);
-
 	ret =3D rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
+		io_kiocb_done_pos(req, kiocb, 0);
 		return ret;
 	}
=20
@@ -3798,14 +3849,17 @@ static int io_write(struct io_kiocb *req, unsigne=
d int issue_flags)
 		    (req->flags & REQ_F_ISREG))
 			goto copy_iov;
=20
+		/* if we cannot lock the file position then punt */
+		if (unlikely(io_kiocb_update_pos(req, kiocb, &ppos, req->rw.len, true)=
))
+			goto copy_iov;
+
 		kiocb->ki_flags |=3D IOCB_NOWAIT;
 	} else {
+		io_kiocb_update_pos(req, kiocb, &ppos, req->rw.len, false);
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	ppos =3D io_kiocb_update_pos(req, kiocb);
-
 	ret =3D rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
@@ -3858,6 +3912,7 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 out_free:
+	io_kiocb_done_pos(req, kiocb, 0);
 	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
 		kfree(iovec);
--=20
2.30.2

