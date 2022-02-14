Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EF44B58F5
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357202AbiBNRol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357205AbiBNRob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:31 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCAF65486
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:22 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21E9KNeY025658
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HeRa2xrPrzZWD3nBwmQhy5/qvO2TqyLuQ8Y3Q09V+fQ=;
 b=YGm+a3Ur7LIiy+gx4ZBHMIrifsmQgdAq+U5TZR801eM2CaRQD2Dbl5PGZavpyjmIaUh0
 2HJ3Tik4cbS04Ig1GFIc/daIKtiM9duwIfj5jKpa0VCLv1wSudwNKBG2ouqiyS0R9NBj
 caAmL71NKoIq/CF5kLWb8R6jGskEFenEWHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7mbx2vwt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:21 -0800
Received: from twshared0983.05.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:15 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 94151ABBD0F7; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 02/14] mm: Introduce do_generic_perform_write
Date:   Mon, 14 Feb 2022 09:43:51 -0800
Message-ID: <20220214174403.4147994-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: RDhWEvkm0vK9J-R2RwGI8hhd0zY2r2hY
X-Proofpoint-ORIG-GUID: RDhWEvkm0vK9J-R2RwGI8hhd0zY2r2hY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=750 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202140105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the do generic_perform_write() function, so an
additional flags parameter can be specified. It uses the new flag
parameter to support async buffered writes.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/fs.h |  1 +
 mm/filemap.c       | 20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e2d892b201b0..e62dba6ed453 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -278,6 +278,7 @@ enum positive_aop_returns {
 #define AOP_FLAG_NOFS			0x0002 /* used by filesystem to direct
 						* helper code (eg buffer layer)
 						* to clear GFP_FS from alloc */
+#define AOP_FLAGS_NOWAIT		0x0004 /* async nowait buffered writes */
=20
 /*
  * oh the beauties of C type declarations.
diff --git a/mm/filemap.c b/mm/filemap.c
index ad8c39d90bf9..d2fb817c0845 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3725,14 +3725,13 @@ generic_file_direct_write(struct kiocb *iocb, str=
uct iov_iter *from)
 }
 EXPORT_SYMBOL(generic_file_direct_write);
=20
-ssize_t generic_perform_write(struct file *file,
-				struct iov_iter *i, loff_t pos)
+static ssize_t do_generic_perform_write(struct file *file, struct iov_it=
er *i,
+					loff_t pos, int flags)
 {
 	struct address_space *mapping =3D file->f_mapping;
 	const struct address_space_operations *a_ops =3D mapping->a_ops;
 	long status =3D 0;
 	ssize_t written =3D 0;
-	unsigned int flags =3D 0;
=20
 	do {
 		struct page *page;
@@ -3801,6 +3800,12 @@ ssize_t generic_perform_write(struct file *file,
=20
 	return written ? written : status;
 }
+
+ssize_t generic_perform_write(struct file *file,
+				struct iov_iter *i, loff_t pos)
+{
+	return do_generic_perform_write(file, i, pos, 0);
+}
 EXPORT_SYMBOL(generic_perform_write);
=20
 /**
@@ -3832,6 +3837,10 @@ ssize_t __generic_file_write_iter(struct kiocb *io=
cb, struct iov_iter *from)
 	ssize_t		written =3D 0;
 	ssize_t		err;
 	ssize_t		status;
+	int             flags =3D 0;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		flags |=3D AOP_FLAGS_NOWAIT;
=20
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info =3D inode_to_bdi(inode);
@@ -3857,7 +3866,8 @@ ssize_t __generic_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
 		if (written < 0 || !iov_iter_count(from) || IS_DAX(inode))
 			goto out;
=20
-		status =3D generic_perform_write(file, from, pos =3D iocb->ki_pos);
+		status =3D do_generic_perform_write(file, from, pos =3D iocb->ki_pos, =
flags);
+
 		/*
 		 * If generic_perform_write() returned a synchronous error
 		 * then we want to return the number of bytes which were
@@ -3889,7 +3899,7 @@ ssize_t __generic_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
 			 */
 		}
 	} else {
-		written =3D generic_perform_write(file, from, iocb->ki_pos);
+		written =3D do_generic_perform_write(file, from, iocb->ki_pos, flags);
 		if (likely(written > 0))
 			iocb->ki_pos +=3D written;
 	}
--=20
2.30.2

