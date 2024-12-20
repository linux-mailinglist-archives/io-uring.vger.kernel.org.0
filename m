Return-Path: <io-uring+bounces-5586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FE19F9CAD
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D9F16BCD1
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D613D225A4B;
	Fri, 20 Dec 2024 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQ6q6o6Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2BB1A3BAD;
	Fri, 20 Dec 2024 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734733126; cv=none; b=Y0g8NZymrhaB4Bq9TbKFkyxAvoJi1zr5ghSM08D+GcsitsL/xDNqJD0m69yS8Xb4SNEdU7QV68vbsb/r4pHwnQbTTzvmH8Sk0ix/g14w5aNnw9GE5ZwzNFu8DRe+IcqDzyOgwPre4n/jtyACaEXpOMJ1DhoePJCe0A4iTvTPUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734733126; c=relaxed/simple;
	bh=L1LBj7z2i6uNkHxxevZlBomiDineKOMTpvMu6F7DgFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0Bu2iKEopEcyX9ilc1qTft8ujJ9DfBRbfkjtpDtvytVfxltr2mIgJkT6FNOZdRy6B4nE5XXv4B/8fKYwQMdTIFwtnNwTxXIAAEdCMGS6ihnQx0mqzUf9QkLyXoAwzl08/OlKnhmLXzQKLT61ZtkFyD3HeG7j1t2yH+v/cW2cns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQ6q6o6Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1793CC4CECD;
	Fri, 20 Dec 2024 22:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734733126;
	bh=L1LBj7z2i6uNkHxxevZlBomiDineKOMTpvMu6F7DgFk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pQ6q6o6QqZ7iUtiDfuy/t+tHRVbKzQHvtP/gcFGPPZfDFv4w+bx3q6Sl8m8BGoYxj
	 6Vln6USrBfZ5lGz9Cf7/8jGRHiftqZjtHPgJOnzCTGKQ1tqJI516w435riXxTI9KHm
	 7H6O7sF5vXa0yupzNxyezMes6JTGGhnCt7lCj0FIZ0YwLpS7BPp5Sbz0X2wbuok6Gv
	 nzMXhCiA8+Enems1lOwtdF2mE+J6qpaLjwOdyI1iSK2V6T0OWghKW5Z6/fMWa3E7yu
	 MuKtgXr1puIYma8qShZCACdN5F2joCprrHMVcCbmauz7E2brQpI7HC9yjm1FXOEEnq
	 yKt6oOH6MX71Q==
Date: Fri, 20 Dec 2024 14:18:45 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 07/20] net: prepare for non devmem TCP
 memory providers
Message-ID: <20241220141845.2bf23574@kernel.org>
In-Reply-To: <20241218003748.796939-8-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-8-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:33 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There is a good bunch of places in generic paths assuming that the only
> page pool memory provider is devmem TCP. As we want to reuse the net_iov
> and provider infrastructure, we need to patch it up and explicitly check
> the provider type when we branch into devmem TCP code.
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

