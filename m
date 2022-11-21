Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0291E631E5D
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiKUKaM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiKUKaL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:30:11 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52494B0439
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:10 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2AKMcOjg009034
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=5sUvSezzyVnUch2+Aj1tHqEtCms1S8nBX2WWVDfbM50=;
 b=Bkks/xSrwGeJbHNOs6lqXcDDDpFBRsTHyf/YMkusRlakm4+kK3Xlhc/FjFUdGCOWoRUn
 pu/Iupnyslerxaun1TZuYQcPfGYFsWx3RsCD40VM4UaHJBNGRhlspYlgA+v5avwpGiz7
 swY7kznryjqC6xfjlZGezQgaMKs9GzAhpBHXv8RhGjWxAFGZczrYilofKbyT21OtE9o7
 uIHeD6IyzjQpdmDdxoByyyapFX0HW1FroaW8WvlZZc6x4p9QaTAfuduHYZNBV3+2ISQh
 z/EliYXpmSU2IrcnLPNlV6KsUZai4T5pO/7+tcMTDYqHMEphXj9qJl0iYQajdYDLdIuj Ew== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kxuq0c45s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:30:09 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:30:07 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A8EA19E66F86; Mon, 21 Nov 2022 02:03:56 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 10/10] io_uring: allow multishot polled reqs to defer completion
Date:   Mon, 21 Nov 2022 02:03:53 -0800
Message-ID: <20221121100353.371865-11-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Rw5DwMxuApp38tK-6Y1b4wMIPKsjjnsU
X-Proofpoint-GUID: Rw5DwMxuApp38tK-6Y1b4wMIPKsjjnsU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Until now there was no reason for multishot polled requests to defer
completions as there was no functional difference. However now this will
actually defer the completions, for a performance win.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5c240d01278a..2e12bddcfb2c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1821,7 +1821,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locke=
d)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK | IO_URING_F_COMPLETE_DEFE=
R);
 }
=20
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
--=20
2.30.2

