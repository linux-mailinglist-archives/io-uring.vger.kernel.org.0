Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4461E528AEE
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343933AbiEPQtB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343861AbiEPQsq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2233C71C
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:45 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGA0uL004827
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=F0m1QmLNDQYiKaUS2R+sLft28q42+xh+blBDka8ibgQ=;
 b=ADZJyIrC6yEtr/AabhuuYoMTHD/5USOXxZ6P+RA/U7W/iYNBvkxpuCkGGLWdqld4PhXG
 L5mb3e/RmDOati8Z5yeLLZbskjWy4yHZr3jYRrDBX5BH+0rj93NMhHjp6nCcma1o8Te4
 ET4/DqZ74OL+6/qYuyaMwj+zcpd+8Ijk7yQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a8u2mav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:44 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:43 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6B430F146DDF; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 08/16] fs: add pending file update time flag.
Date:   Mon, 16 May 2022 09:47:10 -0700
Message-ID: <20220516164718.2419891-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: A0FdQacJ5a6QFyatatkagiZaQcLz2HJO
X-Proofpoint-GUID: A0FdQacJ5a6QFyatatkagiZaQcLz2HJO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This introduces an optimization for the update time flag and async
buffered writes. While an update of the file modification time is
pending and is handled by the workers, concurrent writes do not need
to wait for this time update to complete.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 1 +
 include/linux/fs.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 1d0b02763e98..fd18b2c1b7c4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2091,6 +2091,7 @@ static int do_file_update_time(struct inode *inode,=
 struct file *file,
 		return 0;
=20
 	ret =3D inode_update_time(inode, now, sync_mode);
+	inode->i_flags &=3D ~S_PENDING_TIME;
 	__mnt_drop_write_file(file);
=20
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b479d02e210..3da641dfa6d9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2141,6 +2141,8 @@ struct super_operations {
 #define S_CASEFOLD	(1 << 15) /* Casefolded file */
 #define S_VERITY	(1 << 16) /* Verity file (using fs/verity/) */
 #define S_KERNEL_FILE	(1 << 17) /* File is in use by the kernel (eg. fs/=
cachefiles) */
+#define S_PENDING_TIME (1 << 18) /* File update time is pending */
+
=20
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-syst=
em
@@ -2183,6 +2185,7 @@ static inline bool sb_rdonly(const struct super_blo=
ck *sb) { return sb->s_flags
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
 #define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
 #define IS_VERITY(inode)	((inode)->i_flags & S_VERITY)
+#define IS_PENDING_TIME(inode) ((inode)->i_flags & S_PENDING_TIME)
=20
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev =3D=3D WHITEOUT_DEV)
--=20
2.30.2

