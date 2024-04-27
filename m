Return-Path: <io-uring+bounces-1658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A50F8B44C0
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 09:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CE5EB228DA
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 07:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627FE4085C;
	Sat, 27 Apr 2024 07:18:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A4F376EC;
	Sat, 27 Apr 2024 07:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714202320; cv=none; b=GPQGcK7hMdmWaJPhsDv18cNlJS27RjrpBOiye1+Hre9JbTaKFMTDd/t6vafJS0almfhaStY/U/n5iez/XpOZmqNISWJr4MV/fYcDr0gJOpRpPSbiIqNCQkO9L6h6y8/UiLA26EX5ONWoXt3H5uBhcONP1qL7RITICEGy4ssyCZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714202320; c=relaxed/simple;
	bh=AvI3/ie2Yp2jjnk1Nt1Lte9jVLM4pLHqDHw/pfWPjCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZpdGRhyrynhsGssNWzduL+Zfj/u20VDQRcqBq1lu3P+J4sftT2avVq5Ixbf1T4qiU5oV82d4bDWLjcpXcNKA+zyBdg296mfJ/sdNCqL4cXNcBHRmaFXJJX8r99Y1B5f2HIERcxFqw2VG1v8zMroxM4UHNknBKvw0uWKI+qDCA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEA2E227AA8; Sat, 27 Apr 2024 09:18:34 +0200 (CEST)
Date: Sat, 27 Apr 2024 09:18:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org, asml.silence@gmail.com,
	dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 05/10] block, nvme: modify rq_integrity_vec function
Message-ID: <20240427071834.GE3873@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca@epcas5p1.samsung.com> <20240425183943.6319-6-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

The subjet is about as useless as it gets :)

The essence is that it should take the iter into account, so name that.

> --- a/include/linux/blk-integrity.h
> +++ b/include/linux/blk-integrity.h
> @@ -109,11 +109,12 @@ static inline bool blk_integrity_rq(struct request *rq)
>   * Return the first bvec that contains integrity data.  Only drivers that are
>   * limited to a single integrity segment should use this helper.
>   */

The comment really needs an update.  With this rq_integrity_vec now
is a "normal" iter based operation, that can actually be used by
drivers with multiple integrity segments if it is properly advanced.

> +static inline struct bio_vec rq_integrity_vec(struct request *rq)
>  {
> -	return NULL;
> +	return (struct bio_vec){0};

No need for the 0 here.


