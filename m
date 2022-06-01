Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E032C53AFFC
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiFAVHP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 17:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiFAVHO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 17:07:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BB46B7DD
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 14:07:12 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251E8EQb020018
        for <io-uring@vger.kernel.org>; Wed, 1 Jun 2022 14:07:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Yt6TEqCrJwA/g0p7FZ8GGE3PH7HsqaIrUF33gFTVMx4=;
 b=h6jD3sBZFnEGkI/etm+Lugt7k80ZUCeu0gtuZGp8f4QKXCk6kbJPx6hEP8r6h/IMHpOX
 wzJN+WtbiTYVTCBt6r/LCo3tZ7Q2XWSpeJH73CN9CicjIsp14nZKnqsPWLRaqKUSY8/Y
 1jJLjTHIGzAIab7++CunsZfg/LVlVuyXH0M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge9m2jydc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 14:07:11 -0700
Received: from twshared10560.18.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:07:09 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id DBCE5FEB23A3; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 07/15] fs: Add check for async buffered writes to generic_write_checks
Date:   Wed, 1 Jun 2022 14:01:33 -0700
Message-ID: <20220601210141.3773402-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: c-1JTo88koYPkKEs1qvTfjn5ynbN0LRK
X-Proofpoint-ORIG-GUID: c-1JTo88koYPkKEs1qvTfjn5ynbN0LRK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This introduces the flag FMODE_BUF_WASYNC. If devices support async
buffered writes, this flag can be set. It also modifies the check in
generic_write_checks to take async buffered writes into consideration.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c    | 4 +++-
 include/linux/fs.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e643aec2b0ef..175d98713b9a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1633,7 +1633,9 @@ int generic_write_checks_count(struct kiocb *iocb, =
loff_t *count)
 	if (iocb->ki_flags & IOCB_APPEND)
 		iocb->ki_pos =3D i_size_read(inode);
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+	    !((iocb->ki_flags & IOCB_DIRECT) ||
+	      (file->f_mode & FMODE_BUF_WASYNC)))
 		return -EINVAL;
=20
 	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 01403e637271..bdf1ce48a458 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -180,6 +180,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t=
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

