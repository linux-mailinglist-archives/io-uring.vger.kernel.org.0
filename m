Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2C75483DB
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 12:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiFMKMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 06:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiFMKMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 06:12:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C325B64
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:15 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D0dbn9025898
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7k49VHVzCemj5iULkw4lLhqJCt4ZT/QP9b9yqSYpM+k=;
 b=j/ZKijvWz3b5PKVDvjLnf+tgUkFGphm4Jc8h+2Jm/KUJDBcvqIL4A8vFzZZ7iypMor+c
 95HFvRGmkculSdKwTcIH3UbRk6EpBnj2akqh5iz3qgPguHoPLRXdjkGZV5UMF5OxT1sZ
 EAHp9E+GZ7xaZkDUgutp0C2mNKLJEe4LbUI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmtc3y5kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 03:12:15 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 03:12:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 28E6B1992AE1; Mon, 13 Jun 2022 03:12:04 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/3] io_uring: fix types in provided buffer ring
Date:   Mon, 13 Jun 2022 03:11:56 -0700
Message-ID: <20220613101157.3687-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613101157.3687-1-dylany@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0dCiq4U9K1_gJLEMMCXrz8h6qhl0almr
X-Proofpoint-ORIG-GUID: 0dCiq4U9K1_gJLEMMCXrz8h6qhl0almr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The type of head needs to match that of tail in order for rollover and
comparisons to work correctly.

Without this change the comparison of tail to head might incorrectly allo=
w
io_uring to use a buffer that userspace had not given it.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buff=
ers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9cf9aff51b70..6eea18e8330c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -298,8 +298,8 @@ struct io_buffer_list {
 	/* below is for ring provided buffers */
 	__u16 buf_nr_pages;
 	__u16 nr_entries;
-	__u32 head;
-	__u32 mask;
+	__u16 head;
+	__u16 mask;
 };
=20
 struct io_buffer {
@@ -3876,7 +3876,7 @@ static void __user *io_ring_buffer_select(struct io=
_kiocb *req, size_t *len,
 {
 	struct io_uring_buf_ring *br =3D bl->buf_ring;
 	struct io_uring_buf *buf;
-	__u32 head =3D bl->head;
+	__u16 head =3D bl->head;
=20
 	if (unlikely(smp_load_acquire(&br->tail) =3D=3D head)) {
 		io_ring_submit_unlock(req->ctx, issue_flags);
--=20
2.30.2

