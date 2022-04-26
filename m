Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF35105C7
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353623AbiDZRrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353626AbiDZRr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9350F1836F6
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQTdR024678
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=H1gaP7rmwRkzgL1zpgAy7/OkhOf1XEN09A0i6oOpXGo=;
 b=TaF5a1rhf6dMGoL27gH9Ot05WWSLx8kTwjXIjHwikOTmRLbJT1tvguQqL121Pv/d39j2
 kxq/M90b8V+U7BhxPnIybKpDKR+s7BPs68ulpOttJGOIZUvZ9dgh7kOn4awBHU82f7WC
 xserZ7G3AQr7hkKOBOhIpamM0+0MP7nTMtY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge03h8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:12 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B06AAE2D4867; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 10/18] xfs: Enable async write file modification handling.
Date:   Tue, 26 Apr 2022 10:43:27 -0700
Message-ID: <20220426174335.4004987-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bgBoPVARjzdKW38lG_2LzSvglQC7vpxg
X-Proofpoint-GUID: bgBoPVARjzdKW38lG_2LzSvglQC7vpxg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This modifies xfs write checks to return -EAGAIN if the request either
requires to remove privileges or needs to update the file modification
time. This is required for async buffered writes, so the request gets
handled in the io worker.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_file.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..6f9da1059e8b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -299,6 +299,43 @@ xfs_file_read_iter(
 	return ret;
 }
=20
+static int xfs_file_modified(struct file *file, int flags)
+{
+	int ret;
+	struct dentry *dentry =3D file_dentry(file);
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	/*
+	 * Clear the security bits if the process is not being run by root.
+	 * This keeps people from modifying setuid and setgid binaries.
+	 */
+	ret =3D need_file_remove_privs(inode, dentry);
+	if (ret < 0) {
+		return ret;
+	} else if (ret > 0) {
+		if (flags & IOCB_NOWAIT)
+			return -EAGAIN;
+
+		ret =3D do_file_remove_privs(file, inode, dentry, ret);
+		if (ret)
+			return ret;
+	}
+
+	ret =3D need_file_update_time(inode, file, &now);
+	if (ret <=3D 0)
+		return ret;
+	if (flags & IOCB_NOWAIT) {
+		if (IS_PENDING_TIME(inode))
+			return 0;
+
+		inode->i_flags |=3D S_PENDING_TIME;
+		return -EAGAIN;
+	}
+
+	return do_file_update_time(inode, file, &now, ret);
+}
+
 /*
  * Common pre-write limit and setup checks.
  *
@@ -410,7 +447,7 @@ xfs_file_write_checks(
 		spin_unlock(&ip->i_flags_lock);
=20
 out:
-	return file_modified(file);
+	return xfs_file_modified(file, iocb->ki_flags);
 }
=20
 static int
--=20
2.30.2

