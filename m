Return-Path: <io-uring+bounces-2930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D26B95D36D
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 18:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 525921C23910
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E72D18A6DA;
	Fri, 23 Aug 2024 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="d/ghgaSc"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039618E346
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430519; cv=none; b=JmwM5XJsK6mtfu6qHs7yjr4Mvz9+gmUqRBtVkw+haHijEHqAmEbcG0BRRGmrmq32gvGlYzdyI6ma/5jVp8f2K1VHNxa2rtroRHuAozwQa45+jvKOFkvCpocYtow/IZNKQ39VRNCTk5aKlhhi65PN469ibIgqBL0pn/x92K5uqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430519; c=relaxed/simple;
	bh=KwMYlfHX/PmGkdiIuzM7kl/6Up3b28z6Ru4Z1UgrjYk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhBKmg+DAt90kgOAkNTTER5umt1LNLoQinXp3mQSLD0A3A8dDECagiyPXSXqITo/PI0urNmh+F7mOAmqZmZVEmFzq0psaW/nSuR62r+CjK52r9kCzH2lBTYj3lgU1fObXrHKGInRRXcc6ikdYuiksuWyys23T+d0U+xQ+X/4qrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=d/ghgaSc; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47NETb5X003019
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	facebook; bh=Adr9di2edXlvFwPXO+C8IEXp4Yyjc8TC9nOMa63S1Q8=; b=d/g
	hgaScy/yGzn/LY2qjWIed0vb+vHdqoQCx+4spohVMIX3cCP9xMXwT5/iZgXjPR4p
	JWGrp0FahRV/j0MWneuVvPdvyYG9G7vo4EvbKHxO2MnT2y/ZyRnFtJjIPkPpfse3
	Z8v3WEO1KmKLhDJwnQhTkO5rP7Q5DZf/Xu6B8ShA=
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 416v82gt3g-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:37 -0700 (PDT)
Received: from twshared18321.17.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 23 Aug 2024 16:28:28 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 46E7C5CB7F7B; Fri, 23 Aug 2024 17:28:13 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <io-uring@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 3/6] btrfs: add btrfs_encoded_read_finish
Date: Fri, 23 Aug 2024 17:27:45 +0100
Message-ID: <20240823162810.1668399-4-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240823162810.1668399-1-maharmstone@fb.com>
References: <20240823162810.1668399-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lmr-kJ8rq8bBu_RXOAeVtiIMFUvgRc7a
X-Proofpoint-ORIG-GUID: lmr-kJ8rq8bBu_RXOAeVtiIMFUvgRc7a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_13,2024-08-22_01,2024-05-17_01

Move the end of btrfs_ioctl_encoded_read, responsible for copying to
userspace and cleanup, into its own function.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 29 +++++++++++-----------------
 fs/btrfs/ioctl.c       | 43 ++++++++++++++++++++++++++++++------------
 3 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5cd4308bd337..f4d77c3bb544 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -619,6 +619,7 @@ struct btrfs_encoded_read_private {
 	struct iov_iter iter;
 	struct btrfs_ioctl_encoded_io_args args;
 	struct file *file;
+	void __user *copy_out;
 };
=20
 ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c1292e58366a..1e53977a4854 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9169,13 +9169,13 @@ static ssize_t btrfs_encoded_read_regular(struct =
btrfs_encoded_read_private *pri
=20
 	priv->nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
 	priv->pages =3D kcalloc(priv->nr_pages, sizeof(struct page *), GFP_NOFS=
);
-	if (!priv->pages)
+	if (!priv->pages) {
+		priv->nr_pages =3D 0;
 		return -ENOMEM;
+	}
 	ret =3D btrfs_alloc_page_array(priv->nr_pages, priv->pages, false);
-	if (ret) {
-		ret =3D -ENOMEM;
-		goto out;
-		}
+	if (ret)
+		return -ENOMEM;
=20
 	_btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
 					       disk_io_size, priv);
@@ -9185,7 +9185,7 @@ static ssize_t btrfs_encoded_read_regular(struct bt=
rfs_encoded_read_private *pri
=20
 	ret =3D blk_status_to_errno(READ_ONCE(priv->status));
 	if (ret)
-		goto out;
+		return ret;
=20
 	unlock_extent(io_tree, start, lockend, &priv->cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
@@ -9204,22 +9204,15 @@ static ssize_t btrfs_encoded_read_regular(struct =
btrfs_encoded_read_private *pri
 				     PAGE_SIZE - page_offset);
=20
 		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
-				      &priv->iter) !=3D bytes) {
-			ret =3D -EFAULT;
-			goto out;
-		}
+				      &priv->iter) !=3D bytes)
+			return -EFAULT;
+
 		i++;
 		cur +=3D bytes;
 		page_offset =3D 0;
 	}
-	ret =3D priv->count;
-out:
-	for (i =3D 0; i < priv->nr_pages; i++) {
-		if (priv->pages[i])
-			__free_page(priv->pages[i]);
-	}
-	kfree(priv->pages);
-	return ret;
+
+	return priv->count;
 }
=20
 ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 770bd609f386..3fa661322c26 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4509,6 +4509,34 @@ static int _btrfs_ioctl_send(struct btrfs_inode *i=
node, void __user *argp, bool
 	return ret;
 }
=20
+static ssize_t btrfs_encoded_read_finish(struct btrfs_encoded_read_priva=
te *priv,
+					 ssize_t ret)
+{
+	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs,
+					     flags);
+	unsigned long i;
+
+	if (ret >=3D 0) {
+		fsnotify_access(priv->file);
+		if (copy_to_user(priv->copy_out,
+				 (char *)&priv->args + copy_end_kernel,
+				 sizeof(priv->args) - copy_end_kernel))
+			ret =3D -EFAULT;
+	}
+
+	for (i =3D 0; i < priv->nr_pages; i++) {
+		if (priv->pages[i])
+			__free_page(priv->pages[i]);
+	}
+	kfree(priv->pages);
+	kfree(priv->iov);
+
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
+	return ret;
+}
+
 static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp=
,
 				    bool compat)
 {
@@ -4573,21 +4601,12 @@ static int btrfs_ioctl_encoded_read(struct file *=
file, void __user *argp,
 	if (ret < 0)
 		goto out;
=20
+	priv.copy_out =3D argp + copy_end;
+
 	ret =3D btrfs_encoded_read(&priv);
-	if (ret >=3D 0) {
-		fsnotify_access(file);
-		if (copy_to_user(argp + copy_end,
-				 (char *)&priv.args + copy_end_kernel,
-				 sizeof(priv.args) - copy_end_kernel))
-			ret =3D -EFAULT;
-	}
=20
 out:
-	kfree(priv.iov);
-	if (ret > 0)
-		add_rchar(current, ret);
-	inc_syscr(current);
-	return ret;
+	return btrfs_encoded_read_finish(&priv, ret);
 }
=20
 static int btrfs_ioctl_encoded_write(struct file *file, void __user *arg=
p, bool compat)
--=20
2.44.2


