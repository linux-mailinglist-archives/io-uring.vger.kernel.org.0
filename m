Return-Path: <io-uring+bounces-2887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B0395AD93
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 08:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 281791C22222
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 06:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69789139D09;
	Thu, 22 Aug 2024 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mOagcFM/"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203EE13CA97;
	Thu, 22 Aug 2024 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308430; cv=none; b=awoosUj1+VnU129jL0+uqHlwNEsF9tt8Iv5mjf/NXyJmi4tLr6bH07jgFrO+nRTVzgSuStoiZm7hZ9LhHQFpbF+1MKsxdWzYBtAZnAo3RtKwWPpHmsj5KlRakZ9OOqpAGUIRAO9MysiYplH9OjDJVrpnlazu78REBB6bSHVjWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308430; c=relaxed/simple;
	bh=wQEk/GXx1BVJs6hDyaQhmOqR0YhPxluB524YISBd3ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5dUCJfcFXv5Xg14K5rbQmevjQo34bgZ2Hh/kVwXZpTIPXvhZ2grk0AL0AksAvCZeWgvXk3zjRwg8UQKQR7z5m/d/MvG8SEG5kMv/ruzXiIJQLqOHDcYYZQPhNnjtM6hdgOwf+6uMlFb7ZdBSd05YD3obfVH9Ed3pORE2COJkcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mOagcFM/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wQEk/GXx1BVJs6hDyaQhmOqR0YhPxluB524YISBd3ww=; b=mOagcFM/O8pb4C+//JJsPDkofN
	DxuzccQAJisY2zMPxSqXP9L+EAqeryWiPIopiQsklDnO0xAjdKjser7lQMEi3XEZLYDQjF5+tOomX
	OAVxjmMpifhCfxzq+UFWE2u+OIotuZRv6ZiVYNBukblmAEIX29/Ze9wlzUcOmyK+jcH/l/rDxUhxB
	PiPUsQMXYyCZ0UiGjlHvdet3Sjy3Lyj2C4tYTW4xDjVkQEkI+Te3yVeY9/EDcHvQtqz8isKXw8Cj8
	oEsoJ6FrN9CSTdNcNlThegoWKX/d8GWeM390545lFx176IEFQ2iRFMLtDjTkgp9gFARtzgU0XNHGs
	p348Kbtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1OG-0000000Bcek-0jlc;
	Thu, 22 Aug 2024 06:33:48 +0000
Date: Wed, 21 Aug 2024 23:33:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 4/7] block: introduce blk_validate_write()
Message-ID: <ZsbbzDxV2mN29CYh@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <2ef85c782997ad40e923e7640039e0c7795e19da.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ef85c782997ad40e923e7640039e0c7795e19da.1724297388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:35:54AM +0100, Pavel Begunkov wrote:
> In preparation to further changes extract a helper function out of
> blk_ioctl_discard() that validates if it's allowed to do a write-like
> operation for the given range.

This isn't about a write, it is about a discard.

