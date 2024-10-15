Return-Path: <io-uring+bounces-3684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D357299DD4C
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 06:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98E03282720
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 04:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD231741D4;
	Tue, 15 Oct 2024 04:54:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A5F16CD1D;
	Tue, 15 Oct 2024 04:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728968063; cv=none; b=U/xo6bltDzB5vAmBgleLeZjVVEfNdHb0tT4HMNU3EjX7xwy+KYUmodPe/Xf4FuEDEaic/TrS5gi9A6ZBG9FyyUYXP+k8qfDTcmxHiJaU9oSQF7u304Z4cYYcce/LWvYaga/rYd7cwWkoFj5dvmnjmcDW54Rqv+xDqzMTZOdtZNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728968063; c=relaxed/simple;
	bh=N539zsQoQKhL2JB2HwvGtxWrBWZgeP7JWYixIKElIeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5i5tpDRYQbgOY7erYma0/XZ9MNaFITUENFlIkzhSlQNRoqMqgRYhWoOu+so0lS4q1uz3BAj3Xuv3l5Vk3fSXqNFaSG6uFWs6Wm2K6YjAeFmZGFIDKII7WHB54kLfoWrJ8wiWOZDVlJkzOu9uHro8zL6akwDxVsE/747ZjCepRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41B86227AA8; Tue, 15 Oct 2024 06:54:14 +0200 (CEST)
Date: Tue, 15 Oct 2024 06:54:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Hamza Mahfooz <someguy@effective-light.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	linux-raid@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <20241015045413.GA18058@lst.de>
References: <ZwxzdWmYcBK27mUs@fedora> <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de> <20241014074151.GA22419@lst.de> <ZwzPDU5Lgt6MbpYt@fedora> <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 14, 2024 at 07:09:08PM +0100, Robin Murphy wrote:
>>> The only case I fully understand without looking into the details
>>> is raid1, and that will obviously map the same data multiple times
>>
>> The other cases should be concurrent DIOs on same userspace buffer.
>
> active_cacheline_insert() does already bail out for DMA_TO_DEVICE, so it 
> returning -EEXIST to tickle the warning would seem to genuinely imply these 
> are DMA mappings requesting to *write* the same cacheline concurrently, 
> which is indeed broken in general.

Yes, active_cacheline_insert only complains for FROM_DEVICE or
BIDIRECTIONAL mappings.  I can't see how raid 1 would trigger that
given that it only reads from one leg at a time.

Ming, can you look a bit more into what is happening here?


