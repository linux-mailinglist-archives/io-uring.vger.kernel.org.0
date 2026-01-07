Return-Path: <io-uring+bounces-11435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9856ACFD403
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 11:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8725302C8D4
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 10:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027B333032C;
	Wed,  7 Jan 2026 10:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eziedHsw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBCC32B9BE
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767782637; cv=none; b=MEfj7QwEKAwI3618jaN1mCnpFX1BgRp6PzVLHD12dVAETtrUaKnQysdllQtdSqDI4xGeVzmAHc2aQG+X3EsyzXxHjs6O6aRknyi/BhBGkeN/PSsg4OZjE2zPuLr+US5xif8W7M+9Zcx97g3TqLtrM5mCALY1JQ7UPmyKBMsRbfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767782637; c=relaxed/simple;
	bh=z1y/2hrmSeEqvT+s+gwuwImapzGraOkVy7X2ITCrxcM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=P59VfmFsaDE7seWrkEH5r5QLHPLLU5KQ2ruliGA/Ob22r6V/Y26O/zI0AXm7GQ9PXmhKxIlOcU8PwXqXXYqvOXU8kWUWK/bef7X8ebcILymPZMuhp23B2sDgNEBYfn+fe47JJ32/RKDEOOryk/MwJfwAOGuwgyNkUl8O6hA2DBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eziedHsw; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260107104353epoutp0454a2645065577aff847f59937394e30b~IbPB526K01952719527epoutp04S
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:43:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260107104353epoutp0454a2645065577aff847f59937394e30b~IbPB526K01952719527epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767782633;
	bh=z1y/2hrmSeEqvT+s+gwuwImapzGraOkVy7X2ITCrxcM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eziedHswvd+Hi11n/We0UUu9KcoHmCrXAb5A1QjlOmqW+H/I9105YMVQEUpVBDD9b
	 aG5ukmeuDEsElqq/UsFqx4c9Nox6ouq1V9llgCRJRYg51KmtswVjIyIGO5HmzPUjVR
	 OGEAepak+p2PijwaJA3Zey6JAJu1Zfl/Q5mKIXmk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260107104353epcas5p1149cead31fda247ce33dc9a0ae631a8e~IbPBpj1WF1772417724epcas5p1r;
	Wed,  7 Jan 2026 10:43:53 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dmPlr3XQ3z2SSKZ; Wed,  7 Jan
	2026 10:43:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260107104352epcas5p49641dad7b466025a861da4dc044723d8~IbPASdoSy3206132061epcas5p4b;
	Wed,  7 Jan 2026 10:43:52 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260107104351epsmtip2dbfc10a8ad2298a9cdf6c115b4696fe9~IbO-kpf5f1630216302epsmtip2R;
	Wed,  7 Jan 2026 10:43:51 +0000 (GMT)
Date: Wed, 7 Jan 2026 16:09:46 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V2 2/3] block: don't initialize bi_vcnt for cloned bio
 in bio_iov_bvec_set()
Message-ID: <20260107103946.lnknsj5j3s5wvsoj@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251231030101.3093960-3-ming.lei@redhat.com>
X-CMS-MailID: 20260107104352epcas5p49641dad7b466025a861da4dc044723d8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db81a_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260107104352epcas5p49641dad7b466025a861da4dc044723d8
References: <20251231030101.3093960-1-ming.lei@redhat.com>
	<20251231030101.3093960-3-ming.lei@redhat.com>
	<CGME20260107104352epcas5p49641dad7b466025a861da4dc044723d8@epcas5p4.samsung.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db81a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 31/12/25 11:00AM, Ming Lei wrote:
>bio_iov_bvec_set() creates a cloned bio that borrows a bvec array from
>an iov_iter. For cloned bios, bi_vcnt is meaningless because iteration
>is controlled entirely by bi_iter (bi_idx, bi_size, bi_bvec_done), not
>by bi_vcnt. Remove the incorrect bi_vcnt assignment.
>
>Explicitly initialize bi_iter.bi_idx to 0 to ensure iteration starts
>at the first bvec. While bi_idx is typically already zero from bio
>initialization, making this explicit improves clarity and correctness.
>
>This change also avoids accessing iter->nr_segs, which is an iov_iter
>implementation detail that block code should not depend on.
>
>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>---
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db81a_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db81a_--

