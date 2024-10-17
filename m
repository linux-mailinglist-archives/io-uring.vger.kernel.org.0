Return-Path: <io-uring+bounces-3761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E149A1C37
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 09:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABF4F1F268DA
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 07:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07C71D0E3A;
	Thu, 17 Oct 2024 07:58:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E34D1D079F;
	Thu, 17 Oct 2024 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729151928; cv=none; b=Ss9LGvk6t4ycTxmuLpf3KeqHF24teuioPD1bhpkxtkUy89W0aOPOT9ObSyOaObD7mvUebboPHBwkGAy6q/ffs0jfbkhDmZW7hHOxIRucHIPFfQAoKPaHt4pXAeVlYIOX/Hb/fvPOU6r/fyYSC2mLu7QfxdH3QHUFEWpRT7wv6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729151928; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVO/tIwtHBahJNm39+Wzn6bJdmJ4ONj0q/xeBJF++U78ztnkHe1/i+Smz2HrDo3DDyI3TiwV9khJ1uXpqNauCEgSTMXSRiKn2bxuxNswaAl6xTTRTusm8URwP1+AqU4qyKwEDOHE90KDCcJhH4GqM2r3sc8RzVt8+3zm+XAWC+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 07EC1227A87; Thu, 17 Oct 2024 09:58:42 +0200 (CEST)
Date: Thu, 17 Oct 2024 09:58:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 05/11] fs: introduce IOCB_HAS_METADATA for metadata
Message-ID: <20241017075841.GC25343@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113743epcas5p3b4092c938d8795cea666ab4e6baf4aa9@epcas5p3.samsung.com> <20241016112912.63542-6-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-6-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


