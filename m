Return-Path: <io-uring+bounces-8878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AE9B18966
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 01:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39F666232F1
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 23:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F6322D4E9;
	Fri,  1 Aug 2025 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUlXpxGe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918081917E3;
	Fri,  1 Aug 2025 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754090411; cv=none; b=ZUoXQVkbacODquXadd1EWAxiu25kfe5oC2qJ1rx75xxUwrLZr7tao/WyUZSF6wf51O9ZV3TwiVgpIEQhchJffczmhEzINaW/YRZBKY9ERMsBkufVIROcS5Fc5/IClcmUp4/wpHQ1DmTGS2s8dqJLEsyEviFfClVVWuKa2TZ5cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754090411; c=relaxed/simple;
	bh=bZ4xo8b9MP/9ePId0VtPvGV942wIprx7/UB1pEqffN4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUqZzTmamM9qhnT0clbB+XmX2192mHSmyDbs+ijIzaDANmUjO54MRb7ADoWo1m9T4YkoDJ7MQ7Ah0LD6K1pISproEcbkHP6TD/gpIq3YHXe37hQTk/f34aZuqoAcolbnURDXB2icA0lkqOpstKpkLnpBhSoEQz1TbRcQOJjAjZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUlXpxGe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEE9C4CEE7;
	Fri,  1 Aug 2025 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754090411;
	bh=bZ4xo8b9MP/9ePId0VtPvGV942wIprx7/UB1pEqffN4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pUlXpxGejdBj+e6AbFnC0enMogF7j0F8ba7B3Dsq5UvzEYitLCnaKj3/8ci87l4ZM
	 7u0DuL6slLTBWqh8P6el/h5oimGALuaeKw6wZf3lKr8xu+4mTZ+lrQ2vpcm+N6J2hk
	 34IhZVjcqTnkoDKOZOJqndX2bYSUCr8PFnwUcmfrCOHcn7MtEUIARByx/vo6vspi/I
	 SoGjcTdidryxfBv+W54y4ma0GJWkJ8vy8G93YT89Ef/ONb9U5nYa1fIqwSYxd6b31b
	 hIHhcU42Gbi8oXIWhs3gbNoEUyoChsrZcMkExdBEsLHPrRHFnTs3pkhD8qG/yiqhKs
	 Nyj88EZQL1BsA==
Date: Fri, 1 Aug 2025 16:20:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 15/22] eth: bnxt: store the rx buf size per queue
Message-ID: <20250801162010.1f5b3fba@kernel.org>
In-Reply-To: <CAHS8izPZE752dfZVD6OzGJ7z_tmh2n2tvJK_0yd5mP51FCSKmw@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<be233e78a68e67e5dac6124788e1738eae692407.1753694914.git.asml.silence@gmail.com>
	<CAHS8izPZE752dfZVD6OzGJ7z_tmh2n2tvJK_0yd5mP51FCSKmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Jul 2025 15:33:55 -0700 Mina Almasry wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> >
> > In normal operation only a subset of queues is configured for
> > zero-copy. Since zero-copy is the main use for larger buffer
> > sizes we need to configure the sizes per queue.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>  
> 
> I wonder if this is necessary for some reason, or is it better to
> expect the driver to refer to the netdev->qcfgs directly?
> 
> By my count the configs can now live in 4 places: the core netdev
> config, the core per-queue config, the driver netdev config, and the
> driver per-queue config.
> 
> I honestly I'm not sure about duplicating settings between the netdev
> configs and the per-queue configs in the first place (seems like
> configs should be either driver wide or per-queue to me, and not
> both), and I'm less sure about again duplicating the settings between
> core structs and in-driver structs. Seems like the same information
> duplicated in many places and a nightmare to keep it all in sync.

Does patch 20 answer this question?

