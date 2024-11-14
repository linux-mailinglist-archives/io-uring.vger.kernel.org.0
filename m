Return-Path: <io-uring+bounces-4685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 214669C88DE
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A8A8B36D72
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97EA1F8F18;
	Thu, 14 Nov 2024 11:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ig+phc+d"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CC91F8920
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583179; cv=none; b=gbgyamwftWp7HsN9Baa6DIoF6U7O6WTXwGyYQ7nZYUuYdcITIVQtJd1LLdLNIKYSrcDONRX46r+l1fVYI5ERZoyjtevlF2vQL+KEl75LI4IyXos0fKU8WFA//ZoLiECHBEErAlhXuAs/iaFRgm+CSO2JkTPvIb91KSMlaobaOGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583179; c=relaxed/simple;
	bh=2kIvGSsCSHjizaCaOq0s4apCtzvVdfMgd90goROBPp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cT/Et4/uAROjfPx//U0z7b9bFKS3PcORMxAJ7675Am1gLBVoUic4HM/osJwkeYogtNMAFshZb8ai915N1d3eYgE5rKM3FwQ4Hk0uzj5gsQOcS9bnWLPtAV5G59yrvJlySFUnVVq8EhNkLd75a8sAxby8vhJGrDQALJFdgIcOmrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ig+phc+d; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241114111936epoutp03e01eda8bc35115e5f087e3be8dfeb843~H0bl3oxtS0035400354epoutp03r
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:19:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241114111936epoutp03e01eda8bc35115e5f087e3be8dfeb843~H0bl3oxtS0035400354epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583176;
	bh=ib9AJGQhu+ajB/AguVXUCgWXWEskadPzJ1mb3EBw6vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ig+phc+dpYAHfx/m2ZXI0wwlGapB17T9cvMJuqeHKPb6XpL6o7E1jti4jPCc7Zk2p
	 kVwXahoZniHUnJCWqzsE/4fEFL+6TgLMb3kon9og1F94k+II2qqNvzpVLfQfEFsfl+
	 gUrnX5oOoLrAfQICHHr6Vil2QXWzBPyiS//rUSjw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241114111935epcas5p17e85db56c4b17db0b346ec3563cc1247~H0blZ-ko62218022180epcas5p1x;
	Thu, 14 Nov 2024 11:19:35 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XpyNQ0rfWz4x9Pw; Thu, 14 Nov
	2024 11:19:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FC.DA.09420.A5CD5376; Thu, 14 Nov 2024 20:17:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241114105408epcas5p3c77cda2faf7ccb37abbfd8e95b4ad1f5~H0FWspZez2837828378epcas5p3d;
	Thu, 14 Nov 2024 10:54:08 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241114105408epsmtrp2198d5ad524349923cd606f526fb13590~H0FWrul5g2100721007epsmtrp2i;
	Thu, 14 Nov 2024 10:54:08 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-0c-6735dc5afa28
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.C6.18937.FC6D5376; Thu, 14 Nov 2024 19:54:07 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105405epsmtip2083515c687749b8fae452db789bcba2c~H0FUNCF9p1327613276epsmtip23;
	Thu, 14 Nov 2024 10:54:05 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v9 07/11] io_uring: inline read/write attributes and PI
