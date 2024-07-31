Return-Path: <io-uring+bounces-2623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 876319429D3
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 11:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA8451C211E6
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 09:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDC31A76C4;
	Wed, 31 Jul 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nVWm3GgH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EA91A8C1A
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722416526; cv=none; b=OkGYKWoL22igolvavFkPxYXCDyA9cL2qXJgNiAnoSNk3niZ79ddrN538YCUJ2b7jJf2H6r7n8jcaCn/sHy4rATrFqpo70Q+LuPAUsnhF6xD87/IyHEWRPjort/7Ffg9U6Wj6nvbmXF3W03Sp4R747aUuE5k3AExkvZqBQipAE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722416526; c=relaxed/simple;
	bh=73iB3M1NvO+En//6cpXOakqRULwRIxnXrQtadNy4ESM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ekNmOc8zQagzIwRydyC8h2W59lID6lfOFF5KZPxi8EHuVeEA4lnXs55x3FFJtY7dZ7i3FfH+8DDSOtDK96ZZkAmU3dJgwktlXOGZol1/hzQKFnEJG0brxmLr1lEWCLH8MjXyi9PjlAZLnIxWboo1pH7FQXquwVrY/WWdavwR8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nVWm3GgH; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240731090202epoutp044dd634fbe870d51eee1b5de5d6ef61d9~nQLN4dCTw2867228672epoutp04N
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240731090202epoutp044dd634fbe870d51eee1b5de5d6ef61d9~nQLN4dCTw2867228672epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722416522;
	bh=FpdpcaIWHJWwJTBPAHU+HUB90+qm2bvsrzq99oi+P44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVWm3GgH8kpozCHqATThei4L16iMI9YpIrsTUGGD6syqF5yTFVT99VtvkHv6EELMs
	 jCKYr11f6Rb4466KWYBfXR6Xj2l/eYxV/IZUzzwG5gmaD1ZOwkWbjJ1z2ZuZqltZ/7
	 wfLglrh4aGaOh+W2d/n5rNBYUv+CxBIsuMzVMJGM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240731090201epcas5p11140136ca87e5ffbf611785e4242fe5e~nQLNVp7xL1107911079epcas5p1X;
	Wed, 31 Jul 2024 09:02:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WYmLb5j53z4x9Px; Wed, 31 Jul
	2024 09:01:59 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.AD.09642.78DF9A66; Wed, 31 Jul 2024 18:01:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240731090143epcas5p2ade9e73c43ca6b839baa42761b4dc912~nQK8LY4701581415814epcas5p2k;
	Wed, 31 Jul 2024 09:01:43 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240731090143epsmtrp23d979535a0a042873197551a9dfb3dc6~nQK8Km_FC2144421444epsmtrp2D;
	Wed, 31 Jul 2024 09:01:43 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-6f-66a9fd877b5c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B0.D8.08456.67DF9A66; Wed, 31 Jul 2024 18:01:42 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240731090141epsmtip1f789e75d3c4ad7d684a070704e46d879~nQK6jm6Q-3046530465epsmtip1J;
	Wed, 31 Jul 2024 09:01:41 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v8 1/2] io_uring/rsrc: store folio shift and mask into imu
