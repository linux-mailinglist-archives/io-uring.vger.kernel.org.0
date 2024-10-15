Return-Path: <io-uring+bounces-3682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E8C99DC48
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 04:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33A91B21462
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 02:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D10A249F9;
	Tue, 15 Oct 2024 02:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHGJNDjB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63E3184F
	for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 02:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728959492; cv=none; b=TJ0/pSm3yve/Murox2u+O7Tdd32HiH6SbCOGBIXB62ys9kSaj4tywAWsb08kYuV1soRhCCHcb3NVEbTR9fHChkiUQt6hUemyAXEreVn29Rh2wFazNRkqda5TWUKVxEg/LJO1xoJ4wKOvMZgnECX0rZgXmQz8BHVhyn2VEIPgzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728959492; c=relaxed/simple;
	bh=Eht3kaE8TPAUFrMmB2wYBK16NKLPLwgMkqIgrhPGAHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=js/aR9dovbz2nlI3JGRgwOpu9ZpuXzrmdBcayBgVP9wRpsT0gRbXQNTHne4vMk6pCfCtRr+o/2RG7uJz7cNEaq5LFJb8/OQ15EV8LjmvW3qr+eYofNuMcEBWw068IJOT0gULOExjVRyFZ1QjfH/Lny57LgjT5u1+TpXay/Y6ITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHGJNDjB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728959489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d92jJ6kW+oBkOfqEEGf2E2wbMnllb1zRN+YLBEPwhFs=;
	b=gHGJNDjBxTIQKRz2GxgnZ37hI03TNk0pPcEoGLQbMtsiGEHcLAR5M6U2Na15kCHaAgDCmM
	mGA1pKVdLJ+ZgcJpcrD0PGvqQZShkuMcrPVD1t1svTxyl6gsRez/u5ffPLK6kkLgHddD0V
	xNcegJyxSgMRejWWQ9w8QPGNjnTOoRg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-zeZ5XHc8O_a_kjd-wL27mQ-1; Mon,
 14 Oct 2024 22:31:25 -0400
X-MC-Unique: zeZ5XHc8O_a_kjd-wL27mQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E52EE19560A3;
	Tue, 15 Oct 2024 02:31:23 +0000 (UTC)
Received: from fedora (unknown [10.72.116.119])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6266519560AE;
	Tue, 15 Oct 2024 02:31:16 +0000 (UTC)
Date: Tue, 15 Oct 2024 10:31:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>,
	Hamza Mahfooz <someguy@effective-light.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	linux-raid@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, ming.lei@redhat.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <Zw3T7-6pxGelQX_s@fedora>
References: <ZwxzdWmYcBK27mUs@fedora>
 <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
 <20241014074151.GA22419@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014074151.GA22419@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Oct 14, 2024 at 09:41:51AM +0200, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 09:23:14AM +0200, Hannes Reinecke wrote:
> >> 3) some storage utilities
> >> - dm thin provisioning utility of thin_check
> >> - `dt`(https://github.com/RobinTMiller/dt)
> >>
> >> I looks like same user buffer is used in more than 1 dio.
> >>
> >> 4) some self cooked test code which does same thing with 1)
> >>
> >> In storage stack, the buffer provider is far away from the actual DMA
> >> controller operating code, which doesn't have the knowledge if
> >> DMA_ATTR_SKIP_CPU_SYNC should be set.
> >>
> >> And suggestions for avoiding this noise?
> >>
> > Can you check if this is the NULL page? Operations like 'discard' will 
> > create bios with several bvecs all pointing to the same NULL page.
> > That would be the most obvious culprit.
> 
> The only case I fully understand without looking into the details
> is raid1, and that will obviously map the same data multiple times
> because it writes it out multiple time.  Now mapping a buffer
> multiple times for a DMA_TO_DEVICE is relatively harmless in
> practice as the data is transferred to the device, but it it
> still breaks the dma buffer ownership model in the dma which is
> really helpful to find bugs where people don't think about this
> at all.  Not sure if there is any good solution here.
>

Another related topic:

Recently direct IO buffer alignment changes to just respect DMA
controller alignment which is often too relax, such as dma_alignment
is just 3 for many host controllers, then two direct IO buffers may
cross same DMA mapping cache line.

Is this one real problem?


Thanks,
Ming


