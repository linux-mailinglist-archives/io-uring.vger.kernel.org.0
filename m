Return-Path: <io-uring+bounces-3755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8899A12B5
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 21:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D294028667A
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 19:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E019B216A16;
	Wed, 16 Oct 2024 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHob37zr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCB2216A13;
	Wed, 16 Oct 2024 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729107352; cv=none; b=fPgoYgeUTFd379ub0nove2X8trh85R1sHGVzt2E+2iCsbT7lzv0Cs5cAx7sDaqs4FQeWgohO7vr/jdIl8ijUTWLgvZTds9r9zpXD9QY21e++nCFR0zPGyn9Q2T7Uu8Ys+mvu+ZXJYxNDq2vVUi3ldniy8R0qWTtQ7XxWPAkmlUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729107352; c=relaxed/simple;
	bh=zQBkoRKgsffe6sm8fQRMZvpdlOGY9+zXwYUi6ybAbV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8B6cH3M5nCp26NZ7TwmCkDsUHzXeMjsJ36ozZMe7OzE8y4HpInDCrAcKcVAiCpHE5uuQqXCKXET/yCZDHvUXx4YKImAPtN2ML1LZjJJt/WL/3J1bd3G8O4BYPrlvGHfd6xZmsXt33P422x0A7RWb4e+Ce9ang36fEaYUYS7vWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JHob37zr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B8EC4CED1;
	Wed, 16 Oct 2024 19:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729107352;
	bh=zQBkoRKgsffe6sm8fQRMZvpdlOGY9+zXwYUi6ybAbV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JHob37zr2eyddutbScP40veOlgjdzzewqg0C3Kydv5hPYn+i+i7JgcqyJ3F2rEask
	 xw2wJ46bITMY+zwuljeoC7DTqEj/8p0HmEdgc9uV5WfQw39S61S2RaW0vnkUxQxPXB
	 IWVaKuHdnMW7XEkdLEpSHekVGCuGzYA3GL3YChGO/J4VW9ZSfXne3DqdeaTvA8zFYV
	 KB7jW/vnTx4Z8NYGECMdHJ2tRGxLsfyr0fAOwEBBwyIVkgoLOjpatskNDtRNGcc4UO
	 TK4eoQGss5ZUENN6R1GFcyLP8dsntpKJwf16zLHO9mOSiN0BR7pK9pERmQM5bFhIbn
	 fRvow2mNKcnbA==
Date: Wed, 16 Oct 2024 13:35:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
Message-ID: <ZxAVlFfF-gjzFLwr@kbusch-mbp.dhcp.thefacebook.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
 <CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>
 <20241016112912.63542-5-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-5-anuj20.g@samsung.com>

On Wed, Oct 16, 2024 at 04:59:05PM +0530, Anuj Gupta wrote:
> +struct uio_meta {
> +	meta_flags_t	flags;
> +	u16		app_tag;
> +	u32		seed;
> +	struct iov_iter iter;
> +};

Is the seed used for anything other than the kernel's t10 generation and
verification? It looks like that's all it is for today, and that part is
skipped for userspace metadata, so I'm not sure we need it.

I know it's been used for passthrough commands since nvme started
supporitng it, but I don't see why the driver ever bothered. I think it
wasn't necessary and we've been carrying it forward ever since.

