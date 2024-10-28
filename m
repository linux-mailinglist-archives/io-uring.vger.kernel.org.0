Return-Path: <io-uring+bounces-4060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 536FE9B2F47
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 12:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D830BB209CC
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 11:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A74E1D47CD;
	Mon, 28 Oct 2024 11:51:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6B61BDA8C;
	Mon, 28 Oct 2024 11:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730116307; cv=none; b=US6gvfW5vSiSAGwYV7QoOn6H4K4Q6eZNXh1+mjHW9OgQvTIHapMSySaB48zH09g3D6PTzyi1xlLvvBn8IWcOnlDMaZ/BVhKKojC/dfSimjXDeJgnruRFf4iH4q0mmh6nrQgBIKAI4iC6E1E39TfncfpyzZN/UrUC1uwiuTcwqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730116307; c=relaxed/simple;
	bh=6iynPDxUd9xeqSQxSiZbi0nDOsfusDZloPOmVpJXuQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agniITK6bu+DIPDYcSBLd+/kB1Cb8oQjahiAj/xXUXj+HbKj/lYK3xt/MDGmQJsQswPs1PkTPsiG9kes+ksWhvUkoegKPPkGjDC5CFeyiyreCF54a8OZBwd0vfSnHlQYg+V1HuWL+ZbMv6ZkQ+O2bdJ4MsQ6IN+CSiJ3fSlKdSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12F60227AAC; Mon, 28 Oct 2024 12:51:34 +0100 (CET)
Date: Mon, 28 Oct 2024 12:51:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv9 2/7] block: introduce max_write_hints queue limit
Message-ID: <20241028115132.GB8517@lst.de>
References: <20241025213645.3464331-1-kbusch@meta.com> <20241025213645.3464331-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025213645.3464331-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 25, 2024 at 02:36:40PM -0700, Keith Busch wrote:
> +static inline unsigned short bdev_max_write_hints(struct block_device *bdev)
> +{
> +	return queue_max_write_hints(bdev_get_queue(bdev));
> +}

As pointed out by Bart last time, you can't simply give the write hints
to all block device.  Assume we'd want to wire up the write stream based
separate to f2fs (which btw would be a good demonstration), and you'd
have two different f2fs file systems on separate partitions that'd
now start sharing the write streams if they simply started from stream
1.  Same for our pending XFS data placement work.


