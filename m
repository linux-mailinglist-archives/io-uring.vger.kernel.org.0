Return-Path: <io-uring+bounces-5585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC0D9F9CAB
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E611E1895959
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738B5223715;
	Fri, 20 Dec 2024 22:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKIoMpZ9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF0E21C9FB;
	Fri, 20 Dec 2024 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734733102; cv=none; b=eZzUE5MNTvvtaIYzaapl/sNPXVsoASCyPdlZfU5yg2hjo0tuVTcRK92nzEWpf6DMFOqfChB84ceknoE3UcEBwoqziFa6QRLh6qSQKJbTiuS36vDiFc2YECf42xq6I+jD7K/lqU/iYOICtWf0FjcMMPOf2hX7NoueRiy8+9VKPzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734733102; c=relaxed/simple;
	bh=HJVfiskzgbo9bd4J8po/wxO0kqQzemPbPUuppLtpzww=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHdBeG0q2huC14yPfiZ0X+HTP6IrPsxbJuXXdDpbffeEzSNUGUYIDzfJwkyUyBVLOcHOOYpEo5bAPLEhMAdL12LuToiayW0NCmhC0T4kOtpPrGo7RYeBQH8jPZ/HaAiWfTvKDpwEBHEv4mIlc+g4TezI8qNhM0fONrNcSzJPQws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKIoMpZ9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449C5C4CECD;
	Fri, 20 Dec 2024 22:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734733101;
	bh=HJVfiskzgbo9bd4J8po/wxO0kqQzemPbPUuppLtpzww=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VKIoMpZ9sd1prfyiBmqx3ZelY9uHCyRa4CWuKiM2BZw1ZFP0dYwvnu0wT+XYyvj4+
	 xCuLfQaPVD+COw40mmLrghgXpwxZYn6nckXs2rnxx23iJNjepmhfhPMbVZWYY1b5hL
	 BCb/x6py96GsbYbb1YTuCu52Ievgm6O+VaHIiepwRljvgWRjCwsXzzRyYycwH+z/qb
	 9c8zdGglVLYo/00mx6gwrFlrRmwWCKrDpa/We2ZHrc0eEgXRoaOSUQ0MenwWsJxdtb
	 W3Y/TQnZZxG9zQpwbWckuFAR/i2b1gsft4Cmte6lBVZd2819d+VPiRTm1yVCvJmAwX
	 ZbsIz5avy2vKQ==
Date: Fri, 20 Dec 2024 14:18:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 06/20] net: page_pool: add a mp hook to
 unregister_netdevice*
Message-ID: <20241220141820.264e32e3@kernel.org>
In-Reply-To: <20241218003748.796939-7-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-7-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:32 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Devmem TCP needs a hook in unregister_netdevice_many_notify() to upkeep
> the set tracking queues it's bound to, i.e. ->bound_rxqs. Instead of
> devmem sticking directly out of the genetic path, add a mp function.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

but we may need to start adding kdoc to the struct memory_provider_ops
if it continues to grow

