Return-Path: <io-uring+bounces-4451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CAD9BC9AB
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 10:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 793B91C23A8C
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 09:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A211D0E3C;
	Tue,  5 Nov 2024 09:55:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C4A1367;
	Tue,  5 Nov 2024 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730800551; cv=none; b=cIFMD2qmluSjZwpaQZKyjxvBF1lN5kV4VV0hExeUHdjTx0PK5aH4E39QI7ErOMdtEoMZ98zfQJP2nZrGsmkUaovmKUR6ezQnZ50q90mnAU0fOYnWeAs7TP0BrIGgM5yXgJu+JpV0hkrECeSMScN23KIBKQ0TCTN8j9MqzoBaoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730800551; c=relaxed/simple;
	bh=3ebZI/gEFKmyBuM4555MQ3afYl+L4sNL1v8qnaoY3Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uABPB53//0yptp+GLtEpM5012v+eWhBZkpVySdmYV+UTMe36u3t0wmW1wveLZj0X8+SawWH2FeTcUV7vWJ3wzJRfABqdGJWEjM17Wj/d71r+/YyAx8ZEEnQJXEko6EUJIFkIkX5CJeuREVxDrY+PNHTFoEyj+ejkHfN8oddJDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6D5D568C4E; Tue,  5 Nov 2024 10:55:38 +0100 (CET)
Date: Tue, 5 Nov 2024 10:55:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v7 04/10] fs, iov_iter: define meta io descriptor
Message-ID: <20241105095538.GA597@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141453epcas5p201e4aabfa7aa1f4af1cdf07228f8d4e7@epcas5p2.samsung.com> <20241104140601.12239-5-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104140601.12239-5-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 04, 2024 at 07:35:55PM +0530, Anuj Gupta wrote:
> Add flags to describe checks for integrity meta buffer. Also, introduce
> a  new 'uio_meta' structure that upper layer can use to pass the
> meta/integrity information.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

I'm pretty sure I reviewed this already last time, but here we go
again in case I'm misremembering:

Reviewed-by: Christoph Hellwig <hch@lst.de>


