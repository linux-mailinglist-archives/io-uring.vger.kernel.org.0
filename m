Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE64B5105C4
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353569AbiDZRrb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353621AbiDZRrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD2F1836CA
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:12 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQeTB011897
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BV9qm4HYTiBkRoIEyv/ViUgpvXZ9StCXbNIA/1lP/Mg=;
 b=jM7fczXfr93STR4WG/J6zi+LFeB8z5rZWlg0NVxEzI79sbvjY+LrhrWvruMl1geTvjmo
 mgcKoR6ut3OeIhxjSRCBrz8t1g1/kog2km6xHm9bXR7sh+EG8sllwrWfzmbBSbi1lyA5
 grXEbNZp34OMrhveKVZrPxCsXemxKYHwDXg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyu3nyk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:11 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:10 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A9BC2E2D4865; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 09/18] fs: add pending file update time flag.
Date:   Tue, 26 Apr 2022 10:43:26 -0700
Message-ID: <20220426174335.4004987-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: utlqOzhsv8B11AijdWvJHPWNBOaWrVCg
X-Proofpoint-ORIG-GUID: utlqOzhsv8B11AijdWvJHPWNBOaWrVCg
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
index 64047bb0b9f8..f6d9877c2bb8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2091,6 +2091,7 @@ int do_file_update_time(struct inode *inode, struct=
 file *file,
 		return 0;
=20
 	ret =3D inode_update_time(inode, now, sync_mode);
+	inode->i_flags &=3D ~S_PENDING_TIME;
 	__mnt_drop_write_file(file);
=20
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e268a1a50357..dc9060c0d629 100644
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

