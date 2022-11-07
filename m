Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1208C61FC6B
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiKGSAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 13:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiKGR7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 12:59:44 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612072A43A
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 09:56:20 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A7Glfk5028694
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 09:56:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=QnMdpgYmbsjbHhQ1lDDFeQrvaJxuQSXg0MrwT8Db3lk=;
 b=fs97lz8jkDdcsspWBSL8QgngIhy2g4fNGPgQFaUKngtVgj6HawGHH5uNlNNIbVw7Ml5/
 Ap2FohdIEeoRQ4d22N2yHIhjf/aBccDybNcQRj9N/SyY00sYnDb90Qq+CsxjWkCMc5Tv
 fvxLiwN9cZaSp/AJAb4OTtcYkmiXdpHq2uSaasiCRYMpalunfUK+Kqq2/j7UiNM6jwbk
 QpCTVoozLTvqGA+S8+s5XqdEU5jtZBMU4XwZLIM/k1cYl8ZfbFIS0NYr714myN5Yf/Uc
 sCE4bndFhVw/18U3yBBe6GkYSo97jN9J4319+0vrZRNdG8yQzm8JQ85ulgIj8hFkoPgK 9g== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3knkb819w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 09:56:20 -0800
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 09:56:18 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 995E8ADF1C9D; Mon,  7 Nov 2022 09:56:11 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <linux-fsdevel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 3/4] io_uring: use ubuf for single range imports for read/write
Date:   Mon, 7 Nov 2022 09:56:09 -0800
Message-ID: <20221107175610.349807-4-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175610.349807-1-kbusch@meta.com>
References: <20221107175610.349807-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: SyJw7Krdujj8MQfw9fo7CKKQfpiC5LOh
X-Proofpoint-ORIG-GUID: SyJw7Krdujj8MQfw9fo7CKKQfpiC5LOh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

This is more efficient than ITER_IOVEC.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[merge to 6.1, random fixes]
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/rw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1ce065709724..19551b5e8088 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -391,7 +391,7 @@ static struct iovec *__io_import_iovec(int ddir, stru=
ct io_kiocb *req,
 			rw->len =3D sqe_len;
 		}
=20
-		ret =3D import_single_range(ddir, buf, sqe_len, s->fast_iov, iter);
+		ret =3D import_ubuf(ddir, buf, sqe_len, iter);
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
@@ -450,7 +450,10 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *=
rw, struct iov_iter *iter)
 		struct iovec iovec;
 		ssize_t nr;
=20
-		if (!iov_iter_is_bvec(iter)) {
+		if (iter_is_ubuf(iter)) {
+			iovec.iov_base =3D iter->ubuf + iter->iov_offset;
+			iovec.iov_len =3D iov_iter_count(iter);
+		} else if (!iov_iter_is_bvec(iter)) {
 			iovec =3D iov_iter_iovec(iter);
 		} else {
 			iovec.iov_base =3D u64_to_user_ptr(rw->addr);
@@ -495,7 +498,7 @@ static void io_req_map_rw(struct io_kiocb *req, const=
 struct iovec *iovec,
 	io->free_iovec =3D iovec;
 	io->bytes_done =3D 0;
 	/* can only be fixed buffers, no need to do anything */
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iter_is_ubuf(iter))
 		return;
 	if (!iovec) {
 		unsigned iov_off =3D 0;
--=20
2.30.2

