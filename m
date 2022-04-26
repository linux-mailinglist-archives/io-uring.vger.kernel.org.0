Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDE95105A5
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiDZRrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbiDZRq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:46:59 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DB21816A7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:50 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQX6t011623
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RE5Ox9xrEwOzRKnjCVzMX1uqjY05JgL92w/a4ut+Iv0=;
 b=eaH6Ziv8m7op3mYRIgBG0LUAtnuGjKyWwpRtqTabOnfjQIpovWM3X7y5bJIPuBEozHuZ
 CeusKCMhhyF6go7qIg8nXCu1tZ5rJmRtmB5P00xf+2nka7kvS7q9X+MvA9lRWxVUZgGd
 a329XJdxMivuBMy0B1H2LHH1S/UpiCYQ9aI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyu3nvy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:49 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:47 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 747B2E2D4855; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 01/18] block: add check for async buffered writes to generic_write_checks
Date:   Tue, 26 Apr 2022 10:43:18 -0700
Message-ID: <20220426174335.4004987-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qaGJKXQA0nEW9YzE2j7Vuymgew9KnNd7
X-Proofpoint-ORIG-GUID: qaGJKXQA0nEW9YzE2j7Vuymgew9KnNd7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This introduces the flag FMODE_BUF_WASYNC. If devices support async
buffered writes, this flag can be set. It also modifies the check in
generic_write_checks to take async buffered writes into consideration.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/read_write.c    | 3 ++-
 include/linux/fs.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e643aec2b0ef..f75d75f7bc84 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1633,7 +1633,8 @@ int generic_write_checks_count(struct kiocb *iocb, =
loff_t *count)
 	if (iocb->ki_flags & IOCB_APPEND)
 		iocb->ki_pos =3D i_size_read(inode);
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+	    !((iocb->ki_flags & IOCB_DIRECT) || (file->f_mode & FMODE_BUF_WASYN=
C)))
 		return -EINVAL;
=20
 	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..3b479d02e210 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -177,6 +177,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t=
 offset,
 /* File supports async buffered reads */
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
=20
+/* File supports async nowait buffered writes */
+#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
+
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
--=20
2.30.2

