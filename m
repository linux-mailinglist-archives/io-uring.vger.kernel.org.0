Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DC852F333
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352892AbiETShn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352972AbiETShk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:40 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F318E195BC0
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:39 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSJuC010763
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Z1kN9YKTgEbNSBC9L24GXepXSpkzS0zypoYUBMrIH50=;
 b=QQazOYI9Fg9iDNGiaOl286kJEqjBASOXM/UPxyBi+8pz4TglXnVDOyKWO3Wziql6WAzd
 ykjjVwikRsvXNudYOuqXbOm4nHEqKNt7Zr9gkF/p1U3f2Xt4l1YfyhPPzKHPFsKqqaxt
 M+QqeAMIS3as2Oashn2mfYiAV3T9INbrG+w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6341cjer-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:39 -0700
Received: from twshared6696.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:37 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 88DF4F5E5B2F; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 08/17] fs: Add check for async buffered writes to generic_write_checks
Date:   Fri, 20 May 2022 11:36:37 -0700
Message-ID: <20220520183646.2002023-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 4i5I4MGrpdXhS3Ans6x6zvhckXuIzlTO
X-Proofpoint-ORIG-GUID: 4i5I4MGrpdXhS3Ans6x6zvhckXuIzlTO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

