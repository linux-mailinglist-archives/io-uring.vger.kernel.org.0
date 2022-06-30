Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4D561615
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiF3JSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiF3JSX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:23 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A2C403DA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:14 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LaG3008171
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tIhkPlWStBNk/+zkPkhwWVN8boBfp55d1HvcMzDGNpY=;
 b=oGcIHbH14Z8i/zpn5UX4exEbhjltNgXvXuU01I/lTGfMgsQexf3OeLgRBm5HfJtAFNwU
 K8rDzK7zTqd+KwJgwhKdt9MTPauQ7xVUJPYSA+Nn3z9kSsQkWpwfzDCZ0yXedELrKaED
 dNt69QTY2iHQ74Ly8P8oCw1bT1lmPe0NMao= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0qgqxdw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:13 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub202.TheFacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:12 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C05E82599FDD; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 08/12] io_uring: fix multishot poll on overflow
Date:   Thu, 30 Jun 2022 02:12:27 -0700
Message-ID: <20220630091231.1456789-9-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: HNX4KIdWeJY9m306OJDwAkQug8A2cnvD
X-Proofpoint-ORIG-GUID: HNX4KIdWeJY9m306OJDwAkQug8A2cnvD
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

On overflow, multishot poll can still complete with the IORING_CQE_F_MORE
flag set.
If in the meantime the user clears a CQE and a the poll was cancelled the=
n
the poll will post a CQE without the IORING_CQE_F_MORE (and likely result
-ECANCELED).

However when processing the application will encounter the non-overflow
CQE which indicates that there will be no more events posted. Typical
userspace applications would free memory associated with the poll in this
case.
It will then subsequently receive the earlier CQE which has overflowed,
which breaks the contract given by the IORING_CQE_F_MORE flag.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/poll.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index e8f922a4f6d7..57747d92bba4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -243,8 +243,10 @@ static int io_poll_check_events(struct io_kiocb *req=
, bool *locked)
 						    req->apoll_events);
=20
 			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
-					     mask, IORING_CQE_F_MORE, true))
-				return -ECANCELED;
+					     mask, IORING_CQE_F_MORE, false)) {
+				io_req_set_res(req, mask, 0);
+				return IOU_POLL_REMOVE_POLL_USE_RES;
+			}
 		} else {
 			ret =3D io_poll_issue(req, locked);
 			if (ret =3D=3D IOU_STOP_MULTISHOT)
--=20
2.30.2

