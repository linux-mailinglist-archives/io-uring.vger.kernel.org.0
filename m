Return-Path: <io-uring+bounces-4118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC21F9B4DC4
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63D231F234B0
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E2B19309C;
	Tue, 29 Oct 2024 15:23:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF7C21348;
	Tue, 29 Oct 2024 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215432; cv=none; b=VS2w1A+1MKOaSaWqMLf7O50jvyxAd92rjbbfyUaE9l7ErL6M0Z1TAVnwNpkQpUerLgyYMHRBOpOmXoEgZT9UU7LYYcL+qfmVF/iIGV38Ka6pwdw8rgubmVW3ana4CpkUVJKJ06N0BPgCDRteYuYe/IOJypKvxy5myZUrGSSy//Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215432; c=relaxed/simple;
	bh=KiX9ftutymjXrPfyQK47Opfcb8TonDqjsiKhTwvfVdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZlzxR0QbU0l/UONz2yHSEwzi8BG6Ns4Z5TBBz4asOiDrI6k+aX0ezkwusv6CfgdYhP7rungwgY3FhWVj8ZPtwTRV26mMSQQFkNXvsJlKzcXpir5Pvyv0MoLDNY1lpHzowt2h/r055OplfduMEZpaMMWMT674dH4vkUJIax9Pr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E913227A88; Tue, 29 Oct 2024 16:23:45 +0100 (CET)
Date: Tue, 29 Oct 2024 16:23:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
Message-ID: <20241029152345.GA26431@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151922.459139-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 08:19:17AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> When multiple partitions are used, you may want to enforce different
> subsets of the available write hints for each partition. Provide a
> bitmap attribute of the available write hints, and allow an admin to
> write a different mask to set the partition's allowed write hints.

This still offers all hints to all partitions by default, which still
breaks all use cases where you have actual users of the stream separation
on multiple paritions.

Please assign either all resources to the first partition and none to
the others (probably the easiest and useful for the most common use
case) or split it evenly.

Note that the bdev_max_streams value also needs to be adjusted to only
return the number of streams actually available to a partition.