Date: Thu, 14 Nov 2024 16:15:13 +0530
Message-Id: <20241114104517.51726-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmlu7RO6bpBk/b5C0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzy/dIKpoEWz4mL3b5YGxo2KXYycHBIC
	JhIXz11h6WLk4hAS2M0o8fjjayYI5xOjxL7fhxGcn5OfssO0HP/+B6plJ6PE95brrBDOZ0aJ
	J2eXsYFUsQmoSxx53soIkhAR2MMo0bvwNFgLs8AEJon2iXPAZgkLuEtsu9MD1MHOwSKgKjEx
	HCTKK2Ap8XrNUSaIbfISMy99B6vmFLCSWNGwlRmiRlDi5MwnLCA2M1BN89bZzBD1Nzgkdi+U
	hLBdJPYvb2GEsIUlXh3fAvWBlMTnd3vZIOx0iR+Xn0LtKpBoPrYPqt5eovVUP9BMDqD5mhLr
	d+lDhGUlpp5axwSxlk+i9/cTqFZeiR3zYGwlifaVc6BsCYm95xqgbA+Jiw/fMkPCqpdR4vfJ
	HvYJjAqzkLwzC8k7sxBWL2BkXsUomVpQnJueWmxaYJiXWg6P5eT83E2M4HSu5bmD8e6DD3qH
	GJk4GA8xSnAwK4nwnnI2ThfiTUmsrEotyo8vKs1JLT7EaAoM7YnMUqLJ+cCMklcSb2hiaWBi
	ZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5OUn8UX1svP9152etr9u6Cz4kTp
	esP3uw5cUVhv077UOfH1o+z3p5Wynxrwq3La3eDhEjKWnd7XoGhd0LjjxZ7jN95PPs5X1l/0
	ycxiUfSV7B3rF2W++HGi4aqhUfosJ40DR7z+p7R8fX84cLq7rvG6v781um9N4VhRXXHsrT7D
	4uKa+ked5sqcG41zUi9s7/kyQ326tNCzzvk+8uXyctpmrLITX5l8entjx21VNdPTJ53mh0Rx
	1jAbyKROLvzCPcfLqXJTt+dUo3lrY1v/JWwUkqgM/Rj9oqZh4n6bTXH3d8qtPpe8bHfgsYty
	HkWXLHYc3LD7Q8/KlPOv13b2H5uxV99OttMwujayabfc4SlKLMUZiYZazEXFiQDkyORMcAQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXvf8NdN0g6vN1hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZzy+dYCpo0ay4
	2P2bpYFxo2IXIyeHhICJxPHvf1i6GLk4hAS2M0p09zQxQyQkJE69XMYIYQtLrPz3nB2i6COj
	xMFvLUwgCTYBdYkjz1vBikQETjBKzJ/oBlLELDCDSaLn1wo2kISwgLvEtjs9QDY7B4uAqsTE
	cJAor4ClxOs1R5kg5stLzLz0nR3E5hSwkljRsBXoBg6gXZYS39eLQJQLSpyc+YQFxGYGKm/e
	Opt5AqPALCSpWUhSCxiZVjGKphYU56bnJhcY6hUn5haX5qXrJefnbmIER5lW0A7GZev/6h1i
	ZOJgPMQowcGsJMJ7ytk4XYg3JbGyKrUoP76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFq
	EUyWiYNTqoFp2v3I6GX9b6/bzirQyg5Y1SKqWvvQZn+aKVvSW76d9ztvTS7/Z540eUdJrcPs
	XPaTlXHHTLXKF1w7PeF/w/ofXjrrLmzi89VbP7u5ZfXjr267dc5f2fvuNd+HDwsPzikpNzzw
	m8933SNFYcarGw6d3Sp/wDNFKvG+w1YP1c8955s+Ks3kf1hufMG5pymgYNO63L7TvPc4uK9f
	MTrztWBrbdOlXZtjgo4x5y56y9Gldk2Krfyvntlfs0cNC5cw1vP8DXzPfH3xjk1hVi3vBfrk
	DK9/ihbvzVKtfbxxVfi3A3fkZqw9t0sjR3LxXEuVw8z341Q8dG7kOOVJBD2MPp6516F11761
	my+ovHR1/V7nosRSnJFoqMVcVJwIAGd/bsEhAwAA
X-CMS-MailID: 20241114105408epcas5p3c77cda2faf7ccb37abbfd8e95b4ad1f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105408epcas5p3c77cda2faf7ccb37abbfd8e95b4ad1f5
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105408epcas5p3c77cda2faf7ccb37abbfd8e95b4ad1f5@epcas5p3.samsung.com>

Add the ability to place attributes inline within SQE.
Carve a new field that can accommodate 16 attribute flags:
	__u16 attr_inline_flags;

Currently ATTR_FLAG_PI is defined, and future flags can be or-ed to specify
the attributes that are placed inline.

