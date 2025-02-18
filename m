Return-Path: <io-uring+bounces-6521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87079A3AA8C
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 217233A6358
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10BB17A305;
	Tue, 18 Feb 2025 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+0MuBwR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1B17A2FF;
	Tue, 18 Feb 2025 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739913130; cv=none; b=LK3/HuxVm+7wNI+avfrhIZAv93FMmhbXHZZZGrHUV4VQWWluj67cN5aZxgimuFhgaQIA+F81mL8gCZTWbSBe8sQnn2DPgFnwBcdewkA88RBmkn0jSceJBXwNjTj2Xbcbp98/l4KA/o2TQjdcEtvtu3XxpVS2zJbcVZq5ba3RE6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739913130; c=relaxed/simple;
	bh=XeKZGxioqdjfwra/vjKmOwhBohgtZpeHFr1bC2V76jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueOl30NlcBjD3FCKM2zn/jRwyt1vGT8k1r9g2ix1LDo5R3W930cSNunfrduWLLBkYmnkZ0H0rqoh58wYIp2Y+PiME2Ji9LyIUJBKI3Y/ByA0sTJbWaJ47THj4Gq4helVla7kcB0V9sPFNcgwW7GvgUAq77yEUelqJMmbWtBgIa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+0MuBwR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C6EC4CEE2;
	Tue, 18 Feb 2025 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739913130;
	bh=XeKZGxioqdjfwra/vjKmOwhBohgtZpeHFr1bC2V76jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+0MuBwRcB1NnttFVCxyh4CMTvc9wR/z22zIaHDlBlWlkxTkEFb3Gf7VP+vYLd6LG
	 BRsN9tSnkL/lBmA262whODgong1fxTKfqX7Upkt05Y5uU42qgpYZObupPVAXUiLrDp
	 CsYqQUyL1EwgSt3CfSZ+UE8A2YWa5HUKDcWrbcwntgFoxZsSgMWyfIEdo1r5QysPyk
	 hGVEn9nG7tdsuO0UKf8MLNUzuv7o9/Gt+qqhkk2tKsT9gfTvDC9K0yRp/3SrCrTMQV
	 xb3Y3l+4DWrfCuFQtuThXbl4An7fVn8WsDuqKTfZuFjhrA5fP/lCbOxTt8DaUvjGAn
	 mVJeKbm/WhA1w==
Date: Tue, 18 Feb 2025 14:12:07 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7T3p_sdl0IrWRj8@kbusch-mbp>
References: <20250214154348.2952692-1-kbusch@meta.com>
 <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
 <Z7TpEEEubC5a5t6K@kbusch-mbp>
 <CADUfDZqb-55yAJU1GbDF3tqW=6DhNP+SV3Msx+Sv5GPRHt+s0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZqb-55yAJU1GbDF3tqW=6DhNP+SV3Msx+Sv5GPRHt+s0w@mail.gmail.com>

On Tue, Feb 18, 2025 at 12:42:19PM -0800, Caleb Sander Mateos wrote:
> Right, that's a good point that there's a tradeoff. I think always
> allocating space for IO_CACHED_BVECS_SEGS bvecs is reasonable. Maybe
> IO_CACHED_BVECS_SEGS should be slightly smaller so the allocation fits
> nicely in a power of 2? Currently it looks to take up 560 bytes:
> >>> 48 + 16 * 32
> 560
> 
> Using IO_CACHED_BVECS_SEGS = 29 instead would make it 512 bytes:
> >>> 48 + 16 * 29
> 512

Right, and it's even smaller on 32-bit architectures.

I don't think it's worth optimizing the cached object size like this.
It's probably better we optimize for a particular transfer size. If your
bvec is physically discontiguous, 32 bvecs gets you to 128k transfers on
a 4k page platform. That seems like a common transfer size for
benchmarking throughput. It is arbitrary at the end of the day, so I'm
not set on that if there's an argument for something different.

