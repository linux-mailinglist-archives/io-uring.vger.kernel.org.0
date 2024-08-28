Return-Path: <io-uring+bounces-2965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 46805962D62
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 18:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAD08B25A8E
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 16:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3051A38FD;
	Wed, 28 Aug 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PS2jtbkX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE85334CC4
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724861627; cv=none; b=S+ecJ2BduyetSoMhwd/NpDk1m0FdKZ/WQLkxBwSkn+LiweibV35LSOvq2vmMcvBoM4gxZtAlMjmndB2MvaYdkUEXxjkN8Kew7gZuaz9Nn4GTbs7DAeA0Dk+eevuDtmW4//ZVe8eYMNbV1o7DDeXEU6khvhkzHy8knkSigop9fuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724861627; c=relaxed/simple;
	bh=rUj4e7X9XFiwm6eArKv4Fq5QEX9Ryc8j4twis9QdIKk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Mrrsi2KQulouYUS++wUiyXRFpwNTYW8HS/F8QGLG7u0LHBtRv/HxNVgo2blXjPwWV3cwQpxpyhz3CDseiypfq9xmH6usXMdmzcRrYd3jbi0ecC8VsS9bR0hnXBn3aaOnq4OQUql/x1GYh0CyHo6ikdEdVTmJ4lq2wlOJ0NL2USU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PS2jtbkX; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240828161342epoutp04434f2e8232f220046c3292cd7d490b49~v8IHjw9eb2569525695epoutp04a
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 16:13:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240828161342epoutp04434f2e8232f220046c3292cd7d490b49~v8IHjw9eb2569525695epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724861623;
	bh=HnL33aP4E10mX6zcM/z2UMMF0nMT5SuYS3j5XhT324w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PS2jtbkXa9B0rY5FO+5CpB3xxcVXNM79sh497IU45XvHDGlDUaVVHQP6W2xyVcEX2
	 ebhmso/ZMUx/AOLnOTiFDBi1JAu2wy1M0tvn5vpt2aGbEKsHIFHcgWaJPl3txM4tHl
	 K27bR1uPlvE+Ryw+y68gjkXrRJ3o1TVXGfImw24k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240828161342epcas5p2e27a44f3e80c49f9d0f999331dd9fdf0~v8IHCQ1nM2989929899epcas5p2T;
	Wed, 28 Aug 2024 16:13:42 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Wv8bm4Wpbz4x9Pt; Wed, 28 Aug
	2024 16:13:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F6.DD.08855.4BC4FC66; Thu, 29 Aug 2024 01:13:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240828112543epcas5p1109ce4ce7237ea38e339111b5bf8c63a~v4MrEDHAK2402224022epcas5p1d;
	Wed, 28 Aug 2024 11:25:43 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240828112543epsmtrp2d173a3e59b5ea6e24e83a65f3c737eb6~v4MrDSBPf1058610586epsmtrp2G;
	Wed, 28 Aug 2024 11:25:43 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-82-66cf4cb44878
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	35.F3.07567.7390FC66; Wed, 28 Aug 2024 20:25:43 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240828112540epsmtip12cff0499d082d60701d087b37e368c0a~v4MoUcwNx2866928669epsmtip1N;
	Wed, 28 Aug 2024 11:25:40 +0000 (GMT)
Date: Wed, 28 Aug 2024 16:48:06 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 03/10] block: handle split correctly for user meta
 bounce buffer
