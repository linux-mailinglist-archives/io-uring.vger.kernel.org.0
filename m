Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D438613842
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiJaNmI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiJaNmH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:42:07 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28F4101FD
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:06 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFQsD007133
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=Yf3Oe7nNm4mTSc3Ipcgjg8uc6Rp9QEcyG6HSDoB+xZ4=;
 b=EKCOfaSaFDOw74Oktjbuvt+1B3GImoF+0Pfdv2cyjnPw429BZ+ClRwFoyWfRyOhCoLbk
 srwnnDHvwHwVxhzhSvXK2Z7WAKjhfn1wumR5w4AUJSIdrhbpVSlgB4tLouGw6xhuBiK6
 VfZtnpKX9PvKcaPRVutZmpOQ7Hn7s8qgdKF5t2gopF6CiCyzarCq8aWMtOTwY+c3AFs/
 Hkm8yuwghA5Nr5gRqkzFk8sMX4XECa/Hy6UyAF5RgyFsJ0/3U80IHQa1p58tbI+QYCCj
 Q6jaKBRXV78rgtnvmAH8N9UrMoT6Xxak2/zzS09Px7R97t4maN2Iro0SSSb+g0GioxdW 4Q== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1x1xcd2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:42:05 -0700
Received: from twshared23862.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:42:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 038E48A19664; Mon, 31 Oct 2022 06:41:36 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 12/12] io_uring: poll_add retarget_rsrc support
Date:   Mon, 31 Oct 2022 06:41:26 -0700
Message-ID: <20221031134126.82928-13-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZsbdbKjEvdcRSEIRfN8njtPqINm1f7AF
X-Proofpoint-GUID: ZsbdbKjEvdcRSEIRfN8njtPqINm1f7AF
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

Add can_retarget_rsrc handler for poll.

Note that the copy of fd is stashed in the middle of the struct io_poll a=
s
there is a hole there, and this is the only way to ensure that the
structure does not grow beyond the size of struct io_cmd_data.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/opdef.c |  1 +
 io_uring/poll.c  | 12 ++++++++++++
 io_uring/poll.h  |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 5159b3abc2b2..952ea8ff5032 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -133,6 +133,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.name			=3D "POLL_ADD",
 		.prep			=3D io_poll_add_prep,
 		.issue			=3D io_poll_add,
+		.can_retarget_rsrc	=3D io_poll_can_retarget_rsrc,
 	},
 	[IORING_OP_POLL_REMOVE] =3D {
 		.audit_skip		=3D 1,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..fde8060b9399 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -863,6 +863,7 @@ int io_poll_add_prep(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 		return -EINVAL;
=20
 	poll->events =3D io_poll_parse_events(sqe, flags);
+	poll->fd =3D req->cqe.fd;
 	return 0;
 }
=20
@@ -963,3 +964,14 @@ void io_apoll_cache_free(struct io_cache_entry *entr=
y)
 {
 	kfree(container_of(entry, struct async_poll, cache));
 }
+
+bool io_poll_can_retarget_rsrc(struct io_kiocb *req)
+{
+	struct io_poll *poll =3D io_kiocb_to_cmd(req, struct io_poll);
+
+	if (req->flags & REQ_F_FIXED_FILE &&
+	    io_file_peek_fixed(req, poll->fd) !=3D req->file)
+		return false;
+
+	return true;
+}
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 5f3bae50fc81..dcc4b06bcea1 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -12,6 +12,7 @@ struct io_poll {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				fd; /* only used by poll_add */
 	struct wait_queue_entry		wait;
 };
=20
@@ -37,3 +38,4 @@ bool io_poll_remove_all(struct io_ring_ctx *ctx, struct=
 task_struct *tsk,
 			bool cancel_all);
=20
 void io_apoll_cache_free(struct io_cache_entry *entry);
+bool io_poll_can_retarget_rsrc(struct io_kiocb *req);
--=20
2.30.2

