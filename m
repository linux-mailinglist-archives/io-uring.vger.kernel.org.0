Return-Path: <io-uring+bounces-5031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B9C9D7C75
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:08:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BFCB1624E9
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861E918A6B7;
	Mon, 25 Nov 2024 08:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="alfVbe9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE54D155747
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522084; cv=none; b=ayXFq2rU6b/SXPqOk+5deqK95R9SNZHPxbIiU2wiyaie8DX063L4Q2mvl13wo0aRljuum+svp3Il88I+FBFFkUVkkPWEcm7kJpl8QzGmEzLawCEUR+zZRsrOeYba8FL2v1ncTZo2kpBCmCzsZbDJhPYgK1fZAMW1YWNPdG9bv08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522084; c=relaxed/simple;
	bh=uDUb87C52DXoVA3KvOoAoNEyjHqrw30MJR/Iqxaidaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=pIWtzcuXSx3/RxVKrSq4ROpH/WV3P+hg4ZKYnaOmC0G7vc3nDhPqxGEAkJTKrLGpAVu73yC0O5eEVBohc8ZyCl0MNvkbzE0nNS7u4uUwavrmzbv7buZoMBqEJSaxHIMue+oyYLSfUrYmK0Zu2MriT9KDkPGYHkQTK5/8nJcOL74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=alfVbe9E; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241125080800epoutp022bbbe0f93da945c740d2c7dec08a929f~LJ6dBjR7q2099820998epoutp02W
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241125080800epoutp022bbbe0f93da945c740d2c7dec08a929f~LJ6dBjR7q2099820998epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522081;
	bh=sPCiH7C8otAPeKBQxafGfpBc//4CVwTtOappMXTNYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alfVbe9Eu+Pt2aBRGR9fBRsrXeZ/aDz/UzPYFbowU5UZ4s6ExN1jGwgPeqH+M+AnQ
	 bNW2Bb1yTHwChxqEa+0238WXmAPbZz9W2qNHGeg7mK6RhZXJsdA6994jKINwhgXBU8
	 UJjU/mQWJzupPg/ERIuRvDieUDvevZenbAsrwYDI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241125080800epcas5p412d9a5f2601abac0647e31defe6716bc~LJ6cX-_xj1833918339epcas5p43;
	Mon, 25 Nov 2024 08:08:00 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XxdcG48MDz4x9Q3; Mon, 25 Nov
	2024 08:07:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DB.66.29212.E5034476; Mon, 25 Nov 2024 17:07:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241125071457epcas5p498c0641542bed9057e23cfff9cfc5ff0~LJMH1hjqt1933019330epcas5p4R;
	Mon, 25 Nov 2024 07:14:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241125071457epsmtrp1eaefa71b882c902d9317ca201b91da3d~LJMH0gPoA0302303023epsmtrp1z;
	Mon, 25 Nov 2024 07:14:57 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-87-6744305e1ece
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	20.08.35203.0F324476; Mon, 25 Nov 2024 16:14:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071454epsmtip149999c09d59b464adb11470b42b63af9~LJMFUPWGQ0361403614epsmtip1c;
	Mon, 25 Nov 2024 07:14:54 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v10 04/10] fs, iov_iter: define meta io descriptor