Message-ID: <20240828111806.GA3301@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240824083116.GC8805@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmuu4Wn/NpBoceSFvMWbWN0WL13X42
	i5sHdjJZrFx9lMniXes5FotJh64xWmw/s5TZYu8tbYv5y56yW3Rf38Fmsfz4PyYHbo+ds+6y
	e1w+W+qxaVUnm8fmJfUeu282sHl8fHqLxaNvyypGj82nqz0+b5IL4IzKtslITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlVJoSwxpxQoFJBYXKykb2dT
	lF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ1x4PNUpoL9khULWi+z
	NDDOEO1i5OSQEDCR6D23jr2LkYtDSGA3o8TOiWtYQBJCAp8YJU5PUodIfGOUuLRtDxtcx7XT
	TBCJvYwSbe9+MkM4zxglFk/fzwpSxSKgKnHt6FawDjYBdYkjz1sZQWwRASWJp6/OMoI0MAv8
	YpRYNr2PGSQhLBApsbH5EJjNK6AjseXXMzYIW1Di5MwnYDdxCmhLzFl7EcwWFVCWOLDtONgZ
	EgJbOCQ2LtnMDHGfi8SDeUehbhWWeHV8CzuELSXx+d1eqHi6xI/LT5kg7AKJ5mP7GCFse4nW
	U/1gc5gFMiT+TpsOVS8rMfXUOiaIOJ9E7+8nUL28EjvmwdhKEu0r50DZEhJ7zzVA2R4Su/6t
	Z4YE6i1GidVvoyYwys9C8tssJOsgbB2JBbs/AdkcQLa0xPJ/HBCmpsT6XfoLGFlXMUqmFhTn
	pqcmmxYY5qWWw2M8OT93EyM4KWu57GC8Mf+f3iFGJg7GQ4wSHMxKIrwnjp9NE+JNSaysSi3K
	jy8qzUktPsRoCoysicxSosn5wLyQVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampB
	ahFMHxMHp1QDU0LP44sXIm6L18qnVhTVXOt4dCFqj++7L68LnnClP5muwaUesu8V31P+a/0V
	F8+32ORfWndryp15Ny88toszPnKhWFFzstPxonrXnMijJ2Sc/RX32P9Z1P+9bOvBuiKGb3/u
	f/2/qeaUhQMjE7PaW13tEKPVjs7pZpXKqZcf+z1hLpEUNb6+dxH/mnO+YSmm7HOaD1mc7Jy6
	7YXx1QTZPhP3/x2Kk/4d49pwk3X7hJZJuYtTjy3VeKx5b9rFKxE7xf0nHL+fufnPq6Wpihwb
	pbwfzGef9EC0K6yl+VPZY562Rz+MF2eE7jx7Tu9gpSN7rdmH1kULelZu4bt6eLq96cuDeZMe
	TWfoWlS27NSa471KLMUZiYZazEXFiQAOGPp+UwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTtec83yaQf98dYs5q7YxWqy+289m
	cfPATiaLlauPMlm8az3HYjHp0DVGi+1nljJb7L2lbTF/2VN2i+7rO9gslh//x+TA7bFz1l12
	j8tnSz02repk89i8pN5j980GNo+PT2+xePRtWcXosfl0tcfnTXIBnFFcNimpOZllqUX6dglc
	GZ9PT2Iv+C9W0TlDt4Hxo1AXIyeHhICJRO+100xdjFwcQgK7GSXurHjOBpGQkDj1chkjhC0s
	sfLfc3aIoieMEqfOvmEBSbAIqEpcO7oVrIFNQF3iyPNWsAYRASWJp6/OMoI0MAv8YpRYNr2P
	GSQhLBApsbH5EJjNK6AjseXXMzaIqXcYJdbcfMMKkRCUODnzCdgGZgEtiRv/XgLdxwFkS0ss
	/8cBEuYU0JaYs/YiWImogLLEgW3HmSYwCs5C0j0LSfcshO4FjMyrGCVTC4pz03OTDQsM81LL
	9YoTc4tL89L1kvNzNzGCo0lLYwfjvfn/9A4xMnEwHmKU4GBWEuE9cfxsmhBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXFewxmzU4QE0hNLUrNTUwtSi2CyTBycUg1MVZ+dpFJXf3Xw+3SL/95T25u8
	224c8Ul9KGd188W0Fx5666Z2Xku15/BcE3x7ja5cfXahT/PXkLjZCRvSpZViGo6+X2BuF1iy
	0GlL6xH7M2aHtPn33w3ROZER+2Fp6M5dKm981+xa7vB9c5DblDavWwnnNblc25c9ZxTuSNi1
	8Lf5hiknhG3WXuF9ar/bMkb5r697WIDw9v9buu5yCxq5S18JyTkSs/lHzJn5Fa+dTs8Jnra9
	XvTXZHPl4wv0Xe8f3v3bMdRs2k8BFpPsO+sFcgXNhJ6faqk43RbVYBx3qUgzt2WbkVDpb7UA
	1rbMLZMyM6sX2N5YkaX2dPJ79YO28f5TdlyxqJRiXOvS8t9DiaU4I9FQi7moOBEAZBB4DRUD
	AAA=
