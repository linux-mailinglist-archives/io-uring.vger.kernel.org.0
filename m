Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF4561610
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiF3JSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiF3JSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBFB30F67
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:08 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25U0LZOH020072
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sgvGDgKPrwLbeUqW4XYRdLuC4egsCzWZigh91QpoTW0=;
 b=U9579HFyXBKCz7+TqYaTt2rR1YIrGtnMs2BVKi9O7Bro2EohjnrnQBYA0VH4aLnV/vep
 Iu+rDTsV/lAIW9uiVmSqsUizA8Jf2jttmbnqksyKM+ca/pOtSN+5ISs9fK2LTbFNyg0R
 dfGcBietoLtpZWxk6FFb3hetu0uvk1dyf5s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gywp2qpf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:08 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:07 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A5A552599FD6; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 05/12] io_uring: clean up io_poll_check_events return values
Date:   Thu, 30 Jun 2022 02:12:24 -0700
Message-ID: <20220630091231.1456789-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wygCXQbRGMM6ZiEQrgJJKmYRlWt8WyJD
X-Proofpoint-GUID: wygCXQbRGMM6ZiEQrgJJKmYRlWt8WyJD
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

The values returned are a bit confusing, where 0 and 1 have implied
meaning, so add some definitions for them.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/poll.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index fa25b88a7b93..922a3d1b2e31 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -192,13 +192,18 @@ static void io_poll_remove_entries(struct io_kiocb =
*req)
 	rcu_read_unlock();
 }
=20
+enum {
+	IOU_POLL_DONE =3D 0,
+	IOU_POLL_NO_ACTION =3D 1,
+};
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
  *
- * Returns a negative error on failure. >0 when no action require, which=
 is
- * either spurious wakeup or multishot CQE is served. 0 when it's done w=
ith
- * the request, then the mask is stored in req->cqe.res.
+ * Returns a negative error on failure. IOU_POLL_NO_ACTION when no actio=
n require,
+ * which is either spurious wakeup or multishot CQE is served.
+ * IOU_POLL_DONE when it's done with the request, then the mask is store=
d in req->cqe.res.
  */
 static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
@@ -214,10 +219,11 @@ static int io_poll_check_events(struct io_kiocb *re=
q, bool *locked)
=20
 		/* tw handler should be the owner, and so have some references */
 		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
-			return 0;
+			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
=20
+		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
 			struct poll_table_struct pt =3D { ._key =3D req->apoll_events };
 			req->cqe.res =3D vfs_poll(req->file, &pt) & req->apoll_events;
@@ -226,7 +232,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 		if ((unlikely(!req->cqe.res)))
 			continue;
 		if (req->apoll_events & EPOLLONESHOT)
-			return 0;
+			return IOU_POLL_DONE;
=20
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -238,7 +244,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 				return -ECANCELED;
 		} else {
 			ret =3D io_poll_issue(req, locked);
-			if (ret)
+			if (ret < 0)
 				return ret;
 		}
=20
@@ -248,7 +254,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 		 */
 	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
=20
-	return 1;
+	return IOU_POLL_NO_ACTION;
 }
=20
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
@@ -256,12 +262,11 @@ static void io_poll_task_func(struct io_kiocb *req,=
 bool *locked)
 	int ret;
=20
 	ret =3D io_poll_check_events(req, locked);
-	if (ret > 0)
+	if (ret =3D=3D IOU_POLL_NO_ACTION)
 		return;
=20
-	if (!ret) {
+	if (ret =3D=3D IOU_POLL_DONE) {
 		struct io_poll *poll =3D io_kiocb_to_cmd(req);
-
 		req->cqe.res =3D mangle_poll(req->cqe.res & poll->events);
 	} else {
 		req->cqe.res =3D ret;
@@ -280,7 +285,7 @@ static void io_apoll_task_func(struct io_kiocb *req, =
bool *locked)
 	int ret;
=20
 	ret =3D io_poll_check_events(req, locked);
-	if (ret > 0)
+	if (ret =3D=3D IOU_POLL_NO_ACTION)
 		return;
=20
 	io_poll_remove_entries(req);
--=20
2.30.2

