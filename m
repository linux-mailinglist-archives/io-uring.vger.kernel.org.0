Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A6655E696
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347727AbiF1PDJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347709AbiF1PDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:03:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D89433E3C
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:03:00 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25SEooR9009892
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6OnrcbHVM3UEKAIV92LdKB+Frnz6Bl7ou2nLFHOv2Zc=;
 b=N4IVZi4jJCHrLBIj6fN6fiD8lY7YCuCq8F7ImS9e7pQJS3UBxgDNc6XV+TSVu+ac1dlC
 7beisqKyzNSWV7zu5WYOklHemB576GXjzuroEzVRn7FkTpuQXyORTZeakwmZMdI7+LCG
 j82m0UpyBlTTirbiT6FJpSLUPd6MoECfCv8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3h03ru0386-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:59 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub103.TheFacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:56 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:55 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0B8A4244BBD7; Tue, 28 Jun 2022 08:02:38 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 6/8] io_uring: add IOU_STOP_MULTISHOT return code
Date:   Tue, 28 Jun 2022 08:02:26 -0700
Message-ID: <20220628150228.1379645-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150228.1379645-1-dylany@fb.com>
References: <20220628150228.1379645-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Vwrlnq8E3N0yiQPQsPvpzOI0umY9KStC
X-Proofpoint-GUID: Vwrlnq8E3N0yiQPQsPvpzOI0umY9KStC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
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

For multishot we want a way to signal the caller that multishot has ended
but also this might not be an error return.

For example sockets return 0 when closed, which should end a multishot
recv, but still have a CQE with result 0

Introduce IOU_STOP_MULTISHOT which does this and indicates that the retur=
n
code is stored inside req->cqe

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.h | 7 +++++++
 io_uring/poll.c     | 9 +++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f77e4a5403e4..e8da70781fa3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,6 +15,13 @@
 enum {
 	IOU_OK			=3D 0,
 	IOU_ISSUE_SKIP_COMPLETE	=3D -EIOCBQUEUED,
+
+	/*
+	 * Intended only when both REQ_F_POLLED and REQ_F_APOLL_MULTISHOT
+	 * are set to indicate to the poll runner that multishot should be
+	 * removed and the result is set on req->cqe.res.
+	 */
+	IOU_STOP_MULTISHOT	=3D -ECANCELED,
 };
=20
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index fc3a5789d303..2054df9af291 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -195,6 +195,7 @@ static void io_poll_remove_entries(struct io_kiocb *r=
eq)
 enum {
 	IOU_POLL_DONE =3D 0,
 	IOU_POLL_NO_ACTION =3D 1,
+	IOU_POLL_REMOVE_POLL_USE_RES =3D 2,
 };
=20
 /*
@@ -244,6 +245,8 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 				return -ECANCELED;
 		} else {
 			ret =3D io_poll_issue(req, locked);
+			if (ret =3D=3D IOU_STOP_MULTISHOT)
+				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)
 				return ret;
 		}
@@ -268,7 +271,7 @@ static void io_poll_task_func(struct io_kiocb *req, b=
ool *locked)
 	if (ret =3D=3D IOU_POLL_DONE) {
 		struct io_poll *poll =3D io_kiocb_to_cmd(req);
 		req->cqe.res =3D mangle_poll(req->cqe.res & poll->events);
-	} else {
+	} else if (ret !=3D IOU_POLL_REMOVE_POLL_USE_RES) {
 		req->cqe.res =3D ret;
 		req_set_fail(req);
 	}
@@ -291,7 +294,9 @@ static void io_apoll_task_func(struct io_kiocb *req, =
bool *locked)
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, locked);
=20
-	if (!ret)
+	if (ret =3D=3D IOU_POLL_REMOVE_POLL_USE_RES)
+		io_req_complete_post(req);
+	else if (ret =3D=3D IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
 		io_req_complete_failed(req, ret);
--=20
2.30.2

