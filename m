Return-Path: <io-uring+bounces-6586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E27D7A3DE6B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 16:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59F01188FC9B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039CC1D61A3;
	Thu, 20 Feb 2025 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJeYKIqW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1E61FCE;
	Thu, 20 Feb 2025 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740065082; cv=none; b=e2SeE4gzLEdrHjORGCFgbts6SN3jJJsyuwpaN9BupX7ulgsL/9Ugr1ua0MQzBz1dqbo2SVH+uZo1JxtK1WgbtzlmLIMzG0bdlTSkik6werZMDbgrm0XoDMf/lbVVb8Tv+YGxNU7Vg2dbcloTwrkuvBTgnkpjmSbBY9h+GIWxbGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740065082; c=relaxed/simple;
	bh=knlLdW6Swx8MuQSnlA0afzhfyq5d+s+vBtjJqU1jTFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCsC/u8aAV2623jQfbTCN+Oh5gN9cMPSbhcpg+90eifn0LzhONsn6O9/9JxgZiWVAZDmOb/eRuXTnV5MkVMN6ap0ftA6tMy7DlTfFz5dBglR2MX7h5b+ctJNto4gc771LGkUcxt1qlnNCdHN1Sx+sQ79kzOSWFYdx7IFbSmIzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJeYKIqW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E7C4CED1;
	Thu, 20 Feb 2025 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740065082;
	bh=knlLdW6Swx8MuQSnlA0afzhfyq5d+s+vBtjJqU1jTFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJeYKIqW2xtbtr2a6o4Nr66cdvAQfMb9st7j15Hq6wCDMqpkdU6tlvjukgr2ZHCs4
	 Fufpim6q9Fg5nTZ40rqLpRiNm8shV1oVrzkL0on+Uho7Eow0r9BFUqLBsr+I+uNWhF
	 6G0cByQzIiQAx3xioFvZBycxy7SEitCVTu5V3KTb/qU/oow+Tb3ywEpArP9PDz2dKm
	 OJoOh7QHJF51y8bkUoc9MugcBjvmQ4RSufYALjmFG3HQeSEwyWl3hXPKjKcKGSKcWN
	 2R5MXHzJJ983ymElflYGUMpWQhgMOkydcgI2kCGFtpe9amtE4FqtTqUZzC+BJkhlGi
	 219VuTSZqUuaA==
Date: Thu, 20 Feb 2025 08:24:39 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7dJNx5yIneheFsd@kbusch-mbp>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
 <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>

On Thu, Feb 20, 2025 at 11:08:25AM +0000, Pavel Begunkov wrote:
> On 2/18/25 22:42, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> > more efficiently reuse these buffers.
> > 
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> >   include/linux/io_uring_types.h |  18 ++---
> >   io_uring/filetable.c           |   2 +-
> >   io_uring/rsrc.c                | 120 +++++++++++++++++++++++++--------
> >   io_uring/rsrc.h                |   2 +-
> >   4 files changed, 104 insertions(+), 38 deletions(-)
> > 
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > index 810d1dccd27b1..bbfb651506522 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -69,8 +69,18 @@ struct io_file_table {
> >   	unsigned int alloc_hint;
> ...
> > -struct io_rsrc_node *io_rsrc_node_alloc(int type)
> > +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
> >   {
> >   	struct io_rsrc_node *node;
> > -	node = kzalloc(sizeof(*node), GFP_KERNEL);
> > +	if (type == IORING_RSRC_FILE)
> > +		node = kmalloc(sizeof(*node), GFP_KERNEL);
> > +	else
> > +		node = io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
> 
> That's why node allocators shouldn't be a part of the buffer table.

Are you saying you want file nodes to also subscribe to the cache? The
two tables can be resized independently of each other, we don't know how
many elements the cache needs to hold.

