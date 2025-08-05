Return-Path: <io-uring+bounces-8885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB580B1BCC2
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 00:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F13016B028
	for <lists+io-uring@lfdr.de>; Tue,  5 Aug 2025 22:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A921DF759;
	Tue,  5 Aug 2025 22:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSsfpxLx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70618173;
	Tue,  5 Aug 2025 22:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754433837; cv=none; b=DNn9J3/JGZCTEXP/Cf2BFEBtVa8OWSMZCRPfNqVuZtc5uwOPlTVnkj4IOXUfWR+WwrCHymA+DWhabcFGNB9iVcuRqzedT77SrMoSmV5ttgZro6BWGkj54MTkCBagHtKz7+q2o1/rKDzP9HoqTQuDLIbMq2gz7/hggoor8HK7+ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754433837; c=relaxed/simple;
	bh=zp9mF9AxbmQANyGSCRsB0NBkIIX7UT18b/iQ51kQp9U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCPqqqVcbH2pCzERwNu2oFCaUucwYPdxGZtSf/xNhOhKQRGuqfYlBWP4tMey5OecYyESjzVh6u5c2QISRMoUGLChkr1f9lf6oZOw8X7FoB8O9/z8gG/8nj8VDQaVd9rxFATG+b5SDyn4DSWtm5Vu2XQn821TlGTO07WhFpo+3eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSsfpxLx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB35C4CEF0;
	Tue,  5 Aug 2025 22:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754433837;
	bh=zp9mF9AxbmQANyGSCRsB0NBkIIX7UT18b/iQ51kQp9U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YSsfpxLxNs4nnQfy21Om9Ai9bSC+GAWaCowC9vlJhg/mdlyEhn8NE9KOXA+U3jcUD
	 bmEwver1g7MoD13qC+0B0bN3SoUE4W9moSFbtHyyg0nPfg/69r4PG03za2IKnje5ZJ
	 tO9y1qdK+kQxlRfFeobwjBxsqbiTvKUlyN0Gn2wdyu8GJaoeBiYCmq2RN3mJNq0iH2
	 VZ58jBswDOjvyNLdnY61Blo1dh4L3beTMicMof3CwmJGj+7dG8IZ4Z9pPK5/ZEuSsR
	 xfsL2qK0emixyBXQmNL0WvSrtUcV0L2M4faA7xQRY8XEVYj9Xi9PBnfKGdtJTFlkAh
	 k1Di2z0LS3VNQ==
Date: Tue, 5 Aug 2025 15:43:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Paolo Abeni
 <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, almasrymina@google.com,
 dw@davidwei.uk, michael.chan@broadcom.com, dtatulea@nvidia.com,
 ap420073@gmail.com
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
Message-ID: <20250805154355.3fc1b57a@kernel.org>
In-Reply-To: <11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
	<20250801171009.6789bf74@kernel.org>
	<11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 13:50:08 +0100 Pavel Begunkov wrote:
> > Since we don't allow MP to be replaced atomically today, we don't
> > actually have to place the mp overrides in the config struct and
> > involve the whole netdev_reconfig_start() _swap() _free() machinery.
> > We can just stash the config in the queue state, and "logically"
> > do what I described above.  
> 
> I was thinking stashing it in struct pp_memory_provider_params and
> applying in netdev_rx_queue_restart(). Let me try to move it
> into __netdev_queue_config. Any preference between keeping just
> the size vs a qcfg pointer in pp_memory_provider_params?
> 
> struct struct pp_memory_provider_params {
> 	const struct memory_provider_ops *mp_ops;
> 	u32 rx_buf_len;
> };
> 
> vs
> 
> struct struct pp_memory_provider_params {
> 	const struct memory_provider_ops *mp_ops;
> 	// providers will need to allocate and keep the qcfg
> 	// until it's completely detached from the queues.
> 	struct netdev_queue_config *qcfg;
> };
> 
> The former one would be simpler for now.

+1, I'd stick to the former. We can adjust later if need be.

