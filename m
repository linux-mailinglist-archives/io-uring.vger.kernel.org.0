Return-Path: <io-uring+bounces-11359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2391FCF07C2
	for <lists+io-uring@lfdr.de>; Sun, 04 Jan 2026 02:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2346A30052D6
	for <lists+io-uring@lfdr.de>; Sun,  4 Jan 2026 01:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3277E1F8AC8;
	Sun,  4 Jan 2026 01:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9bEmwvH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732E1F03DE
	for <io-uring@vger.kernel.org>; Sun,  4 Jan 2026 01:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767491001; cv=none; b=HeaTtltN2J5mh1eCTmtOr5XYMBv1DHWsQ+kRUBhEwpyILNKQkt4Aj9xTwH72tJc5V8MPly+fSdNgZ6gVn3Cds1SDjxKs+m1vVugVmMO/6gGy4Pl5ZPRv+YFs5oYRK3Mevte8u1XuoH+kLNXIO4VjIUfHM86HkKdzZCNhZJr9btg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767491001; c=relaxed/simple;
	bh=l5EbRgM9bVZ8pV8NkSF2wo5G6NkqvfiuJxGmKxmW7rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNJtZjZL7zDxkI4kWk78SnMqglOJfuYdNfN2Um7clrH6chRf703c2ft+A4k8pkQ7ezOpu3wCh6+vuXJziudbd7AIqKG+9qu6aShjldszFA//EHHl5rgSEmkZpKM/3fbtOtMDoVwKnHsGwJJs4LvBT0qYrz9FyisE2FIsVGGiIR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9bEmwvH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767490998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOHCJ6ws2PdEVpdMzUbfxY52ykfjA/AadGdfIrG4o2w=;
	b=U9bEmwvHPK8Lk13UVDsT7YluTsNWUi8kEqL4pw1ZjIQJbC+fL4XaG6LrXLkAUyRt7w+Irg
	T7u2Wts0tHBoenJMe7xCVHHH99cS/pUJno1ZVDflB8fyCw98iBdK1QtkSQmKPm/D1v9oXP
	dSsxDjWQhmq6KlM4RPo6qVbMq9hyi8A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-8xYrOUkAPh6aSHp3iCO0tw-1; Sat,
 03 Jan 2026 20:43:15 -0500
X-MC-Unique: 8xYrOUkAPh6aSHp3iCO0tw-1
X-Mimecast-MFC-AGG-ID: 8xYrOUkAPh6aSHp3iCO0tw_1767490993
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62C001956080;
	Sun,  4 Jan 2026 01:43:12 +0000 (UTC)
Received: from fedora (unknown [10.72.116.132])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36773180044F;
	Sun,  4 Jan 2026 01:43:00 +0000 (UTC)
Date: Sun, 4 Jan 2026 09:42:55 +0800
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
Message-ID: <aVnFnzRYWC_Y5zHg@fedora>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
 <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
 <20251204110709.GA22971@lst.de>
 <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
 <20251204131025.GA26860@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251204131025.GA26860@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Dec 04, 2025 at 02:10:25PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 12:09:46PM +0100, Christian König wrote:
> > > I find the naming pretty confusing a well.  But what this does is to
> > > tell the file system/driver that it should expect a future
> > > read_iter/write_iter operation that takes data from / puts data into
> > > the dmabuf passed to this operation.
> > 
> > That explanation makes much more sense.
> > 
> > The remaining question is why does the underlying file system / driver
> > needs to know that it will get addresses from a DMA-buf?
> 
> This eventually ends up calling dma_buf_dynamic_attach and provides
> a way to find the dma_buf_attachment later in the I/O path.

Maybe it can be named as ->dma_buf_attach()?  For wiring dma-buf and the
importer side(nvme).

But I am wondering why not make it as one subsystem interface, such as nvme
ioctl, then the whole implementation can be simplified a lot. It is reasonable
because subsystem is exactly the side for consuming/importing the dma-buf.
 

Thanks, 
Ming


