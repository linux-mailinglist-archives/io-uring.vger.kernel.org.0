Return-Path: <io-uring+bounces-11434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B52CFD400
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 11:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 506DC3053815
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 10:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9431330654;
	Wed,  7 Jan 2026 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IQ2jWeJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE90C33032C
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767782580; cv=none; b=db5QsSoUfLeVyuRL6/VC2R+VOS9rs9m1iMRz8FZg3MODtOf0iN4vf1MJTO2QY+BiUWInasJw76cvtBTGx57jZF3rC44GFHgH1otvFMPaG38OjJxU4z99gZZ7j+zo2EuwuxN35ZmylYg+RO6urcx5LPZ3tlkNybgDRgX+8oe7sAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767782580; c=relaxed/simple;
	bh=2MiCSdA/VIdSQiKcnTLXST4EL3ziPlBDc+Wdv7LbdJM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=FX2lAacpX7F8psfhWcdRcawWc1C9uM8nvfdS1qRwuEH310GeSJRSbOrVT/8sy4jjxEsi1pEvj5fDuSYi8OgJsS8/ZCUky9b4IndduuDU8lCFBo03zoKbWhPGQ4UUpsSg5jtaZfdiCUNtMIgxsjg6Gd0Fb5/rtUXeIWDWA9XRTsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IQ2jWeJJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260107104250epoutp048d8e0a51af05ae028912021d39c5a1ed~IbOHXPS1y1952019520epoutp04y
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:42:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260107104250epoutp048d8e0a51af05ae028912021d39c5a1ed~IbOHXPS1y1952019520epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767782571;
	bh=2MiCSdA/VIdSQiKcnTLXST4EL3ziPlBDc+Wdv7LbdJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IQ2jWeJJMvvGSAB9LXOzIY620CPLNGCgEauLlQMdtZSXwl3AhorUtdby2GQtaRjcK
	 FgZ81WWuZdEwNiZIuudEJ6J2SsVSI6x0LRy2Q061UZ1lvtsK8ADSJMZDmRcf6Sw0Fa
	 Bu2TSlkOCtaGBBZYiXVfBciCfAhYMrqoE7OPpHrM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260107104250epcas5p43dfb789a125cf559f5a23fdd211719b3~IbOG_uqp12599325993epcas5p49;
	Wed,  7 Jan 2026 10:42:50 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dmPkd2npcz6B9m9; Wed,  7 Jan
	2026 10:42:49 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260107104248epcas5p486bc93669a16755b573974f5e1e33d98~IbOExgwdR2599325993epcas5p48;
	Wed,  7 Jan 2026 10:42:48 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260107104247epsmtip120ca41e2e6f9b3082b41f19416838c95~IbOEDnwQZ0901809018epsmtip1d;
	Wed,  7 Jan 2026 10:42:47 +0000 (GMT)
Date: Wed, 7 Jan 2026 16:08:42 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V2 1/3] block: use bvec iterator helper for
 bio_may_need_split()
Message-ID: <20260107103842.yvwt5genpprpxa7a@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251231030101.3093960-2-ming.lei@redhat.com>
X-CMS-MailID: 20260107104248epcas5p486bc93669a16755b573974f5e1e33d98
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_dab70_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260107104248epcas5p486bc93669a16755b573974f5e1e33d98
References: <20251231030101.3093960-1-ming.lei@redhat.com>
	<20251231030101.3093960-2-ming.lei@redhat.com>
	<CGME20260107104248epcas5p486bc93669a16755b573974f5e1e33d98@epcas5p4.samsung.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_dab70_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 31/12/25 11:00AM, Ming Lei wrote:
>bio_may_need_split() uses bi_vcnt to determine if a bio has a single
>segment, but bi_vcnt is unreliable for cloned bios. Cloned bios share
>the parent's bi_io_vec array but iterate over a subset via bi_iter,
>so bi_vcnt may not reflect the actual segment count being iterated.
>
>Replace the bi_vcnt check with bvec iterator access via
>__bvec_iter_bvec(), comparing bi_iter.bi_size against the current
>bvec's length. This correctly handles both cloned and non-cloned bios.
>
>Move bi_io_vec into the first cache line adjacent to bi_iter. This is
>a sensible layout since bi_io_vec and bi_iter are commonly accessed
>together throughout the block layer - every bvec iteration requires
>both fields. This displaces bi_end_io to the second cache line, which
>is acceptable since bi_end_io and bi_private are always fetched
>together in bio_endio() anyway.
>
>The struct layout change requires bio_reset() to preserve and restore
>bi_io_vec across the memset, since it now falls within BIO_RESET_BYTES.
>
>Nitesh verified that this patch doesn't regress NVMe 512-byte IO perf [1].
>
>Link: https://lore.kernel.org/linux-block/20251220081607.tvnrltcngl3cc2fh@green245.gost/ [1]
>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_dab70_
Content-Type: text/plain; charset="utf-8"


------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_dab70_--

