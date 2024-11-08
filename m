Return-Path: <io-uring+bounces-4565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E33E9C211B
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 16:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54B331F21861
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 15:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BEB21B43B;
	Fri,  8 Nov 2024 15:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbzJMLFh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D46521B42E;
	Fri,  8 Nov 2024 15:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081093; cv=none; b=oSEacQi74yNhKmI9G5aGZ3/iYpizXcPBYc4QETn5MKt503fWNM5Jy1AmqrEjcg7iiVHwSZ9x5TF9AWY/7PooKpR/LQ64mI3sale3Mx0hNw/jW45X+bIa55SKHJ+YW5az3cJ2GZO+W1p65rm+HF/da9p04RrtQF96I6EW6XMNzOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081093; c=relaxed/simple;
	bh=mOMvtGK40YQ3w77ykrXsI3BGNXP4DVCCfcRaNvLRXC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDguCtixnm7qfemKEk3jVVTkMr3yZXNBkjFMH2dCfhcC/W8+Zla6J5JCTa4nMEeKiyNSa8ThQkQJxdD33ik3DEc8fFFh+egOPZdR/Gc9fhhsQxdKpPIW3UpS+G07sgSffBwW1w+LOyfGwDAId19DWYIVC7p0IFPws+cCtxhQrC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbzJMLFh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3747C4CECD;
	Fri,  8 Nov 2024 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731081093;
	bh=mOMvtGK40YQ3w77ykrXsI3BGNXP4DVCCfcRaNvLRXC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WbzJMLFhJ8MFKHcEYj94OUODGQgdpKtvpquZXfUUW/usquKC6kMnB0VWo6b5HPyyH
	 bld0Af7AjvcwnKBQbk5rdCymUKo2uErcYMDs8jJoW1SkR2ajpIDZoLdmnbCoJgcX8o
	 Jx6qtKbNNtuo1oBAJ5e0ylhkMweLyh7QHjTjPAZdvNA+G6ylvpUbHhx3ZqetevQute
	 h0vxxkeeb0XlGAjcYGeh7HldbzjimC+He1taEWYRbqIlhMxKcZdM72Qsk9xKpJX0m4
	 mJHKMhlFFB7/BKLrF6kPr/Cb6PoOZ9aW34B3rP20bKbWSChtXksfYE+zUts+/8/mXC
	 PSth57QGQ/Vdw==
Date: Fri, 8 Nov 2024 08:51:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Zy4zgwYKB1f6McTH@kbusch-mbp>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241105155014.GA7310@lst.de>
 <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108141852.GA6578@lst.de>

On Fri, Nov 08, 2024 at 03:18:52PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 07, 2024 at 01:36:35PM -0700, Keith Busch wrote:
> > The zone block support all looks pretty neat, but I think you're making
> > this harder than necessary to support streams. You don't need to treat
> > these like a sequential write device. The controller side does its own
> > garbage collection, so no need to duplicate the effort on the host. And
> > it looks like the host side gc potentially merges multiple streams into
> > a single gc stream, so that's probably not desirable.
> 
> We're not really duplicating much.  Writing sequential is pretty easy,
> and tracking reclaim units separately means you need another tracking
> data structure, and either that or the LBA one is always going to be
> badly fragmented if they aren't the same.

You're getting fragmentation anyway, which is why you had to implement
gc. You're just shifting who gets to deal with it from the controller to
the host. The host is further from the media, so you're starting from a
disadvantage. The host gc implementation would have to be quite a bit
better to justify the link and memory usage necessary for the copies
(...queue a copy-offload discussion? oom?).

This xfs implementation also has logic to recover from a power fail. The
device already does that if you use the LBA abstraction instead of
tracking sequential write pointers and free blocks.

I think you are underestimating the duplication of efforts going on
here.

