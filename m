Return-Path: <io-uring+bounces-4067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A24659B33FF
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EBBB1F22470
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 14:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E941DD88F;
	Mon, 28 Oct 2024 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKPg/yRG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EE518E778;
	Mon, 28 Oct 2024 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126993; cv=none; b=OurQUBaBo/nIJslbl0l81wTpCwJRwFvMj7O7HE3kYCVRo9N4BtXlheyCu2CqN0GmjJK76Z8tDZ3fw1SxzMGlh5i5IMa7nbhusowQyW4ViTLt/dzUCG5jsiMgAZahAUk9zT8H08Rwr8+ZVc/HiPKh/bwj5XDq1b2DDIMnf2/IDTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126993; c=relaxed/simple;
	bh=ul4FrUoyTM3eKMpUlfF3PIljQyXaWGzKT1GGKNK0tak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/2jf2Rxd/p9AI+A9i2wT8uIqa+xlNRzaFCelqPVyl5O5Gg0fB5K+hOQ8nxSX6s0yZwpbmQtdjH4ElGjFinICkCxRt5B6HA2pvdOvgrW4BmZ0uJqTgoc7PaHwCYqUEwC42PGr3QTd0y8L9XMNU+hto3O4s/NLQZnsrG9SZ/gH1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKPg/yRG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68628C4CEC3;
	Mon, 28 Oct 2024 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730126992;
	bh=ul4FrUoyTM3eKMpUlfF3PIljQyXaWGzKT1GGKNK0tak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aKPg/yRGtLNyL4aEfn9s0bwut8kYW1Njtk9aiQdYWsGOXQF1xoShKYeG1bzNcaHJD
	 qsix6/5YGv7/9a039tLdMy/YksesxdLpd91QpE6LTiqJagUqEpImTPBdF6onUFXuDO
	 mbkYYlJa7tp9aXZzL/lG8DsNf0aFZmN4fCMiM6pNLHO5+gf4iPmL5c2wRHwANn0aWm
	 hAy6DnWgLB04DyMd/D+NxRLts2h3jjVTJbYUKMEKgcE6nMq+3Tii2u+liHZf9+3scA
	 5N/KxtluvFUb5fZWEMnsmPEkxx6Np7SM/nzmHZR3oKSYbJnI7vigo1qYOgEX5rRvLJ
	 eu9slgJHd77bg==
Date: Mon, 28 Oct 2024 08:49:50 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv9 3/7] block: allow ability to limit partition write hints
Message-ID: <Zx-kjh8VOYHmQCyH@kbusch-mbp>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-4-kbusch@meta.com>
 <20241028115805.GD8517@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028115805.GD8517@lst.de>

On Mon, Oct 28, 2024 at 12:58:05PM +0100, Christoph Hellwig wrote:
> On Fri, Oct 25, 2024 at 02:36:41PM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > When multiple partitions are used, you may want to enforce different
> > subsets of the available write hints for each partition. Provide a
> > bitmap attribute of the available write hints, and allow an admin to
> > write a different mask to set the partition's allowed write hints.
> 
> Trying my best Greg impersonator voice: This needs to be documented
> in Documentation/ABI/stable/sysfs-block.
> 
> That would have also helped me understanding it.  AFAIK the split here
> is an opt-in, which means the use case I explained in the previous
> case would still not work out of the box, right?

Right.

