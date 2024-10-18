Return-Path: <io-uring+bounces-3801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BEA9A346F
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 07:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE9EE284FB8
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 05:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DCB17BB38;
	Fri, 18 Oct 2024 05:46:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9316A956;
	Fri, 18 Oct 2024 05:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230410; cv=none; b=V2aIH2daMhnYWkWUwT84bsllw7d9gsYUWLqzGH3wM2w09mlfAKqn9kjG3NXJIc9cbfn3fW5+OGL4n3hcf0NXVSBrUsiPD5cp6gUCwYtlNAT4dwv+92jJf/SYCeq1MJ9VV4p2IX54SV7cqcdEu+nx/Aoj56+xnIG/8PuZMTDED0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230410; c=relaxed/simple;
	bh=VV3tg4VoXO9k9cXc+scsHom6zLncU1Z/kb5ocBjvncc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0iTTLHHf14fGAn1hWgvo7hqQl696Rc9wwDj4NvmqRsImFNQuN2fq6n6KIlM1kGFVu8hkcFYgGVcQh+3OI6VLnKVfptkSnSZGwpvc/bxGEP1rRKZZ1eizk74PRzsTP/NuCjnNi268rYOjB7Gr8T/oHjO95bg3Zsx84lbqZt5JXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D4E3227AAF; Fri, 18 Oct 2024 07:46:44 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:46:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
Message-ID: <20241018054643.GA20262@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017160937.2283225-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 09:09:33AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is still backwards compatible with lifetime hints. It just doesn't
> constrain the hints to that definition.

So in the end we'll end up with two uses of it - the existing 5
temperature hints and the new stream separation.  I think it
would be cleaner to make it a union, but I don't care that
strongly.

But we probably want a way to distinguish which one is supported.

E.g. for SCSI we set a net BLK_FEAT_WRITE_HINTS, for NVMe we'll set
BLK_FEAT_STREAM_SEPARATION.

Either way this should probably be the first patch in the series.