Date: Wed, 31 Jul 2024 17:01:32 +0800
Message-Id: <20240731090133.4106-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731090133.4106-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmpm7735VpBvsWa1g0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2Rmrl4gUNItWNPZPYmtgnCHQxcjJISFgIrH6YitrFyMXh5DAbkaJ
	Dd+Xs0M4nxglLm7/xAThfGOUmPzlEitMy5frl1ggEnsZJdquz2aGcJqYJNpeHWcEqWIT0JH4
	veIXC4gtIqAt8frxVDCbWWAXo8TCc1IgtrCAl8SjPZ+ZQWwWAVWJxveH2EBsXgFriV+dt9gh
	tslL7D94FqyGU8BG4tWkiywQNYISJ2c+gZopL9G8dTYzRP1Xdonmu1C2i8Sih72MELawxKvj
	W6BmSkl8frcXaBcHkF0ssWydHMj9EgItjBLv382BqreW+HdlDwtIDbOApsT6XfoQYVmJqafW
	MUGs5ZPo/f2ECSLOK7FjHoytKnHh4DaoVdISaydshTrHQ+L+2vfQgOtnlFh27Sj7BEaFWUje
	mYXknVkIqxcwMq9ilEwtKM5NTy02LTDOSy2HR3Jyfu4mRnAy1fLewfjowQe9Q4xMHIyHGCU4
	mJVEeIVOrkwT4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnAdJ5XEm9oYmlgYmZmZmJpbGao
	JM77unVuipBAemJJanZqakFqEUwfEwenVAOTecmXkuyOXU3LwhdevJXMfHFitdvz6Jdmuoo/
	YhdNN/ya/2eaj/end/8+/m5ZKnFoUnNd+J/fLxgX9cz7z5K4c6J2d8sKU/u3oiwRtzXvBmjs
	fzFR7q3V3K01Vxq5eK2u3n2nICihHZb4oWSX4Ae73L7PJy7VMRe5rXH9fH0l08zv1+X6/Rdo
	dEz22raN8e7ctHQG4f+3DlrmLNe7wFUj9b/+1c6+Fwwfp2oHbprfwdS8P2XZJt6Ev39X6BVU
	fVmdfnvRASOzdWdq5ELYM6fvcHDc88Zp5bpNW6du3dW5x/meR641Q/GdWtmbe2KFUl1Cj3yU
	a0/7z1y3fWa3pn/PxBjpW+l7TAp5FDi1Ar9tVWIpzkg01GIuKk4EANAFFVwvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnG7Z35VpBpObzCyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuolIgXNohWN/ZPYGhhnCHQxcnJICJhI
	fLl+iQXEFhLYzSix+IYuRFxaouNQKzuELSyx8t9zIJsLqKaBSWLf4h1sIAk2AR2J3yt+ATVz
	cIgI6Eo03lUAqWEWOMQo0byhmRGkRljAS+LRns/MIDaLgKpE4/tDYL28AtYSvzpvQS2Ql9h/
	8CxYDaeAjcSrSRfBZgoB1cx8ywRRLihxcuYTsDuZgcqbt85mnsAoMAtJahaS1AJGplWMkqkF
	xbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMGhrqW1g3HPqg96hxiZOBiBbuZgVhLhFTq5Mk2I
	NyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJJanZqakFqUUwWSYOTqkGJr3TjJ7ufKkt
	nyoN4q9ErZt8mG12ePm5fo6cKx7z1qqIn9rAce4B68ZQj6d3Gpf3rOdpmjC59euJUNXF75cd
	nfPif8lH/vk79/m8rM7y+ZkzNS/NPP5bVLHj/ri/1y3i7lTNO1p+Qmpm9T3Nyl9PTnP9T9JZ
	ulbeNTfwnkdHHh+n6eOIO/m8Wz4F3I3wv6t2NHhjugq3q/n7lrbpV1byKFlYdzw8Vxk7pfKL
	wqr5W9m2azTwB581Sysu6XY6VtqQ7rus22eezw3JPcqb87fXHTloecZAd+WJ9YfzLknbWvS9
	LIhYPu2rU5iy0v+wVu+a/B2f3H+cyItV5z7sPUvkX6rrnSv+i/IL/++qXLkoQImlOCPRUIu5
	qDgRAKd7un3kAgAA
X-CMS-MailID: 20240731090143epcas5p2ade9e73c43ca6b839baa42761b4dc912
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240731090143epcas5p2ade9e73c43ca6b839baa42761b4dc912
References: <20240731090133.4106-1-cliang01.li@samsung.com>
	<CGME20240731090143epcas5p2ade9e73c43ca6b839baa42761b4dc912@epcas5p2.samsung.com>

Store the folio shift and folio mask into imu struct and use it in
iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
multi-hugepage buffer get coalesced.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rsrc.c | 15 ++++++---------
 io_uring/rsrc.h |  2 ++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a860516bf448..64152dc6f293 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -915,6 +915,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->folio_mask = PAGE_MASK;
 	*pimu = imu;
 	ret = 0;
 
@@ -1031,23 +1033,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		 * we know that:
 		 *
 		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 * 2) all bvecs are the same in size, except potentially the
 		 *    first and last bvec
 		 *
 		 * So just find our index, and adjust the iterator afterwards.
 		 * If the offset is within the first bvec (or the whole first
 		 * bvec, just use iov_iter_advance(). This makes it easier
 		 * since we can just skip the first segment, which may not
-		 * be PAGE_SIZE aligned.
+		 * be folio_size aligned.
 		 */
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset < bvec->bv_len) {
-			/*
-			 * Note, huge pages buffers consists of one large
-			 * bvec entry and should always go this way. The other
-			 * branch doesn't expect non PAGE_SIZE'd chunks.
-			 */
 			iter->bvec = bvec;
 			iter->count -= offset;
 			iter->iov_offset = offset;
@@ -1056,12 +1053,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 			/* skip first vec */
 			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
+			seg_skip = 1 + (offset >> imu->folio_shift);
 
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
+			iter->iov_offset = offset & ~imu->folio_mask;
 		}
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..ee77e53328bf 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -46,7 +46,9 @@ struct io_mapped_ubuf {
 	u64		ubuf;
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
+	unsigned int    folio_shift;
 	unsigned long	acct_pages;
+	unsigned long   folio_mask;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.34.1


