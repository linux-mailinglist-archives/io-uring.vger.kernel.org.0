Return-Path: <io-uring+bounces-8600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C91AF7747
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 16:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16842177910
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 14:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F772EA474;
	Thu,  3 Jul 2025 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BSmjL+hK"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826B2EA178;
	Thu,  3 Jul 2025 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552626; cv=none; b=uAwLqUBRS/RwnUhWV31kutRcRr3NRykiQ5eWzGcMKkB25IjIQirvZZMfxWMhpeluz1hPvK2gsB7f9iZwbkA7f6Iffiml4CmwevxQskuARsos0m9EJDqLRaJ+nQgRszMuGliTpCpn7/qmsoJI4RfGpA+cc3gn/u4RuM/SLJu7CyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552626; c=relaxed/simple;
	bh=UqCHVI6XlSbC/TOR9oByBhaP+pzp8e91+zTZgpxb5M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVPBFolUpgJGutzw72yJ+iMy89qitWWdzHAFqMBziFDz+02ERpXlNaC48Yq9qjyjKQvJ4cEiLMZkABNLap+W9IlrRY2XkbS88rU2TcyKTinYHHsGRUPjNsfM7ha0hPOWltEurtyq4nzhdg0743E+p2hvj+6fGBXdpnMUPSsMptE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BSmjL+hK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fdwQ7VoCdy9EDfz8qdHjHeqLPa9H8WWCarPWLj8vDE4=; b=BSmjL+hKMq+uETspb9lUMyEHQw
	0bxFAeC2GxGIerv0/y1S/jtyOo7o3HC1cIdgrFj/cACDXHADEyUAeyoUOrq8ommeAQlnCoyHHfpHY
	cLukEWcTdu23KMrC3Bql3cKQxdIc43/VGAmkIgT3U6kex/lPTpXOZ9DU9iScomTE/fckWN1rCQl3w
	wUQm0VQRKQr9LO+52bCrAajjRBNfF83RTFXcqDrCuhW7+pKKDu8l5dOoQOVIuuCE79gDxCxnmPW5d
	+NxJ9PmSYP0do/VK/Svlnk+pKid4eQ7cwDTOxHQ28VByz6yhjhnHBPZJW2Fk7L5l0D0rt+o48bZSW
	YHaTLpvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uXKql-0000000BeR1-44Zb;
	Thu, 03 Jul 2025 14:23:43 +0000
Date: Thu, 3 Jul 2025 07:23:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>, David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC 00/12] io_uring dmabuf read/write support
Message-ID: <aGaSb5rpLD9uc1IK@infradead.org>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[Note: it would be really useful to Cc all relevant maintainers]

On Fri, Jun 27, 2025 at 04:10:27PM +0100, Pavel Begunkov wrote:
> This series implements it for read/write io_uring requests. The uAPI
> looks similar to normal registered buffers, the user will need to
> register a dmabuf in io_uring first and then use it as any other
> registered buffer. On registration the user also specifies a file
> to map the dmabuf for.

Just commenting from the in-kernel POV here, where the interface
feels wrong.

You can't just expose 'the DMA device' up file operations, because
there can be and often is more than one.  Similarly stuffing a
dma_addr_t into an iovec is rather dangerous.

The model that should work much better is to have file operations
to attach to / detach from a dma_buf, and then have an iter that
specifies a dmabuf and offsets into.  That way the code behind the
file operations can forward the attachment to all the needed
devices (including more/less while it remains attached to the file)
and can pick the right dma address for each device.

I also remember some discussion that new dma-buf importers should
use the dynamic imported model for long-term imports, but as I'm
everything but an expert in that area I'll let the dma-buf folks
speak.


