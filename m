Return-Path: <io-uring+bounces-11555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8851FD06CD3
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 03:11:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C5D304919F
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 02:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8F8274B46;
	Fri,  9 Jan 2026 02:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoMEMf1O"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE69273D84
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 02:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767924690; cv=none; b=YhIYmhd9+LnC7R6XuIi5+kBoJW6KVYlxuC/JFJD3nGh2BlUAPzyxsnTojKOBSpMLjeQowxsweUExR9P6r0RwaJC9kZ+WQAtZgRLUpaguZaALbTld9t5Ikrq5EDefarnAJ5CwSGtQK4ZrXO9fr5u+QuNV+eGVvKZE0LXisIt+vQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767924690; c=relaxed/simple;
	bh=4xHCKtZXDRo7uO8OxrPGMlVhxh8phR1fHCKcxDBXTjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHPUvfeBOT5IJ2SEgTbrYArXp+MI42q4G8lpt3qmaDSkeVIY9fm6mR2Hvlv6J/4zBKr4Bgf2OX3KTH/HHpF5dtLLBY7IApTqEx45VN0dwNAVyjBTHuUVk0pEFTDq6dHX+j1pTYYjnu3O6KFPGnzwFQMU5u8RD62fNPmDcYHbYoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoMEMf1O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767924686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09fZuRtKBthvUPFZRfmDU+5G5cxlC+xjTolnVnh0EhI=;
	b=UoMEMf1O40LkIi6WANFNaI48z5sSTvurS70UcDmTVf+yt5szkHp2MST3ee/KR8Kvw3grfA
	plQqPfhGjFQ5KmotLcHbmy468h2sW52B7eEfDiTQVnGHGkLViFaxJm8mSviHC17SuExv8k
	liyt8WXRWad4aDfPnjqKFN6iBqTPj2I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-A_n-5HUKMWaEy_K0o4HrYg-1; Thu,
 08 Jan 2026 21:11:20 -0500
X-MC-Unique: A_n-5HUKMWaEy_K0o4HrYg-1
X-Mimecast-MFC-AGG-ID: A_n-5HUKMWaEy_K0o4HrYg_1767924676
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CBA9195608F;
	Fri,  9 Jan 2026 02:11:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.172])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4C1230002D5;
	Fri,  9 Jan 2026 02:11:02 +0000 (UTC)
Date: Fri, 9 Jan 2026 10:10:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
Message-ID: <aWBjsa2RZ_uaO9Ns@fedora>
References: <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
 <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
 <20251204110709.GA22971@lst.de>
 <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
 <20251204131025.GA26860@lst.de>
 <aVnFnzRYWC_Y5zHg@fedora>
 <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com>
 <20260107160151.GA21887@lst.de>
 <aV8UJvkt7VGzHjxS@fedora>
 <20260108101703.GA24709@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108101703.GA24709@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jan 08, 2026 at 11:17:03AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 08, 2026 at 10:19:18AM +0800, Ming Lei wrote:
> > > The feature is in no way nvme specific.  nvme is just the initial
> > > underlying driver.  It makes total sense to support this for any high
> > > performance block device, and to pass it through file systems.
> > 
> > But why does FS care the dma buffer attachment? Since high performance
> > host controller is exactly the dma buffer attachment point.
> 
> I can't parse what you're trying to say here.

dma buffer attachment is simply none of FS's business.

> 
> > If the callback is added in `struct file_operations` for wiring dma buffer
> > and the importer(host contrller), you will see it is hard to let it cross device
> > mapper/raid or other stackable block devices.
> 
> Why?
> 
> But even when not stacking, the registration still needs to go
> through the file system even for a single device, never mind multiple
> controlled by the file system.

dma_buf can have multiple importers, so why does it have to go through FS for
single device only?

If the registered buffer is attached to single device before going
through FS, it can not support stacking block device, and it can't or not
easily to use for multiple block device, no matter if they are behind same
host controller or multiple.


Thanks,
Ming


