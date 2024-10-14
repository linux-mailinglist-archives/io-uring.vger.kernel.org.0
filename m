Return-Path: <io-uring+bounces-3648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB3D99C1B2
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 09:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D72C1F223EA
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 07:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89601494DE;
	Mon, 14 Oct 2024 07:41:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E415231CA6;
	Mon, 14 Oct 2024 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728891719; cv=none; b=b9Bdv+KBnawTMw2xnjwAMdUqUyzjF7X216v31clF8j1LdvdPzwoWBQAcauihQXxqhWuEm9qJ6EW/XJ5PlHF+NDRDCgGHJgrblVDMmrt6eBYRkF8LPn8Fcp/l/fRFGt72RHjHa5e+AykSJI7w/hGNJZWlvJ9/eBvHOmwVY2efhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728891719; c=relaxed/simple;
	bh=MBeYVI8AF27boE14kv/tqJbI4GfJ8Eto/zOJNuTNSyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuW0nEsvd/wp5Jo05tHkuGcaua7LBmL9roqmwDM2yeCfFQOKvkMZ2iwCCX9cLLX2LBwFA9FxUT9hUr6qkEdIGFcLJ/f4t887/PeMfmcOjGWeCR37+J42WT5l+zjlu1lKoC60U1pyYo/EjG7TN5K51FWu51n3IF6XeR8MMcU/JUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BACF6227AB7; Mon, 14 Oct 2024 09:41:51 +0200 (CEST)
Date: Mon, 14 Oct 2024 09:41:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>,
	Hamza Mahfooz <someguy@effective-light.com>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	linux-raid@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <20241014074151.GA22419@lst.de>
References: <ZwxzdWmYcBK27mUs@fedora> <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 14, 2024 at 09:23:14AM +0200, Hannes Reinecke wrote:
>> 3) some storage utilities
>> - dm thin provisioning utility of thin_check
>> - `dt`(https://github.com/RobinTMiller/dt)
>>
>> I looks like same user buffer is used in more than 1 dio.
>>
>> 4) some self cooked test code which does same thing with 1)
>>
>> In storage stack, the buffer provider is far away from the actual DMA
>> controller operating code, which doesn't have the knowledge if
>> DMA_ATTR_SKIP_CPU_SYNC should be set.
>>
>> And suggestions for avoiding this noise?
>>
> Can you check if this is the NULL page? Operations like 'discard' will 
> create bios with several bvecs all pointing to the same NULL page.
> That would be the most obvious culprit.

The only case I fully understand without looking into the details
is raid1, and that will obviously map the same data multiple times
because it writes it out multiple time.  Now mapping a buffer
multiple times for a DMA_TO_DEVICE is relatively harmless in
practice as the data is transferred to the device, but it it
still breaks the dma buffer ownership model in the dma which is
really helpful to find bugs where people don't think about this
at all.  Not sure if there is any good solution here.

