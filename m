Return-Path: <io-uring+bounces-5951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27F4A147BB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DE5A3A3382
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53581E00B0;
	Fri, 17 Jan 2025 01:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L888YM4V"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F7C4CB5B;
	Fri, 17 Jan 2025 01:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737078445; cv=none; b=R+3HfTpbrdTGUjithAHHgw7aeQxGBp+sxdzDMNdG43/PF5VblmPouDL00G7tc6eV8PRURdzNLdLmcMsbMW3z5SAWFPcvQYaHOCATCfNKBWukZmRYHb1TSardPM9PEW80p2OM0mWGgJy24ygS8nknUf5OjGYtD2ssNcpdpTFgsqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737078445; c=relaxed/simple;
	bh=FCQ1LyIAXh7GDuE1DEc+P7zJdg7DSwM/mMon0hYUN2w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U4ZnN/pHZ8+nUCyZHTFvpb2dxuko6y8GQY68xL/moz6Q9gJ6cgOebh3/jKdAM0vXIA4ozTFh6btmkGzPisaIyM+WkirFtKje4Rbf/1hQ/SeLIZ2UtCHRoCOtzp89VzHfLMVRmyO+wU7SL4CW8Cz7bxA+0k9NQdLIx6qY72aKAYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L888YM4V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2F6C4CED6;
	Fri, 17 Jan 2025 01:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737078445;
	bh=FCQ1LyIAXh7GDuE1DEc+P7zJdg7DSwM/mMon0hYUN2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L888YM4VC2jOpUkXVjFPrSwIUFXAV61LjmU9zc2kvRVIu65kzGBGgqZS/zuYKyYwn
	 F7c/rFP02q2CcGiTafeQU3TWWzHNe0jsVDKghNKKhOJ83bldkafN1OBKnJ/Y7zwlI1
	 s8rKsmMilvIdomiy9FuNsXSv6fvg4qG8trqRgwnUB6dEs4dbCc73r4cbY/4F6gcxrj
	 ZPcZTN8b03B1Q2UbM+XNuQ5R5X5RGe9Z1qxS89i530b9QltRekyplqr9id9XL7VUKH
	 DoKWxgiNLKsP8uy7kiqnRTbCGIFrxT1KBnpN+HQ+KKVpKOl95ysoNp8yyUlzZNh9My
	 DNt8QpkFQSvVA==
Date: Thu, 16 Jan 2025 17:47:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 09/21] net: page_pool: add memory provider
 helpers
Message-ID: <20250116174723.36c7dbed@kernel.org>
In-Reply-To: <20250116231704.2402455-10-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-10-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:51 -0800 David Wei wrote:
> Add helpers for memory providers to interact with page pools.
> net_mp_niov_{set,clear}_page_pool() serve to [dis]associate a net_iov
> with a page pool. If used, the memory provider is responsible to match
> "set" calls with "clear" once a net_iov is not going to be used by a page
> pool anymore, changing a page pool, etc.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Acked-by: Jakub Kicinski <kuba@kernel.org>

