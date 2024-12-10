Return-Path: <io-uring+bounces-5381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FB39EA6C6
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B55A164C3B
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7BC1D14EC;
	Tue, 10 Dec 2024 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXjq6h7/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A181D0F62;
	Tue, 10 Dec 2024 03:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802289; cv=none; b=qnqcQ5fppxv4tq2t/a47GQoNbLSwYdth6UJq3nAZq/Mz4ITFJOD59szJ0G7xqL4wu0RYuz00igDcMPPbDUXF5/cKatZB62914/XlTyUeclElNRcAkIr8N+xs3opDFmiLxV424ufRiPQ51fywbVrdjDco9pBoTJQBE0xUt1ii8FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802289; c=relaxed/simple;
	bh=YMQRPpRBSXAw1WfX4Ql32vJNtEhEsk0IWB0Aphy5vcc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlxqNgFlpAcJD/81bWdAtfQRfrEJdRQWsSE89/WnNe9fEcFVpy2pDeYtri7Ki6X5zFFb4ZMyNcJuI3gdr/y0gAkcfjcA+kpObeyh2Ols0DHehvJVvpAg3RuCfZXj3Qmqx4xR3jfHdND6n1YPOANsGTVlorGMqJxO9ghW7yU2ugI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXjq6h7/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E247C4CEDE;
	Tue, 10 Dec 2024 03:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733802288;
	bh=YMQRPpRBSXAw1WfX4Ql32vJNtEhEsk0IWB0Aphy5vcc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AXjq6h7/Ot4/OrXDFsbDftcIjZCoZGiGRLC8DoTnX7y06t1d0GXar8DhkbdRErUs3
	 0TSO0qDmdc3ft+ZbbYCE5YjEr27PKiDvJkN3aTwpMa74rbNjKqU8UnuIjmJWfzYJpD
	 +uVcQUhEN2MuJ8+REzx72dxNeI6evVj3Wa77EjrymqJLmIp+vn9+bC6YHlOtLdvXG/
	 c1vzqm9Mz5paf6h07f4s0B9u9eV1cW72wqcoqRTxztLwmehVZLZ6nvOVGfYvnaSNHN
	 OkA9KU7arYBEFogsDNSGOmzBAYrhw/lfTRQ9A/DFSJn9H7ZPwnkis6FqWaW8o8wHPy
	 lvOppV+ZoU+cw==
Date: Mon, 9 Dec 2024 19:44:47 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 08/17] net: add helper executing custom
 callback from napi
Message-ID: <20241209194447.26eaffd5@kernel.org>
In-Reply-To: <20241204172204.4180482-9-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-9-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:47 -0800 David Wei wrote:
> It's useful to have napi private bits and pieces like page pool's fast
> allocating cache, so that the hot allocation path doesn't have to do any
> additional synchronisation. In case of io_uring memory provider
> introduced in following patches, we keep the consumer end of the
> io_uring's refill queue private to napi as it's a hot path.
> 
> However, from time to time we need to synchronise with the napi, for
> example to add more user memory or allocate fallback buffers. Add a
> helper function napi_execute that allows to run a custom callback from
> under napi context so that it can access and modify napi protected
> parts of io_uring. It works similar to busy polling and stops napi from
> running in the meantime, so it's supposed to be a slow control path.

Let's leave this out, please. I seriously doubt this works reliably
and the bar for adding complexity to NAPI is fairly high. A commit
which doesn't even quote any perf numbers will certainly not clear it.

