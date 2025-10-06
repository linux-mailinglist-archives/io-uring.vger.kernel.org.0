Return-Path: <io-uring+bounces-9903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B1BBBF993
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 23:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E84334ADA2
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 21:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C668F4A;
	Mon,  6 Oct 2025 21:46:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4439E7464
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759787163; cv=none; b=X6p22d1It8iN/YQwilrcMkAnXBFkSoWmTaCTKDrk4pIIlURPYl+iRqAfkQYWe0fpQRT36cIOV8gHDoZ+5bXXWjjtWC0lxX7Klzonzt43+BTa2mG29IKyStL1FoZ9rIoLyahc9mFQmokVJ/G4grNUfyFDOAGn6h0IXTcA53IgXGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759787163; c=relaxed/simple;
	bh=U+SEDmSk44PqnQJLRMCttnKJbnZfxpWl3uJSnmv2HR0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+lHCpslIcKVj4MvzeswQGS388XnYlHp+P/EOlAqMYF+nzVaIVsUdAJ9lB2aVE3V1+sVN2vKBm3UBXWA4frCb4v2AVIaw9U//KLdz5eYXKxND8/ko6Qz4A3HmmVEQE7YwyEmlTUeXVzX79fX40tEYp0WkfbLOYJpKxR4suTJxA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 0AD41140681; Mon,  6 Oct 2025 17:45:54 -0400 (EDT)
Date: Mon, 6 Oct 2025 17:45:54 -0400
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: CQE repeats the first item?
Message-ID: <20251006214553.GA868@vultr155>
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
 <20251006012503.GA849@vultr155>
 <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>
 <20251006020142.GA835@vultr155>
 <a25558b5-7730-432a-85cc-55fdc8dca0d3@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a25558b5-7730-432a-85cc-55fdc8dca0d3@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Oct 06, 2025 at 07:56:16AM -0600, Jens Axboe wrote:
> io_uring_setup.2 should have all of these setup flags documented.
> 
> I'll ask again since you didn't answer - why aren't you just using
> liburing? It'll handle all of these details for you, so you can focus on
> just using the commands you need and not need to build your own
> abstraction around how to handle the SQ and CQ rings manually.
> 
> -- 
> Jens Axboe

I read through liburing, boss wants me to understand everything about io_uring and wants an in house solution and for me to optimize it.
I was able to write a test that submitted more than 2^32 entries and it ran correctly. I think I'm off to a good start now

