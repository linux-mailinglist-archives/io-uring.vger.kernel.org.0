Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1694455E82D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347677AbiF1PCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347673AbiF1PCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:02:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5725333E38
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:48 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAE7ZI013208
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=htEEzCcE4766+UwdC1leFCQGb+BeCyqpCEFz/0YnVKE=;
 b=CDx4QR6emayqwiddP+de7/TmBe6lA0yOj4AW7JjXjypzFlQGOZkBWukq8CeAJfeeSDnV
 iB4hdJZUxAqklfngOqnBVYpD/FrvUAWgZ7HaBFEghtP63VmUHqhHTWx8nbStHBj7tMNY
 +SiHDFqyRbMRwnMDXLZokCDJqqcsprMTpT4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyxx31y7r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:48 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EF0E8244BBD3; Tue, 28 Jun 2022 08:02:37 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 4/8] io_uring: recycle buffers on error
Date:   Tue, 28 Jun 2022 08:02:24 -0700
Message-ID: <20220628150228.1379645-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150228.1379645-1-dylany@fb.com>
References: <20220628150228.1379645-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 3n5km1FxofacmGiWCLxiucOLTcGKsVjf
X-Proofpoint-ORIG-GUID: 3n5km1FxofacmGiWCLxiucOLTcGKsVjf
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

Rather than passing an error back to the user with a buffer attached,
recycle the buffer immediately.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5e84f7ab92a3..0268c4603f5d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -481,10 +481,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &=3D ~REQ_F_NEED_CLEANUP;
-	if (ret >=3D 0)
+	if (ret > 0)
 		ret +=3D sr->done_io;
 	else if (sr->done_io)
 		ret =3D sr->done_io;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
 	cflags =3D io_put_kbuf(req, issue_flags);
 	if (kmsg->msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
@@ -557,10 +560,13 @@ int io_recv(struct io_kiocb *req, unsigned int issu=
e_flags)
 		req_set_fail(req);
 	}
=20
-	if (ret >=3D 0)
+	if (ret > 0)
 		ret +=3D sr->done_io;
 	else if (sr->done_io)
 		ret =3D sr->done_io;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
 	cflags =3D io_put_kbuf(req, issue_flags);
 	if (msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
--=20
2.30.2

