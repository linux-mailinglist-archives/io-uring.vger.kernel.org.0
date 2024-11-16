Return-Path: <io-uring+bounces-4753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C1C9CFBDF
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 01:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4B3FB2A77D
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 00:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B044D4A33;
	Sat, 16 Nov 2024 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzCsczpX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285B4A2D;
	Sat, 16 Nov 2024 00:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731718588; cv=none; b=LAE5757xKO++NwU+GlaCjpbBZo7WRFVpsdIao7nZFDDJ3yURGDYbhycKIJ279xs9xy+PqbN4juPb3dV+n79VVhmwtoe2VmeEoDjt1RpLekDl5u5c+ZslZ8IPsxpUdLD+VOQRk7TsesqJP7sbQdjT2UjgAVF6f126aZ3z2tHJB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731718588; c=relaxed/simple;
	bh=Xa+jsxKIIUiyRDcaHr5OHl3DkSRKwaUQOtVa7NR/iEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPc8XgwHeK3PHgmbe135YMnj6a9QwXSYXHCiwaBSEykaK3G2j4ekjZ7CFnKdVxgXg8uW3/CvCX0vUlNJW+4MKVDCVM6+wJpmkIqAQBUAfgVRGsK97CMdftYBIkoalXnBd5bihbz7tOdMmPWbivHW0waXj3RBMaQWaoAHzM8M2HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzCsczpX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F985C4CECF;
	Sat, 16 Nov 2024 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731718587;
	bh=Xa+jsxKIIUiyRDcaHr5OHl3DkSRKwaUQOtVa7NR/iEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DzCsczpXSrtPGZvbfN3t3YT5SSe3HtJ67sPlwmNJdN83ww/NSfuv07IIwedHocbBj
	 AEfPf9ZfNZe/hAT65jA0UVkl/aOVPaVL0NH8ImHk3bFKfrMq4tEHNWcBB3JeqTSmQD
	 AFLbwJJBzW5v/G//+OzQPzFTW33crY/3Qa4Sf5NOAWs8zELzN8PP65lurohsHPzNLd
	 B9RjniqQ4f5B0S2GTa3bomy26m4lPYsmr8TrDYXgSCQpUg05UaQcaiNl+6dcj/ehR3
	 VB8EaQnf9/PkkW/WFv5lEWoYpf2w97po2vMQPSwry3XK+LNjPQBSgeUcFY43ZWa63q
	 fccGDH5EFOr9Q==
Date: Fri, 15 Nov 2024 17:56:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add a rq_list type
Message-ID: <20241116005624.GA1178909@thelio-3990X>
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-5-hch@lst.de>
 <20241114201103.GA2036469@thelio-3990X>
 <9f646b56-ebbf-4f2d-bceb-6ce1deb5d515@kernel.dk>
 <be0d06e4-a61a-47e3-8d50-f37f9b6fc719@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be0d06e4-a61a-47e3-8d50-f37f9b6fc719@kernel.dk>

On Fri, Nov 15, 2024 at 12:38:46PM -0700, Jens Axboe wrote:
> On 11/15/24 5:49 AM, Jens Axboe wrote:
> > Fix looks fine, but I can't apply a patch that hasn't been signed off.
> > Please send one, or I'll just have to sort it out manually as we're
> > really close to this code shipping.
> 
> I fixed it up myself, it's too close to me sending out 6.13 changes
> to let it linger:
> 
> https://git.kernel.dk/cgit/linux/commit/?h=for-6.13/block&id=957860cbc1dc89f79f2acc193470224e350dfd03

Thanks, I was going to send a patch amidst my travels today but by the
time I got to it, I saw you had already tackled it on your branch.

Cheers,
Nathan

