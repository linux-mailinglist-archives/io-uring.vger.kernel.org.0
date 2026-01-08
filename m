Return-Path: <io-uring+bounces-11441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F7DD00A41
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 03:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BFC2D300EA28
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 02:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A412B255E43;
	Thu,  8 Jan 2026 02:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KH1jfhUx"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AC3252917
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767838788; cv=none; b=MXu/UCyVYupxjGYMOrhS64rUZgXkqdNcesz6GY3W6rX77762I0mm0do8xX4KKRbt5jVuALn5F3by+yXlbh2LnDE2dXloekuUA5uSlKDHZlKr6ab21xUAvpK+vuOR4zV0Mc2ELNUqqkpSm7MgWhzNl2MnIlupX4ssuYdKhWzs6uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767838788; c=relaxed/simple;
	bh=izpliozQQ6AAmjcpKXMDWqRUBVV+mLb3CvrOtT/maOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCEB1BPHuwVMJn2jyhWaNm2OEmgHlH3aHjjkUBZemeJGLeMZ7fizI7TwT9itvqmlBZEiH09j33tRKKJ8cBDvv328o1ImZrDrOyOd0GBZ3TOJifAedRMHjcO2bZ0sJs2JJz5vBMCh4UszpqAvglzRdwfQfU7cqsfNYdV3G+4mDwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KH1jfhUx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767838785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e58AvOofkAZMERAjCRNSCzg+OQ2/rgznWXJZC9l5yys=;
	b=KH1jfhUxx9X6h7lRZjlruvTNgFSR1v9MQrfnp3OwabPTNLMTvbT2gPH8ym9I77FhGf3D/j
	FPGSkBvVbdZKr8VzzLM6HdLH7azHlGpCZfjVubXTcuNX8qYQOi0zYfP9vhz46RQh/zMK13
	PqW4GTNXRJKVJiRncBrDpOOv8fs0c7Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-C5u5R4y1Mv68vhPM4j7ZUg-1; Wed,
 07 Jan 2026 21:19:39 -0500
X-MC-Unique: C5u5R4y1Mv68vhPM4j7ZUg-1
X-Mimecast-MFC-AGG-ID: C5u5R4y1Mv68vhPM4j7ZUg_1767838776
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C016D18005A7;
	Thu,  8 Jan 2026 02:19:34 +0000 (UTC)
Received: from fedora (unknown [10.72.116.164])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FDBC19560A2;
	Thu,  8 Jan 2026 02:19:23 +0000 (UTC)
Date: Thu, 8 Jan 2026 10:19:18 +0800
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
Message-ID: <aV8UJvkt7VGzHjxS@fedora>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
 <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
 <20251204110709.GA22971@lst.de>
 <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
 <20251204131025.GA26860@lst.de>
 <aVnFnzRYWC_Y5zHg@fedora>
 <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com>
 <20260107160151.GA21887@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260107160151.GA21887@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 07, 2026 at 05:01:51PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 07, 2026 at 04:56:05PM +0100, Christian König wrote:
> > > But I am wondering why not make it as one subsystem interface, such as nvme
> > > ioctl, then the whole implementation can be simplified a lot. It is reasonable
> > > because subsystem is exactly the side for consuming/importing the dma-buf.
> > 
> > Yeah that it might be better if it's more nvme specific came to me as well.
> 
> The feature is in no way nvme specific.  nvme is just the initial
> underlying driver.  It makes total sense to support this for any high
> performance block device, and to pass it through file systems.

But why does FS care the dma buffer attachment? Since high performance host controller
is exactly the dma buffer attachment point.

If the callback is added in `struct file_operations` for wiring dma buffer
and the importer(host contrller), you will see it is hard to let it cross device
mapper/raid or other stackable block devices.

Thanks, 
Ming


