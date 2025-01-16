Return-Path: <io-uring+bounces-5913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9FBA13188
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02E39164045
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84413BB48;
	Thu, 16 Jan 2025 02:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDModgfc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6717BD3;
	Thu, 16 Jan 2025 02:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736995732; cv=none; b=ejpegEn2Ivk4yEAziXAV8ePla3hDwaScCwmnW1BQWp/t6AzBKPy/At+k/sM4qEtSvFdebT6nJYaowrPAIvU8hN5bhJDPpGx6iEXQm90bR9G16g+dO0leXgV1BRXxOYSJE9BJBmkh/jQyeFwhA8uFP37+GTtBYxZYXp1Rl++iMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736995732; c=relaxed/simple;
	bh=5ETaFEkTljab3ojVYsXyNwdOM6bFvmz7QnYyt2ttLZI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bI7C+Sh/UELj7qNbPgXjZVKWHHHgiMXQeH/r+Ykd+OXmJk6WHmXe8O2HKVGrGcssHcHARbFLm/GkAd8OyVlpMu0ROV1dvtlPrBcYaMZVcxhcNjdyHt40nCRKqhySywhJvK7Pr6HDiSn+N91JarX7+r6YxsXLygsghy7OUEV8jlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDModgfc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8757AC4CED1;
	Thu, 16 Jan 2025 02:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736995732;
	bh=5ETaFEkTljab3ojVYsXyNwdOM6bFvmz7QnYyt2ttLZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gDModgfcodXAhBnQqgwvUtLlCJEnFJLTVI3fFDcQDTjBnCMs6tMVzZsWZhy8TR6eX
	 5b3xHIoh2t6B0P9aPDnlmbs60/v61PpEVtittIIi7o/KHeXcN+lTpuQG6HNkJUz2lr
	 vFAuMW5pQ0j8K4CB+TZxRk2P/EcITwHPQz2SIJ/XxMh8+DSTGb4a/vAXFxIP4I9lWJ
	 /hG5oE8UZ/S58kl/g9DgI5x4R545wonRCZTiv22MlQ0BCP5aPsWhdfah7kP0cKwMj5
	 UHNC6S8cTJ6RhmmYiTo2jcCCR1u9uw5lik9rAfkGQnNy1cQUXgp6QyKh6FNJxipyaw
	 xwrZmac6TEsJQ==
Date: Wed, 15 Jan 2025 18:48:50 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 01/22] net: make page_pool_ref_netmem work
 with net iovs
Message-ID: <20250115184850.4d30e408@kernel.org>
In-Reply-To: <52fffbfb-dadb-48fe-84e4-8296b18fd22e@gmail.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-2-dw@davidwei.uk>
	<20250115163019.3e810c0d@kernel.org>
	<52fffbfb-dadb-48fe-84e4-8296b18fd22e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 02:12:06 +0000 Pavel Begunkov wrote:
> On 1/16/25 00:30, Jakub Kicinski wrote:
> > On Wed,  8 Jan 2025 14:06:22 -0800 David Wei wrote:  
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> page_pool_ref_netmem() should work with either netmem representation, but
> >> currently it casts to a page with netmem_to_page(), which will fail with
> >> net iovs. Use netmem_get_pp_ref_count_ref() instead.  
> > 
> > This is a fix, right? If we try to coalesce a cloned netmem skb
> > we'll crash.  
> 
> True, I missed it it's actually used.

I'll add:

Fixes: 8ab79ed50cf1 ("page_pool: devmem support")

and we'll send it to Linus tomorrow. Hope that's okay.