X-CMS-MailID: 20240828112543epcas5p1109ce4ce7237ea38e339111b5bf8c63a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bx0Hnhhrn7x.JlxYXzjBkilvv7KFXT55p7POp3cMcMNV4hS0=_dd2c9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104620epcas5p2118c152963d6cadfbc9968790ac0e536
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104620epcas5p2118c152963d6cadfbc9968790ac0e536@epcas5p2.samsung.com>
	<20240823103811.2421-4-anuj20.g@samsung.com> <20240824083116.GC8805@lst.de>

------bx0Hnhhrn7x.JlxYXzjBkilvv7KFXT55p7POp3cMcMNV4hS0=_dd2c9_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Sat, Aug 24, 2024 at 10:31:16AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 23, 2024 at 04:08:03PM +0530, Anuj Gupta wrote:
> > Copy back the bounce buffer to user-space in entirety when the parent
> > bio completes.
> 
> This looks odd to me.  The usual way to handle iterating the entire
> submitter controlled data is to just iterate over the bvec array, as
> done by bio_for_each_segment_all/bio_for_each_bvec_all for the bio
> data.  I think you want to do the same here, probably with a
> similar bip_for_each_bvec_all or similar helper.  That way you don't
> need to stash away the iter.  Currently we have the field for that,
> but I really want to split up struct bio_integrity_payload into
> what is actually needed for the payload and stuff only needed for
> the block layer autogenerated PI (bip_bio/bio_iter/bip_work).
 
I can add it [*], to iterate over the entire bvec array. But the original
bio_iter still needs to be stored during submission, to calculate the
number of bytes in the original integrity/metadata iter (as it could have
gotten split, and I don't have original integrity iter stored anywhere).
Do you have a different opinion?

[*]
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ff7de4fe74c4..f1690c644e70 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -125,11 +125,23 @@ static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 	struct bio_vec *copy = &bip->bip_vec[1];
 	size_t bytes = bio_iter_integrity_bytes(bi, bip->bio_iter);
 	struct iov_iter iter;
-	int ret;
+	struct bio_vec *bvec;
+	struct bvec_iter_all iter_all;
 
 	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
-	WARN_ON_ONCE(ret != bytes);
+	bip_for_each_segment_all(bvec, bip, iter_all) {
+		ssize_t ret;
+
+		ret = copy_page_to_iter(bvec->bv_page,
+					bvec->bv_offset,
+					bvec->bv_len,
+					&iter);
+
+		if (!iov_iter_count(&iter))
+			break;
+
+		WARN_ON_ONCE(ret < bvec->bv_len);
+	}
 
 	bio_integrity_unpin_bvec(copy, nr_vecs, true);
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 22ff2ae16444..3132ef6f27e0 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -46,6 +46,19 @@ struct uio_meta {
 	struct		iov_iter iter;
 };
 
+static inline bool bip_next_segment(const struct bio_integrity_payload *bip,
+				    struct bvec_iter_all *iter)
+{
+	if (iter->idx >= bip->bip_vcnt)
+		return false;
+
+	bvec_advance(&bip->bip_vec[iter->idx], iter);
+	return true;
+}
+
+#define bip_for_each_segment_all(bvl, bip, iter) \
+	for (bvl = bvec_init_iter_all(&iter); bip_next_segment((bip), &iter); )
+
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
 			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
 			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | \
-- 
2.25.1

------bx0Hnhhrn7x.JlxYXzjBkilvv7KFXT55p7POp3cMcMNV4hS0=_dd2c9_
Content-Type: text/plain; charset="utf-8"


------bx0Hnhhrn7x.JlxYXzjBkilvv7KFXT55p7POp3cMcMNV4hS0=_dd2c9_--

