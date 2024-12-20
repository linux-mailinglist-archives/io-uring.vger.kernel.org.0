Return-Path: <io-uring+bounces-5587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3046E9F9CBE
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A7B6188AB81
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185251BBBCC;
	Fri, 20 Dec 2024 22:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1PcxBhb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8A1A9B27;
	Fri, 20 Dec 2024 22:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734733920; cv=none; b=CCMFmYXEghfDfIjYa64967hodKCaE6JHS4twoEifqyTylN6ytzYEkipRVej5fBKKqcHC5wdadUJAreiIvOGBxvkE/2FzzDRb4Ed0sCC7OnOF6twM5NfyLxfRyOnbhrXxGzP81XK6l0yBFlIZ0kCZW2b0liw8lOWhuiVxUFM9c3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734733920; c=relaxed/simple;
	bh=/855uDMbqGBjr11vy+t6Q5pZWDcsGfAvBLLNa0i0HQg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnIc5bdfJ1CS4q6zI+Dizt8bGj5C/3P8xzT2ZcEz+cBpmihPRg6y1WEZNyFvBlQcL26hAo2+yVyIAzj6/xQOCpG3BZBbPTtMCkSP/MiVkI05KmYo8+2PX6YSckQQiBZJhRL4jXii6tXvVMS2aHmfhISi621fN1nhbbEX4v9SPoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1PcxBhb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7F1C4CECD;
	Fri, 20 Dec 2024 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734733919;
	bh=/855uDMbqGBjr11vy+t6Q5pZWDcsGfAvBLLNa0i0HQg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t1PcxBhbC1/AXn3NxGpG9uIAdprbX7BBaF3cAwbgbhBkXum9akcN3554OYfv5JiC2
	 35MCZellDHmyi/ukdnDjB9Y/SzdJ9Xd7MHXrChmRJaEnki1T+YHMWQlWbpTRvoE+zA
	 YhIwab7N1O83UiJVVXs9KNQPWAthPo9QOCiVgxSI5DaqNzi2FCI1FVoCBd0VPkeNN0
	 EINp2qvQGCk0eUAPN40U0TTK5l0V6e9YwrwXxKcz8GBD5k+uQfErJGah8xvNWgLq6e
	 ZOHCXF3VurUFYKGPj8Ffs+ABAEqcsTA5JY/B/pX8/SaX08pHe1Gc5WOmLVOCjKqV6s
	 ezkx8D1eSWSzg==
Date: Fri, 20 Dec 2024 14:31:58 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 08/20] net: expose
 page_pool_{set,clear}_pp_info
Message-ID: <20241220143158.11585b2d@kernel.org>
In-Reply-To: <20241218003748.796939-9-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-9-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:34 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Memory providers need to set page pool to its net_iovs on allocation, so
> expose page_pool_{set,clear}_pp_info to providers outside net/.

I'd really rather not expose such low level functions in a header
included by every single user of the page pool API.

