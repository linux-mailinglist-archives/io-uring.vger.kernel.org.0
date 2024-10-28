Return-Path: <io-uring+bounces-4062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D639C9B2F6F
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 12:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99849282334
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 11:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90031D3648;
	Mon, 28 Oct 2024 11:58:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD4189B8D;
	Mon, 28 Oct 2024 11:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730116693; cv=none; b=jBa2gJuvj4WRmU17bfTFg0hOMSNnxqni4B8JZEJ9+PIlhyfywF3Yi82JEaQwHK72O8+kygsasWoCJR1Ui+sF8BkAauQZr7fJ78mVBo2ypEcE6TCeMcYOJ8S/BmstVQa5FbPTz4pr1iVoAd6cQny3zTecHAPu6/oGMyTG+iaG5Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730116693; c=relaxed/simple;
	bh=/snqQ8hB85YP2HXCoXcwxeyRuiKR6bcVDfyJNgNsUMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4gF4FjA3kKMv4XwaYDLdjbJjmtS4H0blXE/G/9029tNJZMhKp9AYqaxH0rJFuLjfbBTggGjZ/+7BLv+PL6loxngmFe31+3j/1wgOyto0DM5bRAMWzOvM/XFy4HF3PaQ/BZxy74D1m1wAAibdcXvcGPnr/2W3/ap1MT+vriRU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2B2368BFE; Mon, 28 Oct 2024 12:58:05 +0100 (CET)
Date: Mon, 28 Oct 2024 12:58:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv9 3/7] block: allow ability to limit partition write
 hints
Message-ID: <20241028115805.GD8517@lst.de>
References: <20241025213645.3464331-1-kbusch@meta.com> <20241025213645.3464331-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025213645.3464331-4-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 25, 2024 at 02:36:41PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> When multiple partitions are used, you may want to enforce different
> subsets of the available write hints for each partition. Provide a
> bitmap attribute of the available write hints, and allow an admin to
> write a different mask to set the partition's allowed write hints.

Trying my best Greg impersonator voice: This needs to be documented
in Documentation/ABI/stable/sysfs-block.

That would have also helped me understanding it.  AFAIK the split here
is an opt-in, which means the use case I explained in the previous
case would still not work out of the box, right?

> +	max_write_hints = bdev_max_write_hints(bdev);
> +	if (max_write_hints) {
> +		int size = BITS_TO_LONGS(max_write_hints) * sizeof(long);
> +
> +		bdev->write_hint_mask = kmalloc(size, GFP_KERNEL);
> +		if (!bdev->write_hint_mask) {
> +			free_percpu(bdev->bd_stats);
> +			iput(inode);
> +			return NULL;
> +		}
> +		memset(bdev->write_hint_mask, 0xff, size);
> +	}

This could simply use bitmap_alloc().  Similarly the other uses
would probably benefit from using the bitmap API.

> +	struct block_device *bdev = dev_to_bdev(dev);
> +	unsigned short max_write_hints = bdev_max_write_hints(bdev);
> +
> +	if (max_write_hints)
> +		return sprintf(buf, "%*pb\n", max_write_hints, bdev->write_hint_mask);
> +	else
> +		return sprintf(buf, "0");

No need for the else.  And if you write this as:

	if (!max_write_hints)
		return sprintf(buf, "0");
	return sprintf(buf, "%*pb\n", max_write_hints, bdev->write_hint_mask);

you'd also avoid the overly long line.

> +
> +static ssize_t part_write_hint_mask_store(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	struct block_device *bdev = dev_to_bdev(dev);
> +	unsigned short max_write_hints = bdev_max_write_hints(bdev);
> +	unsigned long *new_mask;
> +	int size;
> +
> +	if (!max_write_hints)
> +		return count;
> +
> +	size = BITS_TO_LONGS(max_write_hints) * sizeof(long);
> +	new_mask = kzalloc(size, GFP_KERNEL);
> +	if (!new_mask)
> +		return -ENOMEM;
> +
> +	bitmap_parse(buf, count, new_mask, max_write_hints);
> +	bitmap_copy(bdev->write_hint_mask, new_mask, max_write_hints);

What protects access to bdev->write_hint_mask?


