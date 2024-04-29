Return-Path: <io-uring+bounces-1672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CB48B5FAC
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 19:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DACF6282162
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7661C86260;
	Mon, 29 Apr 2024 17:07:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5917F47A5C;
	Mon, 29 Apr 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410458; cv=none; b=o2t9lbo26nSKM2FH19QAJupixlnofAnfTGHRGQ7Ej6p3j4cprhwlmQPz0iTEQEgG9EiX3jm1K0s1MgXh9Z/plmkv6d8WTo2z2ZEZsavh0OnBap57iE578b0xEOGwTM8pzD85vNtPUgRwOY1XAFVmeIaoP/D7On1Hbw4MjW/aEC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410458; c=relaxed/simple;
	bh=tK0K6yuM2ErZaa56FWFc/pUIfXVI8UrCztL55MVgwKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2n14md8pIcm0OH8kjmeJQ0yl0JnicAFFl0LxrtCsbawLQ1TLUZSPY3Qq7VMzgiLihSzBOQV+qlWmSyAg8ASXKes7VBjZBldAi56iqLvBta2jtt3ZiCrhJJ8Zeeg9F5at+THda19MRNJ7F+wByGjhjj0dicatQj1A+vqa/LrS6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B467227A87; Mon, 29 Apr 2024 19:07:29 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:07:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of
 bip_vcnt during clone
Message-ID: <20240429170728.GA31337@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com> <20240425183943.6319-3-joshi.k@samsung.com> <20240427070331.GB3873@lst.de> <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com> <Zi-MvOZ_bYVuiuBb@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi-MvOZ_bYVuiuBb@kbusch-mbp.mynextlight.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 01:04:12PM +0100, Keith Busch wrote:
> An earlier version added a field in the bip to point to the original
> bvec from the user address. That extra field wouldn't be used in the far
> majority of cases, so moving the user bvec to the end of the existing
> bip_vec is a spatial optimization. The code may look a little more
> confusing that way, but I think it's better than making the bip bigger.

I think we need to do something like that - just hiding the bounce
buffer is not really maintainable once we get multiple levels of stacking
and other creative bio cloning.

