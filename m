Return-Path: <io-uring+bounces-2359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C09919F03
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82CE91C21799
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092DA1F94A;
	Thu, 27 Jun 2024 06:05:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59BC1BC41;
	Thu, 27 Jun 2024 06:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719468351; cv=none; b=t18vEoaftFSxtPwupYrCnP3xoOW+MeZvxO7C/QJs8QL+5lZ+xLWiQGMSt9uUM0yME7mmmgK+WIMRB/uF1rf2MDPOYUCaNjR42rLnVu+Y4yPTML/GnE8jQbtqIVe+vukdIkkLPHIBf7UN7o8xEx0QEfX2/a2Bfj4dy5nFtVnWugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719468351; c=relaxed/simple;
	bh=HzizMEl2rvLMmoUjlVvyyYLPK8eGeG0OhCY95lBfijg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELaISsuwV4GA7J/OyfHIvKW+u4kqIyjqvGRGjIVV0Tuehmof+s4/gt7v0FwyE41FSpjypiz+7YxJllzZSAn2a4eoLCkBkd0eDqrSbdO3FJByezUdCmkm+f4FSk6QrFXVtYi/tb9E9hdOSZYGebrxB90vw9fSQEyojN1wBKPBlyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BCAEF68CFE; Thu, 27 Jun 2024 08:05:43 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:05:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Read/Write with meta/integrity
Message-ID: <20240627060542.GA15865@lst.de>
References: <CGME20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c@epcas5p3.samsung.com> <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

What tree does this apply to?  There's quite a few rejects vs
for-6.11/block.