Date: Mon, 25 Nov 2024 12:36:27 +0530
Message-Id: <20241125070633.8042-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmlm6cgUu6wa818hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM5ZM0y24wlux+NpCtgbG2dxdjJwcEgIm
	Eiv2b2fvYuTiEBLYwyix7NwzKOcTo8SFD9/YIJxvjBJH3nazwLQsuzqZDcQWEtjLKNF8NQKi
	6DOjxKt9z5hAEmwC6hJHnrcygiREQOb2LjzNAuIwC0xgkmifOIcdpEpYwEli15kJYGNZBFQl
	Li77zwpi8wpYSByaepAJYp28xMxL38HqOQUsJd62HWCBqBGUODnzCZjNDFTTvHU2M8gCCYEb
	HBKf7i2DanaRuHz6NNTdwhKvjm9hh7ClJF72t0HZ6RI/Lj+Fqi+QaD62jxHCtpdoPdUPNJQD
	aIGmxPpd+hBhWYmpp9YxQezlk+j9/QSqlVdixzwYW0mifeUcKFtCYu+5BijbQ+LS72ZomPYA
	Q3viSuYJjAqzkPwzC8k/sxBWL2BkXsUolVpQnJuemmxaYKibl1oOj+fk/NxNjOCUrhWwg3H1
	hr96hxiZOBgPMUpwMCuJ8PKJO6cL8aYkVlalFuXHF5XmpBYfYjQFhvhEZinR5HxgVskriTc0
	sTQwMTMzM7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoGpxaNxZ+PWPUqSS2fPn+t/
	/59YilJa+uan2U69KyNDmAW3/WZ/cnVS8lVjTqbVus/Y3NJqbZgn3LZ/WvH6wBTVhedKVy4V
	X7JBQbW1qLJRYXWxyMNvwpee1YQGtry4cHKuxKzPOeI3rutIN36onayV/G3t/oTlE6ZGCfP9
	Kk3YPl2uiTHWYq1qZdp3ti3JbZrSR76WRxlJdE77Pl/1yfvrO37Zbf//qXLHX1P75SphTCus
	P3VEeH44MDPr53FzfrMlbx3NHh/XZ3tkdPfcC6nZD54IyCYZaa7RXJQosdQryExw87uJD+Vl
	t0UaRMw8LOZe/Mj8+3v24juTO8+dYDqz8Ml13w9xerUCOWHbnoZuVmIpzkg01GIuKk4EAAUN
	tadyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSnO4HZZd0g9fnrSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgylkzTLbjCW7H4
	2kK2BsbZ3F2MnBwSAiYSy65OZuti5OIQEtjNKNH5rJ8NIiEhcerlMkYIW1hi5b/n7BBFHxkl
	Wqe8YwZJsAmoSxx53gpWJCJwglFi/kQ3kCJmgRlMEj2/VoBNEhZwkth1ZgILiM0ioCpxcdl/
	VhCbV8BC4tDUg0wQG+QlZl76zg5icwpYSrxtOwBWLwRUM6tzJVS9oMTJmU/A4sxA9c1bZzNP
	YBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4IjT0tzBuH3VB71D
	jEwcjIcYJTiYlUR4+cSd04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzir/oTRESSE8sSc1OTS1I
	LYLJMnFwSjUwTeHhszZ0u35bxWvHoXC/TEdD7/BYxWXvd9jmrbk9nXnKSVWvxzaTth0w1c/6
	7RTW/v712/MOkpxHVyw40XbusPC77/1rZntGnL/1RoHT6izTNyu7U6bV934evveu9kDCSqXi
	7Q1dS8sVik9/4j42MbhHinmrq4VCmVP7LGtb/4MWWs8X5lz4cCBR5njTossnlzdP6eCepCVd
	oFetW5G4s9992U+DvU/0D0bdusVvWTM1QVzUj2/GRcfrAWaBySdfLI//3WztvPudCrv6Rf32
	Cf4H/F10M5ir2F5WpXBePrVav5ItISyXZ8cKCWGLBX6PeFpUg5k/R1fFaUYoSp63v/4/eNbS
	VzKWlXbGX9OUWIozEg21mIuKEwGNW3FuJwMAAA==
X-CMS-MailID: 20241125071457epcas5p498c0641542bed9057e23cfff9cfc5ff0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071457epcas5p498c0641542bed9057e23cfff9cfc5ff0
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071457epcas5p498c0641542bed9057e23cfff9cfc5ff0@epcas5p4.samsung.com>

Add flags to describe checks for integrity meta buffer. Also, introduce
a  new 'uio_meta' structure that upper layer can use to pass the
meta/integrity information.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uio.h     | 9 +++++++++
 include/uapi/linux/fs.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 853f9de5aa05..8ada84e85447 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -82,6 +82,15 @@ struct iov_iter {
 	};
 };
 
+typedef __u16 uio_meta_flags_t;
+
+struct uio_meta {
+	uio_meta_flags_t	flags;
+	u16			app_tag;
+	u64			seed;
+	struct iov_iter		iter;
+};
+
 static inline const struct iovec *iter_iov(const struct iov_iter *iter)
 {
 	if (iter->iter_type == ITER_UBUF)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..9070ef19f0a3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-- 
2.25.1


