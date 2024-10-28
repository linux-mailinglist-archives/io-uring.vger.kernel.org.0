Return-Path: <io-uring+bounces-4086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5089B394B
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 19:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0286D2824BB
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 18:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37C61DF975;
	Mon, 28 Oct 2024 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7JA3pW8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9E1DF962;
	Mon, 28 Oct 2024 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140738; cv=none; b=QWOwP81BVUqe89IxU60wLlwSipXzuG8Z4PRRXgSBLgwtucVXSE5vXNITPr0PYpnqzc2Yw9U8+7xXZsHapSa4SXopxoz+rrg17LSG7qN08VGiuDR+NHjceAAlg1cHFbuNLvqiqZDxu4qigc8uIjng3UQ4gMM4izoaNMSTHI5KyvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140738; c=relaxed/simple;
	bh=yXvl5ucMYrCRugDnDUgPtXONHx76D+ygufgs+U8P30E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=repPq09L9p6ePnGikJ2EH8WYod79rLfoKuC3gPU79W0vQjv2OEs4VPoEHfkebFAT7p9PBZ9OuEXqoL1jWSpBMpyhvdbGvac9yYuxn0Df3Qq1OvcEtjNr+qXsoGpbt8ZClT096GeMRuYF5i96TsNlx8Z1tGSBv+7k847Yx222kDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7JA3pW8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFDEC4CEC3;
	Mon, 28 Oct 2024 18:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730140738;
	bh=yXvl5ucMYrCRugDnDUgPtXONHx76D+ygufgs+U8P30E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r7JA3pW8g1hX5xPQMspeIhKV4yWSsMsg0b7U6TyGSNAuYS7nOhJZX+XjwSmAgbg8t
	 KfPEFiaSWvMKtDyhWgSObDlgGsupjIiHxfxRIzB2CHH1te2cgfYTZKB4bCJ5VWpJbA
	 jIygKCoa/Ggcpi0VyeQAfng4XZ5bggHOjHtaYGspnZlyt37k2krRH019x2gxp2dd28
	 jSQU0gXQyVQUY6lZ0P+JcU3f2y5JuWOF8Betv4q1ee8QdDQIQhpa22GpU9KdTfQpni
	 ZIcCOU1gdd6/yaOvhlct/ZVUksMJovqWEoaFxmXonb7bR3so0r1obwKwCQi5TxPX+8
	 LoWpWTUlvnQvw==
Date: Mon, 28 Oct 2024 12:38:54 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
	joshi.k@samsung.com, javier.gonz@samsung.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv9 1/7] block: use generic u16 for write hints
Message-ID: <Zx_aPg7Pjq-7lU-T@kbusch-mbp>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-2-kbusch@meta.com>
 <a86cfa72-426b-46f4-83b0-b60920286223@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a86cfa72-426b-46f4-83b0-b60920286223@acm.org>

On Mon, Oct 28, 2024 at 11:19:33AM -0700, Bart Van Assche wrote:
> On 10/25/24 2:36 PM, Keith Busch wrote:
> > This is still backwards compatible with lifetime hints. It just doesn't
> > constrain the hints to that definition.
> 
> Since struct bio is modified, and since it is important not to increase
> the size of struct bio, some comments about whether or not the size of
> struct bio is affected would be welcome.

Sure. The type just shrinks a hole from 2 bytes to 1. Total size remains
the same.

