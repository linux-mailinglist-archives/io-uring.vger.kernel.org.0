Return-Path: <io-uring+bounces-11237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F601CD2A1E
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 09:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 545243010A8C
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 08:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B8925A655;
	Sat, 20 Dec 2025 08:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ky/zAW+B"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B252A22423A
	for <io-uring@vger.kernel.org>; Sat, 20 Dec 2025 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766218843; cv=none; b=AY9lD0w031dmCV/1sVs6bfuuRDhsbQvXLzGF7fgTEXaGJgnYF9j7L0cJD2f/ri652Q6f/4jy5HvV2c6KQWAsYduGnn323tc4vSy0xTfcMhzuocxVS2GTkeXFX5VZU8edhXiBAe0o29ZqHNmiAxHV8MopE/EthTTrdF2YySF69t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766218843; c=relaxed/simple;
	bh=7yIwYBjbhWxFSAswNOF/WryDYMyGg7xBittzBXCnXrI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=j8Lk1ttbj6WLH04SfM7kRug+WaBE+tP+Zhm+mAFFHks7zNn+bH697UOHS9oQAH1pvVRPpr7PxdrIs4e2XfDdCP2d7B3Ur0szVVIwo7+1gPmuXcgS7WnUMkoYKcrggDAhVa0T/8GUtCY+PmNudqi59mmLUetSDtFM4sZJlKszIyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ky/zAW+B; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251220082034epoutp04d8e4a20aaeefb13013df58af5bd5132d~C3qwMeZAZ1297112971epoutp04h
	for <io-uring@vger.kernel.org>; Sat, 20 Dec 2025 08:20:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251220082034epoutp04d8e4a20aaeefb13013df58af5bd5132d~C3qwMeZAZ1297112971epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766218834;
	bh=9hrPYzKJs4MLeRj565g3Q7+tSWI53XRYe/T6Nz5rFJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ky/zAW+BeJgA1WvIpqykXPjUR+Yhmj7Q1Hu6SC8sSDMfC75UsiUGWPFIQzwvcsGTw
	 T0X4G3tyjooIyjIXGNLyC9u86DI5+3lnn7tj1vX9Jtr/1tRw1h6I76nOPusI8+tbzz
	 9nSQqSmzOuatTze+o5qsLt84j9BGoEFfz6nJsfSI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251220082033epcas5p3a863b4556c582c0d38e5ba53c11ee984~C3qvWbpLA2478424784epcas5p3S;
	Sat, 20 Dec 2025 08:20:33 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dYHQm3wRlz3hhT3; Sat, 20 Dec
	2025 08:20:32 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251220082031epcas5p378cacd8fcfdfbcefd899a2e8e4c3cce3~C3qt0VANC2478424784epcas5p3R;
	Sat, 20 Dec 2025 08:20:31 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251220082030epsmtip24ea2a740c809a5e2dd0a4c1f300c1b8a~C3qsyzWqQ1441314413epsmtip2d;
	Sat, 20 Dec 2025 08:20:30 +0000 (GMT)
Date: Sat, 20 Dec 2025 13:49:22 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <20251220081922.3bbmpvjorqcad5rb@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251218093146.1218279-2-ming.lei@redhat.com>
X-CMS-MailID: 20251220082031epcas5p378cacd8fcfdfbcefd899a2e8e4c3cce3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_993eb_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251220082031epcas5p378cacd8fcfdfbcefd899a2e8e4c3cce3
References: <20251218093146.1218279-1-ming.lei@redhat.com>
	<20251218093146.1218279-2-ming.lei@redhat.com>
	<CGME20251220082031epcas5p378cacd8fcfdfbcefd899a2e8e4c3cce3@epcas5p3.samsung.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_993eb_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 18/12/25 05:31PM, Ming Lei wrote:
>->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
>passed to bio_may_need_split().
>
>So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
>checking with help from bio size and bvec->len.
>
>Meantime retrieving the 1st bvec via __bvec_iter_bvec().
>
>Fixes: abd45c159df5 ("block: handle fast path of bio splitting inline")
>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>---
> block/blk.h | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>
>diff --git a/block/blk.h b/block/blk.h
>index e4c433f62dfc..a0b9cecba8fa 100644
>--- a/block/blk.h
>+++ b/block/blk.h
>@@ -371,12 +371,19 @@ struct bio *bio_split_zone_append(struct bio *bio,
> static inline bool bio_may_need_split(struct bio *bio,
> 		const struct queue_limits *lim)
> {
>+	const struct bio_vec *bv;
>+
> 	if (lim->chunk_sectors)
> 		return true;
>-	if (bio->bi_vcnt != 1)
>+
>+	if ((bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE) ||
>+			!bio->bi_io_vec)
REQ_OP_READ, REQ_OP_WRITE check is not necessary, since bio_may_need_split
is always called for READ/WRITE.

Thanks,
Nitesh

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_993eb_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_993eb_--

