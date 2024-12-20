Return-Path: <io-uring+bounces-5581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD879F9C8F
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A4EE1893370
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF064227BB8;
	Fri, 20 Dec 2024 22:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fihlmtyV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863A7226529;
	Fri, 20 Dec 2024 22:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732314; cv=none; b=WzByP0v7/yYdyWwXYM6Qqz6JNZ/bU2VtzzYpJRo7PzJdXKgRJEqg81eYTRn1Fcx+yjqAvG+qFoVLcaSiae8yF/pa7qC+vhx3bC8GXDPtvKV7pt3zAW6KOP0Q0ldykxlUwd9jeqF/NEnQPGlXmMHnekKgQuy5qCodgVX9sVcLfa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732314; c=relaxed/simple;
	bh=sBofJuaSX6GJQfbWlK+/2Sp/KYUJopOnV+ad70mrN9U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFrDzEIZIoTTLsLwzLsFUocT1B9Xp/hJpYjVAdPSDGbtztJ54wZNSDWH+ELY3y8+OzICh4ALJJcxMAF3KSuurVZknOQJkOdIhosrqPav/BicjbaRAWYxZgwYIl66Ezn35tC8YQw2QgB1yBSLn5clCeGZWIUpVsQZ6/6XAQzQpjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fihlmtyV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9446FC4CEDC;
	Fri, 20 Dec 2024 22:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734732314;
	bh=sBofJuaSX6GJQfbWlK+/2Sp/KYUJopOnV+ad70mrN9U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fihlmtyVlcd1CdClAkis5r5o3qIWNd2XRKh0GsP6kD3AV976j4d60CIuaRR5ptddr
	 PWHoMIAZHvQpnO3rgOWTdlFYfIqU50APj0wMICeuDjY8v5/cQaBQYLNn4Ep5llnak1
	 rgInOVPDoUatvhAbD0lo2hTuVLwyq/sn4THXQQFqRhXevtMi7b7lv/1WV1/L+yyWzF
	 hYZs0pXtci2H468mjxjOWd2xgFe8Qbhk0t5x5LD9eMao3y50IMsjfAXQsk6E+ukOAF
	 Kmfwk3WI8rtskqx1BF62w8BnsU+kqkdbNSHSUw7pdeqi7hRTYuwuqEh93FGlUarJtj
	 hPtEKIC42XF1w==
Date: Fri, 20 Dec 2024 14:05:12 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 02/20] net: prefix devmem specific helpers
Message-ID: <20241220140512.5333f2a3@kernel.org>
In-Reply-To: <20241218003748.796939-3-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-3-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:28 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Add prefixes to all helpers that are specific to devmem TCP, i.e.
> net_iov_binding[_id].

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

