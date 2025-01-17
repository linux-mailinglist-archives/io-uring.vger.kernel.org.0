Return-Path: <io-uring+bounces-5952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42059A147BE
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:48:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B460D188ADC6
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F371E1020;
	Fri, 17 Jan 2025 01:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G62ZDmWe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AAC1DED6D;
	Fri, 17 Jan 2025 01:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737078504; cv=none; b=g/1+u94MMVkv4eDVhG7YbjDr8K/sCyh+9CVkfbvBy18LLJQzFRDGy7pKPiv+Utm861DjOiyp/OjPqhONGZEikEYs/L7/xiYmOB2cmAhONhhFmPS2T7j+gwd8f7obKv8dEyqeQ5yD8xpNcZHdrz9pNnKHGEVkCV6o6KQX9bZ/OJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737078504; c=relaxed/simple;
	bh=lFTw+Qn/bQqsnrO0gkiGgPbFPh+Rok+v5SqxBnCepVo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlIPy11erXzHxxBpOE1Q49Jn/C3kD2iSNPb+TbL5+rFsd5zCM1wjN/k2zX13lISjf8kqrOO1UiYld97B/p0fw5ZBKFNKqsFHcYEBAXHtFt4f7ZZdqxX01nd+0fKoRwMtuBARhzZslgjWW61XNYClVd9Z8FWyYhFyGTr3nJdvy28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G62ZDmWe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FEC4CED6;
	Fri, 17 Jan 2025 01:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737078503;
	bh=lFTw+Qn/bQqsnrO0gkiGgPbFPh+Rok+v5SqxBnCepVo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G62ZDmWeJC5xIM/gSMiTPrau1MDkGz7rNnGNyYN6nVWsF3Mq7evrXYAOoLZfuJJlU
	 A0TYwBopkgFjo79oPX3yuChqHxTRQqAN8jkVWcqZbLr5kq9fahRdIdI9/iVnh8DPsS
	 VCpqNWMZ8Ugk/4QJ/TTf0acMm+U6NKCzGBOL2tEWj5K0Js6LEDNQGu5lygSd2mCvlH
	 f0ifyrFthW2E2/JZqyR1+Mc7CDXfY2n4cg70f+nxC6BqdPMu+JRS3R2SWmruEhuk/T
	 mbXD9B7rVc4B5R0tNW9NmX19kCqTBNv9qrBqlMCY/t0WWiZ4OHOb7GpLjtoYkhVKFM
	 rNhY6uAHDZ4Cw==
Date: Thu, 16 Jan 2025 17:48:22 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 04/21] net: page_pool: create hooks for
 custom memory providers
Message-ID: <20250116174822.6195f52e@kernel.org>
In-Reply-To: <20250116174634.0b421245@kernel.org>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-5-dw@davidwei.uk>
	<20250116174634.0b421245@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 17:46:34 -0800 Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 15:16:46 -0800 David Wei wrote:
> > From: Pavel Begunkov <asml.silence@gmail.com>
> > 
> > A spin off from the original page pool memory providers patch by Jakub,
> > which allows extending page pools with custom allocators. One of such
> > providers is devmem TCP, and the other is io_uring zerocopy added in
> > following patches.
> > 
> > Co-developed-by: Jakub Kicinski <kuba@kernel.org> # initial mp proposal
> > Link: https://lore.kernel.org/netdev/20230707183935.997267-7-kuba@kernel.org/
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: David Wei <dw@davidwei.uk>  
> 
> FWIW you still need to add my SoB for Co-developed-by.
> Doesn't checkpatch complain?
> I guess not a deal breaker here if I'm the one applying it...

Ah, and in case I am not..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

