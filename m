Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9298657CB96
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiGUNOG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 09:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiGUNOF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 09:14:05 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8BC117F
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 06:14:04 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDBwJ2007075
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 06:14:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=1UTwILVniiw7ynXES8Bhzxf+egvso18YKqvJaTMOLow=;
 b=dMLjrMg2GDYAfjlv6i8dJmT13peB2U9OIJDx/wgs2PcgAhsZ+600V6aFv8pr+gtmzOEB
 B2dWz2DdNm5xpoxpPajAKhaJ0IEsEinqlLcl4pmXj7S79OsQzjtIivPn8iPRoWm26Qj2
 12/cHUsnfKj2t3iENpuoM0LhXto/18IJSqA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hf7fbr0eq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 06:14:03 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 06:13:33 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 6F7E63586F52; Thu, 21 Jul 2022 06:13:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH] io_uring: do not recycle buffer in READV
Date:   Thu, 21 Jul 2022 06:13:25 -0700
Message-ID: <20220721131325.624788-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fdlO0m517F7EawuenZ9DlZqC7T_GIMvP
X-Proofpoint-ORIG-GUID: fdlO0m517F7EawuenZ9DlZqC7T_GIMvP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

READV cannot recycle buffers as it would lose some of the data required t=
o
reimport that buffer.

Reported-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Fixes: b66e65f41426 ("io_uring: never call io_buffer_select() for a buffe=
r re-select")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

I think going forward we can probably re-enable recycling for READV, or p=
erhaps stick
it in the opdef to make it a bit more general. However since it is late i=
n the merge
cycle I thought the simplest approach is best.

Worth noting the initial discussed approach of stashing the data in `stru=
ct io_rw` would not
have worked as that struct is full already apparently.

Dylan

 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..b0180679584f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1737,6 +1737,14 @@ static void io_kbuf_recycle(struct io_kiocb *req, =
unsigned issue_flags)
 	    (req->flags & REQ_F_PARTIAL_IO))
 		return;
=20
+	/*
+	 * READV uses fields in `struct io_rw` (len/addr) to stash the selected
+	 * buffer data. However if that buffer is recycled the original request
+	 * data stored in addr is lost. Therefore forbid recycling for now.
+	 */
+	if (req->opcode =3D=3D IORING_OP_READV)
+		return;
+
 	/*
 	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
 	 * the flag and hence ensure that bl->head doesn't get incremented.

base-commit: ff6992735ade75aae3e35d16b17da1008d753d28
--=20
2.30.2