When ATTR_FLAG_PI is passed, application should also setup SQE128 ring
and place PI information (i.e., struct io_uring_attr_pi) in the first
32b of second SQE.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 13 +++++++++++-
 io_uring/io_uring.c           |  6 +++++-
 io_uring/rw.c                 | 38 ++++++++++++++++++++++++++++++++---
 3 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2e6808f6ba28..9c290c16e543 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -93,9 +93,11 @@ struct io_uring_sqe {
 			__u16	__pad3[1];
 		};
 		struct {
+			/* used when extra attribute is passed inline SQE/SQE128 */
+			__u16	attr_inline_flags;
 			/* number of elements in the attribute vector */
 			__u8	nr_attr_indirect;
-			__u8	__pad4[3];
+			__u8	__pad4[1];
 		};
 	};
 	union {
@@ -126,6 +128,8 @@ struct io_uring_attr_vec {
 	__u64			addr;
 };
 
+/* sqe->attr_inline_flags */
+#define ATTR_FLAG_PI	(1U << ATTR_TYPE_PI)
 /* PI attribute information */
 struct io_uring_attr_pi {
 		__u16	flags;
@@ -136,6 +140,13 @@ struct io_uring_attr_pi {
 		__u64	rsvd;
 };
 
+/* Second half of SQE128 for IORING_OP_READ/WRITE */
+struct io_uring_sqe_ext {
+	/* if sqe->attr_inline_flags has ATTR_PI, first 32 bytes are for PI */
+	struct io_uring_attr_pi	rw_pi;
+	__u64			rsvd1[4];
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e32dd118d7c8..3f975befe82e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3866,8 +3866,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  attr_inline_flags);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
-	BUILD_BUG_SQE_ELEM(44, __u8,   nr_attr_indirect);
+	BUILD_BUG_SQE_ELEM(46, __u8,   nr_attr_indirect);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
@@ -3894,6 +3895,9 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_ext) !=
+		     sizeof(struct io_uring_sqe));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 93d7451b9370..d2d403ca6eb3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -269,6 +269,11 @@ static inline void io_meta_restore(struct io_async_rw *io)
 	iov_iter_restore(&io->meta.iter, &io->meta_state.iter_meta);
 }
 
+static inline const void *io_uring_sqe_ext(const struct io_uring_sqe *sqe)
+{
+	return (sqe + 1);
+}
+
 static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 			 const struct io_uring_attr_pi *pi_attr)
 {
@@ -343,11 +348,34 @@ static int io_prep_attr_vec(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	return 0;
 }
 
+static int io_prep_inline_attr(struct io_kiocb *req, struct io_rw *rw,
+			       const struct io_uring_sqe *sqe, int ddir,
+			       u16 attr_flags)
+{
+	const struct io_uring_sqe_ext *sqe_ext;
+	const struct io_uring_attr_pi *pi_attr;
+
+	if (!(attr_flags & ATTR_FLAG_PI))
+		return -EINVAL;
+
+	if (!(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EINVAL;
+
+	sqe_ext = io_uring_sqe_ext(sqe);
+	if (READ_ONCE(sqe_ext->rsvd1[0]) || READ_ONCE(sqe_ext->rsvd1[1])
+	    || READ_ONCE(sqe_ext->rsvd1[2]) || READ_ONCE(sqe_ext->rsvd1[3]))
+		return -EINVAL;
+
+	pi_attr = &sqe_ext->rw_pi;
+	return io_prep_rw_pi(req, rw, ddir, pi_attr);
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
+	u16 attr_flags;
 	u8 nr_attr_indirect;
 	int ret;
 
@@ -376,12 +404,16 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(ret))
 		return ret;
 
+	attr_flags = READ_ONCE(sqe->attr_inline_flags);
 	nr_attr_indirect = READ_ONCE(sqe->nr_attr_indirect);
-	if (nr_attr_indirect) {
+	if (attr_flags) {
+		if (READ_ONCE(sqe->__pad4[0]) || nr_attr_indirect)
+			return -EINVAL;
+		ret = io_prep_inline_attr(req, rw, sqe, ddir, attr_flags);
+	} else if (nr_attr_indirect) {
 		u64 attr_vec_usr_addr = READ_ONCE(sqe->attr_vec_addr);
 
-		if (READ_ONCE(sqe->__pad4[0]) || READ_ONCE(sqe->__pad4[1]) ||
-		    READ_ONCE(sqe->__pad4[2]))
+		if (READ_ONCE(sqe->__pad4[0]))
 			return -EINVAL;
 
 		ret = io_prep_attr_vec(req, rw, ddir, attr_vec_usr_addr,
-- 
2.25.1


