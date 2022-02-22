Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6134BF6C2
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 11:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiBVKzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 05:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiBVKzs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 05:55:48 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F067158EA1
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:22 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21M4EqeB019915
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+JhfJ39dpqGcJ4tuYAP5PfpWsR3U6cRg5Qs900vYgMk=;
 b=pPPZOxOGAJ9VQIlioxWKoVKzhqyYXowCZPPCM5bzKehHhSJx08kBuTnevFRnuhgzYEYi
 WhEj8JUpdiNbmQ9oSipbRmlk4XaNInLBZURtQ2nqTDwepBoMiB6oPXwesXxs5rD+/vcC
 QduMy/xIKt18Av0EzjL6cbeIECIChr7D7dQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ecfsmuftf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:21 -0800
Received: from twshared26885.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 02:55:20 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 8FCBE47C3A51; Tue, 22 Feb 2022 02:55:13 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 4/4] io_uring: pre-increment f_pos on rw
Date:   Tue, 22 Feb 2022 02:55:04 -0800
Message-ID: <20220222105504.3331010-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222105504.3331010-1-dylany@fb.com>
References: <20220222105504.3331010-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: b7m9LxmoPYrvKjg1fJkKis3ilkQn7aNr
X-Proofpoint-ORIG-GUID: b7m9LxmoPYrvKjg1fJkKis3ilkQn7aNr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=641 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220064
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
 fs/io_uring.c | 95 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 82 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8954d82def36..adb15234e53c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3066,22 +3066,86 @@ static inline void io_rw_done(struct kiocb *kiocb=
, ssize_t ret)
 	}
 }
=20
-static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
+static bool __io_kiocb_update_pos(struct io_kiocb *req, loff_t **ppos,
+				u64 expected, bool force_nonblock)
+{
+	struct kiocb *kiocb =3D &req->rw.kiocb;
+
+	WARN_ON(req->flags & REQ_F_CUR_POS);
+	if (req->file->f_mode & FMODE_ATOMIC_POS) {
+		if (force_nonblock) {
+			if (!mutex_trylock(&req->file->f_pos_lock))
+				return true;
+		} else {
+			mutex_lock(&req->file->f_pos_lock);
+		}
+	}
+	kiocb->ki_pos =3D req->file->f_pos;
+	req->file->f_pos +=3D expected;
+	if (req->file->f_mode & FMODE_ATOMIC_POS)
+		mutex_unlock(&req->file->f_pos_lock);
+
+	*ppos =3D &kiocb->ki_pos;
+	req->flags |=3D REQ_F_CUR_POS;
+	return false;
+}
+
+static inline bool io_kiocb_update_pos(struct io_kiocb *req, loff_t **pp=
os,
+				u64 expected, bool force_nonblock)
 {
 	struct kiocb *kiocb =3D &req->rw.kiocb;
 	bool is_stream =3D req->file->f_mode & FMODE_STREAM;
=20
 	if (kiocb->ki_pos =3D=3D -1) {
 		if (!is_stream) {
-			req->flags |=3D REQ_F_CUR_POS;
-			kiocb->ki_pos =3D req->file->f_pos;
-			return &kiocb->ki_pos;
+			return __io_kiocb_update_pos(req, ppos, expected,
+						force_nonblock);
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
+static void __io_kiocb_done_pos(struct io_kiocb *req, u64 actual)
+{
+	struct kiocb *kiocb =3D &req->rw.kiocb;
+	u64 expected;
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
+}
+
+static inline void io_kiocb_done_pos(struct io_kiocb *req, u64 actual)
+{
+	if (likely(!(req->flags & REQ_F_CUR_POS)))
+		return;
+	__io_kiocb_done_pos(req, actual);
 }
=20
 static void kiocb_done(struct io_kiocb *req, ssize_t ret,
@@ -3097,8 +3161,7 @@ static void kiocb_done(struct io_kiocb *req, ssize_=
t ret,
 			ret +=3D io->bytes_done;
 	}
=20
-	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos =3D req->rw.kiocb.ki_pos;
+	io_kiocb_done_pos(req, ret >=3D 0 ? ret : 0);
 	if (ret >=3D 0 && (req->rw.kiocb.ki_complete =3D=3D io_complete_rw))
 		__io_complete_rw(req, ret, issue_flags);
 	else
@@ -3663,21 +3726,23 @@ static int io_read(struct io_kiocb *req, unsigned=
 int issue_flags)
=20
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req) ||
+				io_kiocb_update_pos(req, &ppos,
+						req->rw.len, true))) {
 			ret =3D io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
 		kiocb->ki_flags |=3D IOCB_NOWAIT;
 	} else {
+		io_kiocb_update_pos(req, &ppos, req->rw.len, false);
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	ppos =3D io_kiocb_update_pos(req);
-
 	ret =3D rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
+		io_kiocb_done_pos(req, 0);
 		return ret;
 	}
=20
@@ -3799,14 +3864,17 @@ static int io_write(struct io_kiocb *req, unsigne=
d int issue_flags)
 		    (req->flags & REQ_F_ISREG))
 			goto copy_iov;
=20
+		/* if we cannot lock the file position then punt */
+		if (unlikely(io_kiocb_update_pos(req, &ppos, req->rw.len, true)))
+			goto copy_iov;
+
 		kiocb->ki_flags |=3D IOCB_NOWAIT;
 	} else {
+		io_kiocb_update_pos(req, &ppos, req->rw.len, false);
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	ppos =3D io_kiocb_update_pos(req);
-
 	ret =3D rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
@@ -3859,6 +3927,7 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 out_free:
+	io_kiocb_done_pos(req, 0);
 	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
 		kfree(iovec);
--=20
2.30.2

