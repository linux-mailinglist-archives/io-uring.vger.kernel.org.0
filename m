Return-Path: <io-uring+bounces-5584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 710B49F9CA8
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43541698F5
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85131215702;
	Fri, 20 Dec 2024 22:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXgco/Z3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4761B85DF;
	Fri, 20 Dec 2024 22:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732975; cv=none; b=njNhu3QogGXqtsg9eurDLjwZJ0Dibr4jHsLTqpeFTQkFTqfceG1g4wJkJh1ZjuIXT6DINLhCa7wkOYhoOw3i+aVhEQH2lE15Pg7JNXbBu1cKZDHqfWyEdvanv4GciqUpLADwY9AB0+3UY9SkRNqNXmOYVymFWXhpQIAh2Ey5BsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732975; c=relaxed/simple;
	bh=9LRaji69uD3EQIGHAAl3xSOOfhfziDwaFV5ALJNKDvs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLnjAxKuYrE/kik21UBFaJl3WXn/CWzXr8nWZRIAzhRO9LqwQjeZEAgQ5eX4tdDdNmUsPIZekONhkpYHL48/QgxMPraRgHya3c65VLV+UBHyAfIXShSCkYD+QG5KMeLI2XmVxXOOHu43wZb0XSeCDsajQ6ekDfGd+6Ap/2T+TC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXgco/Z3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860B3C4CECD;
	Fri, 20 Dec 2024 22:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734732973;
	bh=9LRaji69uD3EQIGHAAl3xSOOfhfziDwaFV5ALJNKDvs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HXgco/Z37lRoEV6HkrsRxBCpo54/VQ2DwJE1uTD32ajP4xyJzH/51kUbQkZ5G2NH0
	 bcDstgepFnHVFXcuZvWzOLEBDPAme6FZ206o5ecEQJ2PF9dOv3nADz4aVijuhaLGSz
	 aYASAvzaDRIj2jYVH76vAzMRQ0tlYQ5TJEIUOW9gCRck4bPJeM8kbD1KGnYUQlxW9w
	 bbwzDUxoNescvkbfS7FH/2BGep3WJPZmVB7YwUJKeRh6LAkX31BBe4iM7Fm44BQRW8
	 UWQN5bJhYOOFnSRstZca1ttSyAxe2a31PNoPGKlkubpNoc91kzBi3u92CAtYkS8UKp
	 jw7ICOC0pJ3qQ==
Date: Fri, 20 Dec 2024 14:16:11 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 05/20] net: page_pool: add mp op for netlink
 reporting
Message-ID: <20241220141611.6d95a37c@kernel.org>
In-Reply-To: <20241218003748.796939-6-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-6-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:31 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Add a mandatory memory provider callback that prints information about
> the provider.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
> index 8d31c71bea1a..61212f388bc8 100644
> --- a/net/core/page_pool_user.c
> +++ b/net/core/page_pool_user.c

net/core/page_pool_user.c doesn't have to include devmem.h any more

